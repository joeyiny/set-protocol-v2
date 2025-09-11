// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";

import {IWETH} from "../src/contracts/interfaces/external/IWETH.sol";

import {IDebtIssuanceModule} from "../src/contracts/interfaces/IDebtIssuanceModule.sol";

import {Controller} from "../src/contracts/protocol/Controller.sol";
import {IController} from "../src/contracts/interfaces/IController.sol";
import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../src/contracts/interfaces/external/IWildcardStateManager.sol";
import {SlippageIssuanceModule} from "../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
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

contract BuyPlaylist is Script {
    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;
    address wildcard_state_manager_base = 0xC67348A3a3F51f8d4BEE9EB792614b7AD4248786;
    address joey_viral_address = 0xc9C03B554f83DEFBAC6b7F4D5c8380c695bda3D2;
    IWETH public weth = IWETH(0x4200000000000000000000000000000000000006);
    WildcardIssuanceModule public wildcardIssuanceModule = WildcardIssuanceModule(0xf2bD7B7B758f9D693768884c01F983922Bb79673);
    SlippageIssuanceModule public slippageIssuanceModule =
        SlippageIssuanceModule(0xfbac408ebA2b42cda52C9F2BE81128945B3C764a);
    ISetToken public setToken = ISetToken(0x7a1Ad5961df61F5E498e382FC41E8e3094351DAd);
    Controller public controller = Controller(0xE9B4979c7075E885b82aa5f1A673aB16B4EB5775);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        IERC20(weth).approve(address(wildcardIssuanceModule), type(uint256).max);
        weth.deposit{value: 1 ether}();
        address[] memory components = setToken.getComponents();
        for (uint256 i = 0; i < components.length; i++) {
            console.log("Component: ", components[i]);
            IERC20(components[i]).approve(address(slippageIssuanceModule), type(uint256).max);
        }
        address[] memory allComponents = setToken.getComponents();
        uint256[] memory maxAmounts = new uint256[](allComponents.length);
        for (uint256 i = 0; i < allComponents.length; i++) {
            maxAmounts[i] = 1e18;
        }

        slippageIssuanceModule.issueWithSlippage(
            setToken,
            1e15,
            allComponents, // _checkedComponents
            maxAmounts, // _maxTokenAmountsIn (empty array)
            deployer
        );
        vm.stopBroadcast();
    }
}
