Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BEDEE4993
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 15:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjHUPRE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 11:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbjHUPRD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 11:17:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42505FB
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 08:17:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qY6eI-0003vj-0z; Mon, 21 Aug 2023 17:16:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests/shell: expand vmap test case to also cause batch abort
Date:   Mon, 21 Aug 2023 17:16:49 +0200
Message-ID: <20230821151653.21015-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let the last few batches also push an update that contains
elements twice.

This is expected to cause the batch to be aborted,
which increases code coverage on kernel side.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/vmap_timeout.nft     |  2 ++
 tests/shell/testcases/maps/vmap_timeout       | 26 ++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.nft b/tests/shell/testcases/maps/dumps/vmap_timeout.nft
index 295971abda2a..095f894d62e1 100644
--- a/tests/shell/testcases/maps/dumps/vmap_timeout.nft
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.nft
@@ -2,12 +2,14 @@ table inet filter {
 	map portmap {
 		type inet_service : verdict
 		flags timeout
+		gc-interval 10s
 		elements = { 22 : jump ssh_input }
 	}
 
 	map portaddrmap {
 		typeof ip daddr . th dport : verdict
 		flags timeout
+		gc-interval 10s
 		elements = { 1.2.3.4 . 22 : jump ssh_input }
 	}
 
diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index a81ff4f5763f..e59d37ab4048 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -6,22 +6,36 @@ dumpfile=$(dirname $0)/dumps/$(basename $0).nft
 $NFT -f $dumpfile
 
 port=23
-for i in $(seq 1 400) ; do
-	timeout=$((RANDOM%3))
+for i in $(seq 1 100) ; do
+	timeout=$((RANDOM%5))
 	timeout=$((timeout+1))
 	j=1
 
 	batched="{ $port timeout 3s : jump other_input "
-	batched_addr="{ 10.0.$((i%256)).$j . $port timeout 3s : jump other_input "
+	batched_addr="{ 10.0.$((i%256)).$j . $port timeout ${timeout}s : jump other_input "
 	port=$((port + 1))
-	for j in $(seq 2 100); do
+	for j in $(seq 2 400); do
+		timeout=$((RANDOM%5))
+		timeout=$((timeout+1))
+
 		batched="$batched, $port timeout ${timeout}s : jump other_input "
-		batched_addr="$batched_addr, 10.0.$((i%256)).$j . $port timeout ${timeout}s : jump other_input "
+		batched_addr="$batched_addr, 10.0.$((i%256)).$((j%256)) . $port timeout ${timeout}s : jump other_input "
 		port=$((port + 1))
 	done
 
+	fail_addr="$batched_addr, 1.2.3.4 . 23 timeout 5m : jump other_input,
+	                          1.2.3.4 . 23 timeout 3m : jump other_input }"
+	fail="$batched, 23 timeout 1m : jump other_input, 23 : jump other_input }"
+
 	batched="$batched }"
 	batched_addr="$batched_addr }"
+
+	if [ $i -gt 90 ]; then
+		# must fail, we create and $fail/$fail_addr contain one element twice.
+		$NFT create element inet filter portmap "$fail" && exit 111
+		$NFT create element inet filter portaddrmap "$fail_addr" && exit 112
+	fi
+
 	$NFT add element inet filter portmap "$batched"
 	$NFT add element inet filter portaddrmap "$batched_addr"
 done
@@ -30,4 +44,4 @@ $NFT add element inet filter portaddrmap { "* timeout 2s : drop" }
 $NFT add element inet filter portmap { "* timeout 3s : drop" }
 
 # wait for elements to time out
-sleep 4
+sleep 5
-- 
2.41.0

