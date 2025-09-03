// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.6.10;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
struct PriceCurve {
    uint256[] prices;
    uint256 numSteps;
    uint256 stepSize;
}
struct FeeSplit {
    address recipient;
    uint256 bps; // basis points (10000 = 100%)
}
interface IWETH9 is IERC20 {
    /// @notice Deposit ether to get wrapped ether
    function deposit() external payable;

    /// @notice Withdraw wrapped ether to get ether
    function withdraw(uint256) external;
}
struct TokenDeploymentConfig {
    // creator
    address creator;
    // base token
    address baseToken;
    // token details
    // token details
    string name;
    string symbol;
    string image;
    string appIdentifier;
    // Token distribution
    uint256 teamSupply; // Tokens allocated to team
    uint64 vestingStartTime; // vesting start time
    uint64 vestingDuration; // vesting duration
    address vestingWallet; // vesting wallet
    uint256 bondingCurveSupply; // Tokens allocated to bonding curve
    uint256 liquidityPoolSupply; // Tokens allocated to liquidity pool after graduation
    uint256 totalSupply; // Total supply of tokens
    // bonding curve parameters
    uint256 bondingCurveBuyFee; // basis points
    uint256 bondingCurveSellFee; // basis points
    FeeSplit[] bondingCurveFeeSplits; // fee splits for bonding curve
    PriceCurve bondingCurveParams;
    // graduation parameters
    bool allowForcedGraduation;
    bool allowAutoGraduation;
    uint256 graduationFeeBps;
    FeeSplit[] graduationFeeSplits; // fee splits for graduation
    // uniswap v4 pool parameters
    uint24 poolFees;
    FeeSplit[] poolFeeSplits; // fee splits for pool
    // surge fee parameters
    uint256 surgeFeeStartingTime;
    uint256 surgeFeeDuration;
    uint256 maxSurgeFeeBps;
}

struct TokenState {
    bool isGraduated;
    // bonding curve stage state
    uint256 tokensInBondingCurve;
    uint256 baseTokensInBondingCurve;
    // uniswap pool state
    // always zero address since we're using uniswap v4
    // Preserved for sdk compatibility
    address poolAddress;
    uint256 uniswapTokenId;
}

interface IDeployer {
    function stateManager() external view returns (address);

    function buyToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external payable;
    function sellToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external;
}

interface IStateManager {
    function tokenDeploymentConfigs(address token) external view returns (TokenDeploymentConfig memory);
}

contract WildcardAmmAdapter is Ownable, ReentrancyGuardTransient {
    using SafeERC20 for IERC20;

    error InvalidToken;
    error InvalidBaseToken;
    error InvalidData;
    error FailedToTransferTokens;

    IDeployer deployer;
    IWETH9 weth;

    constructor(address _deployer, address _owner, address _weth) Ownable(_owner) {
        deployer = IDeployer(_deployer);
        weth = IWETH9(_weth);
    }

    function updateDeployer(address _deployer) external onlyOwner {
        deployer = IDeployer(_deployer);
    }

    function getSpender() external view returns (address) {
        return address(this);
    }

    function getTradeCalldata(
        address fromToken,
        address toToken,
        address toAddress,
        uint256 fromQuantity,
        uint256 minToQuantity,
        bytes memory _data
    ) external view returns (address, uint256, bytes memory) {
        if (_data.length > 0) {
            revert InvalidData;
        }

        // First check if the fromToken is a base token
        (bool isValidToken, address baseToken) = _getBaseToken(fromToken);
        if (isValidToken) {
            if (baseToken != toToken) {
                revert InvalidBaseToken;
            }
            bytes memory calldata_ =
                abi.encodeWithSelector(this.sellToken.selector, fromToken, fromQuantity, minToQuantity, toAddress);
            return (address(this), 0, calldata_);
        }

        (bool isValidToken2, address baseToken2) = _getBaseToken(toToken);
        if (isValidToken2) {
            if (baseToken2 != fromToken) {
                revert InvalidBaseToken;
            }
            bytes memory calldata_ =
                abi.encodeWithSelector(this.buyToken.selector, toToken, fromQuantity, minToQuantity, toAddress);
            return (address(this), 0, calldata_);
        }

        revert InvalidToken;
    }

    function _getBaseToken(address token) internal view returns (bool, address) {
        IStateManager stateManager = IStateManager(deployer.stateManager());
        TokenDeploymentConfig memory config = stateManager.tokenDeploymentConfigs(token);

        // This token is not deployed by the deployer
        if (config.creator == address(0)) {
            return (false, address(0));
        }

        return (true, config.baseToken);
    }

    function buyToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external nonReentrant {
        (bool isValidToken, address baseToken) = _getBaseToken(token);
        if (isValidToken) {
            if (baseToken == address(weth)) {
                buyTokenFromWeth(token, amountIn, amountOutMin, to);
            } else {
                uint256 tokenBalanceBefore = IERC20(baseToken).balanceOf(address(this));
                IERC20(baseToken).safeTransferFrom(msg.sender, address(this), amountIn);
                IERC20(baseToken).approve(address(deployer), amountIn);
                deployer.buyToken(token, amountIn, amountOutMin, to);
                uint256 tokenBalanceAfter = IERC20(baseToken).balanceOf(address(this));
                if (tokenBalanceAfter > tokenBalanceBefore) {
                    // Return the excess token to the caller
                    IERC20(baseToken).safeTransfer(msg.sender, tokenBalanceAfter - tokenBalanceBefore);
                }
            }
        } else {
            revert InvalidToken;
        }
    }

    function sellToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external nonReentrant {
        (bool isValidToken, address baseToken) = _getBaseToken(token);
        if (isValidToken) {
            if (baseToken == address(weth)) {
                sellTokenToWeth(token, amountIn, amountOutMin, to);
            } else {
                IERC20(token).safeTransferFrom(msg.sender, address(this), amountIn);
                IERC20(token).approve(address(deployer), amountIn);
                deployer.sellToken(token, amountIn, amountOutMin, to);
            }
        } else {
            revert InvalidToken;
        }
    }

    function buyTokenFromWeth(address token, uint256 amountIn, uint256 amountOutMin, address to) internal {
        // Unwrap the WETH to ETH
        IERC20(address(weth)).safeTransferFrom(msg.sender, address(this), amountIn);
        weth.withdraw(amountIn);

        // Refund any ETH balance that was refunded by the deployer
        uint256 expectedETHBalance = address(this).balance - amountIn;
        deployer.buyToken{value: amountIn}(token, amountIn, amountOutMin, to);
        uint256 actualETHBalance = address(this).balance;

        if (actualETHBalance > expectedETHBalance) {
            // Return the excess ETH to the caller
            uint256 amount = actualETHBalance - expectedETHBalance;
            (bool success,) = payable(msg.sender).call{value: amount}("");
            if (!success) {
                revert FailedToTransferTokens;
            }
        }
    }

    receive() external payable {}

    function sellTokenToWeth(address token, uint256 amountIn, uint256 amountOutMin, address to) internal {
        uint256 balanceBefore = address(this).balance;
        IERC20(token).safeTransferFrom(msg.sender, address(this), amountIn);
        IERC20(token).approve(address(deployer), amountIn);

        deployer.sellToken(token, amountIn, amountOutMin, address(this));

        uint256 balanceAfter = address(this).balance;
        uint256 outputAmount = balanceAfter - balanceBefore;

        weth.deposit{value: outputAmount}();
        weth.transfer(to, outputAmount);
    }
}