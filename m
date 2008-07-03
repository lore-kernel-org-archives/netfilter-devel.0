From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: quote variables in release.sh
Date: Thu, 3 Jul 2008 20:15:56 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58254 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYGCSP5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:15:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 68a69d9fbf610899aa95457cdd5c38dcfa447c02
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 3 19:23:39 2008 +0200

    build: quote variables in release.sh
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 release.sh |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/release.sh b/release.sh
index 5635e4c..f77ef25 100644
--- a/release.sh
+++ b/release.sh
@@ -7,14 +7,14 @@ PREV_VERSION=1.4.1
 TMPDIR=/tmp/ipt-release
 IPTDIR="$TMPDIR/iptables-$VERSION"
 
-PATCH=patch-iptables-$PREV_VERSION-$VERSION.bz2
-TARBALL=iptables-$VERSION.tar.bz2
-CHANGELOG=changes-iptables-$PREV_VERSION-$VERSION.txt
+PATCH="patch-iptables-$PREV_VERSION-$VERSION.bz2";
+TARBALL="iptables-$VERSION.tar.bz2";
+CHANGELOG="changes-iptables-$PREV_VERSION-$VERSION.txt";
 
 mkdir -p "$TMPDIR"
-git shortlog v$PREV_VERSION..v$VERSION > "$TMPDIR/$CHANGELOG"
-git diff v$PREV_VERSION..v$VERSION | bzip2 > "$TMPDIR/$PATCH"
-git archive --prefix=iptables-$VERSION/ v$VERSION | tar -xC "$TMPDIR/"
+git shortlog "v$PREV_VERSION..v$VERSION" > "$TMPDIR/$CHANGELOG"
+git diff "v$PREV_VERSION..v$VERSION" | bzip2 > "$TMPDIR/$PATCH"
+git archive --prefix="iptables-$VERSION/" "v$VERSION" | tar -xC "$TMPDIR/"
 
 cd "$IPTDIR" && {
 	sh autogen.sh
@@ -22,9 +22,9 @@ cd "$IPTDIR" && {
 	cd ..
 }
 
-tar -cjf $TARBALL iptables-$VERSION
-gpg -u "Netfilter Core Team" -sb $TARBALL
-md5sum $TARBALL > $TARBALL.md5sum
+tar -cjf "$TARBALL" "iptables-$VERSION";
+gpg -u "Netfilter Core Team" -sb "$TARBALL";
+md5sum "$TARBALL" >"$TARBALL.md5sum";
 
-gpg -u "Netfilter Core Team" -sb $PATCH
-md5sum $PATCH > $PATCH.md5sum
+gpg -u "Netfilter Core Team" -sb "$PATCH";
+md5sum "$PATCH" >"$PATCH.md5sum";

