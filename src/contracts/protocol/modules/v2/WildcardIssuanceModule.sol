// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;
pragma experimental "ABIEncoderV2";

import {IModuleIssuanceHookV2} from "../../../interfaces/IModuleIssuanceHookV2.sol";

import {IController} from "../../../interfaces/IController.sol";
import {IDebtIssuanceModule} from "../../../interfaces/IDebtIssuanceModule.sol";
import {ISetToken} from "../../../interfaces/ISetToken.sol";
import {IWETH} from "../../../interfaces/external/IWETH.sol";
import {IWildcardDeployer} from "../../../interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../../../interfaces/external/IWildcardStateManager.sol";
import {ModuleBaseV2} from "../../lib/ModuleBaseV2.sol";
import {SetTokenAccessible} from "../../lib/SetTokenAccessible.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {console} from "forge-std/console.sol";

interface IWETH9 is IERC20 {
    /// @notice Deposit ether to get wrapped ether
    function deposit() external payable;

    /// @notice Withdraw wrapped ether to get ether
    function withdraw(uint256) external;
}

contract WildcardIssuanceModule is ModuleBaseV2, IModuleIssuanceHookV2, SetTokenAccessible {
    using SafeERC20 for IERC20;

    IWildcardDeployer public wildcardDeployer;
    IWildcardStateManager public wildcardStateManager;
    IWETH public weth;

    constructor(
        IController _controller,
        IWildcardDeployer _wildcardDeployer,
        IWildcardStateManager _wildcardStateManager,
        IWETH _weth
    ) public ModuleBaseV2(_controller) SetTokenAccessible(_controller) {
        wildcardStateManager = _wildcardStateManager;
        wildcardDeployer = _wildcardDeployer;
        weth = _weth;
    }

    function initialize(ISetToken _setToken)
        public
        virtual
        onlySetManager(_setToken, msg.sender)
        onlyValidAndPendingSet(_setToken)
    {
        _setToken.initializeModule();
        console.log("WildcardIssuanceModule initialized");
        address[] memory modules = _setToken.getModules();
        for (uint256 i = 0; i < modules.length; i++) {
            try IDebtIssuanceModule(modules[i]).registerToIssuanceModule(_setToken) {
                // This module registered itself on `modules[i]` issuance module.
            } catch {
                // Try will fail if `modules[i]` is not an instance of IDebtIssuanceModule and does not
                // implement the `registerToIssuanceModule` function, or if the `registerToIssuanceModule`
                // function call reverted. Irrespective of the reason for failure, continue to the next module.
            }
        }
    }

    function componentIssueHook(ISetToken _setToken, uint256 _setTokenQuantity, IERC20 _component, bool _isEquity)
        external
        override
        onlyModule(_setToken)
    {
        // console.log("WildcardIssuanceModule componentIssueHook");
        // wildcardStateManager.buyToken(msg.sender, address(_component), _setTokenQuantity, 0, address(this));
    }

    function componentRedeemHook(ISetToken _setToken, uint256 _setTokenQuantity, IERC20 _component, bool _isEquity)
        external
        override
        onlyModule(_setToken)
    {
        _isEquity;
        wildcardStateManager.sellToken(msg.sender, address(_component), _setTokenQuantity, 0, address(this));
    }

    function moduleIssueHook(ISetToken _setToken, uint256 _setTokenQuantity) external override onlyModule(_setToken) {
        console.log("WildcardIssuanceModule moduleIssueHook");
        // Buy all required tokens before issuance balance checks
        address[] memory components = _setToken.getComponents();

        for (uint256 i = 0; i < components.length; i++) {
            IERC20 component = IERC20(components[i]);

            // Calculate required amount for this component
            uint256 requiredAmount =
                uint256(_setToken.getDefaultPositionRealUnit(components[i])) * _setTokenQuantity / 1e18;

            uint256 currentBalance = component.balanceOf(msg.sender);
            // If we don't have enough, buy from Wildcard
            if (currentBalance < requiredAmount) {
                uint256 amountToBuy = requiredAmount - currentBalance;
                console.log("amountToBuy: ", amountToBuy);
                console.log("currentBalance: ", currentBalance);
                console.log("requiredAmount: ", requiredAmount);
                // TODO: Query actual ETH needed from Wildcard protocol
                // For now, use a conservative estimate (2x the token amount as ETH)
                uint256 ethNeeded = 2 * amountToBuy;

                console.log("tx.origin balance of weth: ", IERC20(address(weth)).balanceOf(tx.origin));
                console.log("tx.origin address: ", tx.origin);
                console.log("msg.sender address: ", msg.sender);
                IERC20(address(weth)).safeTransferFrom(tx.origin, address(this), ethNeeded);
                // console.log("ethNeeded: ", ethNeeded);
                weth.withdraw(ethNeeded);
                uint256 balanceOfEth = address(this).balance;
                console.log("WildcardIssuanceModule balance of eth: ", balanceOfEth);

                try wildcardDeployer.buyToken{value: ethNeeded}(
                    components[i], // token to buy
                    amountToBuy, // amount needed
                    0, // max price (0 = no limit)
                    tx.origin // recipient (the SlippageIssuanceModule)
                ) {
                    // Token purchase successful
                    console.log("WildcardIssuanceModule bought token ", components[i], " amount ", amountToBuy);
                } catch Error(string memory reason) {
                    console.log("WildcardIssuanceModule error: ", reason);

                    console.log("WildcardIssuanceModule failed to buy token ", components[i], " amount ", amountToBuy);
                }
            }
        }
    }

    function moduleRedeemHook(ISetToken _setToken, uint256 /* _setTokenQuantity */ )
        external
        override
        onlyModule(_setToken)
    {
        console.log("WildcardIssuanceModule moduleRedeemHook");
    }

    function getIssuanceAdjustments(ISetToken, /* _setToken */ uint256 /* _setTokenQuantity */ )
        external
        override
        returns (int256[] memory, int256[] memory)
    {
        return (new int256[](0), new int256[](0));
    }

    function getRedemptionAdjustments(ISetToken, /* _setToken */ uint256 /* _setTokenQuantity */ )
        external
        override
        returns (int256[] memory, int256[] memory)
    {
        return (new int256[](0), new int256[](0));
    }

    /**
     * TODO: WRITE THIS FUNCTION
     * @dev SETTOKEN ONLY: Removes this module from the SetToken, via call by the SetToken. Deletes
     * position mappings associated with SetToken.
     *
     * NOTE: Function will revert if there is greater than a position unit amount of USDC of account value.
     */
    function removeModule() public virtual override onlyValidAndInitializedSet(ISetToken(msg.sender)) {
        ISetToken setToken = ISetToken(msg.sender);

        // Try if unregister exists on any of the modules
        address[] memory modules = setToken.getModules();
        for (uint256 i = 0; i < modules.length; i++) {
            try IDebtIssuanceModule(modules[i]).unregisterFromIssuanceModule(setToken) {} catch {}
        }
    }

    // Receive function to accept ETH
    receive() external payable {}
}
