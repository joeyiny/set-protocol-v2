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
/*
== Logs ==
  Deploying contracts with account: 0x8f7BC04Ebf9F1044a6856732002b14e296718F29
  
=== Deployment Summary ===
  Controller deployed at: 0xE9B4979c7075E885b82aa5f1A673aB16B4EB5775
  IntegrationRegistry deployed at: 0x9E16b31b03f8d6f9dDFa406A83bb8a96BFa8e3cf
  SetTokenCreator deployed at: 0xb11876B158304b50eC1Ae19e20A89435918Db44C
  SlippageIssuanceModule deployed at: 0xfbac408ebA2b42cda52C9F2BE81128945B3C764a
  WildcardIssuanceModule deployed at: 0xfC5180481ccD364Ec36c8e5e28A85513CE859dCF

  */

contract LaunchPlaylist is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        SetTokenCreator setTokenCreator = SetTokenCreator(0xb11876B158304b50eC1Ae19e20A89435918Db44C);
        WildcardIssuanceModule wildcardIssuanceModule =
            WildcardIssuanceModule(0xfC5180481ccD364Ec36c8e5e28A85513CE859dCF);
        SlippageIssuanceModule slippageIssuanceModule =
            SlippageIssuanceModule(0xfbac408ebA2b42cda52C9F2BE81128945B3C764a);

        address[] memory components = new address[](1);
        components[0] = 0xCe91B0aeff1380F53BB0d98Fc9a3819d18d9bbd9; // yeat
        int256[] memory units = new int256[](1);
        units[0] = 1e18;
        address[] memory modules = new address[](1);
        modules[0] = address(slippageIssuanceModule);

        address setToken = setTokenCreator.create(components, units, modules, deployer, "yeat songs 3", "YEAT");

        slippageIssuanceModule.initialize(ISetToken(setToken), 0, 0, 0, deployer, IManagerIssuanceHook(address(0)));
        vm.stopBroadcast();
    }
}
