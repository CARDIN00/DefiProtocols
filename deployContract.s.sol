// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "src/simpleErc20.sol";  // Ensure correct file path
import "src/defiWallet.sol";   // Ensure correct file path
import "forge-std/Script.sol";  // Import Foundry Script library

contract DeployContracts is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the ERC20 token
        simpleErc20 token = new simpleErc20(
            1000000,          // Initial supply
            "SampleToken",    // Token name
            "STK",            // Token symbol
            18                // Decimals
        );

        // Deploy the DefiWallet
        DefiWallet wallet = new DefiWallet(address(token));  // Pass the ERC20 token address

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
