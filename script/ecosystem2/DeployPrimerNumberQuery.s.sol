// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/ecosystem2/PrimeNumberQuery.sol";

contract DeployPrimeNumberQuery is Script {
    function run() public {
        vm.startBroadcast();
        address E_nftAddress = vm.envAddress("E_NFT_ADDRESS");
        PrimeNumberQuery pnq = new PrimeNumberQuery(E_nftAddress);
        console.log("Deployed Prime Number Query at:", address(pnq));
        vm.stopBroadcast();
    }
}
