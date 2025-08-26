// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {SetTokenCreator} from "../src/contracts/protocol/SetTokenCreator.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";

contract CreateSetToken is Script {
    // From your deployment
    SetTokenCreator public setTokenCreator = SetTokenCreator(0x74DD958b1dc62EB8dbDf29d2Eb5C01a5e3132973);
    address public basicIssuanceModule = 0x6223386cF634bbfd5dcF256b6ec82BFE47ff0Ae6;
    
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Create a simple 50/50 WETH/USDbC SetToken
        address[] memory components = new address[](2);
        components[0] = 0x4200000000000000000000000000000000000006; // WETH on Base
        components[1] = 0xd9aAEc86B65D86f6A7B5B1b0c42FFA531710b6CA; // USDbC on Base
        
        int256[] memory units = new int256[](2);
        units[0] = 1e18;    // 1 WETH
        units[1] = 2000e6;  // 2000 USDbC (6 decimals)
        
        address[] memory modules = new address[](1);
        modules[0] = basicIssuanceModule;
        
        ISetToken setToken = ISetToken(setTokenCreator.create(
            components,
            units,
            modules,
            deployer, // manager
            "WETH-USDbC Index",
            "WUI"
        ));
        
        console.log("SetToken created:", address(setToken));
        console.log("Manager:", deployer);
        
        vm.stopBroadcast();
    }
}