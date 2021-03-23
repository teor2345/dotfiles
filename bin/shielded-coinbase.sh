#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Print the block height, coinbase input count, shielded coinbase output count,
# size, and hash for each block.
#
# The block hash is written out in Bitcoin order, which is different from
# Zebra's internal byte order, as an optimisation.
#
# Usage: get-shielded-coinbase.sh
#        get-shielded-coinbase.sh -testnet
#
# get-shielded-coinbase.sh passes its arguments through to zcash-cli.
#
# Requires zcash-cli and jq in your path. zcash-cli must be able to
# access a working, synced zcashd instance.

# The minimum heartwood start height across mainnet and testnet
heartwood_start=903000
block_count=$(zcash-cli "$@" getblockcount)

# Test vectors must be on the main chain, so we skip blocks that are within the
# zcashd reorg limit.
BLOCK_REORG_LIMIT=100
block_count=$((block_count - BLOCK_REORG_LIMIT))

i=$heartwood_start
while [ "$i" -lt "$block_count" ]; do
    # Unfortunately, there is no simple RPC for height, size, and hash.
    # So we use the expensive block RPC, and extract fields using jq.
    zcash-cli "$@" getblock "$i" 2 | \
        jq -r '"\(.height) \(.tx[0].vin[0].coinbase|length) \(.tx[0].vShieldedOutput|length) \(.size) \(.hash) "'
    i=$((i + 1))
done
