#!/bin/bash

# Edit this path if you have installed VueTorrent in a different directory
vuetorrentPath="../vuetorrent"

# if ! which zip &> /dev/null; then
#     echo "zip is not installed. Please install zip before running this script."
#     exit 1
# fi
# if ! which curl &> /dev/null; then
#     echo "curl is not installed. Please install curl before running this script."
#     exit 1
# fi

if ! currentVersion=$(cat "${vuetorrentPath}/version.txt"); then
    echo "Error: Failed to read version.txt file. Are you sure the path is correct?"
    exit 1
fi
latestVersion=$(curl -sL https://github.com/VueTorrent/VueTorrent/releases/latest -w %{url_effective} -o /dev/null | grep -oP '(?<=tag\/v).*')

currentFormatted=$(echo "${currentVersion}" | tr -d '.')
latestFormatted=$(echo "${latestVersion}" | tr -d '.')

echo "Local version: ${currentVersion}"
echo "Latest version: ${latestVersion}"

if [ "${latestFormatted}" -gt "${currentFormatted}" ]; then
    echo "Updating VueTorrent..."

    tempDir=$(mktemp -d)
    downloadUrl=https://github.com/VueTorrent/VueTorrent/releases/latest/download/vuetorrent.zip
    zipFilePath=${tempDir}/vuetorrent.zip
    curl -sL $downloadUrl -o $zipFilePath
    rm -rf ${vuetorrentPath}/*
    unzip $zipFilePath -d . > /dev/null
    if [[ "${vuetorrentPath}" != "./vuetorrent" ]]; then
        mv ./vuetorrent/* ${vuetorrentPath}
        rmdir ./vuetorrent
    fi
    rm -f $zipFilePath

    echo "VueTorrent has been updated to ${latestVersion}!"
else
    echo "VueTorrent is up to date!"
fi