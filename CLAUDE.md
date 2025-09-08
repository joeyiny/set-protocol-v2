# Set Protocol V2 - Technical Documentation

## Overview
Set Protocol V2 is a modular smart contract system for creating tokenized portfolios (SetTokens) on Ethereum. SetTokens are ERC-20 tokens backed by underlying components (other ERC-20 tokens) at defined ratios. Think of them as on-chain ETFs that can be programmatically managed through modules.

## Core Architecture

### 1. Controller (packages/set-protocol-v2/src/contracts/protocol/Controller.sol)
Central registry and governance contract that maintains system state:
- **Factories**: Contracts authorized to deploy new SetTokens
- **Modules**: Extensions that add functionality to SetTokens
- **Resources**: Shared system contracts (price oracles, etc.) 
- **Sets**: Registered SetToken contracts
- **Fees**: Protocol fee configurations per module

Key functions:
- `initialize()`: One-time setup of initial system contracts
- `addSet()`: Called by factories to register newly created SetTokens
- `addModule()`, `addFactory()`, `addResource()`: Governance functions to expand system

### 2. SetToken (packages/set-protocol-v2/src/contracts/protocol/SetToken.sol)
ERC-20 token representing a portfolio with:
- **Components**: List of underlying ERC-20 tokens held
- **Positions**: Quantity of each component per SetToken (stored as virtual units)
- **Position Multiplier**: Scaling factor for all positions (enables streaming fees)
- **Modules**: Enabled extensions providing functionality
- **Manager**: Privileged address that can add/remove modules

Key mechanics:
- `invoke()`: Allows modules to execute arbitrary calls from SetToken
- Components have Default positions (held directly) or External positions (held elsewhere)
- Virtual units × position multiplier = real units

### 3. SetTokenCreator (packages/set-protocol-v2/src/contracts/protocol/SetTokenCreator.sol)
Factory contract for deploying new SetTokens:
- Validates components, units, modules, and manager
- Deploys SetToken with initial positions
- Registers new SetToken with Controller
- Modules start in PENDING state and must be initialized

## Module System

### Module States
1. **NONE**: Module not added to SetToken
2. **PENDING**: Module added but not initialized
3. **INITIALIZED**: Module initialized and operational

### Core Modules

#### BasicIssuanceModule
- **Purpose**: Mint/redeem SetTokens for underlying components
- **Issue**: Deposit components → Mint SetTokens
- **Redeem**: Burn SetTokens → Receive components
- Only handles Default positions (components held directly)

#### TradeModule
- **Purpose**: Execute trades to rebalance SetToken component allocations
- **Key Functions**:
  - `trade()`: Swap one component for another using DEX adapters
  - `initialize()`: Enable module and set exchange integrations
  - Only SetToken manager can execute trades
- **Trade Mechanics**:
  - Sells exact amount of source component
  - Buys minimum required amount of destination component
  - Uses external DEX adapters (Uniswap, Sushiswap, 0x, etc.)
  - Updates SetToken positions after successful trade
- **Access Control**: Only initialized module can invoke SetToken calls
- **Integration Pattern**: Uses IntegrationRegistry to resolve adapter addresses
- **Exchange Integration Architecture**:
  1. **Exchange Adapters**: Contracts implementing `IExchangeAdapter` interface
     - `getSpender()`: Returns address to approve tokens to (e.g. Uniswap Router)
     - `getTradeCalldata()`: Generates calldata for DEX-specific trade execution
  2. **Integration Registry**: Maps module + exchange name → adapter address
     - Governance can add/edit/remove exchange integrations
     - Mapping: `TradeModule + "UNISWAP" → UniswapV2ExchangeAdapter`
  3. **Trade Execution Flow**:
     - TradeModule looks up adapter via `integrationRegistry.getIntegrationAdapter()`
     - Calls `adapter.getSpender()` and `adapter.getTradeCalldata()`
     - SetToken approves spender and executes generated calldata
