// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract MyNFT is ERC721, ERC2981 {
    using BitMaps for BitMaps.BitMap;

    BitMaps.BitMap private _discountBitmap;

    bytes32 public merkleRoot;
    uint16 public constant MAX_SUPPLY = 1000;
    uint16 public totalSupply;

    constructor(bytes32 _merkleRoot) ERC721("MyNFT", "MNFT") {
        merkleRoot = _merkleRoot;
        _setDefaultRoyalty(msg.sender, 250); // 2.5% royalty
    }

    function mint(uint256 tokenId, bytes32[] calldata proof) public {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");
        if (isDiscountEligible(msg.sender, proof)) {
            _discountBitmap.set(tokenId);
        }
        _safeMint(msg.sender, tokenId);
        totalSupply++;
    }

    function isDiscountEligible(address addr, bytes32[] calldata proof) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(addr));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    // Explicitly override the supportsInterface function for both ERC721 and ERC2981
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
