// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/ERC721.sol"; // Corrected import path

contract NFTTest is Test {
    MyNFT nft;
    // Properly sized bytes32 value for the merkle root.
    bytes32 constant merkleRoot = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;
    address user = address(1);

    function setUp() public {
        nft = new MyNFT(merkleRoot);
    }

    function testMintWithValidProof() public {
        bytes32[] memory proof = new bytes32[](1);
        // Valid proof
        proof[0] = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;

        nft.mint(1, proof);
        assertEq(nft.ownerOf(1), address(this), "Token should be minted to this contract.");
    }

    function testFailMintWithInvalidProof() public {
        bytes32[] memory proof = new bytes32[](1);
        // Invalid proof
        proof[0] = 0x0456789012345678901234567890123456789012345678901234567890123456;

        vm.expectRevert(); // Expect any revert
        nft.mint(1, proof); // This should fail
    }

    function testFailMintWhenMaxSupplyReached() public {
        for (uint i = 1; i <= 1000; i++) {
            bytes32[] memory proof = new bytes32[](1);
            // Use the same valid proof for simplicity
            proof[0] = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;
            nft.mint(i, proof);
        }
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;
        vm.expectRevert("Max supply reached");
        nft.mint(1001, proof); // This should fail
    }
}
