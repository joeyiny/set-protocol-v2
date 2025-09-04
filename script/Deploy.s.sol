// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";

// Core protocol contracts
import {Controller} from "../src/contracts/protocol/Controller.sol";
import {IController} from "../src/contracts/interfaces/IController.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {IntegrationRegistry} from "../src/contracts/protocol/IntegrationRegistry.sol";
import {IIntegrationRegistry} from "../src/contracts/interfaces/IIntegrationRegistry.sol";
import {PriceOracle} from "../src/contracts/protocol/PriceOracle.sol";
import {IOracle} from "../src/contracts/interfaces/IOracle.sol";
import {SetValuer} from "../src/contracts/protocol/SetValuer.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";
import {SetToken} from "../src/contracts/protocol/SetToken.sol";
import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
// Wildcard adapter
import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Basic modules
import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";
import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";

contract Deploy is Script {
    Controller public controller;
    SetTokenCreator public setTokenCreator;
    IntegrationRegistry public integrationRegistry;
    PriceOracle public priceOracle;
    SetValuer public setValuer;
    BasicIssuanceModule public basicIssuanceModule;
    StreamingFeeModule public streamingFeeModule;
    WildcardAmmAdapter public wildcardAmmAdapter;
    ISetToken public setToken;

    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;

    address joey_viral_address= 0xc9C03B554f83DEFBAC6b7F4D5c8380c695bda3D2;


    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with account:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Controller
        controller = new Controller(deployer);
        IController controllerInterface = IController(address(controller));

        // 2. IntegrationRegistry
        integrationRegistry = new IntegrationRegistry(controllerInterface);
        
        // 3. PriceOracle (empty adapters/oracles for now)
        address[] memory adapters = new address[](0);
        address[] memory assetOnes = new address[](0);
        address[] memory assetTwos = new address[](0);
        IOracle[] memory oracles = new IOracle[](0);

        priceOracle = new PriceOracle(
            controllerInterface,
            address(0), // no master quote asset
            adapters,
            assetOnes,
            assetTwos,
            oracles
        );

        // 4. SetValuer
        setValuer = new SetValuer(controllerInterface);

        // 5. SetTokenCreator
        setTokenCreator = new SetTokenCreator(controllerInterface);
        
        // 6. Modules
        basicIssuanceModule = new BasicIssuanceModule(controllerInterface);
        streamingFeeModule = new StreamingFeeModule(controllerInterface);

        // ----------- INITIALIZE CONTROLLER -----------
        address[] memory factories = new address[](0); // No factories initially

        address[] memory modules = new address[](2);
        modules[0] = address(basicIssuanceModule);
        modules[1] = address(streamingFeeModule);

        address[] memory resources = new address[](3);
        resources[0] = address(integrationRegistry);
        resources[1] = address(priceOracle);
        resources[2] = address(setValuer);

        uint256[] memory resourceIds = new uint256[](3);
        resourceIds[0] = 0; // INTEGRATION_REGISTRY_RESOURCE_ID
        resourceIds[1] = 1; // PRICE_ORACLE_RESOURCE_ID
        resourceIds[2] = 2; // SET_VALUER_RESOURCE_ID

        controller.initialize(factories, modules, resources, resourceIds);
        
        // Add SetTokenCreator as a factory
        controller.addFactory(address(setTokenCreator));

        console.log("\n=== Deployment Summary ===");
        console.log("Controller:", address(controller));
        console.log("IntegrationRegistry:", address(integrationRegistry));
        console.log("PriceOracle:", address(priceOracle));
        console.log("SetValuer:", address(setValuer));
        console.log("SetTokenCreator:", address(setTokenCreator));
        console.log("BasicIssuanceModule:", address(basicIssuanceModule));
        console.log("StreamingFeeModule:", address(streamingFeeModule));
        vm.stopBroadcast();
        deployWildcardAdapter();
        createSetToken();
        mintSetToken();
    }

    function deployWildcardAdapter() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
         vm.startBroadcast(deployerPrivateKey);

        // Deploy WildcardAmmAdapter
        WildcardAmmAdapter wildcardAdapter = new WildcardAmmAdapter(
            wildcard_deployer_base,
            deployer,
            weth9_base
        );
        
        console.log("WildcardAmmAdapter deployed:", address(wildcardAdapter));
        
        // Register for BasicIssuanceModule to use wildcard tokens
        integrationRegistry.addIntegration(
            address(basicIssuanceModule),
            "WILDCARD",  // Integration name
            address(wildcardAdapter)
        );
        
        console.log("WildcardAmmAdapter registered with BasicIssuanceModule");

        // Verify registration
        address registeredAdapter = integrationRegistry.getIntegrationAdapter(
            address(basicIssuanceModule),
            "WILDCARD"
        );
        
        console.log("Verified adapter registration:", registeredAdapter);
        console.log("Registration successful:", registeredAdapter == address(wildcardAdapter));

        vm.stopBroadcast();
    }

    function createSetToken() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        address[] memory modules = new address[](1);
        modules[0] = address(basicIssuanceModule);
        vm.startBroadcast(deployerPrivateKey);


        address[] memory components = new address[](2);
        components[0] = 0xCd53b5F02D690eF89b51B52a8A42db70be97F26d;
        components[1] = 0x2f0A3ed12f9A3b360084B9622620013e503799cB;

        int256[] memory units = new int256[](2);  
        units[0] = 1e18; // Minimal unit
        units[1] = 1e18; // Minimal unit

        address setTokenAddress = setTokenCreator.create(components, units, modules, deployer, "justin blau songs", "JB-songs");
        console.log("SetToken created: ", setTokenAddress);
        ISetToken setToken = ISetToken(setTokenAddress);
        IManagerIssuanceHook managerIssuanceHook = IManagerIssuanceHook(address(0));
        basicIssuanceModule.initialize(setToken, managerIssuanceHook);
        setToken = setToken;
        bool isInitializedModule = setToken.isInitializedModule(address(basicIssuanceModule));
        console.log("Is initialized module:", isInitializedModule);
        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}( 0xCd53b5F02D690eF89b51B52a8A42db70be97F26d, 1e16, 100, deployer);
        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}(0x2f0A3ed12f9A3b360084B9622620013e503799cB, 1e16, 100, deployer);
        IERC20(0xCd53b5F02D690eF89b51B52a8A42db70be97F26d).approve(address(basicIssuanceModule), 1e36);
        IERC20(0x2f0A3ed12f9A3b360084B9622620013e503799cB).approve(address(basicIssuanceModule), 1e36);
        basicIssuanceModule.issue(setToken, 10e18, deployer);
        vm.stopBroadcast();
        
    }

    function mintSetToken() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        // basicIssuanceModule.issue(setToken, 100, deployer);
        vm.stopBroadcast();
    }
}
