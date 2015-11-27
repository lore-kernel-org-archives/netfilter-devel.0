From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft] netlink: fix up indentation damage
Date: Fri, 27 Nov 2015 17:54:13 +0000
Message-ID: <1448646853-22708-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbbK0RyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 12:54:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The conversion to the net libnftnl API has left a lot of indentation damage
in the netlink functions. Fix it up.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c             | 102 +++++++++++++++++++---------------------------
 src/netlink_delinearize.c |  16 +++-----
 src/netlink_linearize.c   |  81 +++++++++++++++++-------------------
 3 files changed, 87 insertions(+), 112 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 974afb1..ba0c20a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -224,24 +224,24 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
 	nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 	if (elem->timeout)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
-					  elem->timeout);
+				       elem->timeout);
 	if (elem->comment)
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_USERDATA,
-				      elem->comment, strlen(elem->comment) + 1);
+				   elem->comment, strlen(elem->comment) + 1);
 
 	if (data != NULL) {
 		netlink_gen_data(data, &nld);
 		switch (data->ops->type) {
 		case EXPR_VERDICT:
 			nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_VERDICT,
-						  data->verdict);
+					       data->verdict);
 			if (data->chain != NULL)
 				nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_CHAIN,
-						      nld.chain, strlen(nld.chain));
+						   nld.chain, strlen(nld.chain));
 			break;
 		case EXPR_VALUE:
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_DATA,
-					      nld.value, nld.len);
+					   nld.value, nld.len);
 			break;
 		default:
 			BUG("unexpected set element expression\n");
@@ -251,7 +251,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
 
 	if (expr->flags & EXPR_F_INTERVAL_END)
 		nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_FLAGS,
-					  NFT_SET_ELEM_INTERVAL_END);
+				       NFT_SET_ELEM_INTERVAL_END);
 
 	return nlse;
 }
@@ -528,15 +528,15 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	if (chain != NULL) {
 		if (chain->flags & CHAIN_F_BASECHAIN) {
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
-					       chain->hooknum);
+					    chain->hooknum);
 			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO,
-					       chain->priority);
+					    chain->priority);
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
-					       chain->type);
+					    chain->type);
 		}
 		if (chain->policy != -1)
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY,
-					       chain->policy);
+					    chain->policy);
 	}
 
 	netlink_dump_chain(nlc);
@@ -561,18 +561,18 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 	if (chain != NULL) {
 		if (chain->flags & CHAIN_F_BASECHAIN) {
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
-					       chain->hooknum);
+					    chain->hooknum);
 			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO,
-					       chain->priority);
+					    chain->priority);
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
-					       chain->type);
+					    chain->type);
 		}
 		if (chain->policy != -1)
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY,
-					       chain->policy);
+					    chain->policy);
 		if (chain->dev != NULL)
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV,
-					       chain->dev);
+					    chain->dev);
 	}
 
 	netlink_dump_chain(nlc);
@@ -936,12 +936,9 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 	struct table *table;
 
 	table = table_alloc();
-	table->handle.family =
-		nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
-	table->handle.table  =
-		xstrdup(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
-	table->flags	     =
-		nftnl_table_get_u32(nlt, NFTNL_TABLE_FLAGS);
+	table->handle.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
+	table->handle.table  = xstrdup(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
+	table->flags	     = nftnl_table_get_u32(nlt, NFTNL_TABLE_FLAGS);
 
 	return table;
 }
@@ -1078,15 +1075,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 	set = set_alloc(&netlink_location);
 	set->handle.family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
-	set->handle.table  =
-		xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
-	set->handle.set    =
-		xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
+	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
+	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 
 	set->keytype = keytype;
-	set->keylen  =
-		nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
-
+	set->keylen  = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 
 	set->datatype = datatype;
@@ -1104,8 +1097,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		set->policy = nftnl_set_get_u32(nls, NFTNL_SET_POLICY);
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_DESC_SIZE))
-		set->desc.size = nftnl_set_get_u32(nls,
-						      NFTNL_SET_DESC_SIZE);
+		set->desc.size = nftnl_set_get_u32(nls, NFTNL_SET_DESC_SIZE);
 
 	return set;
 }
