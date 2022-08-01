Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43153C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 17:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiHARQI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiHARPz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 13:15:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE8B7C3
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 10:15:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIZ1D-0001hh-BN; Mon, 01 Aug 2022 19:15:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: add test case for nf trace infrastructure
Date:   Mon,  1 Aug 2022 19:15:36 +0200
Message-Id: <20220801171536.21372-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801171536.21372-1-fw@strlen.de>
References: <20220801171536.21372-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable/disable tracing infrastructure while packets are in-flight.
This triggers KASAN splat after
e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_trans_stress.sh   | 78 ++++++++++++++++++-
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_trans_stress.sh b/tools/testing/selftests/netfilter/nft_trans_stress.sh
index f1affd12c4b1..4a14bca99dee 100755
--- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
+++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
@@ -9,8 +9,27 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-testns=testns1
+testns=testns-$(mktemp -u "XXXXXXXX")
+
 tables="foo bar baz quux"
+global_ret=0
+eret=0
+lret=0
+
+check_result()
+{
+	local r=$1
+	local OK="PASS"
+
+	if [ $r -ne 0 ] ;then
+		OK="FAIL"
+		global_ret=$r
+	fi
+
+	echo "$OK: nft $2 test returned $r"
+
+	eret=0
+}
 
 nft --version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -59,20 +78,75 @@ done)
 
 sleep 1
 
+ip netns exec "$testns" nft -f "$tmp"
 for i in $(seq 1 10) ; do ip netns exec "$testns" nft -f "$tmp" & done
 
 for table in $tables;do
 	randsleep=$((RANDOM%10))
 	sleep $randsleep
-	ip netns exec "$testns" nft delete table inet $table 2>/dev/null
+	ip netns exec "$testns" nft delete table inet $table # 2>/dev/null
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
 done
 
+check_result $eret "add/delete"
+
 randsleep=$((RANDOM%10))
 sleep $randsleep
 
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp") | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+done
+
+check_result $eret "reload"
+
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp"
+	 echo "insert rule inet foo INPUT meta nftrace set 1"
+	 echo "insert rule inet foo OUTPUT meta nftrace set 1"
+	 ) | ip netns exec "$testns" nft -f /dev/stdin
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+
+	(echo "flush ruleset"; cat "$tmp"
+	 ) | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+done
+
+check_result $eret "add/delete with nftrace enabled"
+
+echo "insert rule inet foo INPUT meta nftrace set 1" >> $tmp
+echo "insert rule inet foo OUTPUT meta nftrace set 1" >> $tmp
+
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp") | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=1
+	fi
+done
+
+check_result $lret "add/delete with nftrace enabled"
+
 pkill -9 ping
 
 wait
 
 rm -f "$tmp"
 ip netns del "$testns"
+
+exit $global_ret
-- 
2.35.1

