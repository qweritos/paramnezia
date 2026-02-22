<div align="center">
  <h1><img alt="Amnezia" height="48" src="https://avatars.githubusercontent.com/u/74861536?s=200&v=4" /> paramnezia</h1>
  <p>Parralel Amnezia <br /> Run multiple isolated instances on same machine</p>

  <p>
    <strong>🚧 Work In Progress 🚧</strong>
  </p>
</div>

<p align="center">
  <a href="https://github.com/qweritos/paramnezia/releases"><img alt="Release" src="https://img.shields.io/github/v/release/qweritos/paramnezia?style=flat-square" /></a>
  <a href="https://github.com/qweritos/paramnezia/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/qweritos/paramnezia?style=flat-square" /></a>
  <a href="https://github.com/qweritos/paramnezia/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/qweritos/paramnezia?style=flat-square" /></a>
  <a href="https://github.com/qweritos/paramnezia/forks"><img alt="Forks" src="https://img.shields.io/github/forks/qweritos/paramnezia?style=flat-square" /></a>
  <a href="https://github.com/qweritos/paramnezia/issues"><img alt="Issues" src="https://img.shields.io/github/issues/qweritos/paramnezia?style=flat-square" /></a>
  <a href="https://github.com/qweritos/paramnezia/commits/main"><img alt="Last Commit" src="https://img.shields.io/github/last-commit/qweritos/paramnezia?style=flat-square" /></a>
</p>

<br />

- Run Amnezia in Docker without dedicated VM overhead.
- Deploy on Kubernetes for multi-instance operations.
- Apply network-based policies per instance to control reachable subnets.
- Run one Amnezia for personal access and another for friends, while blocking friend access to your private subnet.

## Usage

Before starting the stack:

- Clone this repository.
- Configure `docker-compose.yml` for your deployment.
  - Set SSH ports for each instance according to your deployment/network policy.
  - Set port forwarding for the protocols you plan to install in Amnezia.

> Authentication currently supports SSH key login only (password login is not supported yet).

Start the stack:

```bash
docker compose up -d
```

After the container is up, continue the server setup in the Amnezia app.

## Disclaimer

This project is an independent containerization effort and is not affiliated with or endorsed by Amnezia.
You are responsible for your server security, key management, firewall rules, and legal compliance in your jurisdiction.
Use at your own risk.

## License

MIT. See `LICENSE`.
