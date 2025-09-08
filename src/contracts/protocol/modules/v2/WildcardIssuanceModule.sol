// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import {IModuleIssuanceHookV2} from "../../../interfaces/IModuleIssuanceHookV2.sol";

import {ISetToken} from "../../../interfaces/ISetToken.sol";
import {ModuleBaseV2} from "../../lib/ModuleBaseV2.sol";
import {SetTokenAccessible} from "../../lib/SetTokenAccessible.sol";

import {IController} from "../../../interfaces/IController.sol";
import {IWildcardDeployer} from "../../../interfaces/external/IWildcardDeployer.sol";
import {IWildcardStateManager} from "../../../interfaces/external/IWildcardStateManager.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract WildcardIssuanceModule is ModuleBaseV2, ReentrancyGuard, Ownable, SetTokenAccessible, IModuleIssuanceHookV2 {
    IWildcardDeployer public wildcardDeployer;
    IWildcardStateManager public wildcardStateManager;

    constructor(
        IController _controller,
        IWildcardDeployer _wildcardDeployer,
        IWildcardStateManager _wildcardStateManager
    ) public ModuleBaseV2(_controller) SetTokenAccessible(_controller) {
        wildcardStateManager = _wildcardStateManager;
        wildcardDeployer = _wildcardDeployer;
    }
}
