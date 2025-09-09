// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";

// Core protocol contracts

import {IController} from "../src/contracts/interfaces/IController.sol";

import {IIntegrationRegistry} from "../src/contracts/interfaces/IIntegrationRegistry.sol";

import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {IOracle} from "../src/contracts/interfaces/IOracle.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";
import {Controller} from "../src/contracts/protocol/Controller.sol";
import {IntegrationRegistry} from "../src/contracts/protocol/IntegrationRegistry.sol";
import {PriceOracle} from "../src/contracts/protocol/PriceOracle.sol";
import {SetToken} from "../src/contracts/protocol/SetToken.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {SetValuer} from "../src/contracts/protocol/SetValuer.sol";
// Wildcard adapter
// import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Basic modules

import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";

contract Deploy is Script {
    Controller public controller;
    // SetTokenCreator public setTokenCreator;
    IntegrationRegistry public integrationRegistry;
    PriceOracle public priceOracle;
    SetValuer public setValuer;
    // BasicIssuanceModule public basicIssuanceModule;
    StreamingFeeModule public streamingFeeModule;
    // WildcardAmmAdapter public wildcardAmmAdapter;
    ISetToken public setToken;

    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;

    address joey_viral_address = 0xc9C03B554f83DEFBAC6b7F4D5c8380c695bda3D2;
    BasicIssuanceModule public basicIssuanceModule = BasicIssuanceModule(0xCc801C704E7171c3DB19de0Bf5B8771ad5E652Ae);
    SetTokenCreator public setTokenCreator = SetTokenCreator(0x2d1D7c8d431aC8dF397A9e7A03fe1b933Dd9CFFe);

    address public tokenOne = 0xA20e7196f420ecC3a520e806fFb86934bF88dED9;
    address public tokenTwo = 0xCd53b5F02D690eF89b51B52a8A42db70be97F26d;

    function run() external {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // address deployer = vm.addr(deployerPrivateKey);

        // console.log("Deploying contracts with account:", deployer);

        // vm.startBroadcast(deployerPrivateKey);

        // // 1. Controller
        // controller = new Controller(deployer);
        // IController controllerInterface = IController(address(controller));

        // // 2. IntegrationRegistry
        // integrationRegistry = new IntegrationRegistry(controllerInterface);

        // // 3. PriceOracle (empty adapters/oracles for now)
        // address[] memory adapters = new address[](0);
        // address[] memory assetOnes = new address[](0);
        // address[] memory assetTwos = new address[](0);
        // IOracle[] memory oracles = new IOracle[](0);

        // priceOracle = new PriceOracle(
        //     controllerInterface,
        //     address(0), // no master quote asset
        //     adapters,
        //     assetOnes,
        //     assetTwos,
        //     oracles
        // );

        // // 4. SetValuer
        // setValuer = new SetValuer(controllerInterface);

        // // 5. SetTokenCreator
        // setTokenCreator = new SetTokenCreator(controllerInterface);

        // // 6. Modules
        // basicIssuanceModule = new BasicIssuanceModule(controllerInterface);
        // streamingFeeModule = new StreamingFeeModule(controllerInterface);

        // // ----------- INITIALIZE CONTROLLER -----------
        // address[] memory factories = new address[](0); // No factories initially

        // address[] memory modules = new address[](2);
        // modules[0] = address(basicIssuanceModule);
        // modules[1] = address(streamingFeeModule);

        // address[] memory resources = new address[](3);
        // resources[0] = address(integrationRegistry);
        // resources[1] = address(priceOracle);
        // resources[2] = address(setValuer);

        // uint256[] memory resourceIds = new uint256[](3);
        // resourceIds[0] = 0; // INTEGRATION_REGISTRY_RESOURCE_ID
        // resourceIds[1] = 1; // PRICE_ORACLE_RESOURCE_ID
        // resourceIds[2] = 2; // SET_VALUER_RESOURCE_ID

        // controller.initialize(factories, modules, resources, resourceIds);

        // // Add SetTokenCreator as a factory
        // controller.addFactory(address(setTokenCreator));

        // console.log("\n=== Deployment Summary ===");
        // console.log("Controller:", address(controller));
        // console.log("IntegrationRegistry:", address(integrationRegistry));
        // console.log("PriceOracle:", address(priceOracle));
        // console.log("SetValuer:", address(setValuer));
        // console.log("SetTokenCreator:", address(setTokenCreator));
        // console.log("BasicIssuanceModule:", address(basicIssuanceModule));
        // console.log("StreamingFeeModule:", address(streamingFeeModule));
        // vm.stopBroadcast();
        // deployWildcardAdapter();
        createSetToken();
        // mintSetToken();
    }

    // function deployWildcardAdapter() public {
    //     uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    //     address deployer = vm.addr(deployerPrivateKey);
    //     vm.startBroadcast(deployerPrivateKey);

    //     // Deploy WildcardAmmAdapter
    //     // WildcardAmmAdapter wildcardAdapter = new WildcardAmmAdapter(wildcard_deployer_base, deployer, weth9_base);

    //     console.log("WildcardAmmAdapter deployed:", address(wildcardAdapter));

    //     // Register for BasicIssuanceModule to use wildcard tokens
    //     integrationRegistry.addIntegration(
    //         address(basicIssuanceModule),
    //         "WILDCARD", // Integration name
    //         address(wildcardAdapter)
    //     );

    //     console.log("WildcardAmmAdapter registered with BasicIssuanceModule");

    //     // Verify registration
    //     address registeredAdapter = integrationRegistry.getIntegrationAdapter(address(basicIssuanceModule), "WILDCARD");

    //     console.log("Verified adapter registration:", registeredAdapter);
    //     console.log("Registration successful:", registeredAdapter == address(wildcardAdapter));

    //     vm.stopBroadcast();
    // }

    function createSetToken() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);
        address[] memory modules = new address[](1);
        modules[0] = address(basicIssuanceModule);

        address[] memory components = new address[](2);
        components[0] = tokenOne;
        components[1] = tokenTwo;

        int256[] memory units = new int256[](2);
        units[0] = 1e18; // Minimal unit
        units[1] = 1e18; // Minimal unit

        address setTokenAddress =
            setTokenCreator.create(components, units, modules, deployer, "Joey's Gym songs", "AURA");
        console.log("SetToken created: ", setTokenAddress);
        ISetToken setToken = ISetToken(setTokenAddress);
        IManagerIssuanceHook managerIssuanceHook = IManagerIssuanceHook(address(0));
        basicIssuanceModule.initialize(setToken, managerIssuanceHook);
        setToken = setToken;

        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}(tokenOne, 1e16, 0, deployer);
        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}(tokenTwo, 1e16, 0, deployer);

        uint256 balanceTokenOne = IERC20(tokenOne).balanceOf(deployer);
        uint256 balanceTokenTwo = IERC20(tokenTwo).balanceOf(deployer);
        console.log("Balance token one: ", balanceTokenOne);
        console.log("Balance token two: ", balanceTokenTwo);

        IERC20(tokenOne).approve(address(basicIssuanceModule), balanceTokenOne);
        IERC20(tokenTwo).approve(address(basicIssuanceModule), balanceTokenTwo);

        basicIssuanceModule.issue(setToken, 1e18, deployer);

        vm.stopBroadcast();
    }

    function mintSetToken() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        // basicIssuanceModule.issue(setToken, 100, deployer);
        vm.stopBroadcast();
    }

    // function deployTradeModule() public {
    //       uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    // address deployer = vm.addr(deployerPrivateKey);

    // console.log("\n=== Set Protocol V2 Configuration ===");
    // console.log("Deployer:", deployer);
    // console.log("Controller:", CONTROLLER_ADDRESS);
    // console.log("IntegrationRegistry:", INTEGRATION_REGISTRY_ADDRESS);
    // console.log("WildcardAmmAdapter:", WILDCARD_AMM_ADAPTER_ADDRESS);

    // Controller controller = Controller(CONTROLLER_ADDRESS);
    // IntegrationRegistry integrationRegistry = IntegrationRegistry(INTEGRATION_REGISTRY_ADDRESS);

    // vm.startBroadcast(deployerPrivateKey);

    // // Deploy TradeModule
    // console.log("\n=== Deploying TradeModule ===");
    // TradeModule tradeModule = new TradeModule(IController(CONTROLLER_ADDRESS));
    // console.log("TradeModule deployed at:", address(tradeModule));

    // // Add TradeModule to Controller
    // console.log("\n=== Adding TradeModule to Controller ===");
    // controller.addModule(address(tradeModule));
    // console.log("TradeModule added to Controller");

    // // Add WildcardAmmAdapter to IntegrationRegistry for TradeModule
    // console.log("\n=== Configuring IntegrationRegistry ===");
    // string memory wildExchangeName = "WildcardExchange";
    // integrationRegistry.addIntegration(
    //   address(tradeModule),
    //   wildExchangeName,
    //   WILDCARD_AMM_ADAPTER_ADDRESS
    // );
    // console.log("WildcardAmmAdapter registered for TradeModule");

    // // Get all SetTokens from Controller
    // console.log("\n=== Initializing TradeModule for SetTokens ===");
    // address[] memory sets = controller.getSets();
    // console.log("Found", sets.length, "SetTokens");

    // for (uint256 i = 0; i < sets.length; i++) {
    //   ISetToken setToken = ISetToken(sets[i]);
    //   console.log("\nProcessing SetToken", i + 1, ":", sets[i]);

    //   // Check if TradeModule is already initialized
    //   bool isInitialized = setToken.isInitializedModule(address(tradeModule));

    //   if (!isInitialized) {
    //     // Check if the module is pending
    //     bool isPending = setToken.isPendingModule(address(tradeModule));

    //     if (!isPending) {
    //       // Add as pending module first
    //       console.log("  Adding TradeModule as pending module...");
    //       SetToken(payable(sets[i])).addModule(address(tradeModule));
    //     }

    //     // Initialize the module
    //     console.log("  Initializing TradeModule...");
    //     tradeModule.initialize(setToken);
    //     console.log("  TradeModule initialized for SetToken");
    //   } else {
    //     console.log("  TradeModule already initialized");
    //   }
    // }

    // vm.stopBroadcast();

    // // Display final status
    // console.log("\n=== Final Status ===");
    // address[] memory modules = controller.getModules();
    // console.log("Total modules registered:", modules.length);
    // for (uint256 i = 0; i < modules.length; i++) {
    //   console.log("Module", i + 1, ":", modules[i]);
    //   if (modules[i] == address(tradeModule)) {
    //     console.log("  ^ TradeModule (NEW)");
    //   }
    // }

    // // Check integrations
    // console.log("\n=== Integration Registry Status ===");
    // address wildcardAdapter = integrationRegistry.getIntegrationAdapter(
    //   address(tradeModule),
    //   wildExchangeName
    // );
    // console.log("WildcardAmmAdapter for TradeModule:", wildcardAdapter);

    // console.log("\n✅ TradeModule deployment and configuration complete!");
    // }
}
