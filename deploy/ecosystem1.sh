#!/bin/bash

# Setup
export RPC_URL="http://localhost:8545"
export SENDER_ADDRESS="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
export SENDER_PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
export MERKLE_ROOT="$(node ../utils/generateMerkleTree.mjs | grep 'Merkle Root:' | awk '{print $3}')"
echo "Generating merkle tree with these 4 addresses:"
echo ""
echo "1.- 0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
echo "2.- 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"
echo "3.- 0x90F79bf6EB2c4f870365E785982E1f101E93b906"
echo "4.- 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65"
echo ""
echo "Generated Merkle Root: $MERKLE_ROOT"
echo ""

# Deploy ERC721 Contract
NFT_DEPLOY_OUTPUT=$(MERKLE_ROOT=$MERKLE_ROOT forge script ../script/ecosystem1/DeployERC721.s.sol:DeployERC721 --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY)
export NFT_ADDRESS=$(echo "$NFT_DEPLOY_OUTPUT" | grep -oP 'Deployed ERC721 at: \K0x[a-fA-F0-9]{40}')
echo "Deployed ERC721 at: $NFT_ADDRESS with the merkle root: $MERKLE_ROOT "
echo ""

# Deploy ERC20 Contract
ERC20_DEPLOY_OUTPUT=$(forge script ../script/ecosystem1/DeployERC20.s.sol:DeployERC20 --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY)
export ERC20_ADDRESS=$(echo "$ERC20_DEPLOY_OUTPUT" | grep -oP 'Deployed ERC20 at: \K0x[a-fA-F0-9]{40}')
echo "Deployed ERC20 at: $ERC20_ADDRESS"
echo ""

# Deploy Staking Contract with the addresses of NFT and ERC20
STAKING_DEPLOY_OUTPUT=$(NFT_ADDRESS=$NFT_ADDRESS ERC20_ADDRESS=$ERC20_ADDRESS forge script ../script/ecosystem1/DeployStaking.s.sol:DeployStaking --broadcast --rpc-url $RPC_URL --ffi --private-key $SENDER_PRIVATE_KEY)
export STAKING_ADDRESS=$(echo "$STAKING_DEPLOY_OUTPUT" | grep -oP 'Deployed staking contract at: \K0x[a-fA-F0-9]{40}')
echo "Deployed Staking at: $STAKING_ADDRESS passing the NFT address: $NFT_ADDRESS and the ERC20 address: $ERC20_ADDRESS"
echo "Set owner of the ERC20 contract to $STAKING_ADDRESS"
echo ""
