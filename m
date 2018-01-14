From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests/shell: add tests for deletion of chains via chain handle
Date: Mon, 15 Jan 2018 01:03:07 +0530
Message-ID: <20180114193307.7374-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41366 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeANTda (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jan 2018 14:33:30 -0500
Received: by mail-pg0-f65.google.com with SMTP id 136so6497423pgd.8
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2018 11:33:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delete chain with given unique handle for a table.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/testcases/chains/0016delete_handle_0 | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0016delete_handle_0

diff --git a/tests/shell/testcases/chains/0016delete_handle_0 b/tests/shell/testcases/chains/0016delete_handle_0
new file mode 100755
index 0000000..cf11da8
--- /dev/null
+++ b/tests/shell/testcases/chains/0016delete_handle_0
@@ -0,0 +1,36 @@
+#!/bin/bash
+
+set -e
+$NFT add table test-ip
+$NFT add chain test-ip x	# should have handle 1
+$NFT add chain test-ip y	# should have handle 2
+$NFT add chain test-ip z	# should have handle 3
+$NFT add table ip6 test-ip6
+$NFT add chain ip6 test-ip6 x	# should have handle 1
+$NFT add chain ip6 test-ip6 y	# should have handle 2
+$NFT add chain ip6 test-ip6 z	# should have handle 3
+$NFT delete chain test-ip handle 2
+$NFT delete chain ip6 test-ip6 handle 3
+
+EXPECTED="table ip test-ip {
+	chain x {
+	}
+
+	chain z {
+	}
+}
+table ip6 test-ip6 {
+	chain x {
+	}
+
+	chain y {
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
2.11.0

