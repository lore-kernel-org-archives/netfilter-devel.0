From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] tests: shell: Add test for chain rename.
Date: Mon,  2 Oct 2017 16:31:54 +0530
Message-ID: <20171002110154.19721-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33794 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBLCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 07:02:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id g65so5394390pfe.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Oct 2017 04:02:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test for chain rename use case.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/chains/0013rename_1 | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0013rename_1

diff --git a/tests/shell/testcases/chains/0013rename_1 b/tests/shell/testcases/chains/0013rename_1
new file mode 100755
index 0000000..a69d855
--- /dev/null
+++ b/tests/shell/testcases/chains/0013rename_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+# kernel should return EEXIST
+$NFT rename chain t c1 c2 2>/dev/null
+echo "E: Renamed chain with non existing chain" >&2
-- 
2.13.6

