From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 10/11] src: annotate follow up dependency just after killing another
Date: Thu, 28 Jan 2016 22:24:59 +0100
Message-ID: <1454016300-29969-11-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbcA1VZW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 521DCC880B
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40556DA807
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 74950DA808
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:19 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The inet and netdev families generate two implicit dependencies to check
for the interface type, so we have to check just after killing an implicit
dependency if there is another that we should annotate to kill it as well.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index cb9c3ab..bbe1876 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1031,6 +1031,30 @@ static void integer_type_postprocess(struct expr *expr)
 	}
 }
 
+static void payload_dependency_save(struct rule_pp_ctx *ctx, unsigned int base,
+				    struct stmt *nstmt, struct expr *tmp)
+{
+	unsigned int proto = mpz_get_be16(tmp->value);
+	const struct proto_desc *desc, *next;
+	bool stacked_header = false;
+
+	desc = ctx->pctx.protocol[base].desc;
+
+	assert(desc);
+	if (desc) {
+		next = proto_find_upper(desc, proto);
+		stacked_header = next && next->base == base;
+	}
+
+	if (stacked_header) {
+		ctx->pctx.protocol[base].desc = next;
+		ctx->pctx.protocol[base].offset += desc->length;
+		payload_dependency_store(ctx, nstmt, base - 1);
+	} else {
+		payload_dependency_store(ctx, nstmt, base);
+	}
+}
+
 static void payload_match_expand(struct rule_pp_ctx *ctx,
 				 struct expr *expr,
 				 struct expr *payload)
@@ -1068,26 +1092,11 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 */
 		if (ctx->pbase == PROTO_BASE_INVALID &&
 		    left->flags & EXPR_F_PROTOCOL) {
-			unsigned int proto = mpz_get_be16(tmp->value);
-			const struct proto_desc *desc, *next;
-			bool stacked_header = false;
-
-			desc = ctx->pctx.protocol[base].desc;
-			assert(desc);
-			if (desc) {
-				next = proto_find_upper(desc, proto);
-				stacked_header = next && next->base == base;
-			}
-
-			if (stacked_header) {
-				ctx->pctx.protocol[base].desc = next;
-				ctx->pctx.protocol[base].offset += desc->length;
-				payload_dependency_store(ctx, nstmt, base - 1);
-			} else {
-				payload_dependency_store(ctx, nstmt, base);
-			}
+			payload_dependency_save(ctx, base, nstmt, tmp);
 		} else {
 			payload_dependency_kill(ctx, nexpr->left);
+			if (left->flags & EXPR_F_PROTOCOL)
+				payload_dependency_save(ctx, base, nstmt, tmp);
 		}
 	}
 	list_del(&ctx->stmt->list);
-- 
2.1.4

