// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Enumerable {
    function balanceOf(address owner) external view returns (uint256 balance);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
}

contract PrimeNumberQuery {
    IERC721Enumerable public nftAddress;

    constructor(address _nftAddress) {
        nftAddress = IERC721Enumerable(_nftAddress);
    }

    function isPrime(uint256 number) public pure returns (bool) {
        if (number < 2) return false;
        for (uint256 i = 2; i * i <= number; i++) {
            if (number % i == 0) return false;
        }
        return true;
    }

    function countPrimesOwnedBy(address owner) external view returns (uint256) {
        uint256 count = 0;
        uint256 balance = nftAddress.balanceOf(owner);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = nftAddress.tokenOfOwnerByIndex(owner, i);
            if (isPrime(tokenId)) {
                count++;
            }
        }
        return count;
    }
}
