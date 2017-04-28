From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: shell: delete element and chain in transaction
Date: Fri, 28 Apr 2017 15:07:06 +0200
Message-ID: <1493384826-3685-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755555AbdD1NHZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 09:07:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DF151EC2D1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:07:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 847961850E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:07:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 882381B2EF3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 15:07:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a test to test refcounting from element to chain and
objects.

Reported-by: Andreas Schultz <aschultz@tpip.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/0040set_0 | 76 ++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0040set_0

diff --git a/tests/shell/testcases/transactions/0040set_0 b/tests/shell/testcases/transactions/0040set_0
new file mode 100755
index 000000000000..241703d90340
--- /dev/null
+++ b/tests/shell/testcases/transactions/0040set_0
@@ -0,0 +1,76 @@
+#!/bin/bash
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="table ip filter {
+	map client_to_any {
+		type ipv4_addr : verdict
+		elements = { 1.2.3.4 : goto CIn_1 }
+	}
+
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		goto client_to_any
+	}
+
+	chain client_to_any {
+		ip saddr vmap @client_to_any
+	}
+
+	chain CIn_1 {
+	}
+}"
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+GET="$($NFT list ruleset)"
+
+if [ "$RULESET" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$GET")
+	exit 1
+fi
+
+RULESET="delete element ip filter client_to_any { 1.2.3.4 : goto CIn_1 }
+delete chain ip filter CIn_1"
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+GET="$($NFT list ruleset)"
+
+EXPECTED="table ip filter {
+	map client_to_any {
+		type ipv4_addr : verdict
+	}
+
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		goto client_to_any
+	}
+
+	chain client_to_any {
+		ip saddr vmap @client_to_any
+	}
+}"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.1.4

