Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C02FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 09:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiC2JCa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 05:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiC2JC3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 05:02:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13956209A64
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 02:00:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C58963032
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 10:57:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 4/4] optimize: Restore optimization for raw payload expressions
Date:   Tue, 29 Mar 2022 11:00:41 +0200
Message-Id: <20220329090041.1156012-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220329090041.1156012-1-pablo@netfilter.org>
References: <20220329090041.1156012-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch reverts d0f14b5337e7 ("optimize: do not merge raw payload
expressions") after adding support for concatenation with variable
length TYPE_INTEGER.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 src/optimize.c                                |  3 --
 .../optimizations/dumps/merge_vmap_raw.nft    | 31 ++++++++++++++++++
 .../testcases/optimizations/merge_vmap_raw    | 32 +++++++++++++++++++
 3 files changed, 63 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_vmap_raw

diff --git a/src/optimize.c b/src/optimize.c
index 7a268c452226..4ad25fab6be4 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -40,9 +40,6 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 
 	switch (expr_a->etype) {
 	case EXPR_PAYLOAD:
-		/* disable until concatenation with integer works. */
-		if (expr_a->payload.is_raw || expr_b->payload.is_raw)
-			return false;
 		if (expr_a->payload.base != expr_b->payload.base)
 			return false;
 		if (expr_a->payload.offset != expr_b->payload.offset)
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
new file mode 100644
index 000000000000..18847116eb50
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmap_raw.nft
@@ -0,0 +1,31 @@
+table inet x {
+	chain nat_dns_dnstc {
+		meta l4proto udp redirect to :5300
+		drop
+	}
+
+	chain nat_dns_this_5301 {
+		meta l4proto udp redirect to :5301
+		drop
+	}
+
+	chain nat_dns_saturn_5301 {
+		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5301
+		drop
+	}
+
+	chain nat_dns_saturn_5302 {
+		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5302
+		drop
+	}
+
+	chain nat_dns_saturn_5303 {
+		meta nfproto ipv4 meta l4proto udp dnat ip to 240.0.1.2:5303
+		drop
+	}
+
+	chain nat_dns_acme {
+		udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : goto nat_dns_dnstc, 62-78 . 0xe31393032383939353831343037320e : goto nat_dns_this_5301, 62-78 . 0xe31363436323733373931323934300e : goto nat_dns_saturn_5301, 62-78 . 0xe32393535373539353636383732310e : goto nat_dns_saturn_5302, 62-78 . 0xe38353439353637323038363633390e : goto nat_dns_saturn_5303 }
+		drop
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_vmap_raw b/tests/shell/testcases/optimizations/merge_vmap_raw
new file mode 100755
index 000000000000..f3dc0721b94f
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_vmap_raw
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet x {
+	chain nat_dns_dnstc     { meta l4proto udp redirect to :5300 ; drop ; }
+        chain nat_dns_this_5301 { meta l4proto udp redirect to :5301 ; drop ; }
+        chain nat_dns_saturn_5301  { meta nfproto ipv4 meta l4proto udp dnat to 240.0.1.2:5301 ; drop ; }
+        chain nat_dns_saturn_5302  { meta nfproto ipv4 meta l4proto udp dnat to 240.0.1.2:5302 ; drop ; }
+        chain nat_dns_saturn_5303  { meta nfproto ipv4 meta l4proto udp dnat to 240.0.1.2:5303 ; drop ; }
+
+        chain nat_dns_acme {
+                udp length 47-63 @th,160,128 0x0e373135363130333131303735353203 \
+                        goto nat_dns_dnstc
+
+                udp length 62-78 @th,160,128 0x0e31393032383939353831343037320e \
+                        goto nat_dns_this_5301
+
+                udp length 62-78 @th,160,128 0x0e31363436323733373931323934300e \
+                        goto nat_dns_saturn_5301
+
+                udp length 62-78 @th,160,128 0x0e32393535373539353636383732310e \
+                        goto nat_dns_saturn_5302
+
+                udp length 62-78 @th,160,128 0x0e38353439353637323038363633390e \
+                        goto nat_dns_saturn_5303
+
+                drop
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

