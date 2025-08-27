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
import {PriceOracle} from "../src/contracts/protocol/PriceOracle.sol";
import {IOracle} from "../src/contracts/interfaces/IOracle.sol";
import {SetValuer} from "../src/contracts/protocol/SetValuer.sol";

// Basic modules
import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";

contract Deploy is Script {
    Controller public controller;
    SetTokenCreator public setTokenCreator;
    IntegrationRegistry public integrationRegistry;
    PriceOracle public priceOracle;
    SetValuer public setValuer;
    BasicIssuanceModule public basicIssuanceModule;
    StreamingFeeModule public streamingFeeModule;

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

        // // // 4. SetValuer
        setValuer = new SetValuer(controllerInterface);


        // 5. SetTokenCreator
        setTokenCreator = new SetTokenCreator(controllerInterface);
        
        // // // 6. Modules
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

        // Deploy SetTokenCreator after controller initialization
        
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

    }
}
