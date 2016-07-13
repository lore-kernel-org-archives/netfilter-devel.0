From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] tests: shell: make sure split table definition works via nft -f
Date: Wed, 13 Jul 2016 16:59:42 +0200
Message-ID: <1468421982-2620-2-git-send-email-pablo@netfilter.org>
References: <1468421982-2620-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60894 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbcGMO74 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jul 2016 10:59:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9F1682519AC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 90CD29EBBD
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83406A827A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2016 16:59:47 +0200 (CEST)
In-Reply-To: <1468421982-2620-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add test to cover split table definition in one single file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/nft-f/0008split_tables_0 | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0008split_tables_0

diff --git a/tests/shell/testcases/nft-f/0008split_tables_0 b/tests/shell/testcases/nft-f/0008split_tables_0
new file mode 100755
index 0000000..2bc6e46
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0008split_tables_0
@@ -0,0 +1,50 @@
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
+RULESET="table inet filter {
+	chain ssh {
+		type filter hook input priority 0; policy accept;
+		tcp dport ssh accept;
+	}
+}
+
+table inet filter {
+	chain input {
+		type filter hook input priority 1; policy drop;
+	}
+}"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table inet filter {
+	chain ssh {
+		type filter hook input priority 0; policy accept;
+		tcp dport ssh accept
+	}
+
+	chain input {
+		type filter hook input priority 1; policy drop;
+	}
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.1.4

