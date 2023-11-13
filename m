Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A4AC41535
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjKMNjN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjKMNjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A32ED1729
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:06 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 03/11] tests: shell: skip stateful expression in sets tests if kernel lacks support
Date:   Mon, 13 Nov 2023 14:38:50 +0100
Message-Id: <20231113133858.121324-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests that require stateful expressions in sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use git describe --contains and use diff instead of $DIFF, requested by Florian

 tests/shell/features/set_expr.sh              | 19 +++++++++++++++++++
 tests/shell/testcases/json/0002table_map_0    |  1 +
 tests/shell/testcases/maps/0009vmap_0         |  2 ++
 .../testcases/optimizations/merge_stmts_vmap  |  2 ++
 tests/shell/testcases/sets/0048set_counters_0 |  2 ++
 .../testcases/sets/0051set_interval_counter_0 |  2 ++
 tests/shell/testcases/sets/elem_opts_compat_0 |  2 ++
 7 files changed, 30 insertions(+)
 create mode 100755 tests/shell/features/set_expr.sh

diff --git a/tests/shell/features/set_expr.sh b/tests/shell/features/set_expr.sh
new file mode 100755
index 000000000000..fbdfc2288fcb
--- /dev/null
+++ b/tests/shell/features/set_expr.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+# 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
+# v5.7-rc1~146^2~12^2~25
+
+# NFT_SET_EXPR to detect kernel feature only available since
+# b4e70d8dd9ea ("netfilter: nftables: add set expression flags")
+# v5.11-rc3~39^2^2
+
+EXPECTED="table ip x {
+	set y {
+		typeof ip saddr
+		counter
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+diff -u <($NFT list ruleset) - <<<"$EXPECTED"
diff --git a/tests/shell/testcases/json/0002table_map_0 b/tests/shell/testcases/json/0002table_map_0
index b375e9969608..a1e9f2634978 100755
--- a/tests/shell/testcases/json/0002table_map_0
+++ b/tests/shell/testcases/json/0002table_map_0
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
 
 set -e
 
diff --git a/tests/shell/testcases/maps/0009vmap_0 b/tests/shell/testcases/maps/0009vmap_0
index d31e1608f792..4e133b72f6ef 100755
--- a/tests/shell/testcases/maps/0009vmap_0
+++ b/tests/shell/testcases/maps/0009vmap_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 set -e
 
 EXPECTED="table inet filter {
diff --git a/tests/shell/testcases/optimizations/merge_stmts_vmap b/tests/shell/testcases/optimizations/merge_stmts_vmap
index 6e0f0762b7bb..e5357c0f66b6 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_vmap
+++ b/tests/shell/testcases/optimizations/merge_stmts_vmap
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 set -e
 
 RULESET="table ip x {
diff --git a/tests/shell/testcases/sets/0048set_counters_0 b/tests/shell/testcases/sets/0048set_counters_0
index e62d25df799c..95babdc9ca5f 100755
--- a/tests/shell/testcases/sets/0048set_counters_0
+++ b/tests/shell/testcases/sets/0048set_counters_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 set -e
 
 EXPECTED="table ip x {
diff --git a/tests/shell/testcases/sets/0051set_interval_counter_0 b/tests/shell/testcases/sets/0051set_interval_counter_0
index ea90e264bfcc..6e67a43c577a 100755
--- a/tests/shell/testcases/sets/0051set_interval_counter_0
+++ b/tests/shell/testcases/sets/0051set_interval_counter_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 set -e
 
 EXPECTED="table ip x {
diff --git a/tests/shell/testcases/sets/elem_opts_compat_0 b/tests/shell/testcases/sets/elem_opts_compat_0
index 3467cc07e646..7563773e626f 100755
--- a/tests/shell/testcases/sets/elem_opts_compat_0
+++ b/tests/shell/testcases/sets/elem_opts_compat_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 # ordering of element options and expressions has changed, make sure parser
 # accepts both ways
 
-- 
2.30.2

