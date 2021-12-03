Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3DCC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 14:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381456AbhLCOhA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 09:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381337AbhLCOhA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 09:37:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5665DC061751
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 06:33:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mt9cz-0001eG-Pf; Fri, 03 Dec 2021 15:33:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: switch zone stress to socat
Date:   Fri,  3 Dec 2021 15:33:23 +0100
Message-Id: <20211203143323.4159-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

centos9 has nmap-ncat which doesn't like the '-q' option, use socat.
While at it, mark test skipped if needed tools are missing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_zones_many.sh     | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
index ac646376eb01..04633119b29a 100755
--- a/tools/testing/selftests/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -18,11 +18,17 @@ cleanup()
 	ip netns del $ns
 }
 
-ip netns add $ns
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $gw"
-	exit $ksft_skip
-fi
+checktool (){
+	if ! $1 > /dev/null 2>&1; then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
+
+checktool "nft --version" "run test without nft tool"
+checktool "ip -Version" "run test without ip tool"
+checktool "socat -V" "run test without socat tool"
+checktool "ip netns add $ns" "create net namespace"
 
 trap cleanup EXIT
 
@@ -71,7 +77,8 @@ EOF
 		local start=$(date +%s%3N)
 		i=$((i + 10000))
 		j=$((j + 1))
-		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" nc -w 1 -q 1 -u -p 12345 127.0.0.1 12345 > /dev/null
+		# nft rule in output places each packet in a different zone.
+		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
-- 
2.32.0

