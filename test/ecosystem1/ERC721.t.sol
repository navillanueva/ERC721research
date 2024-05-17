// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTTest is Test, IERC721Receiver {
    MyNFT nft;
    bytes32 constant merkleRoot = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;
    address user = address(1);

    function setUp() public {
        nft = new MyNFT(merkleRoot);
    }

    function testMintWithValidProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;

        nft.mint(1, proof);
        assertEq(nft.ownerOf(1), address(this), "Token should be minted to this contract.");
    }

    function testFailMintWithInvalidProof() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0x0456789012345678901234567890123456789012345678901234567890123456;

        vm.expectRevert("Invalid Merkle Proof");
        nft.mint(1, proof); // This should fail
    }

    // Question: why does this fail with a "Revert reason mismatch" instead of with the custom error

    function testMintWhenMaxSupplyReachedShouldRevert() public {
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;
        for (uint256 i = 1; i <= 1000; i++) {
            nft.mint(i, proof);
        }
        vm.expectRevert(MyNFT.MaxSupplyReached.selector);
        nft.mint(1001, proof);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
