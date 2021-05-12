# openshift-client.deb

This is mainly a Makefile that:

- downloads the binary release (given version and revision) from GitHub releases
- verifies the download against the SHA256 checksum
- unpacks the binary
- creates a Debian package (.deb) from the unpacked binary
- optionally installs using the .deb file


