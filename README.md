# Whitelist Removal Script

## Setup

1. Configure your wallet by creating a `.env` file based on the `.env.example`:
   ```
   # For local wallet with private key
   WALLET_TYPE=local
   PRIVATE_KEY=your_private_key_without_0x_prefix
   
   # For hardware wallet (Ledger)
   WALLET_TYPE=ledger
   MNEMONIC_INDEX=0
   ```

2. Update the `removeWhitelist.json` configuration file:
   - Add the token addresses you want to modify
   - For each token, specify the addresses to remove from the whitelist
   - Ensure network information is correctly configured

## Execution

Run the script with the following command:

```
forge script script/RemoveWhitelist.s.sol --ffi
```

## SIMULATE

If want to only simulate update the `ONLY_SIMULATE` variable to `true` in the script.
