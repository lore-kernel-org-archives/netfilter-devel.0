From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft v2] tests: shell: Add tests for chain rename.
Date: Thu,  5 Oct 2017 13:36:46 +0530
Message-ID: <20171005080647.15713-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37725 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdJEIHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2017 04:07:36 -0400
Received: by mail-pg0-f65.google.com with SMTP id o1so13932493pga.4
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Oct 2017 01:07:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test cases for renaming chain with existing and non 
existing chains.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
Changes in v1:
- Added test for non existing chains.

Changes in v2:
- Added tests for both existing and non existing chains.
- Edited the comment.
- Modified commit message.

 tests/shell/testcases/chains/0013rename_0 |  8 ++++++++
 tests/shell/testcases/chains/0014rename_1 | 14 ++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0013rename_0
 create mode 100755 tests/shell/testcases/chains/0014rename_1

diff --git a/tests/shell/testcases/chains/0013rename_0 b/tests/shell/testcases/chains/0013rename_0
new file mode 100755
index 0000000..b9fe11a
--- /dev/null
+++ b/tests/shell/testcases/chains/0013rename_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+# kernel should not return EEXIST
+$NFT rename chain t c1 c2
diff --git a/tests/shell/testcases/chains/0014rename_1 b/tests/shell/testcases/chains/0014rename_1
new file mode 100755
index 0000000..e29e788
--- /dev/null
+++ b/tests/shell/testcases/chains/0014rename_1
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+$NFT add chain t c2
+# kernel should return EEXIST
+$NFT rename chain t c1 c2
+
+if [ $? -eq 0 ] ; then
+	echo "E: Renamed with existing chain" >&2
+	exit 0
+fi
-- 
2.13.6

