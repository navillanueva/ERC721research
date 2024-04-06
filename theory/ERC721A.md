**How does ERC721A save gas?**

ERC721 the original standard, introducing non-fungible tokens to the space. Issues with this standard is that tokens are not enforced to be minted sequentially, and there is no efficient way of fetching all of the tokenIDs that one address has since we only have these functions:

    - ownerOf() => who is the owner of that tokenID
    - balanceOf() => number of token one address has, but not which ones

ERC721Enumerable is an extension of the standard contract that fixes this issue by introducing 4 new datas structures and 3 functions:

    ```
    mapping(address owner => mapping(uint256 index => uint256)) private _ownedTokens;
    mapping(uint256 tokenId => uint256) private _ownedTokensIndex;
    uint256[] private _allTokens;
    mapping(uint256 tokenId => uint256) private _allTokensIndex;
    ```

ERC721A made three main optimizations, which are most notably felt when compared to ERC721Enumerable, but also better than the standard ERC721 used by OpenZeppelin:

    - optimization 1: removing the use of ERC721Enumerable eliminates some read/writes to storage

    - optimization 2: updating the owner's balance only once, this is possibly by accounting and expecting batch minting to happen, so instead of doing increments of 1 to the balanceof() func

    - optimization 3:

    ```


    ```

**Where does it add cost?**

As explained before, ERC721A made serious optimizations to cut down the gas costs of sequentially minting NFTs, but this become a "trade-off" later in the life of the token.
