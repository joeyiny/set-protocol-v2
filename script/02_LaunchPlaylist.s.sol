// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {SlippageIssuanceModule} from "../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";

contract LaunchPlaylist is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        SetTokenCreator setTokenCreator = SetTokenCreator(0xAbA5C2D79a9F7532130ea3c30dabb82b094EDf39);
        WildcardIssuanceModule wildcardIssuanceModule =
            WildcardIssuanceModule(0xf19286981C39C092C02802733704AFd098c897A5);

        address[] memory components = new address[](1);
        components[0] = 0xCe91B0aeff1380F53BB0d98Fc9a3819d18d9bbd9; // yeat
        int256[] memory units = new int256[](1);
        units[0] = 1e18;
        address[] memory modules = new address[](1);
        modules[0] = 0x83C7444b1224210641Ad7231BeE8181d870A28e6;

        address setToken = setTokenCreator.create(components, units, modules, deployer, "yeat songs", "YEAT");

        SlippageIssuanceModule slippageIssuanceModule =
            SlippageIssuanceModule(0x83C7444b1224210641Ad7231BeE8181d870A28e6);

        slippageIssuanceModule.initialize(ISetToken(setToken), 0, 0, 0, deployer, IManagerIssuanceHook(address(0)));

        vm.stopBroadcast();
    }
}
