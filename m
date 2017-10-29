From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 03/16] tests: shell: Add test for log statement.
Date: Mon, 30 Oct 2017 02:19:18 +0530
Message-ID: <20171029204931.7792-3-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:47641 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdJ2Utv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:51 -0400
Received: by mail-pf0-f195.google.com with SMTP id z11so9228599pfk.4
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:51 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add test case for log statement.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/optionals/log_0 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/log_0

diff --git a/tests/shell/testcases/optionals/log_0 b/tests/shell/testcases/optionals/log_0
new file mode 100755
index 0000000..672cff7
--- /dev/null
+++ b/tests/shell/testcases/optionals/log_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip x {
+	chain y {
+		type filter hook output priority 0; policy accept;
+		tcp dport ssh log group 0 counter packets 0 bytes 0
+	}
+}"
+
+$NFT add table ip x
+$NFT add chain ip x y { type filter hook output priority 0\; }
+$NFT add rule ip x y tcp dport 22 log group 0 counter
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+        DIFF="$(which diff)"
+        [ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+        exit 1
+fi
-- 
2.13.6

