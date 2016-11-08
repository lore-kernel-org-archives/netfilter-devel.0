From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: shell: add test case for inserting element into verdict map
Date: Tue,  8 Nov 2016 23:06:37 +0800
Message-ID: <1478617597-13459-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, arturo@debian.org,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:47421 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbcKHPH0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 10:07:26 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

"dalegaard@gmail.com" reports that when inserting an element into a
verdict map, kernel crash will happen. Now add this test case so we
can avoid future regressions fail.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 .../shell/testcases/sets/0008create_verdict_map_0  | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0008create_verdict_map_0

diff --git a/tests/shell/testcases/sets/0008create_verdict_map_0 b/tests/shell/testcases/sets/0008create_verdict_map_0
new file mode 100755
index 0000000..8ebb450
--- /dev/null
+++ b/tests/shell/testcases/sets/0008create_verdict_map_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+table ip t {
+	map sourcemap {
+		type ipv4_addr : verdict;
+	}
+	chain postrouting {
+		ip saddr vmap @sourcemap accept
+	}
+}
+add chain t c
+add element t sourcemap { 100.123.10.2 : jump c }
+" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
-- 
2.5.5


