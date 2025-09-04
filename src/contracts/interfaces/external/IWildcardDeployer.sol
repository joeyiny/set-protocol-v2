pragma solidity 0.6.10;

interface IWildcardDeployer {
     function buyToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external payable;
    function sellToken(address token, uint256 amountIn, uint256 amountOutMin, address to) external;

}