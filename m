From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 2/9] tests: shell: Add test case for jump chain.
Date: Wed, 11 Oct 2017 10:11:37 +0530
Message-ID: <e88173fd5018800db110fa1e36d2103cfabfb3b4.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35862 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdJKEl4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:41:56 -0400
Received: by mail-pf0-f193.google.com with SMTP id z11so1151722pfk.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:41:56 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for checking jump to non existing chain.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/chains/0015check_jump_loop_1 | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0015check_jump_loop_1

diff --git a/tests/shell/testcases/chains/0015check_jump_loop_1 b/tests/shell/testcases/chains/0015check_jump_loop_1
new file mode 100755
index 0000000..059cfaa
--- /dev/null
+++ b/tests/shell/testcases/chains/0015check_jump_loop_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+$NFT add chain t c2
+$NFT add t c1 jump c2
+# kernel should return ENOENT
+$NFT add t c2 ip daddr vmap { 1 : jump c3 }
+echo "E: Jumped to non existing chain" >&2
-- 
2.13.6

