Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC6EC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343567AbjKIQXR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbjKIQXP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA74D35AD
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:12 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 08/12] tests: shell: skip if kernel does not support bitshift
Date:   Thu,  9 Nov 2023 17:23:00 +0100
Message-Id: <20231109162304.119506-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few tests are missing bitshift checks that has been added to
885845468408 ("tests/shell: skip bitshift tests if kernel lacks
support").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/maps/vmap_mark_bitwise_0  |  2 +
 tests/shell/testcases/sets/typeof_sets_0      | 86 +++++++++----------
 2 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/tests/shell/testcases/maps/vmap_mark_bitwise_0 b/tests/shell/testcases/maps/vmap_mark_bitwise_0
index 0d933553e6b8..2f305b27bc33 100755
--- a/tests/shell/testcases/maps/vmap_mark_bitwise_0
+++ b/tests/shell/testcases/maps/vmap_mark_bitwise_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
+
 set -e
 
 RULESET="table ip x {
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 35c572c1e537..92555a1f923e 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -17,22 +17,53 @@ INPUT_OSF_SET="
 		elements = { \"Linux\" }
 	}
 "
+
+INPUT_FRAG_SET="
+	set s4 {
+		typeof frag frag-off
+		elements = { 1, 1024 }
+	}
+"
+
+INPUT_VERSION_SET="
+	set s8 {
+		typeof ip version
+		elements = { 4, 6 }
+	}
+"
+
 INPUT_OSF_CHAIN="
 	chain c1 {
 		osf name @s1 accept
 	}
 "
 
+INPUT_FRAG_CHAIN="
+	chain c4 {
+		frag frag-off @s4 accept
+	}
+"
+
 INPUT_SCTP_CHAIN="
 	chain c7 {
 		sctp chunk init num-inbound-streams @s7 accept
 	}
 "
+INPUT_VERSION_CHAIN="
+	chain c8 {
+		ip version @s8 accept
+	}
+"
 
 if [ "$NFT_TEST_HAVE_sctp_chunks" = n ] ; then
 	INPUT_SCTP_CHAIN=
 fi
 
+if [ "$NFT_TEST_HAVE_bitshift" = n ] ; then
+	INPUT_FRAG_CHAIN=
+	INPUT_VERSION_CHAIN=
+fi
+
 if [ "$NFT_TEST_HAVE_osf" = n ] ; then
 	if [ "$((RANDOM % 2))" -eq 1 ] ; then
 		# Regardless of $NFT_TEST_HAVE_osf, we can define the set.
@@ -51,12 +82,7 @@ INPUT="table inet t {$INPUT_OSF_SET
 	set s3 {
 		typeof meta ibrpvid
 		elements = { 2, 3, 103 }
-	}
-
-	set s4 {
-		typeof frag frag-off
-		elements = { 1, 1024 }
-	}
+	}$INPUT_FRAG_SET
 
 	set s5 {
 		typeof ip option ra value
@@ -71,12 +97,7 @@ INPUT="table inet t {$INPUT_OSF_SET
 	set s7 {
 		typeof sctp chunk init num-inbound-streams
 		elements = { 1, 4 }
-	}
-
-	set s8 {
-		typeof ip version
-		elements = { 4, 6 }
-	}
+	}$INPUT_VERSION_SET
 
 	set s9 {
 		typeof ip hdrlength
@@ -96,11 +117,7 @@ $INPUT_OSF_CHAIN
 	chain c2 {
 		ether type vlan vlan id @s2 accept
 	}
-
-	chain c4 {
-		frag frag-off @s4 accept
-	}
-
+$INPUT_FRAG_CHAIN
 	chain c5 {
 		ip option ra value @s5 accept
 	}
@@ -109,10 +126,7 @@ $INPUT_OSF_CHAIN
 		tcp option maxseg size @s6 accept
 	}
 $INPUT_SCTP_CHAIN
-	chain c8 {
-		ip version @s8 accept
-	}
-
+$INPUT_VERSION_CHAIN
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
@@ -136,12 +150,7 @@ EXPECTED="table inet t {$INPUT_OSF_SET
 		typeof meta ibrpvid
 		elements = { 2, 3, 103 }
 	}
-
-	set s4 {
-		typeof frag frag-off
-		elements = { 1, 1024 }
-	}
-
+$INPUT_FRAG_SET
 	set s5 {
 		typeof ip option ra value
 		elements = { 1, 1024 }
@@ -156,12 +165,7 @@ EXPECTED="table inet t {$INPUT_OSF_SET
 		typeof sctp chunk init num-inbound-streams
 		elements = { 1, 4 }
 	}
-
-	set s8 {
-		typeof ip version
-		elements = { 4, 6 }
-	}
-
+$INPUT_VERSION_SET
 	set s9 {
 		typeof ip hdrlength
 		elements = { 0, 1, 2, 3, 4,
@@ -181,11 +185,7 @@ $INPUT_OSF_CHAIN
 	chain c2 {
 		vlan id @s2 accept
 	}
-
-	chain c4 {
-		frag frag-off @s4 accept
-	}
-
+$INPUT_FRAG_CHAIN
 	chain c5 {
 		ip option ra value @s5 accept
 	}
@@ -193,11 +193,7 @@ $INPUT_OSF_CHAIN
 	chain c6 {
 		tcp option maxseg size @s6 accept
 	}
-$INPUT_SCTP_CHAIN
-	chain c8 {
-		ip version @s8 accept
-	}
-
+$INPUT_SCTP_CHAIN$INPUT_VERSION_CHAIN
 	chain c9 {
 		ip hdrlength @s9 accept
 	}
@@ -216,6 +212,10 @@ $NFT -f - <<< "$INPUT" || die $'nft command failed to process input:\n'">$INPUT<
 
 $DIFF -u <($NFT list ruleset) - <<<"$EXPECTED" || die $'diff failed between ruleset and expected data.\nExpected:\n'">$EXPECTED<"
 
+if [ "$NFT_TEST_HAVE_bitshift" = n ] ; then
+	echo "Partial test due to NFT_TEST_HAVE_bitshift=n. Skip"
+	exit 77
+fi
 if [ "$NFT_TEST_HAVE_osf" = n ] ; then
 	echo "Partial test due to NFT_TEST_HAVE_osf=n. Skip"
 	exit 77
-- 
2.30.2

