From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 12/16] tests: files: Test for meta expressions.
Date: Mon, 30 Oct 2017 02:19:27 +0530
Message-ID: <20171029204931.7792-12-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:54162 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:13 -0400
Received: by mail-pg0-f66.google.com with SMTP id s2so9670886pge.10
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:13 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for meta expressions.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/transactions/0026rule_0 | 44 +++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0026rule_0

diff --git a/tests/shell/testcases/transactions/0026rule_0 b/tests/shell/testcases/transactions/0026rule_0
new file mode 100755
index 0000000..4111ce9
--- /dev/null
+++ b/tests/shell/testcases/transactions/0026rule_0
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+# Test for meta expressions.
+
+set -e
+
+$NFT add table x
+$NFT add chain x y { type filter hook output priority 0\; }
+$NFT add rule x y meta length 1000
+$NFT add rule x y meta protocol 0x0800
+$NFT add rule x y meta mark 0
+$NFT add rule x y meta iif lo
+$NFT add rule x y meta iifname "eth0"
+$NFT add rule x y meta oif lo
+$NFT add rule x y meta oifname "eth0"
+$NFT add rule x y meta skuid 1000
+$NFT add rule x y meta nftrace set 1
+$NFT add rule x y meta rtclassid cosmos
+
+usr=$"$USER"
+
+EXPECTED="table ip x {
+	chain y {
+		type filter hook output priority 0; policy accept;
+		meta length 1000
+		meta protocol ip
+		mark 0x00000000
+		iif \"lo\"
+		iifname \"eth0\"
+		oif \"lo\"
+		oifname \"eth0\"
+		skuid \"$usr\"
+		nftrace set 1
+		rtclassid \"cosmos\"
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