@@ -1119,14 +1111,14 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_TYPE,
-			     dtype_map_to_kernel(set->keytype));
+			  dtype_map_to_kernel(set->keytype));
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_LEN,
-			     div_round_up(set->keylen, BITS_PER_BYTE));
+			  div_round_up(set->keylen, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
-				     dtype_map_to_kernel(set->datatype));
+				  dtype_map_to_kernel(set->datatype));
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
-				     set->datalen / BITS_PER_BYTE);
+				  set->datalen / BITS_PER_BYTE);
 	}
 	netlink_dump_set(nls);
 
@@ -1135,8 +1127,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
 
-	set->handle.set =
-		xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
+	set->handle.set = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	nftnl_set_free(nls);
 
 	return err;
@@ -1151,14 +1142,14 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	nls = alloc_nftnl_set(h);
 	nftnl_set_set_u32(nls, NFTNL_SET_FLAGS, set->flags);
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_TYPE,
-			     dtype_map_to_kernel(set->keytype));
+			  dtype_map_to_kernel(set->keytype));
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_LEN,
-			     div_round_up(set->keylen, BITS_PER_BYTE));
+			  div_round_up(set->keylen, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
-				     dtype_map_to_kernel(set->datatype));
+				  dtype_map_to_kernel(set->datatype));
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
-				     set->datalen / BITS_PER_BYTE);
+				  set->datalen / BITS_PER_BYTE);
 	}
 	if (set->timeout)
 		nftnl_set_set_u64(nls, NFTNL_SET_TIMEOUT, set->timeout);
@@ -1168,15 +1159,12 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	nftnl_set_set_u32(nls, NFTNL_SET_ID, set->handle.set_id);
 
 	if (!(set->flags & (SET_F_CONSTANT))) {
-		if (set->policy != NFT_SET_POL_PERFORMANCE) {
-			nftnl_set_set_u32(nls, NFTNL_SET_POLICY,
-					     set->policy);
-		}
+		if (set->policy != NFT_SET_POL_PERFORMANCE)
+			nftnl_set_set_u32(nls, NFTNL_SET_POLICY, set->policy);
 
-		if (set->desc.size != 0) {
+		if (set->desc.size != 0)
 			nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE,
-					     set->desc.size);
-		}
+					  set->desc.size);
 	}
 
 	netlink_dump_set(nls);
@@ -1475,7 +1463,7 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 	} else {
 		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_DATA)) {
 			nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_DATA,
-							  &nld.len);
+						       &nld.len);
 		} else if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_CHAIN)) {
 			nld.chain = nftnl_set_elem_get_str(nlse, NFTNL_SET_ELEM_CHAIN);
 			nld.verdict = nftnl_set_elem_get_u32(nlse, NFTNL_SET_ELEM_VERDICT);
@@ -1738,7 +1726,7 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_table_fprintf(stdout, nlt, monh->format,
-				  netlink_msg2nftnl_of(type));
+				    netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
 	}
@@ -1770,20 +1758,17 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			chain_free(c);
 			break;
 		case NFT_MSG_DELCHAIN:
-			family = nftnl_chain_get_u32(nlc,
-							NFTNL_CHAIN_FAMILY);
+			family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
 			printf("delete chain %s %s %s\n", family2str(family),
-			       nftnl_chain_get_str(nlc,
-						      NFTNL_CHAIN_TABLE),
-			       nftnl_chain_get_str(nlc,
-						      NFTNL_CHAIN_NAME));
+			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE),
+			       nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 			break;
 		}
 		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_chain_fprintf(stdout, nlc, monh->format,
-				  netlink_msg2nftnl_of(type));
+				    netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
 	}
@@ -1819,8 +1804,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 			printf("\n");
 			break;
 		case NFT_MSG_DELSET:
-			family = nftnl_set_get_u32(nls,
-						      NFTNL_SET_FAMILY);
+			family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 			printf("delete set %s %s %s\n",
 			       family2str(family),
 			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
@@ -1911,7 +1895,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_set_fprintf(stdout, nls, monh->format,
-				netlink_msg2nftnl_of(type));
+				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 614fbe0..4a85395 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -174,7 +174,7 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 		nld.verdict = nftnl_expr_get_u32(nle, NFTNL_EXPR_IMM_VERDICT); 
 		if  (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN)) {
 			nld.chain = nftnl_expr_get(nle, NFTNL_EXPR_IMM_CHAIN,
-						      &nld.len);
+						   &nld.len);
 		}
 	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_DATA)) {
 		nld.value = nftnl_expr_get(nle, NFTNL_EXPR_IMM_DATA, &nld.len);
@@ -347,7 +347,7 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 
 	if (mpz_cmp_ui(o, 0)) {
 		nld.value = nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_XOR,
-					      &nld.len);
+					   &nld.len);
 
 		or = netlink_alloc_value(loc, &nld);
 		mpz_set(or->value, o);
