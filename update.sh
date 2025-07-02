#!/bin/zsh

set -o allexport
source .env
set +o allexport

set ftp:ssl-force true
set ftp:ssl-protect-data true
set ftp:passive-mode yes

LOCAL_DIR_PPA="ppa"
LOCAL_DIR_PPA_STAGING="ppa_staging"

rm -rf "$LOCAL_DIR_PPA"
rm -rf "$LOCAL_DIR_PPA_STAGING"
mkdir -pv "$LOCAL_DIR_PPA" "$LOCAL_DIR_PPA_STAGING"

echo "Downloading PPA..."
lftp -u "$FTP_PPA_USER","$FTP_PPA_SECRET" "$FTP_PPA_HOST" <<EOF
mirror --verbose --delete --parallel=2 --exclude .cagefs / "$LOCAL_DIR_PPA"
quit
EOF

echo "Downloading PPA staging..."
lftp -u "$FTP_PPA_STAGING_USER","$FTP_PPA_STAGING_SECRET" "$FTP_PPA_STAGING_HOST" <<EOF
mirror --verbose --delete --parallel=2 --exclude .cagefs / "$LOCAL_DIR_PPA_STAGING"
quit
EOF

echo "Copying files to PPA"
mkdir -pv ppa/ubuntu
cp -v ppa_staging/* ppa/ubuntu/

pushd ppa/ubuntu || exit 1
dpkg --version
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release
gpg --default-key "$GPG_KEY_EMAIL" -abs -o - Release > Release.gpg
gpg --default-key "$GPG_KEY_EMAIL" --clearsign -o - Release > InRelease

popd || exit 1

echo "Uploading..."
lftp -u "$FTP_PPA_USER","$FTP_PPA_SECRET" "$FTP_PPA_HOST" <<EOF
mirror --reverse --verbose --delete --parallel=2 "$LOCAL_DIR_PPA" /
quit
EOF
