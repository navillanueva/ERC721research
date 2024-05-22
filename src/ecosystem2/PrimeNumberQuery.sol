// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract PrimeNumberQuery {
    IERC721Enumerable public nftAddress;

    constructor(address _nftAddress) {
        nftAddress = IERC721Enumerable(_nftAddress);
    }

    // https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
    // this new algorithm is more efficient
    function isPrime(uint256 number) public pure returns (bool) {
        if (number < 2) return false;
        if (number == 2 || number == 3) return true;
        if (number % 2 == 0 || number % 3 == 0) return false;
        for (uint256 i = 5; i * i <= number; i += 6) {
            if (number % i == 0 || number % (i + 2) == 0) return false;
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
