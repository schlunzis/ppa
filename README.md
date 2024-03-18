# Custom PPA for personal projects

This repository is used to host a PPA for all our projects. If a `.deb` file is pushed to this repository, it will be automatically added to the PPA.


## Adding the PPA to your system

```bash
curl -s --compressed "https://schlunzis.github.io/ppa/ubuntu/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/schlunzis.gpg >/dev/null
sudo curl -s --compressed -o /etc/apt/sources.list.d/schlunzis.list "https://jaypi4c.github.io/ppa/ubuntu/schlunzis.list"
sudo apt update
```
