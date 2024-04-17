// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MyEnumerableNFT is ERC721Enumerable {
    constructor() ERC721("MyEnumerableNFT", "MENFT") {
        for (uint256 i = 1; i <= 20; i++) {
            // Randomly generating token IDs between 1 and 100
            uint256 tokenId = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, i))) % 100) + 1;
            _safeMint(msg.sender, tokenId);
        }
    }
}
