#!/bin/bash
set -x  # Enable verbose logging

# Setup
export RPC_URL="http://localhost:8545"
export SENDER_ADDRESS="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
export SENDER_PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
export MERKLE_ROOT="$(node ../utils/generateMerkleTree.mjs | grep 'Merkle Root:' | awk '{print $3}')"
echo "Generated Merkle Root: $MERKLE_ROOT"

# Deploy ERC721 Contract
export NFT_ADDRESS=$(MERKLE_ROOT=$MERKLE_ROOT forge script ../script/ecosystem1/DeployERC721.s.sol:DeployERC721 --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY | grep "Deployed ERC721 at:" | awk '{print $NF}')
echo "NFT Contract Deployed at: $NFT_ADDRESS"

# Check if NFT_ADDRESS is correctly set
if [ -z "$NFT_ADDRESS" ]; then
  echo "Failed to deploy NFT contract."
  exit 1
fi

# Deploy ERC20 Contract
export ERC20_ADDRESS=$(forge script ../script/ecosystem1/DeployERC20.s.sol:DeployERC20 --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY | grep "Deployed ERC20 at:" | awk '{print $NF}')
echo "ERC20 Contract Deployed at: $ERC20_ADDRESS"

# Check if ERC20_ADDRESS is correctly set
if [ -z "$ERC20_ADDRESS" ]; then
  echo "Failed to deploy ERC20 contract."
  exit 1
fi

# Debugging: print the values of NFT_ADDRESS and ERC20_ADDRESS
echo "NFT_ADDRESS: $NFT_ADDRESS"
echo "ERC20_ADDRESS: $ERC20_ADDRESS"

# Deploy Staking Contract with the addresses of NFT and ERC20
export STAKING_ADDRESS=$(NFT_ADDRESS=$NFT_ADDRESS ERC20_ADDRESS=$ERC20_ADDRESS forge script ../script/ecosystem1/DeployStaking.s.sol:DeployStaking --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY | grep "Deployed Staking contract at:" | awk '{print $NF}')
echo "Staking Contract Deployed at: $STAKING_ADDRESS"

# Check if STAKING_ADDRESS is correctly set
if [ -z "$STAKING_ADDRESS" ]; then
  echo "Failed to deploy Staking contract."
  exit 1
fi

set +x  # Disable verbose logging
