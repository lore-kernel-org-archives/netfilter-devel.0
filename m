From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: Add test for compile options.
Date: Sun, 14 Jan 2018 02:51:29 +0530
Message-ID: <20180113212129.3475-2-rvarsha016@gmail.com>
References: <20180113212129.3475-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:37428 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752830AbeAMVVu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jan 2018 16:21:50 -0500
Received: by mail-pf0-f169.google.com with SMTP id p1so6411946pfh.4
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jan 2018 13:21:50 -0800 (PST)
In-Reply-To: <20180113212129.3475-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a script to test available compile options.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/build/run-tests.sh | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100755 tests/build/run-tests.sh

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
new file mode 100755
index 0000000..298acca
--- /dev/null
+++ b/tests/build/run-tests.sh
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+if [ "$(id -u)" !=  "0" ]  ; then
+        echo "Run as root user"
+        exit 1
+fi
+
+LOG_FILE="`pwd`/tests.log"
+dir=../..
+cmd=./configure
+argument=( --without-cli --enable-debug --with-mini-gmp --enable-pdf-doc --with-xtables )
+ok=0
+failed=0
+
+[ -f $LOG_FILE ] && rm -rf $LOG_FILE
+cd $dir
+
+for var in "${argument[@]}" ; do
+	echo "[EXECUTING] Testing compile option $var"
+	$cmd $var >/dev/null 2>>$LOG_FILE
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

