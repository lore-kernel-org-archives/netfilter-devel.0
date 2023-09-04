Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF86CC83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 09:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350634AbjIDJHP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 05:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352619AbjIDJHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 05:07:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64471A5
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:07:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qd5Y6-0000FO-DC; Mon, 04 Sep 2023 11:07:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/5] tests: shell: add and use feature probe for map query like a set
Date:   Mon,  4 Sep 2023 11:06:33 +0200
Message-ID: <20230904090640.3015-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904090640.3015-1-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On recent kernels one can perform a lookup in a map without a destination
register (i.e., treat the map like a set -- pure existence check).

Add a feature probe and work around the missing feature in
typeof_maps_add_delete: do the test with a simplified ruleset,

Indicate skipped even though a reduced test was run (earlier errors
cause a failure) to not trigger dump validation error.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/map_lookup.nft           | 11 ++++++
 .../testcases/maps/typeof_maps_add_delete     | 35 ++++++++++++++-----
 2 files changed, 38 insertions(+), 8 deletions(-)
 create mode 100644 tests/shell/features/map_lookup.nft

diff --git a/tests/shell/features/map_lookup.nft b/tests/shell/features/map_lookup.nft
new file mode 100644
index 000000000000..06c4c9d9c82d
--- /dev/null
+++ b/tests/shell/features/map_lookup.nft
@@ -0,0 +1,11 @@
+# a4878eeae390 ("netfilter: nf_tables: relax set/map validation checks")
+# v6.5-rc1~163^2~256^2~8
+table ip t {
+        map m {
+                typeof ip daddr : meta mark
+        }
+
+        chain c {
+                ip saddr @m
+        }
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_add_delete b/tests/shell/testcases/maps/typeof_maps_add_delete
index 341de538e90e..579194b03372 100755
--- a/tests/shell/testcases/maps/typeof_maps_add_delete
+++ b/tests/shell/testcases/maps/typeof_maps_add_delete
@@ -1,6 +1,15 @@
 #!/bin/bash
 
-EXPECTED='table ip dynset {
+CONDMATCH="ip saddr @dynmark"
+NCONDMATCH="ip saddr != @dynmark"
+
+# use reduced feature set
+if [ $NFT_HAVE_map_lookup -eq 0 ] ;then
+	CONDMATCH=""
+	NCONDMATCH=""
+fi
+
+EXPECTED="table ip dynset {
 	map dynmark {
 		typeof ip daddr : meta mark
 		counter
@@ -9,20 +18,20 @@ EXPECTED='table ip dynset {
 	}
 
 	chain test_ping {
-		ip saddr @dynmark counter comment "should not increment"
-		ip saddr != @dynmark add @dynmark { ip saddr : 0x1 } counter
-		ip saddr @dynmark counter comment "should increment"
-		ip saddr @dynmark delete @dynmark { ip saddr : 0x1 }
-		ip saddr @dynmark counter comment "delete should be instant but might fail under memory pressure"
+		$CONDMATCH counter comment \"should not increment\"
+		$NCONDMATCH add @dynmark { ip saddr : 0x1 } counter
+		$CONDMATCH counter comment \"should increment\"
+		$CONDMATCH delete @dynmark { ip saddr : 0x1 }
+		$CONDMATCH counter comment \"delete should be instant but might fail under memory pressure\"
 	}
 
 	chain input {
 		type filter hook input priority 0; policy accept;
 
-		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment "also check timeout-gc"
+		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment \"also check timeout-gc\"
 		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
 	}
-}'
+}"
 
 set -e
 $NFT -f - <<< $EXPECTED
@@ -31,5 +40,15 @@ $NFT list ruleset
 ip link set lo up
 ping -c 1 127.0.0.42
 
+$NFT get element ip dynset dynmark { 10.2.3.4 }
+
 # wait so that 10.2.3.4 times out.
 sleep 2
+
+set +e
+$NFT get element ip dynset dynmark { 10.2.3.4 } && exit 1
+
+# success, but indicate skip for reduced test to avoid dump validation error
+if [ $NFT_HAVE_map_lookup -eq 0 ];then
+	exit 123
+fi
-- 
2.41.0

