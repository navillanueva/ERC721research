// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./mocks/MockERC721Enumerable.sol";
import "../../src/ecosystem2/PrimeNumberQuery.sol";

contract PrimeNumberQueryTest is Test {
    MockERC721Enumerable mockNFT;
    PrimeNumberQuery primeQuery;
    address testUser = address(1);

    function setUp() public {
        mockNFT = new MockERC721Enumerable();
        primeQuery = new PrimeNumberQuery(address(mockNFT));

        // Mint prime and non-prime token IDs directly
        mockNFT.safeMint(testUser, 2); // Prime
        mockNFT.safeMint(testUser, 3); // Prime
        mockNFT.safeMint(testUser, 4); // Non-prime
        mockNFT.safeMint(testUser, 5); // Prime
        mockNFT.safeMint(testUser, 11); // Prime
    }

    function testPrimeCount() public view {
        uint256 primeCount = primeQuery.countPrimesOwnedBy(testUser);
        assertEq(primeCount, 4, "Should correctly count four prime tokens");
    }

    function testIsPrimeFunction() public view {
        assertTrue(primeQuery.isPrime(2));
        assertTrue(primeQuery.isPrime(3));
        assertTrue(primeQuery.isPrime(5));
        assertTrue(primeQuery.isPrime(11));
        assertFalse(primeQuery.isPrime(1));
        assertFalse(primeQuery.isPrime(4));
        assertFalse(primeQuery.isPrime(6));
        assertFalse(primeQuery.isPrime(0));
    }
}
