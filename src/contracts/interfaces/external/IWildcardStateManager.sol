pragma solidity 0.6.10;

interface IWildcardStateManager {
 function buyToken(address buyer, address token, uint256 amountIn, uint256 amountOutMin, address to)
        external
        payable
        returns (uint256, bool);
    function sellToken(address buyer, address token, uint256 amountIn, uint256 amountOutMin, address to)
        external
        returns (uint256);
}