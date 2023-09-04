Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E3EC83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 09:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350273AbjIDJHH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 05:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344770AbjIDJHG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 05:07:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5EF13D
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:07:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qd5Xy-0000Ep-7s; Mon, 04 Sep 2023 11:07:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/5] tests: shell: let netdev_chain_0 test indicate SKIP if kernel requires netdev device
Date:   Mon,  4 Sep 2023 11:06:31 +0200
Message-ID: <20230904090640.3015-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904090640.3015-1-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test case only works on kernel 6.4+.
Add feature probe for this and then exit early.

We don't want to indicate a test failure, as this test doesn't apply
on older kernels.

But we should not indicate sucess either, else we might be fooled
in case something went wrong during feature probe.

Add a special return value, 123, and let run-tests.sh count this
as 'SKIPPED'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/netdev_chain_without_device.nft |  7 +++++++
 tests/shell/run-tests.sh                             | 11 ++++++++++-
 tests/shell/testcases/chains/netdev_chain_0          |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/features/netdev_chain_without_device.nft

diff --git a/tests/shell/features/netdev_chain_without_device.nft b/tests/shell/features/netdev_chain_without_device.nft
new file mode 100644
index 000000000000..25eb200ffe31
--- /dev/null
+++ b/tests/shell/features/netdev_chain_without_device.nft
@@ -0,0 +1,7 @@
+# 207296f1a03b ("netfilter: nf_tables: allow to create netdev chain without device")
+# v6.4-rc1~132^2~14^2
+table netdev t {
+	chain c {
+		type filter hook ingress priority 0; policy accept;
+        }
+}
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 3113404de2b9..17cab3f11c9b 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -161,6 +161,7 @@ fi
 echo ""
 ok=0
 failed=0
+skipped=0
 taint=0
 
 check_features()
@@ -270,6 +271,9 @@ do
 				msg_warn "[DUMP FAIL]	$testfile"
 			fi
 		fi
+	elif [ "$rc_got" -eq 123 ]; then
+		((skipped++))
+		msg_info "[SKIPPED]	$testfile"
 	else
 		((failed++))
 		if [ "$VERBOSE" == "y" ] ; then
@@ -294,7 +298,12 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+msg_info "results: [OK] $ok [FAILED] $failed [SKIPPED] $skipped [TOTAL] $((ok+failed+skipped))"
+
+if [ $ok -eq 0 -a  $failed -eq 0 ]; then
+	# no test cases were run, indicate a failure
+	failed=1
+fi
 
 if [ "$VERBOSE" == "y" ] ; then
 	echo "Probed Features:"
diff --git a/tests/shell/testcases/chains/netdev_chain_0 b/tests/shell/testcases/chains/netdev_chain_0
index 67cd715fc59f..2e2a0c177fcb 100755
--- a/tests/shell/testcases/chains/netdev_chain_0
+++ b/tests/shell/testcases/chains/netdev_chain_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+[ "$NFT_HAVE_netdev_chain_without_device" -eq 0 ] && exit 123
+
 ip link add d0 type dummy || {
         echo "Skipping, no dummy interface available"
         exit 0
-- 
2.41.0

