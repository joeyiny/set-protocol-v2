// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "../helpers/BaseTest.sol";

import {IController} from "../../src/contracts/interfaces/IController.sol";
import {IIntegrationRegistry} from "../../src/contracts/interfaces/IIntegrationRegistry.sol";
import {IManagerIssuanceHook} from "../../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {IOracle} from "../../src/contracts/interfaces/IOracle.sol";
import {ISetToken} from "../../src/contracts/interfaces/ISetToken.sol";
import {IWETH} from "../../src/contracts/interfaces/external/IWETH.sol";
import {IWildcardDeployer} from "../../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../../src/contracts/interfaces/external/IWildcardStateManager.sol";

import {Controller} from "../../src/contracts/protocol/Controller.sol";
import {IntegrationRegistry} from "../../src/contracts/protocol/IntegrationRegistry.sol";
import {PriceOracle} from "../../src/contracts/protocol/PriceOracle.sol";
import {SetToken} from "../../src/contracts/protocol/SetToken.sol";
import {SetTokenCreator} from "../../src/contracts/protocol/SetTokenCreator.sol";
import {SetValuer} from "../../src/contracts/protocol/SetValuer.sol";

import {BasicIssuanceModule} from "../../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {SlippageIssuanceModule} from "../../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {StreamingFeeModule} from "../../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";
import {WildcardIssuanceModule} from "../../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PlaylistsTest is BaseTest {
    ISetToken setToken;
    IWETH weth = IWETH(WETH_BASE);

    function setUp() public {
        baseSetUp();
    }

    function launchPlaylist() public {
        vm.startPrank(deployer);
        address[] memory components = new address[](3);
        components[0] = 0xCe91B0aeff1380F53BB0d98Fc9a3819d18d9bbd9; // yeat - idgaf
        components[1] = 0xC5bC2f22c2793FB873f04be35bb9AF2b8C2b616e; // bryson tiller - finished
        components[2] = 0x92c99C9a9eaE3f7385AC2D919D086a96FA1bc4f3; // cash cobain - fisherrr remix

        int256[] memory units = new int256[](3);
        units[0] = 1e18;
        units[1] = 1e18;
        units[2] = 1e18;
        address[] memory modules = new address[](1);
        modules[0] = address(slippageIssuanceModule);

        address returnedETF = setTokenCreator.create(components, units, modules, deployer, "some cool songs", "BANGERS");
        setToken = ISetToken(returnedETF);

        slippageIssuanceModule.initialize(ISetToken(setToken), 0, 0, 0, deployer, IManagerIssuanceHook(address(0)));
        controller.addModule(address(wildcardIssuanceModule));
        ISetToken(setToken).addModule(address(wildcardIssuanceModule));
        wildcardIssuanceModule.initialize(ISetToken(setToken));

        vm.stopPrank();
    }

    function testLaunchPlaylist() public {
        launchPlaylist();
    }

    function testBuyPlaylist() public {
        launchPlaylist();
        vm.startPrank(deployer);

        IERC20(weth).approve(address(wildcardIssuanceModule), type(uint256).max);
        weth.deposit{value: 1 ether}();
        address[] memory components = setToken.getComponents();
        for (uint256 i = 0; i < components.length; i++) {
            console.log("Component: ", components[i]);
            IERC20(components[i]).approve(address(slippageIssuanceModule), type(uint256).max);
        }
        address[] memory allComponents = setToken.getComponents();
        uint256[] memory maxAmounts = new uint256[](allComponents.length);
        for (uint256 i = 0; i < allComponents.length; i++) {
            maxAmounts[i] = 1e18;
        }
        uint256 wethBalance = IERC20(address(weth)).balanceOf(deployer);
        uint256 ethBalance = deployer.balance;

        slippageIssuanceModule.issueWithSlippage(
            setToken,
            1e15,
            allComponents, // _checkedComponents
            maxAmounts, // _maxTokenAmountsIn (empty array)
            deployer
        );

        vm.stopPrank();
    }
}
