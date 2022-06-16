Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA89C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 09:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiFPJfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 05:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiFPJfq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 05:35:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6435143EEF
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 02:35:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] tests: shell: large set overlap and automerge
Date:   Thu, 16 Jun 2022 11:35:41 +0200
Message-Id: <20220616093541.277164-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a test to validate set overlap and automerge for large set. This
test runs nft -f twice to cover for set reload without flush.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/sets/overlap_automerge_large_0  | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100755 tests/shell/testcases/sets/overlap_automerge_large_0

diff --git a/tests/shell/testcases/sets/overlap_automerge_large_0 b/tests/shell/testcases/sets/overlap_automerge_large_0
new file mode 100755
index 000000000000..578eeda81831
--- /dev/null
+++ b/tests/shell/testcases/sets/overlap_automerge_large_0
@@ -0,0 +1,52 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet x {
+        set y {
+                type ipv4_addr
+                flags interval
+        }
+}"
+
+tmpfile=$(mktemp)
+
+for ((i=1;i<255;i+=2))
+do
+	for ((j=1;j<224;j+=2))
+	do
+		echo "add element inet x y { 10.100.$i.$j }" >> $tmpfile
+	done
+done
+
+$NFT -f - <<< $RULESET
+time $NFT -f $tmpfile
+time $NFT -f $tmpfile
+$NFT flush ruleset
+
+tmpfile2=$(mktemp)
+
+RULESET="table inet x {
+        set y {
+                type ipv4_addr
+                flags interval
+		auto-merge
+        }
+}"
+
+for ((i=1;i<255;i+=2))
+do
+	for ((j=1;j<224;j+=2))
+	do
+		echo "add element inet x y { 10.100.$i.$j }" >> $tmpfile2
+		j=$(($j+1))
+		echo "add element inet x y { 10.100.$i.$j }" >> $tmpfile2
+	done
+done
+
+$NFT -f - <<< $RULESET
+time $NFT -f $tmpfile2
+time $NFT -f $tmpfile2
+
+rm -f $tmpfile
+rm -f $tmpfile2
-- 
2.30.2

