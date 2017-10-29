From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 14/16] tests: shell: Add tests for concat expression.
Date: Mon, 30 Oct 2017 02:19:29 +0530
Message-ID: <20171029204931.7792-14-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:55775 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:18 -0400
Received: by mail-pf0-f193.google.com with SMTP id 17so9215242pfn.12
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:18 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add test cases for concat type and element mismatch.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/transactions/0050concat_1 | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0050concat_1

diff --git a/tests/shell/testcases/transactions/0050concat_1 b/tests/shell/testcases/transactions/0050concat_1
new file mode 100755
index 0000000..0e4f6e1
--- /dev/null
+++ b/tests/shell/testcases/transactions/0050concat_1
@@ -0,0 +1,26 @@
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
+RULESET="add table ip x
+add chain ip x y
+add rule ip x y ip daddr . tcp sport . tcp dport { \
+        192.168.0.1 . 22,       \
+        192.168.0.1 . 80,       \
+}
+add rule ip x y ip daddr . tcp dport { \
+        192.168.0.1 . 192.168.0.2,      \
+        192.168.0.1 . 192.168.0.3,      \
+}"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+echo "E: Allowed concat type and element mismatch"
-- 
2.13.6