@@ -564,10 +564,8 @@ static void netlink_parse_counter(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = counter_stmt_alloc(loc);
-	stmt->counter.packets =
-		nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_PACKETS);
-	stmt->counter.bytes   =
-		nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_BYTES);
+	stmt->counter.packets = nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_PACKETS);
+	stmt->counter.bytes   = nftnl_expr_get_u64(nle, NFTNL_EXPR_CTR_BYTES);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
@@ -585,8 +583,7 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 		stmt->log.flags |= STMT_LOG_PREFIX;
 	}
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_GROUP)) {
-		stmt->log.group =
-			nftnl_expr_get_u16(nle, NFTNL_EXPR_LOG_GROUP);
+		stmt->log.group = nftnl_expr_get_u16(nle, NFTNL_EXPR_LOG_GROUP);
 		stmt->log.flags |= STMT_LOG_GROUP;
 	}
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_SNAPLEN)) {
@@ -653,8 +650,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	family = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FAMILY);
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_NAT_FLAGS))
-		stmt->nat.flags = nftnl_expr_get_u32(nle,
-							NFTNL_EXPR_NAT_FLAGS);
+		stmt->nat.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FLAGS);
 
 	reg1 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3c8f4ca..0790dce 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -150,9 +150,9 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("payload");
 	netlink_put_register(nle, NFTNL_EXPR_PAYLOAD_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_BASE,
-			      expr->payload.base - 1);
+			   expr->payload.base - 1);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET,
-			      expr->payload.offset / BITS_PER_BYTE);
+			   expr->payload.offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFT_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
@@ -171,11 +171,11 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("exthdr");
 	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_DREG, dreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
-			     expr->exthdr.desc->type);
+			  expr->exthdr.desc->type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET,
-			      expr->exthdr.tmpl->offset / BITS_PER_BYTE);
+			   expr->exthdr.tmpl->offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
-			      expr->len / BITS_PER_BYTE);
+			   expr->len / BITS_PER_BYTE);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -223,9 +223,9 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_LOOKUP_SREG, sreg);
 	netlink_put_register(nle, NFTNL_EXPR_LOOKUP_DREG, dreg);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_LOOKUP_SET,
-			      expr->mappings->set->handle.set);
+			   expr->mappings->set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_SET_ID,
-			      expr->mappings->set->handle.set_id);
+			   expr->mappings->set->handle.set_id);
 
 	if (dreg == NFT_REG_VERDICT)
 		release_register(ctx, expr->map);
@@ -249,9 +249,9 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("lookup");
 	netlink_put_register(nle, NFTNL_EXPR_LOOKUP_SREG, sreg);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_LOOKUP_SET,
-			      expr->right->set->handle.set);
+			   expr->right->set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_LOOKUP_SET_ID,
-			      expr->right->set->handle.set_id);
+			   expr->right->set->handle.set_id);
 
 	release_register(ctx, expr->left);
 	nftnl_rule_add_expr(ctx->nlr, nle);
@@ -357,7 +357,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("cmp");
 	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-			      netlink_gen_cmp_op(expr->op));
+			   netlink_gen_cmp_op(expr->op));
 	payload_shift_value(expr->left, right);
 	netlink_gen_data(right, &nld);
 	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, len);
@@ -385,12 +385,12 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	switch (expr->op) {
 	case OP_NEQ:
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				      netlink_gen_cmp_op(OP_LT));
+				   netlink_gen_cmp_op(OP_LT));
 		break;
 	case OP_RANGE:
 	case OP_EQ:
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				      netlink_gen_cmp_op(OP_GTE));
+				   netlink_gen_cmp_op(OP_GTE));
 		break;
 	default:
 		BUG("invalid range operation %u\n", expr->op);
@@ -405,12 +405,12 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	switch (expr->op) {
 	case OP_NEQ:
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				      netlink_gen_cmp_op(OP_GT));
+				   netlink_gen_cmp_op(OP_GT));
 		break;
 	case OP_RANGE:
 	case OP_EQ:
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				      netlink_gen_cmp_op(OP_LTE));
+				   netlink_gen_cmp_op(OP_LTE));
 		break;
 	default:
 		BUG("invalid range operation %u\n", expr->op);
