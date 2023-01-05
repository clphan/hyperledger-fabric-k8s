# Important:
- When restart the CA server OR modify configuration file, the previously issued certificates are not replaced.
- If need certificates to be regenerated when server is restarted, delete the certs and start server again.
- When restart CA server the previously issued certs will no longer be able to authenticate with the CA.

# Output:
A TLS root CA cert will be created, it will need to be available on each client system that will run commands against the TLS CA.

Run the following command:
```
helm install -f values.yaml hlf-tlsca . -n hyperledger-fabric
```
