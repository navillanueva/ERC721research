#!/bin/bash

# Start Forge Anvil
forge anvil --port 8545 &  # Launch in background if needed
ANVIL_PID=$!
sleep 5  # Wait a few seconds to ensure Anvil is fully up

# Deploy ERC721 (NFT) Contract
NFT_ADDRESS=$(forge script script/DeployMyNFT.s.sol --broadcast --rpc-url http://localhost:8545 | grep "Deployed at:" | awk '{print $3}')
echo "NFT Contract Deployed at: $NFT_ADDRESS"

# Deploy ERC20 Contract
ERC20_ADDRESS=$(forge script script/DeployMyERC20.s.sol --broadcast --rpc-url http://localhost:8545 | grep "Deployed at:" | awk '{print $3}')
echo "ERC20 Contract Deployed at: $ERC20_ADDRESS"

# Deploy Staking Contract with the addresses of NFT and ERC20
forge script script/DeployStakingContract.s.sol --broadcast --rpc-url http://localhost:8545 --ffi --sender <wallet_address> --constructor-args $NFT_ADDRESS $ERC20_ADDRESS

# Optionally kill Anvil if you started it just for this script
kill $ANVIL_PID
