// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MockERC721Enumerable is ERC721Enumerable {
    uint16 public constant MAX_SUPPLY = 20;
    uint256 public currentSupply = 0;

    constructor() ERC721("MockMyEnumerableNFT", "MMENFT") {}

    function safeMint(address to, uint256 tokenId) public {
        require(currentSupply < MAX_SUPPLY, "Max supply reached");
        _mint(to, tokenId);
        currentSupply += 1;
    }
}
