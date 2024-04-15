**Revisit the solidity events tutorial. How can OpenSea quickly determine which NFTs an address owns if most NFTs don’t use ERC721 enumerable? Explain how you would accomplish this if you were creating an NFT marketplace**

Determining which NFTs an address owns for an ERC721 collection that doesn't count with the Enumerable extension can be acheived by querying the events of the contract.

It is important to note that events are better for querying data than transactions because Ethereum has more built in functions on how to retrieve them, being able to fetch by:

- event
- events.allEvents
- getPastEvenets

When we take a look at the standard ERC721 implementation carried out by the OpenZeppelin, we can verify that everytime there is a storage change in the contract (mint, transfer or burn) there is an event emitted:

```
emit Transfer(from, to, tokenId);
```

Knowing this, identifying what NFTs belong to an address can be acheived easily applying the correct filter. This is what it would look like:

```
const ethers = require('ethers');

// Assume these are filled correctly
const provider = new ethers.providers.JsonRpcProvider('your_rpc_url');
const tokenAddress = '0x...'; // The address of the ERC721 token contract

const tokenAbi = [
  // ABI content must include the Transfer event
  "event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)"
];

const tokenContract = new ethers.Contract(tokenAddress, tokenAbi, provider);

// Address you want to find the tokens of
const holderAddress = '0x...';

// Create a filter for the Transfer events where the 'to' field is the holder's address
const filter = tokenContract.filters.Transfer(null, holderAddress);

// Query the filter
tokenContract.queryFilter(filter).then((events) => {
  const tokenIds = events.map(event => event.args.tokenId);
  console.log("Token IDs owned by the address:", tokenIds);
});

```

