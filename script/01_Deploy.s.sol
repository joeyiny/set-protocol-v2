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

import {IWETH} from "../src/contracts/interfaces/external/IWETH.sol";

import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../src/contracts/interfaces/external/IWildcardStateManager.sol";
import {Controller} from "../src/contracts/protocol/Controller.sol";
import {IntegrationRegistry} from "../src/contracts/protocol/IntegrationRegistry.sol";
import {PriceOracle} from "../src/contracts/protocol/PriceOracle.sol";
import {SetToken} from "../src/contracts/protocol/SetToken.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {SetValuer} from "../src/contracts/protocol/SetValuer.sol";

import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {SlippageIssuanceModule} from "../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Deploy is Script {
    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;
    address wildcard_state_manager_base = 0xC67348A3a3F51f8d4BEE9EB792614b7AD4248786;

    Controller public controller;

    address joey_viral_address = 0xc9C03B554f83DEFBAC6b7F4D5c8380c695bda3D2;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with account:", deployer);

        vm.startBroadcast(deployerPrivateKey);

        // // 1. Controller
        controller = new Controller(deployer);

        // // 2. IntegrationRegistry
        IntegrationRegistry integrationRegistry = new IntegrationRegistry(IController(address(controller)));

        // // 3. SetTokenCreator
        SetTokenCreator setTokenCreator = new SetTokenCreator(IController(address(controller)));

        // // 4. SlippageIssuanceModule
        SlippageIssuanceModule slippageIssuanceModule = new SlippageIssuanceModule(IController(address(controller)));

        // // 5. WildcardIssuanceModule
        WildcardIssuanceModule wildcardIssuanceModule = new WildcardIssuanceModule(
            IController(address(controller)),
            IWildcardDeployer(wildcard_deployer_base),
            IWildcardStateManager(wildcard_state_manager_base),
            IWETH(address(weth9_base))
        );

        controller.initialize(new address[](0), new address[](0), new address[](0), new uint256[](0));
        controller.addFactory(address(setTokenCreator));
        controller.addModule(address(slippageIssuanceModule));

        console.log("\n=== Deployment Summary ===");
        console.log("Controller deployed at:", address(controller));
        console.log("IntegrationRegistry deployed at:", address(integrationRegistry));
        console.log("SetTokenCreator deployed at:", address(setTokenCreator));
        console.log("SlippageIssuanceModule deployed at:", address(slippageIssuanceModule));
        console.log("WildcardIssuanceModule deployed at:", address(wildcardIssuanceModule));

        vm.stopBroadcast();
    }
}
