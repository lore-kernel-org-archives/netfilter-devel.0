Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E22C63797
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Jan 2023 19:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjAOT1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Jan 2023 14:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjAOT1j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Jan 2023 14:27:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ECF512879
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jan 2023 11:27:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: extend runtime set element automerge to cover partial deletions
Date:   Sun, 15 Jan 2023 20:27:31 +0100
Message-Id: <20230115192731.3301751-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Perform partial deletions of an existing interval and check that the
set remains in consistent state.

Before the follow kernel fixes:

 netfilter: nft_set_rbtree: skip elements in transaction from garbage collection
 netfilter: nft_set_rbtree: Switch to node list walk for overlap detection

without these patches, this test fails with bogus overlap reports.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/automerge_0 | 51 +++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/automerge_0 b/tests/shell/testcases/sets/automerge_0
index c9fb609571fa..7530b3db7317 100755
--- a/tests/shell/testcases/sets/automerge_0
+++ b/tests/shell/testcases/sets/automerge_0
@@ -38,6 +38,11 @@ i=0
 cat $tmpfile3 | while read line && [ $i -lt 10 ]
 do
 	$NFT add element inet x y { $line }
+	if [ $? -ne 0 ]
+	then
+		echo "failed to add $line"
+		exit 1
+	fi
 	i=$((i+1))
 done
 
@@ -51,12 +56,56 @@ do
 		echo "failed to add $from-$to"
 		exit 1
 	fi
-	$NFT get element inet x y { $from-$to }
+
+	$NFT get element inet x y { $from-$to } 1>/dev/null
 	if [ $? -ne 0 ]
 	then
 		echo "failed to get $from-$to"
 		exit 1
 	fi
+
+	# partial removals in the previous random range
+	from2=$(($from+10))
+	to2=$(($to-10))
+	$NFT delete element inet x y { $from, $to, $from2-$to2 }
+	if [ $? -ne 0 ]
+	then
+		echo "failed to delete $from, $to, $from2-$to2"
+		exit 1
+	fi
+
+	# check deletions are correct
+	from=$(($from+1))
+	$NFT get element inet x y { $from } 1>/dev/null
+	if [ $? -ne 0 ]
+	then
+		echo "failed to get $from"
+		exit 1
+	fi
+
+	to=$(($to-1))
+	$NFT get element inet x y { $to } 1>/dev/null
+	if [ $? -ne 0 ]
+	then
+		echo "failed to get $to"
+		exit 1
+	fi
+
+	from2=$(($from2-1))
+	$NFT get element inet x y { $from2 } 1>/dev/null
+	if [ $? -ne 0 ]
+	then
+		echo "failed to get $from2"
+		exit 1
+	fi
+	to2=$(($to2+1))
+
+	$NFT get element inet x y { $to2 } 1>/dev/null
+	if [ $? -ne 0 ]
+	then
+		echo "failed to get $to2"
+		exit 1
+	fi
 done
 
 rm -f $tmpfile
-- 
2.30.2

