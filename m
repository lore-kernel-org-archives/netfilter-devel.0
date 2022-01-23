Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DB6C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jan 2022 14:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiAWOqA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jan 2022 09:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiAWOqA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jan 2022 09:46:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30C5C06173B
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Jan 2022 06:45:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nBe7y-0001T0-CK; Sun, 23 Jan 2022 15:45:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: reduce zone stress test running time
Date:   Sun, 23 Jan 2022 15:45:54 +0100
Message-Id: <20220123144554.567444-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This selftests needs almost 3 minutes to complete, reduce the
insertes zones to 1000.  Test now completes in about 20 seconds.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_zones_many.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
index 04633119b29a..5a8db0b48928 100755
--- a/tools/testing/selftests/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -9,7 +9,7 @@ ns="ns-$sfx"
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-zones=20000
+zones=2000
 have_ct_tool=0
 ret=0
 
@@ -75,10 +75,10 @@ EOF
 
 	while [ $i -lt $max_zones ]; do
 		local start=$(date +%s%3N)
-		i=$((i + 10000))
+		i=$((i + 1000))
 		j=$((j + 1))
 		# nft rule in output places each packet in a different zone.
-		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
+		dd if=/dev/zero of=/dev/stdout bs=8k count=1000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
@@ -86,7 +86,7 @@ EOF
 
 		stop=$(date +%s%3N)
 		local duration=$((stop-start))
-		echo "PASS: added 10000 entries in $duration ms (now $i total, loop $j)"
+		echo "PASS: added 1000 entries in $duration ms (now $i total, loop $j)"
 	done
 
 	if [ $have_ct_tool -eq 1 ]; then
@@ -128,11 +128,11 @@ test_conntrack_tool() {
 			break
 		fi
 
-		if [ $((i%10000)) -eq 0 ];then
+		if [ $((i%1000)) -eq 0 ];then
 			stop=$(date +%s%3N)
 
 			local duration=$((stop-start))
-			echo "PASS: added 10000 entries in $duration ms (now $i total)"
+			echo "PASS: added 1000 entries in $duration ms (now $i total)"
 			start=$stop
 		fi
 	done
-- 
2.34.1

