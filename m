Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3883CC001DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 19:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbjHJTsQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbjHJTsP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 15:48:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAB412B
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 12:48:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qUBdh-0002JZ-0d; Thu, 10 Aug 2023 21:48:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: add test with concatenation, vmap and timeout
Date:   Thu, 10 Aug 2023 21:48:01 +0200
Message-ID: <20230810194804.14969-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add 4k elements to map, with timeouts in range 1..3s, also add a
catchall element with timeout.

Check that all elements are no longer included in set list after 4s.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/vmap_timeout.nft     | 29 ++++++++++++++++
 tests/shell/testcases/maps/vmap_timeout       | 33 +++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_timeout.nft
 create mode 100755 tests/shell/testcases/maps/vmap_timeout

diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.nft b/tests/shell/testcases/maps/dumps/vmap_timeout.nft
new file mode 100644
index 000000000000..7bbad87cbb15
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.nft
@@ -0,0 +1,29 @@
+table inet filter {
+	map portmap {
+		type inet_service : verdict
+		flags timeout
+		elements = { 22 : jump ssh_input }
+	}
+
+	map portaddrmap {
+		typeof ip daddr . th dport : verdict
+		flags timeout
+		elements = { 1.2.3.4 . 22 : jump ssh_input }
+	}
+
+	chain ssh_input {
+	}
+
+	chain other_input {
+	}
+
+	chain wan_input {
+		ip daddr . tcp dport vmap @portaddrmap
+		tcp dport vmap @portmap
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority raw; policy accept;
+		iif vmap { "lo" : jump wan_input }
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
new file mode 100755
index 000000000000..7d3dc454f6c8
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+set -e
+
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+$NFT -f $dumpfile
+
+port=23
+for i in $(seq 1 400) ; do
+	timeout=$((RANDOM%3))
+	timeout=$((timeout+1))
+	j=1
+
+	batched="{ $port timeout 3s : jump other_input "
+	batched_addr="{ 10.0.$((i%256)).$j . $port timeout 3s : jump other_input "
+	port=$((port + 1))
+	for j in $(seq 2 100); do
+		batched="$batched, $port timeout ${timeout}s : jump other_input "
+		batched_addr="$batched_addr, 10.0.$((i%256)).$j . $port timeout ${timeout}s : jump other_input "
+		port=$((port + 1))
+	done
+
+	batched="$batched }"
+	batched_addr="$batched_addr }"
+	$NFT add element inet filter portmap "$batched"
+	$NFT add element inet filter portaddrmap "$batched_addr"
+done
+
+$NFT add element inet filter portaddrmap { "* timeout 2s : drop" }
+$NFT add element inet filter portmap { "* timeout 3s : drop" }
+
+# wait for elements to time out
+sleep 4
-- 
2.41.0

