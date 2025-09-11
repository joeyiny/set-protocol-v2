// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {IController} from "../../src/contracts/interfaces/IController.sol";

import {IWETH} from "../../src/contracts/interfaces/external/IWETH.sol";
import {IWildcardDeployer} from "../../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../../src/contracts/interfaces/external/IWildcardStateManager.sol";
import {Controller} from "../../src/contracts/protocol/Controller.sol";
import {IntegrationRegistry} from "../../src/contracts/protocol/IntegrationRegistry.sol";
import {SetTokenCreator} from "../../src/contracts/protocol/SetTokenCreator.sol";
import {SlippageIssuanceModule} from "../../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {WildcardIssuanceModule} from "../../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";

abstract contract BaseTest is Test {
    // Base mainnet addresses
    address constant WETH_BASE = 0x4200000000000000000000000000000000000006;
    address constant WILDCARD_DEPLOYER_BASE = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;
    address constant WILDCARD_STATE_MANAGER_BASE = 0xC67348A3a3F51f8d4BEE9EB792614b7AD4248786;

    // Common test addresses
    address deployer;
    address user;
    address manager;

    // Core protocol contracts
    Controller controller;
    IntegrationRegistry integrationRegistry;
    SetTokenCreator setTokenCreator;
    SlippageIssuanceModule slippageIssuanceModule;
    WildcardIssuanceModule wildcardIssuanceModule;

    function baseSetUp() internal {
        forkBase();
        // Setup test accounts
        deployer = makeAddr("deployer");
        user = makeAddr("user");
        manager = makeAddr("manager");

        // Give test accounts ETH
        vm.deal(deployer, 1000 ether);
        vm.deal(user, 1000 ether);
        vm.deal(manager, 1000 ether);

        // Deploy core protocol
        vm.startPrank(deployer);

        controller = new Controller(deployer);
        integrationRegistry = new IntegrationRegistry(IController(address(controller)));
        setTokenCreator = new SetTokenCreator(IController(address(controller)));
        slippageIssuanceModule = new SlippageIssuanceModule(IController(address(controller)));

        wildcardIssuanceModule = new WildcardIssuanceModule(
            IController(address(controller)),
            IWildcardDeployer(WILDCARD_DEPLOYER_BASE),
            IWildcardStateManager(WILDCARD_STATE_MANAGER_BASE),
            IWETH(WETH_BASE)
        );

        // Initialize controller
        address[] memory factories = new address[](1);
        factories[0] = address(setTokenCreator);

        address[] memory modules = new address[](1);
        modules[0] = address(slippageIssuanceModule);
        address[] memory resources = new address[](1);
        resources[0] = address(integrationRegistry);

        uint256[] memory resourceIds = new uint256[](1);
        resourceIds[0] = 0; // IntegrationRegistry resource ID

        controller.initialize(factories, modules, resources, resourceIds);

        vm.stopPrank();
    }

    function forkBase() internal {
        string memory rpcUrl = vm.envString("RPC_URL");
        uint256 forkId = vm.createFork(rpcUrl);
        vm.selectFork(forkId);
    }

    function forkBaseAtBlock(uint256 blockNumber) internal {
        string memory rpcUrl = vm.envString("RPC_URL");
        uint256 forkId = vm.createFork(rpcUrl, blockNumber);
        vm.selectFork(forkId);
    }
}
