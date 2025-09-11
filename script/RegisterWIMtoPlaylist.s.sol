// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";

import {IWETH} from "../src/contracts/interfaces/external/IWETH.sol";

import {IDebtIssuanceModule} from "../src/contracts/interfaces/IDebtIssuanceModule.sol";

import {IController} from "../src/contracts/interfaces/IController.sol";
import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../src/contracts/interfaces/external/IWildcardStateManager.sol";
import {Controller} from "../src/contracts/protocol/Controller.sol";
import {SlippageIssuanceModule} from "../src/contracts/protocol/modules/v1/SlippageIssuanceModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";
import {WildcardIssuanceModule} from "../src/contracts/protocol/modules/v2/WildcardIssuanceModule.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract RegisterWIM is Script {
    address weth9_base = 0x4200000000000000000000000000000000000006;
    address wildcard_deployer_base = 0x065EE5e9Ab0A4A382a5763f935176B880d512b06;
    address wildcard_state_manager_base = 0xC67348A3a3F51f8d4BEE9EB792614b7AD4248786;

    ISetToken public setToken = ISetToken(0x7a1Ad5961df61F5E498e382FC41E8e3094351DAd);
    Controller controller = Controller(0xE9B4979c7075E885b82aa5f1A673aB16B4EB5775);
    WildcardIssuanceModule public wildcardIssuanceModule =
        WildcardIssuanceModule(0xf2bD7B7B758f9D693768884c01F983922Bb79673);

    address joey_viral_address = 0xc9C03B554f83DEFBAC6b7F4D5c8380c695bda3D2;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployer);

        ISetToken(setToken).addModule(address(wildcardIssuanceModule));
        wildcardIssuanceModule.initialize(ISetToken(setToken));

        vm.stopBroadcast();
    }
}
