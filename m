From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 06/10] src: ct: print nfproto name for some header fields
Date: Wed, 27 Sep 2017 20:16:50 +0200
Message-ID: <20170927181654.3129-7-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37766 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:56 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this prints "original saddr|daddr $NFPROTO" to make output
symmetric with the syntax that we now prefer on input side.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index e8298975e692..de5b0b904cdf 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -16,6 +16,8 @@
 #include <inttypes.h>
 #include <string.h>
 
+#include <netinet/ip.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
@@ -269,9 +271,10 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
-static void ct_print(enum nft_ct_keys key, int8_t dir)
+static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto)
 {
 	const struct symbolic_constant *s;
+	const struct proto_desc *desc;
 
 	printf("ct ");
 	if (dir < 0)
@@ -283,13 +286,25 @@ static void ct_print(enum nft_ct_keys key, int8_t dir)
 			break;
 		}
 	}
+
+	switch (key) {
+	case NFT_CT_SRC: /* fallthrough */
+	case NFT_CT_DST:
+		desc = proto_find_upper(&proto_inet, nfproto);
+		if (desc)
+			printf("%s ", desc->name);
+		break;
+	default:
+		break;
+	}
+
  done:
 	printf("%s", ct_templates[key].token);
 }
 
 static void ct_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	ct_print(expr->ct.key, expr->ct.direction);
+	ct_print(expr->ct.key, expr->ct.direction, expr->ct.nfproto);
 }
 
 static bool ct_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -379,10 +394,13 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 	switch (expr->ct.key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-		if (desc == &proto_ip)
+		if (desc == &proto_ip) {
 			expr->dtype = &ipaddr_type;
-		else if (desc == &proto_ip6)
+			expr->ct.nfproto = NFPROTO_IPV4;
+		} else if (desc == &proto_ip6) {
 			expr->dtype = &ip6addr_type;
+			expr->ct.nfproto = NFPROTO_IPV6;
+		}
 
 		expr->len = expr->dtype->size;
 		break;
@@ -399,7 +417,7 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 
 static void ct_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	ct_print(stmt->ct.key, stmt->ct.direction);
+	ct_print(stmt->ct.key, stmt->ct.direction, 0);
 	printf(" set ");
 	expr_print(stmt->ct.expr, octx);
 }
-- 
2.13.5

