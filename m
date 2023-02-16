Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C9BC61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 20:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBPUcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPUcC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 15:32:02 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3F60196B9
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 12:32:01 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] evaluate: infer family from mapping
Date:   Thu, 16 Feb 2023 21:31:56 +0100
Message-Id: <20230216203157.448390-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216203157.448390-1-pablo@netfilter.org>
References: <20230216203157.448390-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the key in the nat mapping is either ip or ip6, then set the nat
family accordingly, no need for explicit family in the nat statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                       | 47 +++++++++++++++++++++++++---
 tests/shell/testcases/sets/0047nat_0 | 14 +++++++++
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f92b160ce3a4..da8131d706d6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3502,16 +3502,50 @@ static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
 	return 0;
 }
 
+static int expr_family_infer(struct proto_ctx *pctx, const struct expr *expr)
+{
+	int family = pctx->family;
+	struct expr *i;
+
+	if (expr->etype == EXPR_MAP) {
+		switch (expr->map->etype) {
+		case EXPR_CONCAT:
+			list_for_each_entry(i, &expr->map->expressions, list) {
+				if (i->etype == EXPR_PAYLOAD) {
+					if (i->payload.desc == &proto_ip)
+						family = NFPROTO_IPV4;
+					else if (i->payload.desc == &proto_ip6)
+						family = NFPROTO_IPV6;
+				}
+			}
+			break;
+		case EXPR_PAYLOAD:
+			if (expr->map->payload.desc == &proto_ip)
+				family = NFPROTO_IPV4;
+			else if (expr->map->payload.desc == &proto_ip6)
+				family = NFPROTO_IPV6;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return family;
+}
+
 static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
-			      uint8_t family,
-			      struct expr **addr)
+			      uint8_t *family, struct expr **addr)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct datatype *dtype;
 	int err;
 
 	if (pctx->family == NFPROTO_INET) {
-		dtype = get_addr_dtype(family);
+		if (*family == NFPROTO_INET ||
+		    *family == NFPROTO_UNSPEC)
+			*family = expr_family_infer(pctx, *addr);
+
+		dtype = get_addr_dtype(*family);
 		if (dtype->size == 0)
 			return stmt_error(ctx, stmt,
 					  "ip or ip6 must be specified with address for inet tables.");
@@ -3532,6 +3566,9 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	const struct datatype *dtype;
 	int addr_type, err;
 
+	if (stmt->nat.family == NFPROTO_INET)
+		stmt->nat.family = expr_family_infer(pctx, stmt->nat.addr);
+
 	switch (stmt->nat.family) {
 	case NFPROTO_IPV4:
 		addr_type = TYPE_IPADDR;
@@ -3658,7 +3695,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 			return 0;
 		}
 
-		err = stmt_evaluate_addr(ctx, stmt, stmt->nat.family,
+		err = stmt_evaluate_addr(ctx, stmt, &stmt->nat.family,
 					 &stmt->nat.addr);
 		if (err < 0)
 			return err;
@@ -3709,7 +3746,7 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->tproxy.addr->etype == EXPR_RANGE)
 			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
 
-		err = stmt_evaluate_addr(ctx, stmt, stmt->tproxy.family,
+		err = stmt_evaluate_addr(ctx, stmt, &stmt->tproxy.family,
 					 &stmt->tproxy.addr);
 
 		if (err < 0)
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index cb1d4d68d2d2..d19f5b69fd33 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -18,3 +18,17 @@ EXPECTED="table ip x {
 set -e
 $NFT -f - <<< $EXPECTED
 $NFT add element x y { 10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
+
+EXPECTED="table inet x {
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    dnat to ip daddr . tcp dport map { 10.141.10.1 . 22 : 192.168.2.2, 10.141.11.2 . 2222 : 192.168.4.2 }
+            }
+
+            chain y {
+                    type nat hook postrouting priority srcnat; policy accept;
+                    snat to ip saddr map { 10.141.10.0/24 : 192.168.2.2-192.168.2.4, 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
+            }
+}"
+
+$NFT -f - <<< $EXPECTED
-- 
2.30.2

