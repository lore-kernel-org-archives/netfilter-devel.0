From: Matthias Schiffer <mschiffer@universe-factory.net>
Subject: [PATCH xtables-addons] build: fix configure compatiblity with POSIX shells
Date: Fri,  1 Apr 2016 22:35:34 +0200
Message-ID: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net>
Cc: netfilter-devel@vger.kernel.org
To: jengelh@inai.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:53705 "EHLO
	chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbcDAUmJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 16:42:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel version detection code uses some bashisms, which makes the build
fail on Debian systems where /bin/sh links to dash. Replace with POSIX-
conforming commands at the cost of requiring awk.
---
 configure.ac | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index 82a1355..735c090 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,21 +44,15 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 
 if test -n "$kbuilddir"; then
 	AC_MSG_CHECKING([kernel version that we will build against])
-	krel="$(make -sC "$kbuilddir" M=$PWD kernelrelease)";
-	kmajor="${krel%%[[^0-9]]*}";
-	kmajor="$(($kmajor+0))";
-	krel="${krel:${#kmajor}}";
-	krel="${krel#.}";
-	kminor="${krel%%[[^0-9]]*}";
-	kminor="$(($kminor+0))";
-	krel="${krel:${#kminor}}";
-	krel="${krel#.}";
-	kmicro="${krel%%[[^0-9]]*}";
-	kmicro="$(($kmicro+0))";
-	krel="${krel:${#kmicro}}";
-	krel="${krel#.}";
-	kstable="${krel%%[[^0-9]]*}";
-	kstable="$(($kstable+0))";
+	krel="$(make -sC "$kbuilddir" M=$PWD kernelrelease | $AWK -v 'FS=[[^0-9.]]' '{print $1; exit}')";
+	save_IFS=$IFS;
+	IFS='.';
+	set x $krel;
+	kmajor="$(($2+0))";
+	kminor="$(($3+0))";
+	kmicro="$(($4+0))";
+	kstable="$(($5+0))";
+	IFS=$save_IFS;
 	if test -z "$kmajor" -o -z "$kminor" -o -z "$kmicro"; then
 		echo "WARNING: Version detection did not succeed. Continue at own luck.";
 	else
-- 
2.8.0

