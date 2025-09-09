// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import {IController} from "../src/contracts/interfaces/IController.sol";

import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";
import {IWETH} from "../src/contracts/interfaces/external/IWETH.sol";

import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../src/contracts/interfaces/external/IWildcardStateManager.sol";
import {Controller} from "../src/contracts/protocol/Controller.sol";
import {IntegrationRegistry} from "../src/contracts/protocol/IntegrationRegistry.sol";
import {SetToken} from "../src/contracts/protocol/SetToken.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {SlippageIssuanceModule} from "../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {TradeModule} from "../src/contracts/protocol/modules/v1/TradeModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// === Deployment Summary ===
//   Controller: 0xB54E915DEDD1d824Bba47b21c5f624CC7B49682b
//   IntegrationRegistry: 0xf3b8F9f08D0eba650DD72519426584C53a8C74A6
//   PriceOracle: 0xa9271779222B768c5d3f75765aA02d6DbCf7e717
//   SetValuer: 0xC8B1f705A9B0504d3948E7FFcAEC4B17905AEA5d
//   SetTokenCreator: 0x2d1D7c8d431aC8dF397A9e7A03fe1b933Dd9CFFe
//   BasicIssuanceModule: 0xCc801C704E7171c3DB19de0Bf5B8771ad5E652Ae
//   StreamingFeeModule: 0xd62D838C62e63Ce05F91339e1589dA7A54ad616d
//   TradeModule: 0x0E3064Ff3bE9eBE773018d269DAaE9C28736b05b

contract Sep5 is Script {
    /* This is a script to test the WildcardExchangeAdapter.
    We must deploy the WildcardExchangeAdapter and register it with the IntegrationRegistry.
    Then we must deploy the TradeModule and register it with the Controller.
    Then we must attempt to trade the given SetToken.
    */

    SetTokenCreator setTokenCreator = SetTokenCreator(0x2d1D7c8d431aC8dF397A9e7A03fe1b933Dd9CFFe);
    TradeModule tradeModule = TradeModule(0x0E3064Ff3bE9eBE773018d269DAaE9C28736b05b);
    IntegrationRegistry integrationRegistry = IntegrationRegistry(0xf3b8F9f08D0eba650DD72519426584C53a8C74A6);
    Controller controller = Controller(0xB54E915DEDD1d824Bba47b21c5f624CC7B49682b);
    address public wildcardDeployerAddress = (0x065EE5e9Ab0A4A382a5763f935176B880d512b06);
    address public wildcardStateManagerAddress = (0xC67348A3a3F51f8d4BEE9EB792614b7AD4248786);

    address public tokenOne = (0xB257816C42Cc6fAEb7795B9d2729d55d972EFe4b);
    address public tokenTwo = (0x343217f77657A0F7319701bce196D6d43d009C14);
    IWETH public weth = IWETH(0x4200000000000000000000000000000000000006);
    ISetToken setToken = ISetToken(0x68Dcb3bb7Aa7430162603D1DbF5FEa4859072b01);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy and add SlippageIssuanceModule first
        SlippageIssuanceModule slippageIssuanceModule = new SlippageIssuanceModule(IController(address(controller)));
        controller.addModule(address(slippageIssuanceModule));
        setToken.addModule(address(slippageIssuanceModule));

        // Deploy and add WildcardIssuanceModule second (before initializing either)
        WildcardIssuanceModule wildcardIssuanceModule = new WildcardIssuanceModule(
            IController(address(controller)),
            IWildcardDeployer(wildcardDeployerAddress),
            IWildcardStateManager(wildcardStateManagerAddress),
            IWETH(address(weth))
        );
        controller.addModule(address(wildcardIssuanceModule));
        setToken.addModule(address(wildcardIssuanceModule));

        // Initialize SlippageIssuanceModule first
        slippageIssuanceModule.initialize(
            setToken,
            0, // maxManagerFee
            0, // issueFee
            0, // redeemFee
            deployer, // feeRecipient
            IManagerIssuanceHook(address(0)) // managerIssuanceHook
        );

        // Initialize WildcardIssuanceModule after - it will register itself with SlippageIssuanceModule
        wildcardIssuanceModule.initialize(setToken);

        // Approve WETH to WildcardIssuanceModule so it can pull WETH and convert to ETH for buying
        IERC20(weth).approve(address(wildcardIssuanceModule), type(uint256).max);
        console.log("Approved WETH to WildcardIssuanceModule");

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

        // Wrap ETH into WETH for the deployer
        uint256 ethToWrap = 10 ether;
        weth.deposit{value: ethToWrap}();
        console.log("Wrapped ETH into WETH for deployer: ", ethToWrap);

        slippageIssuanceModule.issueWithSlippage(
            setToken,
            5e17,
            allComponents, // _checkedComponents
            maxAmounts, // _maxTokenAmountsIn (empty array)
            deployer
        );

        vm.stopBroadcast();
    }
}
