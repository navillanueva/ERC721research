#!/bin/bash

# Setup
export RPC_URL="http://localhost:8545"
export SENDER_ADDRESS="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
export SENDER_PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"


# Deploy MyEnumerableNFT Contract
NFT_DEPLOY_OUTPUT=$(forge script ../script/ecosystem2/DeployERC721Enumerable.s.sol:DeployERC721Enumerable --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY)
export NFT_ADDRESS=$(echo "$NFT_DEPLOY_OUTPUT" | grep -oP 'Deployed ERC721Enumerable at: \K0x[a-fA-F0-9]{40}')
echo "Deployed MyEnumerableNFT at: $NFT_ADDRESS"
echo ""

# Deploy PrimeNumberQuery Contract
PNQ_DEPLOY_OUTPUT=$(E_NFT_ADDRESS=$NFT_ADDRESS forge script ../script/ecosystem2/DeployPrimeNumberQuery.s.sol:DeployPrimeNumberQuery --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY)
export PNQ_ADDRESS=$(echo "$PNQ_DEPLOY_OUTPUT" | grep -oP 'Deployed Prime Number Query at: \K0x[a-fA-F0-9]{40}')
echo "Deployed PrimeNumberQuery at: $PNQ_ADDRESS"
echo "Passing the NFT address: $NFT_ADDRESS"
echo ""
echo "Ecosystem 2 is deployed and ready to use :)"