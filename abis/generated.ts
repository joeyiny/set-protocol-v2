//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BasicIssuanceModule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const basicIssuanceModuleAbi = [
  {
    type: 'constructor',
    inputs: [
      {
        name: '_controller',
        internalType: 'contract IController',
        type: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'controller',
    outputs: [
      { name: '', internalType: 'contract IController', type: 'address' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      { name: '_quantity', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'getRequiredComponentUnitsForIssue',
    outputs: [
      { name: '', internalType: 'address[]', type: 'address[]' },
      { name: '', internalType: 'uint256[]', type: 'uint256[]' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      {
        name: '_preIssueHook',
        internalType: 'contract IManagerIssuanceHook',
        type: 'address',
      },
    ],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      { name: '_quantity', internalType: 'uint256', type: 'uint256' },
      { name: '_to', internalType: 'address', type: 'address' },
    ],
    name: 'issue',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'contract ISetToken', type: 'address' }],
    name: 'managerIssuanceHook',
    outputs: [
      {
        name: '',
        internalType: 'contract IManagerIssuanceHook',
        type: 'address',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      { name: '_quantity', internalType: 'uint256', type: 'uint256' },
      { name: '_to', internalType: 'address', type: 'address' },
    ],
    name: 'redeem',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'removeModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_issuer',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: '_to', internalType: 'address', type: 'address', indexed: true },
      {
        name: '_hookContract',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
      {
        name: '_quantity',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'SetTokenIssued',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_redeemer',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: '_to', internalType: 'address', type: 'address', indexed: true },
      {
        name: '_quantity',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'SetTokenRedeemed',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Controller
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const controllerAbi = [
  {
    type: 'constructor',
    inputs: [
      { name: '_feeRecipient', internalType: 'address', type: 'address' },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_factory', internalType: 'address', type: 'address' }],
    name: 'addFactory',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_feeType', internalType: 'uint256', type: 'uint256' },
      { name: '_newFeePercentage', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'addFee',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'addModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_resource', internalType: 'address', type: 'address' },
      { name: '_id', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'addResource',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_setToken', internalType: 'address', type: 'address' }],
    name: 'addSet',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_feeType', internalType: 'uint256', type: 'uint256' },
      { name: '_newFeePercentage', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'editFee',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_newFeeRecipient', internalType: 'address', type: 'address' },
    ],
    name: 'editFeeRecipient',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'factories',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'feeRecipient',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '', internalType: 'address', type: 'address' },
      { name: '', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'fees',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getFactories',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_moduleAddress', internalType: 'address', type: 'address' },
      { name: '_feeType', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'getModuleFee',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getModules',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getResources',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getSets',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_factories', internalType: 'address[]', type: 'address[]' },
      { name: '_modules', internalType: 'address[]', type: 'address[]' },
      { name: '_resources', internalType: 'address[]', type: 'address[]' },
      { name: '_resourceIds', internalType: 'uint256[]', type: 'uint256[]' },
    ],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'isFactory',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'isInitialized',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'isModule',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'isResource',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'isSet',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_contractAddress', internalType: 'address', type: 'address' },
    ],
    name: 'isSystemContract',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'modules',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_factory', internalType: 'address', type: 'address' }],
    name: 'removeFactory',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'removeModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_id', internalType: 'uint256', type: 'uint256' }],
    name: 'removeResource',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_setToken', internalType: 'address', type: 'address' }],
    name: 'removeSet',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'resourceId',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'resources',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'sets',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_factory',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'FactoryAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_factory',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'FactoryRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_feeType',
        internalType: 'uint256',
        type: 'uint256',
        indexed: true,
      },
      {
        name: '_feePercentage',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'FeeEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_newFeeRecipient',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
    ],
    name: 'FeeRecipientChanged',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ModuleAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ModuleRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'previousOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_resource',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: '_id', internalType: 'uint256', type: 'uint256', indexed: false },
    ],
    name: 'ResourceAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_resource',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: '_id', internalType: 'uint256', type: 'uint256', indexed: false },
    ],
    name: 'ResourceRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_factory',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'SetAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'SetRemoved',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IDeployer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iDeployerAbi = [
  {
    type: 'function',
    inputs: [
      { name: 'token', internalType: 'address', type: 'address' },
      { name: 'amountIn', internalType: 'uint256', type: 'uint256' },
      { name: 'amountOutMin', internalType: 'uint256', type: 'uint256' },
      { name: 'to', internalType: 'address', type: 'address' },
    ],
    name: 'buyToken',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'token', internalType: 'address', type: 'address' },
      { name: 'amountIn', internalType: 'uint256', type: 'uint256' },
      { name: 'amountOutMin', internalType: 'uint256', type: 'uint256' },
      { name: 'to', internalType: 'address', type: 'address' },
    ],
    name: 'sellToken',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'stateManager',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IStateManager
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iStateManagerAbi = [
  {
    type: 'function',
    inputs: [{ name: 'token', internalType: 'address', type: 'address' }],
    name: 'tokenDeploymentConfigs',
    outputs: [
      {
        name: '',
        internalType: 'struct TokenDeploymentConfig',
        type: 'tuple',
        components: [
          { name: 'creator', internalType: 'address', type: 'address' },
          { name: 'baseToken', internalType: 'address', type: 'address' },
          { name: 'name', internalType: 'string', type: 'string' },
          { name: 'symbol', internalType: 'string', type: 'string' },
          { name: 'image', internalType: 'string', type: 'string' },
          { name: 'appIdentifier', internalType: 'string', type: 'string' },
          { name: 'teamSupply', internalType: 'uint256', type: 'uint256' },
          { name: 'vestingStartTime', internalType: 'uint64', type: 'uint64' },
          { name: 'vestingDuration', internalType: 'uint64', type: 'uint64' },
          { name: 'vestingWallet', internalType: 'address', type: 'address' },
          {
            name: 'bondingCurveSupply',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'liquidityPoolSupply',
            internalType: 'uint256',
            type: 'uint256',
          },
          { name: 'totalSupply', internalType: 'uint256', type: 'uint256' },
          {
            name: 'bondingCurveBuyFee',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'bondingCurveSellFee',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'bondingCurveFeeSplits',
            internalType: 'struct FeeSplit[]',
            type: 'tuple[]',
            components: [
              { name: 'recipient', internalType: 'address', type: 'address' },
              { name: 'bps', internalType: 'uint256', type: 'uint256' },
            ],
          },
          {
            name: 'bondingCurveParams',
            internalType: 'struct PriceCurve',
            type: 'tuple',
            components: [
              { name: 'prices', internalType: 'uint256[]', type: 'uint256[]' },
              { name: 'numSteps', internalType: 'uint256', type: 'uint256' },
              { name: 'stepSize', internalType: 'uint256', type: 'uint256' },
            ],
          },
          { name: 'allowForcedGraduation', internalType: 'bool', type: 'bool' },
          { name: 'allowAutoGraduation', internalType: 'bool', type: 'bool' },
          {
            name: 'graduationFeeBps',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'graduationFeeSplits',
            internalType: 'struct FeeSplit[]',
            type: 'tuple[]',
            components: [
              { name: 'recipient', internalType: 'address', type: 'address' },
              { name: 'bps', internalType: 'uint256', type: 'uint256' },
            ],
          },
          { name: 'poolFees', internalType: 'uint24', type: 'uint24' },
          {
            name: 'poolFeeSplits',
            internalType: 'struct FeeSplit[]',
            type: 'tuple[]',
            components: [
              { name: 'recipient', internalType: 'address', type: 'address' },
              { name: 'bps', internalType: 'uint256', type: 'uint256' },
            ],
          },
          {
            name: 'surgeFeeStartingTime',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'surgeFeeDuration',
            internalType: 'uint256',
            type: 'uint256',
          },
          { name: 'maxSurgeFeeBps', internalType: 'uint256', type: 'uint256' },
        ],
      },
    ],
    stateMutability: 'view',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IWETH9
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const iweth9Abi = [
  {
    type: 'function',
    inputs: [
      { name: 'owner', internalType: 'address', type: 'address' },
      { name: 'spender', internalType: 'address', type: 'address' },
    ],
    name: 'allowance',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'approve',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'account', internalType: 'address', type: 'address' }],
    name: 'balanceOf',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'deposit',
    outputs: [],
    stateMutability: 'payable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'totalSupply',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'recipient', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transfer',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'sender', internalType: 'address', type: 'address' },
      { name: 'recipient', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transferFrom',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'withdraw',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'owner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'spender',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Approval',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'from', internalType: 'address', type: 'address', indexed: true },
      { name: 'to', internalType: 'address', type: 'address', indexed: true },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Transfer',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IntegrationRegistry
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const integrationRegistryAbi = [
  {
    type: 'constructor',
    inputs: [
      {
        name: '_controller',
        internalType: 'contract IController',
        type: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
      { name: '_adapter', internalType: 'address', type: 'address' },
    ],
    name: 'addIntegration',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_modules', internalType: 'address[]', type: 'address[]' },
      { name: '_names', internalType: 'string[]', type: 'string[]' },
      { name: '_adapters', internalType: 'address[]', type: 'address[]' },
    ],
    name: 'batchAddIntegration',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_modules', internalType: 'address[]', type: 'address[]' },
      { name: '_names', internalType: 'string[]', type: 'string[]' },
      { name: '_adapters', internalType: 'address[]', type: 'address[]' },
    ],
    name: 'batchEditIntegration',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'controller',
    outputs: [
      { name: '', internalType: 'contract IController', type: 'address' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
      { name: '_adapter', internalType: 'address', type: 'address' },
    ],
    name: 'editIntegration',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
    ],
    name: 'getIntegrationAdapter',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_nameHash', internalType: 'bytes32', type: 'bytes32' },
    ],
    name: 'getIntegrationAdapterWithHash',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
    ],
    name: 'isValidIntegration',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_module', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
    ],
    name: 'removeIntegration',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_adapter',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_integrationName',
        internalType: 'string',
        type: 'string',
        indexed: false,
      },
    ],
    name: 'IntegrationAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_newAdapter',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
      {
        name: '_integrationName',
        internalType: 'string',
        type: 'string',
        indexed: false,
      },
    ],
    name: 'IntegrationEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_adapter',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_integrationName',
        internalType: 'string',
        type: 'string',
        indexed: false,
      },
    ],
    name: 'IntegrationRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'previousOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SetToken
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const setTokenAbi = [
  {
    type: 'constructor',
    inputs: [
      { name: '_components', internalType: 'address[]', type: 'address[]' },
      { name: '_units', internalType: 'int256[]', type: 'int256[]' },
      { name: '_modules', internalType: 'address[]', type: 'address[]' },
      {
        name: '_controller',
        internalType: 'contract IController',
        type: 'address',
      },
      { name: '_manager', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
      { name: '_symbol', internalType: 'string', type: 'string' },
    ],
    stateMutability: 'nonpayable',
  },
  { type: 'receive', stateMutability: 'payable' },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'addComponent',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
    ],
    name: 'addExternalPositionModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'addModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'owner', internalType: 'address', type: 'address' },
      { name: 'spender', internalType: 'address', type: 'address' },
    ],
    name: 'allowance',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'approve',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'account', internalType: 'address', type: 'address' }],
    name: 'balanceOf',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_account', internalType: 'address', type: 'address' },
      { name: '_quantity', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'burn',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'components',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'controller',
    outputs: [
      { name: '', internalType: 'contract IController', type: 'address' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'decimals',
    outputs: [{ name: '', internalType: 'uint8', type: 'uint8' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'subtractedValue', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'decreaseAllowance',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_realUnit', internalType: 'int256', type: 'int256' },
    ],
    name: 'editDefaultPositionUnit',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
      { name: '_data', internalType: 'bytes', type: 'bytes' },
    ],
    name: 'editExternalPositionData',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
      { name: '_realUnit', internalType: 'int256', type: 'int256' },
    ],
    name: 'editExternalPositionUnit',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_newMultiplier', internalType: 'int256', type: 'int256' },
    ],
    name: 'editPositionMultiplier',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getComponents',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'getDefaultPositionRealUnit',
    outputs: [{ name: '', internalType: 'int256', type: 'int256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
    ],
    name: 'getExternalPositionData',
    outputs: [{ name: '', internalType: 'bytes', type: 'bytes' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'getExternalPositionModules',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
    ],
    name: 'getExternalPositionRealUnit',
    outputs: [{ name: '', internalType: 'int256', type: 'int256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getModules',
    outputs: [{ name: '', internalType: 'address[]', type: 'address[]' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getPositions',
    outputs: [
      {
        name: '',
        internalType: 'struct ISetToken.Position[]',
        type: 'tuple[]',
        components: [
          { name: 'component', internalType: 'address', type: 'address' },
          { name: 'module', internalType: 'address', type: 'address' },
          { name: 'unit', internalType: 'int256', type: 'int256' },
          { name: 'positionState', internalType: 'uint8', type: 'uint8' },
          { name: 'data', internalType: 'bytes', type: 'bytes' },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'getTotalComponentRealUnits',
    outputs: [{ name: '', internalType: 'int256', type: 'int256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'addedValue', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'increaseAllowance',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'initializeModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_target', internalType: 'address', type: 'address' },
      { name: '_value', internalType: 'uint256', type: 'uint256' },
      { name: '_data', internalType: 'bytes', type: 'bytes' },
    ],
    name: 'invoke',
    outputs: [{ name: '_returnValue', internalType: 'bytes', type: 'bytes' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'isComponent',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_module', internalType: 'address', type: 'address' },
    ],
    name: 'isExternalPositionModule',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'isInitializedModule',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'isLocked',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'isPendingModule',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'lock',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'locker',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'manager',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_account', internalType: 'address', type: 'address' },
      { name: '_quantity', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'mint',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'moduleStates',
    outputs: [
      { name: '', internalType: 'enum ISetToken.ModuleState', type: 'uint8' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'modules',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'name',
    outputs: [{ name: '', internalType: 'string', type: 'string' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'positionMultiplier',
    outputs: [{ name: '', internalType: 'int256', type: 'int256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '_component', internalType: 'address', type: 'address' }],
    name: 'removeComponent',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '_component', internalType: 'address', type: 'address' },
      { name: '_positionModule', internalType: 'address', type: 'address' },
    ],
    name: 'removeExternalPositionModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'removeModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_module', internalType: 'address', type: 'address' }],
    name: 'removePendingModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_manager', internalType: 'address', type: 'address' }],
    name: 'setManager',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'symbol',
    outputs: [{ name: '', internalType: 'string', type: 'string' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'totalSupply',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'recipient', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transfer',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'sender', internalType: 'address', type: 'address' },
      { name: 'recipient', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transferFrom',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'unlock',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'owner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'spender',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Approval',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ComponentAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ComponentRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_realUnit',
        internalType: 'int256',
        type: 'int256',
        indexed: false,
      },
    ],
    name: 'DefaultPositionUnitEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_positionModule',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: '_data', internalType: 'bytes', type: 'bytes', indexed: false },
    ],
    name: 'ExternalPositionDataEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_positionModule',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_realUnit',
        internalType: 'int256',
        type: 'int256',
        indexed: false,
      },
    ],
    name: 'ExternalPositionUnitEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_target',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: true,
      },
      { name: '_data', internalType: 'bytes', type: 'bytes', indexed: false },
      {
        name: '_returnValue',
        internalType: 'bytes',
        type: 'bytes',
        indexed: false,
      },
    ],
    name: 'Invoked',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_newManager',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
      {
        name: '_oldManager',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
    ],
    name: 'ManagerEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ModuleAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ModuleInitialized',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'ModuleRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_module',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'PendingModuleRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_positionModule',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'PositionModuleAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_component',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_positionModule',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'PositionModuleRemoved',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_newMultiplier',
        internalType: 'int256',
        type: 'int256',
        indexed: false,
      },
    ],
    name: 'PositionMultiplierEdited',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'from', internalType: 'address', type: 'address', indexed: true },
      { name: 'to', internalType: 'address', type: 'address', indexed: true },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Transfer',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SetTokenCreator
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const setTokenCreatorAbi = [
  {
    type: 'constructor',
    inputs: [
      {
        name: '_controller',
        internalType: 'contract IController',
        type: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'controller',
    outputs: [
      { name: '', internalType: 'contract IController', type: 'address' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: '_components', internalType: 'address[]', type: 'address[]' },
      { name: '_units', internalType: 'int256[]', type: 'int256[]' },
      { name: '_modules', internalType: 'address[]', type: 'address[]' },
      { name: '_manager', internalType: 'address', type: 'address' },
      { name: '_name', internalType: 'string', type: 'string' },
      { name: '_symbol', internalType: 'string', type: 'string' },
    ],
    name: 'create',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_manager',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
      { name: '_name', internalType: 'string', type: 'string', indexed: false },
      {
        name: '_symbol',
        internalType: 'string',
        type: 'string',
        indexed: false,
      },
    ],
    name: 'SetTokenCreated',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// StreamingFeeModule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const streamingFeeModuleAbi = [
  {
    type: 'constructor',
    inputs: [
      {
        name: '_controller',
        internalType: 'contract IController',
        type: 'address',
      },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
    ],
    name: 'accrueFee',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'controller',
    outputs: [
      { name: '', internalType: 'contract IController', type: 'address' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'contract ISetToken', type: 'address' }],
    name: 'feeStates',
    outputs: [
      { name: 'feeRecipient', internalType: 'address', type: 'address' },
      {
        name: 'maxStreamingFeePercentage',
        internalType: 'uint256',
        type: 'uint256',
      },
      {
        name: 'streamingFeePercentage',
        internalType: 'uint256',
        type: 'uint256',
      },
      {
        name: 'lastStreamingFeeTimestamp',
        internalType: 'uint256',
        type: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
    ],
    name: 'getFee',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      {
        name: '_settings',
        internalType: 'struct StreamingFeeModule.FeeState',
        type: 'tuple',
        components: [
          { name: 'feeRecipient', internalType: 'address', type: 'address' },
          {
            name: 'maxStreamingFeePercentage',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'streamingFeePercentage',
            internalType: 'uint256',
            type: 'uint256',
          },
          {
            name: 'lastStreamingFeeTimestamp',
            internalType: 'uint256',
            type: 'uint256',
          },
        ],
      },
    ],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'removeModule',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      { name: '_newFeeRecipient', internalType: 'address', type: 'address' },
    ],
    name: 'updateFeeRecipient',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      {
        name: '_setToken',
        internalType: 'contract ISetToken',
        type: 'address',
      },
      { name: '_newFee', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'updateStreamingFee',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_managerFee',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: '_protocolFee',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'FeeActualized',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_newFeeRecipient',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
    ],
    name: 'FeeRecipientUpdated',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: '_setToken',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: '_newStreamingFee',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'StreamingFeeUpdated',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WildcardAmmAdapter
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const wildcardAmmAdapterAbi = [
  {
    type: 'constructor',
    inputs: [
      { name: '_deployer', internalType: 'address', type: 'address' },
      { name: '_owner', internalType: 'address', type: 'address' },
      { name: '_weth', internalType: 'address', type: 'address' },
    ],
    stateMutability: 'nonpayable',
  },
  { type: 'receive', stateMutability: 'payable' },
  {
    type: 'function',
    inputs: [
      { name: 'token', internalType: 'address', type: 'address' },
      { name: 'amountIn', internalType: 'uint256', type: 'uint256' },
      { name: 'amountOutMin', internalType: 'uint256', type: 'uint256' },
      { name: 'to', internalType: 'address', type: 'address' },
    ],
    name: 'buyToken',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'getSpender',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'fromToken', internalType: 'address', type: 'address' },
      { name: 'toToken', internalType: 'address', type: 'address' },
      { name: 'toAddress', internalType: 'address', type: 'address' },
      { name: 'fromQuantity', internalType: 'uint256', type: 'uint256' },
      { name: 'minToQuantity', internalType: 'uint256', type: 'uint256' },
      { name: '_data', internalType: 'bytes', type: 'bytes' },
    ],
    name: 'getTradeCalldata',
    outputs: [
      { name: '', internalType: 'address', type: 'address' },
      { name: '', internalType: 'uint256', type: 'uint256' },
      { name: '', internalType: 'bytes', type: 'bytes' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'owner',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'renounceOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'token', internalType: 'address', type: 'address' },
      { name: 'amountIn', internalType: 'uint256', type: 'uint256' },
      { name: 'amountOutMin', internalType: 'uint256', type: 'uint256' },
      { name: 'to', internalType: 'address', type: 'address' },
    ],
    name: 'sellToken',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'newOwner', internalType: 'address', type: 'address' }],
    name: 'transferOwnership',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '_deployer', internalType: 'address', type: 'address' }],
    name: 'updateDeployer',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'previousOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'OwnershipTransferred',
  },
] as const
