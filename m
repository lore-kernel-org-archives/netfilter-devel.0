Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCF5C04AAB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 17:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjIURCZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjIURCH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 13:02:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF2D2117
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 09:59:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qjFMy-0004MB-7a; Thu, 21 Sep 2023 10:49:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3] tests: shell: add feature probe for sctp chunk matching
Date:   Thu, 21 Sep 2023 10:48:46 +0200
Message-ID: <20230921084849.634-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921084849.634-1-fw@strlen.de>
References: <20230921084849.634-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip the relavant parts of the test if nft_exthdr lacks sctp support.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/sctp_chunks.nft     |  7 +++++++
 tests/shell/testcases/sets/typeof_sets_0 | 26 +++++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)
 create mode 100644 tests/shell/features/sctp_chunks.nft

diff --git a/tests/shell/features/sctp_chunks.nft b/tests/shell/features/sctp_chunks.nft
new file mode 100644
index 000000000000..520afd64bd2e
--- /dev/null
+++ b/tests/shell/features/sctp_chunks.nft
@@ -0,0 +1,7 @@
+# 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
+# v5.14-rc1~119^2~373^2~15
+table ip t {
+	chain c {
+		sctp chunk init 0
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index c1c0f51f399c..35c572c1e537 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -23,6 +23,16 @@ INPUT_OSF_CHAIN="
 	}
 "
 
+INPUT_SCTP_CHAIN="
+	chain c7 {
+		sctp chunk init num-inbound-streams @s7 accept
+	}
+"
+
+if [ "$NFT_TEST_HAVE_sctp_chunks" = n ] ; then
+	INPUT_SCTP_CHAIN=
+fi
+
 if [ "$NFT_TEST_HAVE_osf" = n ] ; then
 	if [ "$((RANDOM % 2))" -eq 1 ] ; then
 		# Regardless of $NFT_TEST_HAVE_osf, we can define the set.
@@ -98,11 +108,7 @@ $INPUT_OSF_CHAIN
 	chain c6 {
 		tcp option maxseg size @s6 accept
 	}
-
-	chain c7 {
-		sctp chunk init num-inbound-streams @s7 accept
-	}
-
+$INPUT_SCTP_CHAIN
 	chain c8 {
 		ip version @s8 accept
 	}
@@ -187,11 +193,7 @@ $INPUT_OSF_CHAIN
 	chain c6 {
 		tcp option maxseg size @s6 accept
 	}
-
-	chain c7 {
-		sctp chunk init num-inbound-streams @s7 accept
-	}
-
+$INPUT_SCTP_CHAIN
 	chain c8 {
 		ip version @s8 accept
 	}
@@ -218,3 +220,7 @@ if [ "$NFT_TEST_HAVE_osf" = n ] ; then
 	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
 	exit 77
 fi
+if [ "$NFT_TEST_HAVE_sctp_chunks" = n ] ; then
+	echo "Partial test due to NFT_TEST_HAVE_sctp_chunks=n. Skip"
+	exit 77
+fi
-- 
2.41.0

