# Custom PPA for personal projects

This repository is used to host a PPA for all our projects.

## Adding the PPA to your system

```bash
curl -s --compressed "https://ppa.schlunzis.org/ubuntu/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/schlunzis.gpg >/dev/null
sudo curl -s --compressed -o /etc/apt/sources.list.d/schlunzis.list "https://ppa.schlunzis.org/ubuntu/schlunzis.list"
sudo apt update
```

## How to release a new package or version

### Upload

Run the following in a GitHub Action to upload the file:

```bash
curl -T *.deb ${{ secrets.FTP_HOST }} --user "${{ secrets.FTP_USER }}:${{ secrets.FTP_SECRET }}"
```

Example secrets:

| FTP_HOST            | FTP_USER   | FTP_SECRET |
|---------------------|------------|------------|
| `ftp://example.com` | `username` | `password` |

### Updating the PPA

1. Copy the `.env.sample` file and fill in the credentials.
2. Have the GPG Key imported.
3. run `./update.sh`

The script copies all files from the remote PPA via FTP.
Then it compies over the deb packages in staging and updates the PPA with `dpkg`.
Finally, the files are copied back to the remote PPA.

Note that if you want to change the contents of files, like the list file, you have to comment out the removal of the
directory and the downloading.
Otherwise, the contents will be overwritten.