- **Adding New Exchange**:
  1. Deploy exchange adapter implementing `IExchangeAdapter`
  2. Call `integrationRegistry.addIntegration(tradeModuleAddress, "EXCHANGE_NAME", adapterAddress)`
  3. Exchange now available for trading via `_exchangeName` parameter
- **Example Flow**: Manager wants to reduce TokenA allocation and increase TokenB
  1. Calculate trade parameters (sell amount, min receive)
  2. Call `trade(setToken, "UNISWAP", sendToken, sendQuantity, receiveToken, minReceiveQuantity, data)`
  3. Module resolves "UNISWAP" → UniswapV2ExchangeAdapter via registry
  4. Adapter generates Uniswap Router calldata for `swapExactTokensForTokens()`
  5. SetToken approves Router and executes trade
  6. SetToken positions updated to reflect new balances

#### StreamingFeeModule  
- **Purpose**: Accrue management fees
- Adjusts position multiplier to extract value over time

#### GeneralIndexModule
- **Purpose**: Automated rebalancing for index products
- Supports trade execution and position management

#### DebtIssuanceModule
- **Purpose**: Issue/redeem with external positions (lending, staking)
- Handles complex positions beyond simple token holdings

#### SlippageIssuanceModule
- **Purpose**: Enhanced issuance/redemption with slippage protection for positions requiring trades
- **Inherits from**: DebtIssuanceModule (all its functionality plus slippage features)
- **Key Features**:
  - Protects against sandwich attacks during issuance/redemption
  - Supports positions that require trades to replicate (perpetuals, leveraged tokens)
  - Better estimation of required tokens including position syncing changes
  - Allows setting max/min token limits per component
- **Core Functions**:
  - `issueWithSlippage()`: Issue with max token input limits
  - `redeemWithSlippage()`: Redeem with min token output limits
  - `getRequiredComponentIssuanceUnitsOffChain()`: Calculate exact tokens needed including adjustments
  - `getRequiredComponentRedemptionUnitsOffChain()`: Calculate exact tokens received including adjustments
- **Slippage Protection Mechanism**:
  1. Issuer/redeemer specifies `_checkedComponents` array (components to check)
  2. Provides corresponding `_maxTokenAmountsIn` (for issue) or `_minTokenAmountsOut` (for redeem)
  3. Module validates actual amounts don't exceed/fall below limits
  4. Only need to specify limits for components with slippage risk
- **Position Adjustments**:
  - Module hooks can return position adjustments during issuance/redemption
  - Adjustments account for trades, syncing, or rebalancing during the process
  - Positive equity adjustment = more tokens needed/received
  - Negative debt adjustment = more debt incurred
- **Integration with External Protocols**:
  - Works with any module implementing `IModuleIssuanceHookV2`
  - Hooks provide `getIssuanceAdjustments()` and `getRedemptionAdjustments()`
  - Adjustments are cumulative across all registered hooks
- **Example Usage Flow**:
  1. SetToken has PERP tokens that require trading to replicate
  2. User calls `issueWithSlippage()` with PERP in `_checkedComponents`
  3. Sets `_maxTokenAmountsIn` for PERP to protect against price manipulation
  4. Module calculates required amounts including trade slippage
  5. Validates amounts don't exceed user's limits
  6. Executes issuance with protection

## Integration System

### IntegrationRegistry
Maps modules to adapters for external protocols:
- Module → Integration Name → Adapter Address
- Allows modules to interact with DeFi protocols
- Governance can add/edit integrations

### Adapter Types
- **Exchange Adapters**: DEX integrations for trading
- **Wrap Adapters**: Wrapping/unwrapping tokens (ETH→WETH)
- **Lending Adapters**: Aave, Compound integrations
- **Staking Adapters**: Staking protocol integrations

## Key Workflows

