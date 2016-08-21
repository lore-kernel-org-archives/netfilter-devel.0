From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 3/4 V6 nft] test: shell: Add tests for deleting rule by description
Date: Sun, 21 Aug 2016 23:22:09 +0200
Message-ID: <20160821212210.26161-3-carlosfg@riseup.net>
References: <20160821212210.26161-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:34475 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753460AbcHUVWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2016 17:22:41 -0400
In-Reply-To: <20160821212210.26161-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

They checks if commands like "nft delete rule <table> <chain> <rule desc>"
works as is expected.

First one checks if command deletes only one of the matched rules.
Second one checks if command fails when rule did not found.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 .../testcases/rule_management/0010delete-by-desc_0 | 39 ++++++++++++++++++++++
 .../testcases/rule_management/0011delete-by-desc_1 | 20 +++++++++++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/shell/testcases/rule_management/0010delete-by-desc_0
 create mode 100755 tests/shell/testcases/rule_management/0011delete-by-desc_1

diff --git a/tests/shell/testcases/rule_management/0010delete-by-desc_0 b/tests/shell/testcases/rule_management/0010delete-by-desc_0
new file mode 100755
index 0000000..6afdec1
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0010delete-by-desc_0
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+# positive tests for rule deletion by description:
+#	$ nft delete rule <table> <chain> <rule description>
+
+RULE2DEL="ip saddr 1.1.1.1 counter"
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c ip saddr 1.1.1.1
+$NFT add rule t c $RULE2DEL
+$NFT add rule t c ip saddr 1.1.1.1 accept
+$NFT add rule t c $RULE2DEL
+
+$NFT delete rule t c $RULE2DEL
+if [ $? -ne 0 ]; then
+	echo "E: unable to delete rule \"$RULE2DEL\"" >&2
+	exit 1
+fi
+
+set +e; # Next commands can return 0
+REMAINS_RULE2DEL=$($NFT list -a ruleset | grep -c "$RULE2DEL")
+REMAINS_RULES=$(( $($NFT list -a ruleset | wc -l) - 4 ))
+set -e
+
+if   [ $REMAINS_RULE2DEL -eq 2 ]; then
+	echo "E: First rule \"$RULE2DEL\" should have been deleted" >&2
+	exit 1
+elif [ $REMAINS_RULE2DEL -eq 0 ]; then
+	echo "E: Second rule \"$RULE2DEL\" should not have been deleted" >&2
+	exit 1
+fi
+
+if [ $REMAINS_RULES -ne 3 ]; then
+	echo "E: Rest of rules should not have been deleted" >&2
+	$NFT list -a ruleset
+	exit 1
+fi
diff --git a/tests/shell/testcases/rule_management/0011delete-by-desc_1 b/tests/shell/testcases/rule_management/0011delete-by-desc_1
new file mode 100755
index 0000000..3ddb5ef
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0011delete-by-desc_1
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+# negative tests for rule deletion by description:
+#	$ nft delete rule <table> <chain> <rule description>
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT add rule t c ip saddr 1.1.1.1
+$NFT add rule t c ip saddr 1.1.1.1 accept
+
+set +e; # Next command must fail
+$NFT delete rule t c ip saddr 2.2.2.2
+RET=$?
+if [ $RET -ne 1 ]; then
+	echo "E: Try to delete a nonexistent rule should throw an error" >&2
+	exit $RET
+fi
+
+exit $RET
-- 
2.8.3

