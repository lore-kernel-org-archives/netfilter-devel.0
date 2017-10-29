From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 05/16] tests: shell: Add test for log flags.
Date: Mon, 30 Oct 2017 02:19:20 +0530
Message-ID: <20171029204931.7792-5-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:48514 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdJ2Utz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:55 -0400
Received: by mail-pf0-f196.google.com with SMTP id b79so9226007pfk.5
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:55 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test cases for log flags.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/optionals/log_flags_0 | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/log_flags_0

diff --git a/tests/shell/testcases/optionals/log_flags_0 b/tests/shell/testcases/optionals/log_flags_0
new file mode 100755
index 0000000..7b8550f
--- /dev/null
+++ b/tests/shell/testcases/optionals/log_flags_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip x {
+	chain y {
+		log flags tcp sequence,options
+		log flags ip options
+		log flags skuid
+		log flags ether
+		log flags all
+	}
+}"
+
+$NFT add table ip x
+$NFT add chain ip x y
+$NFT add rule x y log flags tcp sequence,options
+$NFT add rule x y log flags ip options
+$NFT add rule x y log flags skuid
+$NFT add rule x y log flags ether
+$NFT add rule x y log flags all
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

