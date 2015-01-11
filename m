From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/6] netlink: style fixes
Date: Sun, 11 Jan 2015 08:09:39 +0000
Message-ID: <1420963782-21189-4-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54797 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbAKIJt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:49 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove style discrepancies between different netlink I/O functions:

- we don't use brackets for single line statements
- most functions don't have a newline between error reporting and exit

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index cb22c30..af56d22 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -128,6 +128,7 @@ struct nft_table *alloc_nft_table(const struct handle *h)
 	nft_table_attr_set_u32(nlt, NFT_TABLE_ATTR_FAMILY, h->family);
 	if (h->table != NULL)
 		nft_table_attr_set(nlt, NFT_TABLE_ATTR_NAME, h->table);
+
 	return nlt;
 }
 
@@ -145,6 +146,7 @@ struct nft_chain *alloc_nft_chain(const struct handle *h)
 		nft_chain_attr_set_u64(nlc, NFT_CHAIN_ATTR_HANDLE, h->handle);
 	if (h->chain != NULL)
 		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, h->chain);
+
 	return nlc;
 }
 
@@ -164,10 +166,10 @@ struct nft_rule *alloc_nft_rule(const struct handle *h)
 		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_HANDLE, h->handle);
 	if (h->position)
 		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_POSITION, h->position);
-	if (h->comment) {
+	if (h->comment)
 		nft_rule_attr_set_data(nlr, NFT_RULE_ATTR_USERDATA,
 				       h->comment, strlen(h->comment) + 1);
-	}
+
 	return nlr;
 }
 
@@ -178,6 +180,7 @@ struct nft_rule_expr *alloc_nft_expr(const char *name)
 	nle = nft_rule_expr_alloc(name);
 	if (nle == NULL)
 		memory_allocation_error();
+
 	return nle;
 }
 
@@ -223,10 +226,9 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 		case EXPR_VERDICT:
 			nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_VERDICT,
 						  expr->right->verdict);
-			if (expr->chain != NULL) {
+			if (expr->chain != NULL)
 				nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_CHAIN,
 						nld.chain, strlen(nld.chain));
-			}
 			break;
 		case EXPR_VALUE:
 			nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_DATA,
@@ -238,10 +240,9 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 		}
 	}
 
-	if (expr->flags & EXPR_F_INTERVAL_END) {
+	if (expr->flags & EXPR_F_INTERVAL_END)
 		nft_set_elem_attr_set_u32(nlse, NFT_SET_ELEM_ATTR_FLAGS,
 					  NFT_SET_ELEM_INTERVAL_END);
-	}
 
 	return nlse;
 }
@@ -364,11 +365,10 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 	netlink_linearize_rule(ctx, nlr, rule);
 	err = mnl_nft_rule_batch_add(nlr, flags | NLM_F_EXCL, ctx->seqnum);
 	nft_rule_free(nlr);
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, &rule->location,
 				 "Could not add rule to batch: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -398,7 +398,6 @@ int netlink_del_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete rule to batch: %s",
 				 strerror(errno));
-
 	return err;
 }
 
@@ -536,10 +535,9 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 				      ctx->seqnum);
 	nft_chain_free(nlc);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not add chain: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -587,10 +585,9 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 	err = mnl_nft_chain_batch_add(nlc, 0, ctx->seqnum);
 	nft_chain_free(nlc);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not rename chain: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -615,10 +612,9 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
 	nft_chain_free(nlc);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete chain: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -634,10 +630,9 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 	err = mnl_nft_chain_batch_del(nlc, 0, ctx->seqnum);
 	nft_chain_free(nlc);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete chain: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -801,10 +796,9 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 				      ctx->seqnum);
 	nft_table_free(nlt);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not add table: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -846,10 +840,9 @@ static int netlink_del_table_batch(struct netlink_ctx *ctx,
 	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
 	nft_table_free(nlt);
 
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete table: %s",
 				 strerror(errno));
-	}
 	return err;
 }
 
@@ -1114,10 +1107,9 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	netlink_dump_set(nls);
 
 	err = mnl_nft_set_batch_add(nls, NLM_F_EXCL, ctx->seqnum);
-	if (err < 0) {
+	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
-	}
 	nft_set_free(nls);
 
 	return err;
@@ -1457,7 +1449,6 @@ int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not flush the ruleset: %s",
 				 strerror(errno));
-
 	return err;
 }
 
-- 
2.1.0

