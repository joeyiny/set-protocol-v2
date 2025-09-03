// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.10;

pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";

contract DeployWildcardAdapter is Script {
    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        wildcardAmmAdapter wildcardAmmAdapter = new WildcardAmmAdapter(wildcard_deployer_base, deployer, weth9_base);

        console.log("WildcardAmmAdapter deployed:", address(wildcardAmmAdapter));

        vm.stopBroadcast();
    }
}