**How does ERC721A save gas?**

ERC721 the original standard, introducing non-fungible tokens to the space. Issues with this standard is that tokens are not enforced to be minted sequentially, and there is no efficient way of fetching all of the tokenIDs that one address has since we only have these functions:

    - ownerOf() => who is the owner of that tokenID
    - balanceOf() => number of token one address has, but not which ones

ERC721Enumerable is an extension of the standard contract that fixes this issue by introducing 4 new datas structures:

```
    mapping(address owner => mapping(uint256 index => uint256)) private _ownedTokens;

    mapping(uint256 tokenId => uint256) private _ownedTokensIndex;

    uint256[] private _allTokens;

    mapping(uint256 tokenId => uint256) private _allTokensIndex;
```

With these new data structures, three functions were added as well:

```
    function totalSupply() public view virtual returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual returns (uint256) {
        if (index >= totalSupply()) {
            revert ERC721OutOfBoundsIndex(address(0), index);
        }
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
        if (index >= balanceOf(owner)) {
            revert ERC721OutOfBoundsIndex(owner, index);
        }
        return _ownedTokens[owner][index];
    }
```

Generally though, it is advised not to use this extension as it introduces a large gas overhead. Adding the functionality to enumerate tokens, either overall tokenByIndex() or by owner tokenOfOwnerByIndex() has two outcomes:

    - read functions are cheaper: information about token ownership order is available and indexed, making it beneficial for applications that need to display all tokens owned by an account or iterate through all tokens
    - write functions are more expensive: transfer become more expensive due to the additional reads/writes that need to be made to the variables the account for token ownership, updating the token list of both the receiver and sender and also _ownedTokens and _allTokens arrays

While in some scenarios it can make sense to implement ERC721Enumerable, most of the time we want the opposite outcome, write functions should be as cheap as possible since users will be mostly trading the token, and (unless you are maybe using the NFTs to build a game) read will most likely not be used as frequently.

Even in the scenario that you were anticipating having to read and constantly identify which users had what NFTs, this could all be done (the iteration that is) off-chain, and then the result forwarded and verified on-chain (by using ownerOf in the original ERC721 implementation).

ERC721A made three main optimizations, which are most notably felt when compared to ERC721Enumerable, but also better than the standard ERC721 used by OpenZeppelin:

    - optimization 1: removing the use of ERC721Enumerable eliminates some read/writes to storage

    - optimization 2: updating the owner's balance only once, this is possibly by accounting and expecting batch minting to happen, so instead of doing increments of 1 to the balanceof() func

    - optimization 3:

    ```


    ```

**Where does it add cost?**

As explained before, ERC721A made serious optimizations to cut down the gas costs of sequentially minting NFTs, this comes at the expense of the first or next person to trigger a transfer of that token.

Calculating the cost of the cost of: - minting + transfering to a next owner on ERC721 - minting + trasnfering to a next owner on ERC721A - minting + trasnfering to a next owner on ERC721Enumerable

They might all come to around the same cost, but the big argument is that during mint of a big project, the stress on the network is expected to be much higher, but later on (when users are trading) the gas cost will be cheaper, so in theory ERC721A should be the best solution all-around

[] calculate gas cost of each thing
[] show where it add costs in the transfer function (code)