### Creating a SetToken
1. Deploy via `SetTokenCreator.create()`
2. Specify components, units, modules, manager
3. SetToken registered with Controller
4. Manager initializes modules

### Issuing SetTokens
1. User approves BasicIssuanceModule for components
2. Calls `issue()` with quantity
3. Components transferred to SetToken
4. SetTokens minted to user

### Trading Components
1. Manager calls trade function on TradeModule
2. Module uses adapter to execute trade
3. SetToken balances updated

### Position Management
- **Real Unit**: Actual token amount per SetToken
- **Virtual Unit**: Stored value before multiplier
- **Position Multiplier**: Scaling factor (starts at 1e18)
- Formula: `realUnit = virtualUnit * positionMultiplier / 1e18`

## Security Model

### Access Control
- **Controller Owner**: Can add/remove system contracts
- **SetToken Manager**: Can add/remove modules, change manager
- **Modules**: Can invoke calls from SetToken when initialized
- **Locker**: Module that temporarily locks SetToken for multi-tx operations

### Validations
- Components must be non-zero addresses
- Units must be positive
- No duplicate components
- Modules must be Controller-approved
- Factories must be Controller-authorized

## Gas Optimization Patterns
- Position multiplier for efficient fee accrual
- Virtual units reduce storage updates
- Batch operations in registry contracts
- Module separation minimizes SetToken complexity

## Using SlippageIssuanceModule with External Protocols

### Integration with DEXes/AMMs

The SlippageIssuanceModule works seamlessly with various decentralized exchanges through the adapter pattern:

#### Supported Exchange Adapters
- **UniswapV2**: `UniswapV2ExchangeAdapter` - Standard V2 pools
- **UniswapV3**: `UniswapV3ExchangeAdapter` - Concentrated liquidity pools
- **SushiSwap**: Uses UniswapV2 adapter (same interface)
- **Curve**: `CurveExchangeAdapter` - Stablecoin and pegged asset pools
- **Balancer**: `BalancerV1IndexExchangeAdapter` - Weighted pools
- **1inch**: `OneInchExchangeAdapter` - Aggregator for best prices
- **Kyber**: `KyberExchangeAdapter` - Dynamic market maker
- **0x Protocol**: Via custom adapter - Liquidity aggregation

#### Setting Up Exchange Integration
```solidity
// 1. Deploy exchange adapter
UniswapV3ExchangeAdapter adapter = new UniswapV3ExchangeAdapter(routerAddress);

// 2. Register in IntegrationRegistry
integrationRegistry.addIntegration(
    address(slippageIssuanceModule),
    "UniswapV3",
    address(adapter)
);

// 3. Use in issuance with slippage protection
slippageIssuanceModule.issueWithSlippage(
    setToken,
    quantity,
    [weth, usdc],           // Check these components for slippage
    [maxWethIn, maxUsdcIn], // Max amounts willing to pay
    recipient
);
```

### Integration with Lending Protocols

For SetTokens with lending positions (Aave, Compound):

#### Position Syncing with Lending
- Lending positions require syncing before issuance/redemption
- Module hooks handle interest accrual and position updates
- SlippageIssuanceModule accounts for these changes in calculations

#### Example: Aave Integration
```solidity
// AaveLeverageModule implements IModuleIssuanceHookV2
// Returns adjustments for collateral and debt positions
function getIssuanceAdjustments(ISetToken _setToken, uint256 _quantity) 
    returns (int256[] memory equity, int256[] memory debt) 
{
    // Calculate interest accrued since last update
    // Return positive adjustment for increased collateral
    // Return negative adjustment for increased debt
}
```

### Integration with Perpetual Protocols

For SetTokens with perpetual futures positions:

#### Key Considerations
- Perpetuals require precise replication due to funding rates
- Position value changes between blocks
- Slippage protection crucial for large positions