@@ -586,11 +586,11 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_SREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_BYTEORDER_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_LEN,
-			      expr->len / BITS_PER_BYTE);
+			   expr->len / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_SIZE,
-			      expr->arg->len % 32 ? 2 : 4);
+			   expr->arg->len % 32 ? 2 : 4);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BYTEORDER_OP,
-			      netlink_gen_unary_op(expr->op));
+			   netlink_gen_unary_op(expr->op));
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -612,7 +612,7 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 		if ((expr->chain != NULL) &&
 		    !nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN)) {
 			nftnl_expr_set_str(nle, NFTNL_EXPR_IMM_CHAIN,
-					      nld.chain);
+					   nld.chain);
 		}
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_IMM_VERDICT, nld.verdict);
 		break;
@@ -671,11 +671,11 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("counter");
 	if (stmt->counter.packets) {
 		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_PACKETS,
-				      stmt->counter.packets);
+				   stmt->counter.packets);
 	}
 	if (stmt->counter.bytes) {
 		nftnl_expr_set_u64(nle, NFTNL_EXPR_CTR_BYTES,
-				      stmt->counter.bytes);
+				   stmt->counter.bytes);
 	}
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
@@ -745,19 +745,17 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 				      stmt->log.prefix);
 	}
 	if (stmt->log.flags & STMT_LOG_GROUP) {
-		nftnl_expr_set_u16(nle, NFTNL_EXPR_LOG_GROUP,
-				      stmt->log.group);
+		nftnl_expr_set_u16(nle, NFTNL_EXPR_LOG_GROUP, stmt->log.group);
 		if (stmt->log.flags & STMT_LOG_SNAPLEN)
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_SNAPLEN,
-					      stmt->log.snaplen);
+					   stmt->log.snaplen);
 		if (stmt->log.flags & STMT_LOG_QTHRESHOLD)
 			nftnl_expr_set_u16(nle, NFTNL_EXPR_LOG_QTHRESHOLD,
-					      stmt->log.qthreshold);
+					   stmt->log.qthreshold);
 	} else {
-		if (stmt->log.flags & STMT_LOG_LEVEL) {
+		if (stmt->log.flags & STMT_LOG_LEVEL)
 			nftnl_expr_set_u32(nle, NFTNL_EXPR_LOG_LEVEL,
-					      stmt->log.level);
-		}
+					   stmt->log.level);
 	}
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
@@ -787,7 +785,7 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_REJECT_TYPE, stmt->reject.type);
 	if (stmt->reject.icmp_code != -1)
 		nftnl_expr_set_u8(nle, NFTNL_EXPR_REJECT_CODE,
-				     stmt->reject.icmp_code);
+				  stmt->reject.icmp_code);
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
@@ -899,17 +897,14 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 					 pmin_reg);
 			netlink_gen_expr(ctx, stmt->redir.proto->right,
 					 pmax_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MIN,
-					      pmin_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MAX,
-					      pmax_reg);
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_REDIR_REG_PROTO_MIN,
+					   pmin_reg);
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_REDIR_REG_PROTO_MAX,
+					   pmax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->redir.proto, pmin_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MIN,
-					      pmin_reg);
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_REDIR_REG_PROTO_MIN,
+					   pmin_reg);
 		}
 	}
 
@@ -970,10 +965,10 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("queue");
 	nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_NUM, mpz_get_uint16(low));
 	nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_TOTAL, total_queues);
-	if (stmt->queue.flags) {
+	if (stmt->queue.flags)
 		nftnl_expr_set_u16(nle, NFTNL_EXPR_QUEUE_FLAGS,
-				      stmt->queue.flags);
-	}
+				   stmt->queue.flags);
+
 	nftnl_rule_add_expr(ctx->nlr, nle);
 
 	mpz_clear(low);
@@ -1009,12 +1004,12 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
 	nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
-			      stmt->set.key->timeout);
+			   stmt->set.key->timeout);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, stmt->set.op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME,
-			      stmt->set.set->set->handle.set);
+			   stmt->set.set->set->handle.set);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID,
-			      stmt->set.set->set->handle.set_id);
+			   stmt->set.set->set->handle.set_id);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
2.5.0

