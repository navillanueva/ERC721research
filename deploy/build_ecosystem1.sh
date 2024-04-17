#!/bin/bash

# Start Anvil on a different port if needed
anvil --port 9000 &  # Launch in background if needed
ANVIL_PID=$!
sleep 5  # Wait a few seconds to ensure Anvil is fully up

# Check if Anvil started successfully
if ! nc -z localhost 9000; then
    echo "Anvil failed to start on port 9000"
    exit 1
fi

echo "Anvil started successfully on port 9000"

# Wallet address from Anvil's pre-generated accounts
WALLET_ADDRESS="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"

# Generate Merkle Tree and capture the Merkle root
export MERKLE_ROOT="$(node utils/generateMerkleTree.mjs | grep 'Merkle Root:' | awk '{print $3}')"
echo "Generated Merkle Root: $MERKLE_ROOT"

# Deploy ERC721 Contract
NFT_ADDRESS=$(forge script script/ecosystem1/DeployERC721.s.sol:DeployERC721 --broadcast --rpc-url http://localhost:9000 --sender $WALLET_ADDRESS | grep "Deployed at:" | awk '{print $3}')
echo "NFT Contract Deployed at: $NFT_ADDRESS"

# Deploy ERC20 Contract temporarily owned by the deployer
ERC20_ADDRESS=$(forge script script/ecosystem1/DeployERC20.s.sol:DeployERC20 --broadcast --rpc-url http://localhost:9000 --sender $WALLET_ADDRESS | grep "Deployed at:" | awk '{print $3}')
echo "ERC20 Contract Deployed at: $ERC20_ADDRESS"

# Deploy Staking Contract with the ERC20 address
STAKING_ADDRESS=$(forge script script/ecosystem1/DeployStaking.s.sol:DeployStaking --broadcast --rpc-url http://localhost:9000 --ffi --sender $WALLET_ADDRESS --constructor-args $ERC20_ADDRESS | grep "Deployed at:" | awk '{print $3}')
echo "Staking Contract Deployed at: $STAKING_ADDRESS"

# Transfer ownership of ERC20 to the Staking Contract
forge script script/ecosystem1/TransferOwnership.s.sol:TransferOwnership --broadcast --rpc-url http://localhost:9000 --sender $WALLET_ADDRESS --constructor-args $ERC20_ADDRESS $STAKING_ADDRESS

# Optionally kill Anvil if you started it just for this script
kill $ANVIL_PID
