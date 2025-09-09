// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import {IManagerIssuanceHook} from "../src/contracts/interfaces/IManagerIssuanceHook.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";
import {IWildcardDeployer} from "../src/contracts/interfaces/external/IWildcardDeployer.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";

import {BasicIssuanceModule} from "../src/contracts/protocol/modules/v1/BasicIssuanceModule.sol";
import {StreamingFeeModule} from "../src/contracts/protocol/modules/v1/StreamingFeeModule.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";
// import {WildcardAmmAdapter} from "../src/contracts/protocol/integration/amm/WildcardAmmAdapter.sol";

/*
  Controller: 0xE1193b941EC90DB3BA3d8EFec824850b238a807C
  IntegrationRegistry: 0xA2706b7b75EaaCd54b9C980711f4F4B8f8896Aaa
  PriceOracle: 0x23E77baeA586337557AA7cc8ad81538E9b558a3e
  SetValuer: 0xdb19ba094564B120ee31b181Bdc908A061AD7aFa
  SetTokenCreator: 0x085Cc7411CfF6340d97D4807b3C8B2e1590AF6cF
  BasicIssuanceModule: 0x22Fff118CDCC37848967B84cD373e653c7e04409
  StreamingFeeModule: 0x56c96F8a5D18211560285Bf47CE98783A8dcEb63
  WildcardAmmAdapter: 0xa1AFc4AAD29d393fa8784E381b49183034B01E77
*/

contract CreateSetToken is Script {
    // From your deployment
    BasicIssuanceModule public basicIssuanceModule = BasicIssuanceModule(0xCc801C704E7171c3DB19de0Bf5B8771ad5E652Ae);
    SetTokenCreator public setTokenCreator = SetTokenCreator(0x2d1D7c8d431aC8dF397A9e7A03fe1b933Dd9CFFe);
    address public tokenOne = 0xB257816C42Cc6fAEb7795B9d2729d55d972EFe4b;
    address public tokenTwo = 0x343217f77657A0F7319701bce196D6d43d009C14;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        address[] memory modules = new address[](1);
        modules[0] = address(basicIssuanceModule);
        vm.startBroadcast(deployerPrivateKey);

        address[] memory components = new address[](2);
        components[0] = tokenOne;
        components[1] = tokenTwo;

        int256[] memory units = new int256[](2);
        units[0] = 1e18; // Minimal unit
        units[1] = 1e18; // Minimal unit

        address setTokenAddress =
            setTokenCreator.create(components, units, modules, deployer, "justin blau songs", "JB-songs");
        console.log("SetToken created: ", setTokenAddress);
        ISetToken setToken = ISetToken(setTokenAddress);
        IManagerIssuanceHook managerIssuanceHook = IManagerIssuanceHook(address(0));
        basicIssuanceModule.initialize(setToken, managerIssuanceHook);
        setToken = setToken;

        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}(tokenOne, 1e16, 0, deployer);
        IWildcardDeployer(0x065EE5e9Ab0A4A382a5763f935176B880d512b06).buyToken{value: 1e16}(
            tokenTwo, 1e16, 100, deployer
        );

        IERC20(tokenOne).approve(address(basicIssuanceModule), 1e36);
        IERC20(tokenTwo).approve(address(basicIssuanceModule), 1e36);

        basicIssuanceModule.issue(setToken, 10e18, deployer);

        vm.stopBroadcast();
    }
}