#### Example: Perpetual Protocol Integration
```solidity
// PerpV2LeverageModule provides hooks for position adjustments
// Accounts for:
// - Funding payments
// - Price impact of position changes
// - Collateral requirements

slippageIssuanceModule.issueWithSlippage(
    setToken,
    quantity,
    [vETH, vBTC],              // Perpetual positions to check
    [maxVethCost, maxVbtcCost], // Max cost including slippage
    recipient
);
```

### Integration with Staking Protocols

For SetTokens with staked positions:

#### Liquid Staking Tokens
- stETH, rETH, etc. may have price deviations
- Use SlippageIssuanceModule to protect against peg deviations

#### Example: stETH Integration
```solidity
// CurveStEthExchangeAdapter handles ETH <-> stETH conversions
// Accounts for Curve pool imbalances

slippageIssuanceModule.issueWithSlippage(
    setToken,
    quantity,
    [stETH],         // Check stETH for slippage
    [maxStEthIn],    // Max stETH willing to provide
    recipient
);
```

### Custom Protocol Integration

To integrate a new protocol with SlippageIssuanceModule:

#### 1. Implement Module with Issuance Hooks
```solidity
contract CustomProtocolModule is ModuleBase, IModuleIssuanceHookV2 {
    function getIssuanceAdjustments(ISetToken _setToken, uint256 _quantity)
        external
        returns (int256[] memory, int256[] memory)
    {
        // Calculate position changes during issuance
        // Return equity and debt adjustments
    }
    
    function getRedemptionAdjustments(ISetToken _setToken, uint256 _quantity)
        external
        returns (int256[] memory, int256[] memory)
    {
        // Calculate position changes during redemption
    }
}
```

#### 2. Register Module Hook
```solidity
slippageIssuanceModule.registerToIssuanceModule(setToken);
```

#### 3. Create Exchange Adapter (if needed)
```solidity
contract CustomExchangeAdapter is IExchangeAdapter {
    function getSpender() external view returns (address) {
        return CUSTOM_PROTOCOL_ROUTER;
    }
    
    function getTradeCalldata(
        address _fromToken,
        address _toToken,
        address _toAddress,
        uint256 _fromQuantity,
        uint256 _minToQuantity,
        bytes memory _data
    ) external view returns (address, uint256, bytes memory) {
        // Generate protocol-specific calldata
        bytes memory callData = abi.encodeWithSignature(
            "swap(address,address,uint256,uint256)",
            _fromToken, _toToken, _fromQuantity, _minToQuantity
        );
        return (CUSTOM_PROTOCOL_ROUTER, 0, callData);
    }
}
```

### Best Practices

#### 1. Always Use Slippage Protection
- Set reasonable limits based on expected price impact
- Account for gas costs in limit calculations
- Monitor on-chain liquidity before large operations

#### 2. Handle Multiple Protocol Positions
- Order matters when multiple hooks are registered
- Test adjustment calculations thoroughly
- Consider cumulative effects of all positions

#### 3. Gas Optimization
- Batch operations when possible
- Cache frequently accessed data
- Minimize external calls in adjustment calculations

#### 4. Security Considerations
- Validate all adjustment values are within expected ranges
- Implement circuit breakers for extreme market conditions
- Regular audits of custom adapters and modules

## Integration Points

### For Playlist Implementation
1. Use `SetTokenCreator` to deploy playlist tokens
2. Song tokens as components with defined weights
3. `BasicIssuanceModule` for minting/redeeming playlists
4. Optional: `StreamingFeeModule` for creator fees
5. Optional: `TradeModule` for rebalancing song weights

### Key Addresses Needed
- Controller: System registry contract
- SetTokenCreator: Factory for new playlists
- BasicIssuanceModule: For issuance/redemption
- IntegrationRegistry: For protocol integrations

### Deployment Steps
1. Deploy and initialize Controller
2. Deploy SetTokenCreator and register as factory
3. Deploy modules and register with Controller
4. Deploy IntegrationRegistry
5. Add adapters for any external protocols
6. Create SetTokens via factory