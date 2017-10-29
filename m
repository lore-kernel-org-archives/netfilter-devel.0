From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 06/16] tests: shell: Add tests for payload expression.
Date: Mon, 30 Oct 2017 02:19:21 +0530
Message-ID: <20171029204931.7792-6-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:51731 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2Ut6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:58 -0400
Received: by mail-pf0-f193.google.com with SMTP id n14so9214665pfh.8
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:58 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for adjacent payload expression.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/transactions/0024rule_0 | 44 +++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0024rule_0

diff --git a/tests/shell/testcases/transactions/0024rule_0 b/tests/shell/testcases/transactions/0024rule_0
new file mode 100755
index 0000000..7644ce8
--- /dev/null
+++ b/tests/shell/testcases/transactions/0024rule_0
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+# Tests for adjacent payload expressions.
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
+RULESET="add table x
+add chain x y
+add rule x y tcp sport 1024 tcp dport 22 counter
+add rule x y ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter
+add rule x y tcp sequence 0 tcp sport 1024 tcp dport 22
+add rule x y tcp sport 1024 tcp dport 22 tcp sequence 0"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+
+EXPECTED="table ip x {
+	chain y {
+		tcp sport 1024 tcp dport ssh counter packets 0 bytes 0
+		ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter packets 0 bytes 0
+		tcp sport 1024 tcp dport ssh tcp sequence 0
+		tcp sport 1024 tcp dport ssh tcp sequence 0
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
2.13.6

