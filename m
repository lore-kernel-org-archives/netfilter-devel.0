From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: shell: validate set size
Date: Tue, 24 Jan 2017 19:36:27 +0100
Message-ID: <1485282987-9118-2-git-send-email-pablo@netfilter.org>
References: <1485282987-9118-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46676 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdAXShC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:37:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84B6A1D94A8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75231A825E
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F938A7E99
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:36:41 +0100 (CET)
In-Reply-To: <1485282987-9118-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add two tests to make sure that set size checks work fine:

1) Check if set size is indeed working, this is a simple one.
2) Check if set size is correct after ENFILE error, there is bug that
   adds a new spare slot everytime we hit this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0018set_check_size_1 |  8 ++++++++
 tests/shell/testcases/sets/0019set_check_size_0 | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0018set_check_size_1
 create mode 100755 tests/shell/testcases/sets/0019set_check_size_0

diff --git a/tests/shell/testcases/sets/0018set_check_size_1 b/tests/shell/testcases/sets/0018set_check_size_1
new file mode 100755
index 000000000000..833b8e2bd877
--- /dev/null
+++ b/tests/shell/testcases/sets/0018set_check_size_1
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+$NFT add table x
+$NFT add set x s {type ipv4_addr\; size 2\;}
+$NFT add element x s {1.1.1.1}
+$NFT add element x s {1.1.1.2}
+$NFT add element x s {1.1.1.3}
diff --git a/tests/shell/testcases/sets/0019set_check_size_0 b/tests/shell/testcases/sets/0019set_check_size_0
new file mode 100755
index 000000000000..c20970838bf9
--- /dev/null
+++ b/tests/shell/testcases/sets/0019set_check_size_0
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+$NFT add table x
+$NFT add set x s {type ipv4_addr\; size 2\;}
+$NFT add element x s {1.1.1.1}
+$NFT add element x s {1.1.1.2}
+
+$NFT add element x s { 1.1.1.3 } 2>/dev/null
+if [ $? -eq 0 ]; then
+        echo "E: set is full, but element was added" >&2
+	exit 1
+fi
+#
+# Try again, this helps us catch incorrect set->nelems decrement from abort path
+#
+$NFT add element x s { 1.1.1.3 } 2>/dev/null
+if [ $? -eq 0 ]; then
+        echo "E: set is full, but element was added" >&2
+	exit 1
+fi
-- 
2.1.4

