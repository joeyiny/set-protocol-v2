// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.6.10;
pragma experimental ABIEncoderV2;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// Protocol interfaces
import {IBasicIssuanceModule} from "../src/contracts/interfaces/IBasicIssuanceModule.sol";
import {ISetToken} from "../src/contracts/interfaces/ISetToken.sol";

contract MintSetToken is Script {
    // Your deployed contract addresses
    address public basicIssuanceModule = 0x22Fff118CDCC37848967B84cD373e653c7e04409;
    address public setTokenAddress = 0x7e8e3FBdEEb409B63F58b14Ddbd7FD5b10b957a5;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address minter = vm.addr(deployerPrivateKey);

        console.log("Minting set tokens for account:", minter);
        console.log("Set Token Address:", setTokenAddress);

        vm.startBroadcast(deployerPrivateKey);

        ISetToken setToken = ISetToken(setTokenAddress);
        IBasicIssuanceModule issuanceModule = IBasicIssuanceModule(basicIssuanceModule);
        bool isInitializedModule = setToken.isInitializedModule(basicIssuanceModule);
        console.log("Is initialized module:", isInitializedModule);
        // Amount of set tokens to mint (in wei)
        uint256 setTokenQuantity = 1 ether; // 1 playlist token

        // Get required component amounts
        (address[] memory components, uint256[] memory positions) =
            issuanceModule.getRequiredComponentUnitsForIssue(setToken, setTokenQuantity);

        // console.log("\nRequired components for minting:");
        // for (uint256 i = 0; i < components.length; i++) {
        //     console.log("Component:", components[i]);
        //     console.log("Amount needed:", positions[i]);

        //     // Check if we have enough balance
        //     uint256 balance = IERC20(components[i]).balanceOf(minter);
        //     console.log("Current balance:", balance);

        //     require(balance >= positions[i], "Insufficient balance for component");

        //     // Approve the BasicIssuanceModule to spend our tokens
        //     IERC20(components[i]).approve(basicIssuanceModule, positions[i]);
        //     console.log("Approved component", i);
        // }

        // // Mint the set token
        // console.log("\nMinting", setTokenQuantity, "set tokens...");
        // issuanceModule.issue(setToken, setTokenQuantity, minter);

        // console.log("Successfully minted set tokens!");
        // console.log("New set token balance:", setToken.balanceOf(minter));

        vm.stopBroadcast();
    }
}
