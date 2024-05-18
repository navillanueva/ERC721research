// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// --------------------------------------------- OLD CONTRACT --------------------------------------------------------

// contract Overmint1 is ERC721 {
//     using Address for address;
//     mapping(address => uint256) public amountMinted;
//     uint256 public totalSupply;

//     constructor() ERC721("Overmint1", "AT") {}

//     function mint() external {
//         require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
//         totalSupply++;
//         _safeMint(msg.sender, totalSupply);
//         amountMinted[msg.sender]++;
//     }

//     function success(address _attacker) external view returns (bool) {
//         return balanceOf(_attacker) == 5;
//     }
// }

/// --------------------------------------------- NEW CONTRACT --------------------------------------------------------

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Overmint1 is ERC721, ReentrancyGuard {
    using Address for address;

    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external nonReentrant {
        require(amountMinted[msg.sender] < 3, "max 3 NFTs");
        amountMinted[msg.sender]++;
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}
