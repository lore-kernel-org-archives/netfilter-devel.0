From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v2] tests: Add test for compile options.
Date: Tue, 16 Jan 2018 08:00:36 +0530
Message-ID: <20180116023036.31547-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:37150 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeAPCay (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 21:30:54 -0500
Received: by mail-pf0-f172.google.com with SMTP id p1so8924860pfh.4
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 18:30:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a script to test available compile options.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v2:
 - Added test for make diskcheck

 tests/build/run-tests.sh | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100755 tests/build/run-tests.sh

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
new file mode 100755
index 0000000..36cd8d8
--- /dev/null
+++ b/tests/build/run-tests.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+
+if [ "$(id -u)" !=  "0" ]  ; then
+        echo "Run as root user"
+        exit 1
+fi
+
+log_file="`pwd`/tests.log"
+tarball="nftables-0.8.1.tar.bz2"
+dir=../..
+cmd=./configure
+argument=( --without-cli --enable-debug --with-mini-gmp --enable-pdf-doc --with-xtables )
+ok=0
+failed=0
+
+[ -f $log_file ] && rm -rf $log_file
+cd $dir
+
+echo  "Testing build with distcheck"
+make distcheck >/dev/null 2>>$log_file
+rt=$?
+
+rm -rf $tarball
+
+if [ $rt != 0 ] ; then
+	echo "Something went wrong. Check the log for details."
+	exit 1
+fi
+
+echo -en "\033[1A\033[K"
+echo "Build works. Now, testing compile options"
+
+for var in "${argument[@]}" ; do
+	echo "[EXECUTING] Testing compile option $var"
+	$cmd $var >/dev/null 2>>$log_file
+	rt=$?
+	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
+
+	if [ $rt -eq 0 ] ; then
+		echo "[OK] Compile option $var works."
+		((ok++))
+	else
+		echo "[FAILED] Compile option $var does not work. Check log for details."
+		((failed++))
+	fi
+done
+
+echo "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+exit 0
-- 
2.14.3

