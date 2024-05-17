// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem2/ERC721Enumerable.sol";

contract MyEnumerableNFTTest is Test {
    MyEnumerableNFT e_nft;
    address user = address(1);

    function setUp() public {
        e_nft = new MyEnumerableNFT();
    }

    function testSafeMint() public {
        uint256 initialSupply = e_nft.totalSupply();
        e_nft.safeMint(user);
        assertEq(e_nft.totalSupply(), initialSupply + 1, "Total supply should increase by 1");
        assertEq(e_nft.ownerOf(1), user, "user should own the newly minted token");
    }

    function testMintAboveMaxSupplyShouldRevert() public {
        for (uint256 i = 0; i < 20; i++) {
            e_nft.safeMint(user);
        }
        vm.expectRevert(MyEnumerableNFT.MaxSupplyReached.selector);
        e_nft.safeMint(user);
    }

    function testGetOwnedTokens() public {
        e_nft.safeMint(user);
        e_nft.safeMint(user);
        uint256[] memory owned = e_nft.getOwnedTokens(user);
        assertEq(owned.length, 2, "user should own two tokens");
    }

    function testRandomnessOfTokenIDs() public {
        uint256[] memory ids = new uint256[](20);
        for (uint256 i = 0; i < 20; i++) {
            e_nft.safeMint(user);
            ids[i] = e_nft.tokenOfOwnerByIndex(user, i);
        }
        bool isDuplicate = checkForDuplicates(ids);
        assertTrue(!isDuplicate, "Token IDs should be unique and not duplicated");
    }

    function checkForDuplicates(uint256[] memory array) private pure returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            for (uint256 j = i + 1; j < array.length; j++) {
                if (array[i] == array[j]) {
                    return true;
                }
            }
        }
        return false;
    }
}
