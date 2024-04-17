// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../../src/ecosystem1/Staking.sol";
import "../../src/ecosystem1/ERC721.sol";
import "../../src/ecosystem1/ERC20.sol";

contract DeployStaking is Script {
    address private nftAddress;
    address private erc20Address;

    constructor(address _nftAddress, address _erc20Address) {
        nftAddress = _nftAddress;
        erc20Address = _erc20Address;
    }

    function run() public {
        vm.startBroadcast();

        MyNFT nft = MyNFT(nftAddress);
        MyERC20 token = MyERC20(erc20Address);

        Staking staking = new Staking(nft, token);

        vm.stopBroadcast();
    }
}
