Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BE2C04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 13:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbjHBNyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbjHBNys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 09:54:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E162119
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 06:54:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qRCJE-0004cr-MH; Wed, 02 Aug 2023 15:54:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: add dynmap datapath add/delete test case
Date:   Wed,  2 Aug 2023 15:54:28 +0200
Message-ID: <20230802135432.2234-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../maps/dumps/typeof_maps_add_delete.nft     | 22 ++++++++++++
 .../testcases/maps/typeof_maps_add_delete     | 35 +++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_add_delete

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
new file mode 100644
index 000000000000..9134673cf48a
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
@@ -0,0 +1,22 @@
+table ip dynset {
+	map dynmark {
+		typeof ip daddr : meta mark
+		size 64
+		counter
+		timeout 5m
+	}
+
+	chain test_ping {
+		ip saddr @dynmark counter packets 0 bytes 0 comment "should not increment"
+		ip saddr != @dynmark add @dynmark { ip saddr : 0x00000001 } counter packets 1 bytes 84
+		ip saddr @dynmark counter packets 1 bytes 84 comment "should increment"
+		ip saddr @dynmark delete @dynmark { ip saddr : 0x00000001 }
+		ip saddr @dynmark counter packets 0 bytes 0 comment "delete should be instant but might fail under memory pressure"
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		add @dynmark { 10.2.3.4 timeout 1s : 0x00000002 } comment "also check timeout-gc"
+		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_add_delete b/tests/shell/testcases/maps/typeof_maps_add_delete
new file mode 100755
index 000000000000..341de538e90e
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_add_delete
@@ -0,0 +1,35 @@
+#!/bin/bash
+
+EXPECTED='table ip dynset {
+	map dynmark {
+		typeof ip daddr : meta mark
+		counter
+		size 64
+		timeout 5m
+	}
+
+	chain test_ping {
+		ip saddr @dynmark counter comment "should not increment"
+		ip saddr != @dynmark add @dynmark { ip saddr : 0x1 } counter
+		ip saddr @dynmark counter comment "should increment"
+		ip saddr @dynmark delete @dynmark { ip saddr : 0x1 }
+		ip saddr @dynmark counter comment "delete should be instant but might fail under memory pressure"
+	}
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+
+		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment "also check timeout-gc"
+		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
+	}
+}'
+
+set -e
+$NFT -f - <<< $EXPECTED
+$NFT list ruleset
+
+ip link set lo up
+ping -c 1 127.0.0.42
+
+# wait so that 10.2.3.4 times out.
+sleep 2
-- 
2.41.0

