From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 09/16] tests: shell: Add test for ct expression.
Date: Mon, 30 Oct 2017 02:19:24 +0530
Message-ID: <20171029204931.7792-9-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:48535 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:05 -0400
Received: by mail-pf0-f196.google.com with SMTP id b79so9226222pfk.5
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:05 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test cases for ct expression.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/transactions/0025rule_0 | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0025rule_0

diff --git a/tests/shell/testcases/transactions/0025rule_0 b/tests/shell/testcases/transactions/0025rule_0
new file mode 100755
index 0000000..b8df747
--- /dev/null
+++ b/tests/shell/testcases/transactions/0025rule_0
@@ -0,0 +1,36 @@
+#!/bin/bash
+
+# Test for ct statements.
+
+set -e
+
+$NFT add table x
+$NFT add chain x y { type filter hook output priority 0\; }
+$NFT add rule x y ct state new,established
+$NFT add rule x y ct direction original
+$NFT add rule x y ct direction reply
+$NFT add rule x y ct status expected
+$NFT add rule x y ct mark 0
+$NFT add rule x y ct expiration 30
+$NFT add rule x y ct helper "ftp"
+
+EXPECTED="table ip x {
+	chain y {
+		type filter hook output priority 0; policy accept;
+		ct state established,new
+		ct direction original
+		ct direction reply
+		ct status expected
+		ct mark 0x00000000
+		ct expiration 30s
+		ct helper \"ftp\"
+	}
+}"
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

