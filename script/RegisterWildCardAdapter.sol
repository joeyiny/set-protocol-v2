// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";

// Wildcard adapter
// import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";

// Basic modules
import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";

contract RegisterWildCardAdapter is Script {
    address public wildcardAmmAdapter = 0xEaf49ba68e8FD79B23a5a8aC145D0dA21e9f2bD3;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        console.log("WildcardAmmAdapter registered");

        vm.stopBroadcast();
    }
}
