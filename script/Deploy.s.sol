// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/swap.sol";
import "../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Swapper erc20swapper = new Swapper();

        vm.stopBroadcast();
    }
}
// forge script --chain sepolia script/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv


 //    address private constant SWAP_ROUTER_02 =
//         0x3bFA4769FB09eefC5a80d6E87c3B9C650f7Ae48E;
//     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
//     address private constant DAI = 0x68194a729C2450ad26072b3D33ADaCbcef39D574;
//     address private constant DAI_WETH_POOL_3000 =
//         0xC2e9F25Be6257c210d7Adf0D4Cd6E3E881ba25f8;


contract DeployProxy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the implementation contract
        Swapper implementation = new Swapper();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSignature("initialize(address,address,address,address)", 
            SWAP_ROUTER_02, WETH, DAI, msg.sender);

        // Deploy the proxy and initialize
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);

        vm.stopBroadcast();
    }
}
