#!/bin/bash

# Setup
export RPC_URL="http://localhost:8545"
export MERKLE_ROOT="$(node ../utils/generateMerkleTree.mjs | grep 'Merkle Root:' | awk '{print $3}')"
echo "Generated Merkle Root: $MERKLE_ROOT"

# Deploy NFT Contract
export NFT_ADDRESS=$(MERKLE_ROOT=$MERKLE_ROOT forge script ../script/ecosystem1/DeployERC721.s.sol:DeployERC721 --broadcast --rpc-url $RPC_URL --ffi | grep "Deployed ERC721 at:" | awk '{print $NF}')
echo "NFT Contract Deployed at: $NFT_ADDRESS"

# Deploy ERC20 Contract
export ERC20_ADDRESS=$(forge script ../script/ecosystem1/DeployERC20.s.sol:DeployERC20 --broadcast --rpc-url $RPC_URL --ffi  | grep "Deployed ERC20 at:" | awk '{print $NF}')
echo "ERC20 Contract Deployed at: $ERC20_ADDRESS"

# Deploy Staking Contract
export STAKING_ADDRESS=$(NFT_ADDRESS=$NFT_ADDRESS ERC20_ADDRESS=$ERC20_ADDRESS forge script ../script/ecosystem1/DeployStaking.s.sol:DeployStaking --broadcast --rpc-url $RPC_URL --ffi --sender $SENDER_ADDRESS | grep "Deployed Staking contract at:" | awk '{print $NF}')
echo "Staking Contract Deployed at: $STAKING_ADDRESS"

