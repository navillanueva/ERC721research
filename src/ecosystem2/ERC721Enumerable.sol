// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721Enumerable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/// @title Standard NFT that generates pseudo random token IDs from 1-100 inclusive
/// @author Nicolas Arnedo
/// @dev has gas intensive mints as it randomly looks for a token id
contract MyEnumerableNFT is ERC721Enumerable {
    uint8 MAX_TOKEN_SUPPLY = 20;

    constructor() ERC721("EnumerableNFT", "ENFT") {}

    function safeMint(address to) public payable {
        require(totalSupply() < MAX_TOKEN_SUPPLY, "Tokens have been minted out");
        uint256 tokenId = generateRandomTokenID(to);
        _safeMint(to, tokenId);
    }

    function getOwnedTokens(address owner) public view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokens = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokens[i] = tokenOfOwnerByIndex(owner, i);
        }
        return tokens;
    }

    function generateRandomTokenID(address minter) internal returns (uint256) {
        uint256 tokenId;
        uint256 attempts = 0;
        do {
            tokenId = (uint256(keccak256(abi.encodePacked(minter, block.timestamp, attempts))) % 100) + 1;
            attempts++;
        } while (_ownerOf(tokenId) != address(0) && attempts < 100);
        require(attempts < 100, "Failed to generate unique token ID");
        return tokenId;
    }
}
