From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 1/6] payload: fix stacked headers protocol context tracking
Date: Sun, 24 Apr 2016 22:30:35 +0100
Message-ID: <1461533440-10605-2-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52075 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcDXVjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:20 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code contains multiple scattered around fragments to fiddle with the
protocol contexts to work around the fact that stacked headers update the
context for the incorrect layer.

Fix this by updating the correct layer in payload_expr_pctx_update() and
also take care of offset adjustments there and only there. Remove all
manual protocol context fiddling and change protocol context debugging to
also print the offset for stacked headers.

All previously successful testcases pass.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c            | 44 +++++++++++---------------------------------
 src/netlink_delinearize.c |  7 ++-----
 src/payload.c             |  8 ++++++--
 src/proto.c               | 10 +++++++---
 4 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 346e34f..a65e145 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -358,12 +358,6 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 
-	ctx->pctx.protocol[base].desc = expr->payload.desc;
-	assert(ctx->pctx.protocol[base].offset == 0);
-
-	assert(desc->length);
-	ctx->pctx.protocol[base].offset += desc->length;
-
 	*res = stmt;
 	return 0;
 }
@@ -430,17 +424,6 @@ static int meta_iiftype_gen_dependency(struct eval_ctx *ctx,
 	return 0;
 }
 
-static void proto_ctx_debunk(struct eval_ctx *ctx,
-			     const struct proto_desc *desc,
-			     const struct proto_desc *next,
-			     struct expr *payload, enum proto_bases base)
-{
-	ctx->pctx.protocol[base + 1].desc = NULL;
-	ctx->pctx.protocol[base].desc = next;
-	ctx->pctx.protocol[base].offset += desc->length;
-	payload->payload.offset += desc->length;
-}
-
 static bool proto_is_dummy(const struct proto_desc *desc)
 {
 	return desc == &proto_inet || desc == &proto_netdev;
@@ -451,7 +434,6 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 				     struct expr *payload)
 {
 	enum proto_bases base = payload->payload.base;
-	const struct proto_desc *next;
 	struct stmt *nstmt = NULL;
 	int link, err;
 
@@ -465,27 +447,17 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 	}
 
 	assert(base < PROTO_BASE_MAX);
-	next = ctx->pctx.protocol[base + 1].desc;
-
-	/* ether type vlan sets vlan as network protocol, debunk ethernet if it
-	 * is already there.
-	 */
-	if (payload->payload.desc == next) {
-		proto_ctx_debunk(ctx, desc, next, payload, base);
-		return 0;
-	}
-
 	/* This payload and the existing context don't match, conflict. */
-	if (next != NULL)
+	if (ctx->pctx.protocol[base + 1].desc != NULL)
 		return 1;
 
 	link = proto_find_num(desc, payload->payload.desc);
-	if (link < 0 || conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
+	if (link < 0 ||
+	    conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
 		return 1;
 
 	payload->payload.offset += ctx->pctx.protocol[base].offset;
 	list_add_tail(&nstmt->list, &ctx->stmt->list);
-	ctx->pctx.protocol[base + 1].desc = NULL;
 
 	return 0;
 }
@@ -1622,7 +1594,7 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		default:
 			return stmt_binary_error(ctx, stmt,
 				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
-				    "cannot reject this ether type");
+				    "cannot reject this network family");
 		}
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
@@ -1644,7 +1616,7 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		default:
 			return stmt_binary_error(ctx, stmt,
 				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
-				    "cannot reject this ether type");
+				    "cannot reject this network family");
 		}
 		break;
 	}
@@ -1657,6 +1629,12 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 {
 	const struct proto_desc *desc;
 
+	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	if (desc != &proto_eth)
+		return stmt_binary_error(ctx,
+					 &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
+					 stmt, "unsupported link layer protocol");
+
 	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (desc != NULL &&
 	    stmt_evaluate_reject_bridge_family(ctx, stmt, desc) < 0)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ca1c6e6..ee4cf12 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1077,13 +1077,10 @@ static void payload_dependency_save(struct rule_pp_ctx *ctx, unsigned int base,
 		stacked_header = next && next->base == base;
 	}
 
-	if (stacked_header) {
-		ctx->pctx.protocol[base].desc = next;
-		ctx->pctx.protocol[base].offset += desc->length;
+	if (stacked_header)
 		payload_dependency_store(ctx, nstmt, base - 1);
-	} else {
+	else
 		payload_dependency_store(ctx, nstmt, base);
-	}
 }
 
 static void payload_match_expand(struct rule_pp_ctx *ctx,
diff --git a/src/payload.c b/src/payload.c
index f6c0a97..45a2ba2 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -85,8 +85,12 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, proto);
 
-	assert(left->payload.base + 1 <= PROTO_BASE_MAX);
-	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
+	assert(desc->base <= PROTO_BASE_MAX);
+	if (desc->base == base->base) {
+		assert(base->length > 0);
+		ctx->protocol[base->base].offset += base->length;
+	}
+	proto_ctx_update(ctx, desc->base, &expr->location, desc);
 }
 
 static const struct expr_ops payload_expr_ops = {
diff --git a/src/proto.c b/src/proto.c
index b54a4c1..329d991 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -148,11 +148,15 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
 
 	pr_debug("update %s protocol context:\n", proto_base_names[base]);
 	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
-		pr_debug(" %-20s: %s%s\n",
+		pr_debug(" %-20s: %s",
 			 proto_base_names[i],
 			 ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
-						 "none",
-			 i == base ? " <-" : "");
+						 "none");
+		if (ctx->protocol[i].offset)
+			pr_debug(" (offset: %u)", ctx->protocol[i].offset);
+		if (i == base)
+			pr_debug(" <-");
+		pr_debug("\n");
 	}
 	pr_debug("\n");
 #endif
-- 
2.5.5

