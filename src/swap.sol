// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./iweth.sol";
import "./iswaprouter02.sol";
import "./erc20swapper.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// address  constant SWAP_ROUTER_02 = 0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E;
// address  constant WETH = 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14;
// address  constant DAI = 0x68194a729C2450ad26072b3D33ADaCbcef39D574;

contract Swapper is Initializable, UUPSUpgradeable, OwnableUpgradeable{

    // ISwapRouter02 private  router = ISwapRouter02(SWAP_ROUTER_02);
    // IERC20 private  weth = IERC20(WETH);
    // IWETH private  weth2 = IWETH(WETH);
    // IERC20 private  dai = IERC20(DAI);
    ISwapRouter02 private router;
    IWETH private weth2;
    IERC20 private dai;

    function initialize(address _router, address _weth, address _dai, address initialOwner) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init(initialOwner);

        router = ISwapRouter02(_router);
        weth2 = IWETH(_weth);
        dai = IERC20(_dai);

        transferOwnership(initialOwner);
    }
  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function lockUpgrade() external onlyOwner {
        _authorizeUpgrade(address(0));
    }

    function swapEtherToToken(address token, uint minAmount) external payable returns (uint) {
        // Wrap ETH into WETH
        weth2.deposit{value: msg.value}();
        
        // Approve the router to spend WETH
        weth2.approve(address(router), msg.value);

        // Prepare parameters for the swap
        ISwapRouter02.ExactInputSingleParams memory params = ISwapRouter02
            .ExactInputSingleParams({
                tokenIn: address(weth2),
                tokenOut: token,
                fee: 3000,
                recipient: msg.sender,
                amountIn: msg.value,
                amountOutMinimum: minAmount,
                sqrtPriceLimitX96: 0
            });

        // Execute the swap
        uint amountOut = router.exactInputSingle(params);

        return amountOut;
    }

//Alternative function from uniswap router to swap erc20 with exact input
  function swapExactInputSingleHop(uint256 amountIn, uint256 amountOutMin) external {
        weth2.transferFrom(msg.sender, address(this), amountIn);
        weth2.approve(address(router), amountIn);

        ISwapRouter02.ExactInputSingleParams memory params = ISwapRouter02
            .ExactInputSingleParams({
            tokenIn: address(weth2),
            tokenOut: address(dai),
            fee: 3000,
            recipient: msg.sender,
            amountIn: amountIn,
            amountOutMinimum: amountOutMin,
            sqrtPriceLimitX96: 0
        });

        router.exactInputSingle(params);
    }

//Alternative function from uniswap router to swap erc20 with exact output


     receive()external payable{}

}



