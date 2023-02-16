Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC77AC636D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 20:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBPUcE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 15:32:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81F1B196A9
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 12:32:02 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] optimize: infer family for nat mapping
Date:   Thu, 16 Feb 2023 21:31:57 +0100
Message-Id: <20230216203157.448390-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216203157.448390-1-pablo@netfilter.org>
References: <20230216203157.448390-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Infer family from key in nat mapping, otherwise nat mapping via merge
breaks since family is not specified.

Merging:
fw-test-bug2.nft:4:9-78:         iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
fw-test-bug2.nft:5:9-77:         iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
fw-test-bug2.nft:6:9-75:         iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
into:
        dnat ip to iifname . ip daddr . tcp dport map { enp2s0 . 72.2.3.66 . 53122 : 10.1.1.10 . 22, enp2s0 . 72.2.3.66 . 443 : 10.1.1.52 . 443, enp2s0 . 72.2.3.70 . 80 : 10.1.1.52 . 80 }

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1657
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                | 23 +++++++++++++++++--
 .../optimizations/dumps/merge_nat.nft         | 11 +++++++++
 tests/shell/testcases/optimizations/merge_nat | 16 +++++++++++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  | 11 +++++++++
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index d60aa8f22c07..3548719031e6 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -21,6 +21,7 @@
 #include <statement.h>
 #include <utils.h>
 #include <erec.h>
+#include <linux/netfilter.h>
 
 #define MAX_STMTS	32
 
@@ -872,9 +873,9 @@ static void merge_nat(const struct optimize_ctx *ctx,
 		      const struct merge *merge)
 {
 	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left;
+	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i;
-	int k;
 
 	k = stmt_nat_find(ctx);
 	assert(k >= 0);
@@ -896,9 +897,18 @@ static void merge_nat(const struct optimize_ctx *ctx,
 
 	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
 	left = expr_get(stmt->expr->left);
+	if (left->etype == EXPR_PAYLOAD) {
+		if (left->payload.desc == &proto_ip)
+			family = NFPROTO_IPV4;
+		else if (left->payload.desc == &proto_ip6)
+			family = NFPROTO_IPV6;
+	}
 	expr = map_expr_alloc(&internal_location, left, set);
 
 	nat_stmt = ctx->stmt_matrix[from][k];
+	if (nat_stmt->nat.family == NFPROTO_UNSPEC)
+		nat_stmt->nat.family = family;
+
 	expr_free(nat_stmt->nat.addr);
 	nat_stmt->nat.addr = expr;
 
@@ -912,9 +922,9 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 			     const struct merge *merge)
 {
 	struct expr *expr, *set, *elem, *nat_expr, *mapping, *left, *concat;
+	int k, family = NFPROTO_UNSPEC;
 	struct stmt *stmt, *nat_stmt;
 	uint32_t i, j;
-	int k;
 
 	k = stmt_nat_find(ctx);
 	assert(k >= 0);
@@ -943,11 +953,20 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 	for (j = 0; j < merge->num_stmts; j++) {
 		stmt = ctx->stmt_matrix[from][merge->stmt[j]];
 		left = stmt->expr->left;
+		if (left->etype == EXPR_PAYLOAD) {
+			if (left->payload.desc == &proto_ip)
+				family = NFPROTO_IPV4;
+			else if (left->payload.desc == &proto_ip6)
+				family = NFPROTO_IPV6;
+		}
 		compound_expr_add(concat, expr_get(left));
 	}
 	expr = map_expr_alloc(&internal_location, concat, set);
 
 	nat_stmt = ctx->stmt_matrix[from][k];
+	if (nat_stmt->nat.family == NFPROTO_UNSPEC)
+		nat_stmt->nat.family = family;
+
 	expr_free(nat_stmt->nat.addr);
 	nat_stmt->nat.addr = expr;
 
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 96e38ccd798a..dd17905dbfeb 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -23,3 +23,14 @@ table ip test4 {
 		dnat ip to ip daddr . tcp dport map { 1.1.1.1 . 80 : 4.4.4.4 . 8000, 2.2.2.2 . 81 : 3.3.3.3 . 9000 }
 	}
 }
+table inet nat {
+	chain prerouting {
+		oif "lo" accept
+		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443 }
+	}
+
+	chain postrouting {
+		oif "lo" accept
+		snat ip to ip daddr map { 72.2.3.66 : 10.2.2.2, 72.2.3.67 : 10.2.3.3 }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index 1484b7d39d48..edf7f4c438b9 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -42,3 +42,19 @@ RULESET="table ip test4 {
 }"
 
 $NFT -o -f - <<< $RULESET
+
+RULESET="table inet nat {
+	chain prerouting {
+		oif lo accept
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
+		iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
+	}
+	chain postrouting {
+		oif lo accept
+		ip daddr 72.2.3.66 snat to 10.2.2.2
+		ip daddr 72.2.3.67 snat to 10.2.3.3
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index e796805471a3..97c04a1637a2 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -11,3 +11,14 @@ table ip x {
 		snat ip to ip saddr map @y
 	}
 }
+table inet x {
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat ip to ip daddr . tcp dport map { 10.141.10.1 . 22 : 192.168.2.2, 10.141.11.2 . 2222 : 192.168.4.2 }
+	}
+
+	chain y {
+		type nat hook postrouting priority srcnat; policy accept;
+		snat ip to ip saddr map { 10.141.10.0/24 : 192.168.2.2-192.168.2.4, 10.141.11.0/24 : 192.168.4.2/31 }
+	}
+}
-- 
2.30.2

