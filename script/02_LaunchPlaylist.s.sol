// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";

import {Controller} from "../src/contracts/protocol/Controller.sol";
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
        // WildcardIssuanceModule wildcardIssuanceModule =
        //     WildcardIssuanceModule(0xfC5180481ccD364Ec36c8e5e28A85513CE859dCF);
        SlippageIssuanceModule slippageIssuanceModule =
            SlippageIssuanceModule(0xfbac408ebA2b42cda52C9F2BE81128945B3C764a);
        Controller controller = Controller(0xE9B4979c7075E885b82aa5f1A673aB16B4EB5775);
        address[] memory components = new address[](3);
        components[0] = 0xDf961AE00Ba4F5f1993E25f43850c77C5990dB63;
        components[1] = 0x92c99C9a9eaE3f7385AC2D919D086a96FA1bc4f3;
        components[2] = 0xC5bC2f22c2793FB873f04be35bb9AF2b8C2b616e;

        int256[] memory units = new int256[](3);
        units[0] = 1e18;
        units[1] = 1e18;
        units[2] = 1e18;
        address[] memory modules = new address[](1);
        modules[0] = address(slippageIssuanceModule);

        address setToken = setTokenCreator.create(components, units, modules, deployer, "some cool songs", "BANGERS");

        slippageIssuanceModule.initialize(ISetToken(setToken), 0, 0, 0, deployer, IManagerIssuanceHook(address(0)));

        vm.stopBroadcast();
    }
}
