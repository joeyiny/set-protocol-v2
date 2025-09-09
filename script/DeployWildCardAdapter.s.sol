// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";
// import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";
import {IIntegrationRegistry} from "../src/contracts/interfaces/IIntegrationRegistry.sol";

contract DeployWildCardAdapter is Script {
    address public constant INTEGRATION_REGISTRY = 0xA2706b7b75EaaCd54b9C980711f4F4B8f8896Aaa;
    address public constant BASIC_ISSUANCE_MODULE = 0x22Fff118CDCC37848967B84cD373e653c7e04409;

    address public constant WETH9_BASE = 0x4200000000000000000000000000000000000006;
    address public constant WILDCARD_DEPLOYER_BASE = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying WildcardAmmAdapter...");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy WildcardAmmAdapter
        // WildcardAmmAdapter wildcardAdapter = new WildcardAmmAdapter(WILDCARD_DEPLOYER_BASE, deployer, WETH9_BASE);

        // console.log("WildcardAmmAdapter deployed:", address(wildcardAdapter));

        // // Register the adapter with IntegrationRegistry
        // IIntegrationRegistry integrationRegistry = IIntegrationRegistry(INTEGRATION_REGISTRY);

        // // Register for BasicIssuanceModule to use wildcard tokens
        // integrationRegistry.addIntegration(
        //     BASIC_ISSUANCE_MODULE,
        //     "WILDCARD", // Integration name
        //     address(wildcardAdapter)
        // );

        // console.log("WildcardAmmAdapter registered with BasicIssuanceModule");

        // // Verify registration
        // address registeredAdapter = integrationRegistry.getIntegrationAdapter(BASIC_ISSUANCE_MODULE, "WILDCARD");

        // console.log("Verified adapter registration:", registeredAdapter);
        // console.log("Registration successful:", registeredAdapter == address(wildcardAdapter));

        vm.stopBroadcast();
    }
}
