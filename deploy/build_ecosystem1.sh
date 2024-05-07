#!/bin/bash

# Setup
export RPC_URL="http://localhost:8545"
export MERKLE_ROOT="$(node utils/generateMerkleTree.mjs | grep 'Merkle Root:' | awk '{print $3}')"
echo "Generated Merkle Root: $MERKLE_ROOT"

# Deploy Contracts
export NFT_ADDRESS=$(forge script script/ecosystem1/DeployERC721.s.sol --ffi | grep "0x" | awk '{print $NF}')


export ERC20_ADDRESS=$(forge script script/ecosystem1/DeployERC20.s.sol --rpc-url $RPC_URL --ffi | tail -n 1)


export STAKING_ADDRESS=$(forge script script/ecosystem1/DeployStaking.s.sol --rpc-url $RPC_URL --ffi | tail -n 1)
