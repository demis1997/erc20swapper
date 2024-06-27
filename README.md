
## Swapper Contract

The Swapper contract is an upgradeable smart contract designed to facilitate token swaps using Uniswap V3. It wraps ETH into WETH and interacts with the Uniswap V3 router to swap WETH for other ERC20 tokens. The contract is upgradeable using the UUPS pattern and provides functions to lock upgrades.

### Features

Upgradeable Contract: Uses UUPSUpgradeable for contract upgradeability.
Token Swapping: Allows swapping of ETH to ERC20 tokens using Uniswap V3.
ERC20 Token Swapping: Supports swapping of ERC20 tokens using Uniswap V3.
Ownership Control: Ownership is controlled using OwnableUpgradeable from OpenZeppelin.
Contract Details

### State Variables
ISwapRouter02 private router: Interface for the Uniswap V3 router.
IWETH private weth2: Interface for the WETH token.
IERC20 private dai: Interface for the DAI token.
Functions
```shell
initialize
```
```shell
function initialize(address _router, address _weth, address _dai, address initialOwner) public initializer
```
Initializes the contract with the given router, WETH, DAI addresses, and the owner.

```shell
_authorizeUpgrade
```
Authorizes upgrades to the contract. Can only be called by the owner.

```shell
function _authorizeUpgrade(address newImplementation) internal override onlyOwner

```

lockUpgrade

Locks the contract to prevent future upgrades.

```shell
function lockUpgrade() external onlyOwner
```


swapEtherToToken

Swaps ETH to a specified ERC20 token using Uniswap V3.

```shell
function swapEtherToToken(address token, uint minAmount) external payable returns (uint)
```

swapExactInputSingleHop

Swaps an exact amount of WETH to DAI using Uniswap V3.

```shell
function swapExactInputSingleHop(uint256 amountIn, uint256 amountOutMin) external
```
receive

Fallback function to receive ETH.
```shell
receive() external payable
```



```shell
cd swapper
```

Install Dependencies: Install the necessary dependencies.

```shell
cd swapper
```

Deploy
```shell
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../forge-std/Script.sol";
import "../src/Swapper.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the implementation contract
        Swapper implementation = new Swapper();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSignature(
            "initialize(address,address,address,address)", 
            SWAP_ROUTER_02, 
            WETH, 
            DAI, 
            deployerAddress
        );

        // Deploy the proxy and initialize
        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);

        vm.stopBroadcast();
    }
}
```
Run Deployment Script: Ensure the environment variables are set and run the deployment script.
```shell
forge script script/Deploy.s.sol:DeployScript --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv

```
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
