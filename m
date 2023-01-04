Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7241EC4708E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Jan 2023 11:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbjADLzW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 06:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjADLyv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 06:54:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE51D0EF
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Jan 2023 03:54:49 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pD2M3-0002AH-Fl; Wed, 04 Jan 2023 12:54:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH nf] selftests: netfilter: fix transaction test script timeout handling
Date:   Wed,  4 Jan 2023 12:54:42 +0100
Message-Id: <20230104115442.2427-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kselftest framework uses a default timeout of 45 seconds for
all test scripts.

Increase the timeout to two minutes for the netfilter tests, this
should hopefully be enough,

Make sure that, should the script be canceled, the net namespace and
the spawned ping instances are removed.

Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_trans_stress.sh      | 16 +++++++++-------
 tools/testing/selftests/netfilter/settings       |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings

diff --git a/tools/testing/selftests/netfilter/nft_trans_stress.sh b/tools/testing/selftests/netfilter/nft_trans_stress.sh
index a7f62ad4f661..2ffba45a78bf 100755
--- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
+++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
@@ -10,12 +10,20 @@
 ksft_skip=4
 
 testns=testns-$(mktemp -u "XXXXXXXX")
+tmp=""
 
 tables="foo bar baz quux"
 global_ret=0
 eret=0
 lret=0
 
+cleanup() {
+	ip netns pids "$testns" | xargs kill 2>/dev/null
+	ip netns del "$testns"
+
+	rm -f "$tmp"
+}
+
 check_result()
 {
 	local r=$1
@@ -43,6 +51,7 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+trap cleanup EXIT
 tmp=$(mktemp)
 
 for table in $tables; do
@@ -139,11 +148,4 @@ done
 
 check_result $lret "add/delete with nftrace enabled"
 
-pkill -9 ping
-
-wait
-
-rm -f "$tmp"
-ip netns del "$testns"
-
 exit $global_ret
diff --git a/tools/testing/selftests/netfilter/settings b/tools/testing/selftests/netfilter/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/netfilter/settings
@@ -0,0 +1 @@
+timeout=120
-- 
2.38.2

