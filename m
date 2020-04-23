Return-Path: <SRS0=9Oxv=6H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1709C54FD0
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Apr 2020 20:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA1982073A
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Apr 2020 20:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDWUoV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Apr 2020 16:44:21 -0400
Received: from correo.us.es ([193.147.175.20]:52222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgDWUoV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Apr 2020 16:44:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BB261C4381
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 22:44:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A39BBAAA1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 22:44:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4FC26BAC2F; Thu, 23 Apr 2020 22:44:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D62ADA7B2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 22:44:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 Apr 2020 22:44:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ED91342EFB80
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2020 22:44:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: NAT support for intervals in maps
Date:   Thu, 23 Apr 2020 22:44:10 +0200
Message-Id: <20200423204410.510075-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to specify an interval of IP address in maps.

 table ip x {
        chain y {
                type nat hook postrouting priority srcnat; policy accept;
                snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
        }
 }

The example above performs SNAT to packets that comes from 10.141.11.4
to an interval of IP addresses from 192.168.2.2 to 192.168.2.4 (both
included).

You can also combine this with dynamic maps:

 table ip x {
        map y {
                type ipv4_addr : interval ipv4_addr
                flags interval
                elements = { 10.141.10.0/24 : 192.168.2.2-192.168.2.4 }
        }

        chain y {
                type nat hook postrouting priority srcnat; policy accept;
                snat ip interval to ip saddr map @y
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h      |  2 ++
 include/statement.h       |  5 ++++
 src/evaluate.c            | 44 +++++++++++++++++++++++++++++--
 src/mnl.c                 |  5 +++-
 src/netlink.c             | 67 +++++++++++++++++++++++++++++++++++++++++++++--
 src/netlink_delinearize.c | 39 +++++++++++++++++++++++++++
 src/netlink_linearize.c   |  8 ++++++
 src/parser_bison.y        | 34 ++++++++++++++++++++++++
 src/rule.c                |  3 +++
 src/statement.c           |  2 ++
 10 files changed, 204 insertions(+), 5 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 87c39e5de08a..359348275a04 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -184,6 +184,7 @@ const struct expr_ops *expr_ops_by_type(enum expr_types etype);
  * @EXPR_F_PROTOCOL:		expressions describes upper layer protocol
  * @EXPR_F_INTERVAL_END:	set member ends an open interval
  * @EXPR_F_BOOLEAN:		expression is boolean (set by relational expr on LHS)
+ * @EXPR_F_INTERVAL:		expression describes a interval
  */
 enum expr_flags {
 	EXPR_F_CONSTANT		= 0x1,
@@ -191,6 +192,7 @@ enum expr_flags {
 	EXPR_F_PROTOCOL		= 0x4,
 	EXPR_F_INTERVAL_END	= 0x8,
 	EXPR_F_BOOLEAN		= 0x10,
+	EXPR_F_INTERVAL		= 0x20,
 };
 
 #include <payload.h>
diff --git a/include/statement.h b/include/statement.h
index 8fb459ca1cd4..29f6090ee25e 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -119,6 +119,10 @@ enum nft_nat_etypes {
 
 extern const char *nat_etype2str(enum nft_nat_etypes type);
 
+enum {
+	STMT_NAT_F_INTERVAL	= (1 << 0),
+};
+
 struct nat_stmt {
 	enum nft_nat_etypes	type;
 	struct expr		*addr;
@@ -126,6 +130,7 @@ struct nat_stmt {
 	uint32_t		flags;
 	uint8_t			family;
 	bool			ipportmap;
+	uint32_t		internal_flags;
 };
 
 extern struct stmt *nat_stmt_alloc(const struct location *loc,
diff --git a/src/evaluate.c b/src/evaluate.c
index 759b17366f68..550bace3b5a7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1446,6 +1446,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (binop_transfer(ctx, expr) < 0)
 			return -1;
 
+		if (ctx->set->data->flags & EXPR_F_INTERVAL)
+			ctx->set->data->len *= 2;
+
 		ctx->set->key->len = ctx->ectx.len;
 		ctx->set = NULL;
 		map = *expr;
@@ -1486,6 +1489,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *mapping = *expr;
 	struct set *set = ctx->set;
+	uint32_t datalen;
 
 	if (set == NULL)
 		return expr_error(ctx->msgs, mapping,
@@ -1502,7 +1506,12 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
 	if (set->data) {
-		expr_set_context(&ctx->ectx, set->data->dtype, set->data->len);
+		if (set->data->flags & EXPR_F_INTERVAL)
+			datalen = set->data->len / 2;
+		else
+			datalen = set->data->len;
+
+		expr_set_context(&ctx->ectx, set->data->dtype, datalen);
 	} else {
 		assert((set->flags & NFT_SET_MAP) == 0);
 	}
@@ -1512,7 +1521,14 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!expr_is_constant(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
 				  "Value must be a constant");
-	if (!expr_is_singleton(mapping->right))
+
+	if (set_is_anonymous(set->flags) &&
+	    (mapping->right->etype == EXPR_RANGE ||
+	     mapping->right->etype == EXPR_PREFIX))
+		set->data->flags |= EXPR_F_INTERVAL;
+
+	if (!(set->data->flags & EXPR_F_INTERVAL) &&
+	    !expr_is_singleton(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
 				  "Value must be a singleton");
 
@@ -2970,6 +2986,27 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		if (err < 0)
 			return err;
 	}
+
+	if (stmt->nat.internal_flags & STMT_NAT_F_INTERVAL) {
+		switch (stmt->nat.addr->etype) {
+		case EXPR_MAP:
+			if (!(stmt->nat.addr->mappings->set->data->flags & EXPR_F_INTERVAL))
+				return expr_error(ctx->msgs, stmt->nat.addr,
+						  "map is not defined as interval");
+			break;
+		case EXPR_RANGE:
+		case EXPR_PREFIX:
+			break;
+		default:
+			return expr_error(ctx->msgs, stmt->nat.addr,
+					  "neither prefix, range nor map expression");
+		}
+
+		stmt->flags |= STMT_F_TERMINAL;
+
+		return 0;
+	}
+
 	if (stmt->nat.proto != NULL) {
 		err = nat_evaluate_transport(ctx, stmt, &stmt->nat.proto);
 		if (err < 0)
@@ -3477,6 +3514,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
 
+		if (set->data->flags & EXPR_F_INTERVAL)
+			set->data->len *= 2;
+
 		if (set->data->etype == EXPR_CONCAT &&
 		    expr_evaluate_concat(ctx, &set->data, false) < 0)
 			return -1;
diff --git a/src/mnl.c b/src/mnl.c
index 3c009fab6dcf..fb34ecb3dece 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1012,8 +1012,11 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		memory_allocation_error();
 
 	set_key_expression(ctx, set->key, set->flags, udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
-	if (set->data)
+	if (set->data) {
 		set_key_expression(ctx, set->data, set->flags, udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
+		nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_DATA_INTERVAL,
+				    !!(set->data->flags & EXPR_F_INTERVAL));
+	}
 
 	if (set->desc.field_len[0]) {
 		nftnl_set_set_data(nls, NFTNL_SET_DESC_CONCAT,
diff --git a/src/netlink.c b/src/netlink.c
index 7b7ef39e7807..938186f584d2 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -176,6 +176,8 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			assert(nld.len > 0);
 			/* fallthrough */
 		case EXPR_VALUE:
+		case EXPR_RANGE:
+		case EXPR_PREFIX:
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_DATA,
 					   nld.value, nld.len);
 			break;
@@ -296,6 +298,38 @@ static void netlink_gen_verdict(const struct expr *expr,
 	}
 }
 
+static void netlink_gen_range(const struct expr *expr,
+			      struct nft_data_linearize *nld)
+{
+	unsigned int len = div_round_up(expr->left->len, BITS_PER_BYTE) * 2;
+	unsigned char data[len];
+	unsigned int offset = 0;
+
+	memset(data, 0, len);
+	offset = netlink_export_pad(data, expr->left->value, expr->left);
+	netlink_export_pad(data + offset, expr->right->value, expr->right);
+	memcpy(nld->value, data, len);
+	nld->len = len;
+}
+
+static void netlink_gen_prefix(const struct expr *expr,
+			       struct nft_data_linearize *nld)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE) * 2;
+	unsigned char data[len];
+	int offset;
+	mpz_t v;
+
+	offset = netlink_export_pad(data, expr->prefix->value, expr);
+	mpz_init_bitmask(v, expr->len - expr->prefix_len);
+	mpz_add(v, expr->prefix->value, v);
+	netlink_export_pad(data + offset, v, expr->prefix);
+	mpz_clear(v);
+
+	memcpy(nld->value, data, len);
+	nld->len = len;
+}
+
 void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 {
 	switch (expr->etype) {
@@ -305,6 +339,10 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
+	case EXPR_RANGE:
+		return netlink_gen_range(expr, data);
+	case EXPR_PREFIX:
+		return netlink_gen_prefix(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr_name(expr));
 	}
@@ -618,6 +656,7 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	case NFTNL_UDATA_SET_KEYBYTEORDER:
 	case NFTNL_UDATA_SET_DATABYTEORDER:
 	case NFTNL_UDATA_SET_MERGE_ELEMENTS:
+	case NFTNL_UDATA_SET_DATA_INTERVAL:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -699,9 +738,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype = NULL;
 	struct expr *typeof_expr_key, *typeof_expr_data;
+	bool automerge = false, data_interval = false;
 	uint32_t flags, key, objtype = 0;
 	const struct datatype *dtype;
-	bool automerge = false;
 	const char *udata;
 	struct set *set;
 	uint32_t ulen;
@@ -724,6 +763,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(keybyteorder, NFTNL_UDATA_SET_KEYBYTEORDER);
 		GET_U32_UDATA(databyteorder, NFTNL_UDATA_SET_DATABYTEORDER);
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
+		GET_U32_UDATA(data_interval, NFTNL_UDATA_SET_DATA_INTERVAL);
 
 #undef GET_U32_UDATA
 		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_KEY_TYPEOF]);
@@ -792,6 +832,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			typeof_expr_key = NULL;
 		}
 
+		if (data_interval)
+			set->data->flags |= EXPR_F_INTERVAL;
+
 		if (dtype != datatype)
 			datatype_free(datatype);
 	}
@@ -885,6 +928,24 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	}
 }
 
+static struct expr *netlink_parse_interval_elem(const struct datatype *dtype,
+						struct expr *expr)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	struct expr *left, *right;
+	char data[len];
+
+	mpz_export_data(data, expr->value, dtype->byteorder, len);
+	left = constant_expr_alloc(&internal_location, dtype,
+				   dtype->byteorder,
+				   (len / 2) * BITS_PER_BYTE, &data[0]);
+	right = constant_expr_alloc(&internal_location, dtype,
+				    dtype->byteorder,
+				    (len / 2) * BITS_PER_BYTE, &data[len / 2]);
+
+	return range_expr_alloc(&expr->location, left, right);
+}
+
 static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
 					      struct expr *data)
 {
@@ -1021,7 +1082,9 @@ key_end:
 		datatype_set(data, set->data->dtype);
 		data->byteorder = set->data->byteorder;
 
-		if (set->data->dtype->subtypes)
+		if (set->data->flags & EXPR_F_INTERVAL)
+			data = netlink_parse_interval_elem(set->data->dtype, data);
+		else if (set->data->dtype->subtypes)
 			data = netlink_parse_concat_elem(set->data->dtype, data);
 
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 79efda123c14..bab059a2fee7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -979,6 +979,38 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+static bool is_nat_addr_map(const struct expr *addr, uint8_t family)
+{
+	const struct expr *mappings, *data;
+	const struct set *set;
+
+	if (!addr ||
+	    expr_ops(addr)->type != EXPR_MAP)
+		return false;
+
+	mappings = addr->right;
+	if (expr_ops(mappings)->type != EXPR_SET_REF)
+		return false;
+
+	set = mappings->set;
+	data = set->data;
+
+	if (!(data->flags & EXPR_F_INTERVAL))
+		return false;
+
+	/* if we're dealing with an address:address map,
+	 * the length will be bit_sizeof(addr) + 32 (one register).
+	 */
+	switch (family) {
+	case NFPROTO_IPV4:
+		return data->len == 32 + 32;
+	case NFPROTO_IPV6:
+		return data->len == 128 + 128;
+	}
+
+	return false;
+}
+
 static bool is_nat_proto_map(const struct expr *addr, uint8_t family)
 {
 	const struct expr *mappings, *data;
@@ -1046,6 +1078,13 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
+	if (is_nat_addr_map(addr, family)) {
+		stmt->nat.family = family;
+		stmt->nat.internal_flags |= STMT_NAT_F_INTERVAL;
+		ctx->stmt = stmt;
+		return;
+	}
+
 	reg2 = netlink_parse_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX);
 	if (reg2 && reg2 != reg1) {
 		addr = netlink_get_register(ctx, loc, reg2);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e70e63b336cd..944fcdae4ee9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1117,6 +1117,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			netlink_gen_expr(ctx, stmt->nat.addr, amin_reg);
 			netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MIN,
 					     amin_reg);
+			if (stmt->nat.addr->etype == EXPR_MAP &&
+			    stmt->nat.addr->mappings->set->data->flags & EXPR_F_INTERVAL) {
+				amax_reg = get_register(ctx, NULL);
+				registers++;
+				amin_reg += netlink_register_space(nat_addrlen(family));
+				netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
+						     amin_reg);
+			}
 		}
 
 		if (stmt->nat.ipportmap) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0e04a0e4fcf0..18e3fcf578ce 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1792,6 +1792,17 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
+			|	map_block	TYPE
+						data_type_expr	COLON	INTERVAL	data_type_expr
+						stmt_separator
+			{
+				$1->key = $3;
+				$1->data = $6;
+				$1->data->flags |= EXPR_F_INTERVAL;
+
+				$1->flags |= NFT_SET_MAP;
+				$$ = $1;
+			}
 			|	map_block	TYPEOF
 						typeof_expr	COLON	typeof_expr
 						stmt_separator
@@ -1803,6 +1814,18 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
+			|	map_block	TYPEOF
+						typeof_expr	COLON	INTERVAL	typeof_expr
+						stmt_separator
+			{
+				$1->key = $3;
+				datatype_set($1->key, $3->dtype);
+				$1->data = $6;
+				$1->data->flags |= EXPR_F_INTERVAL;
+
+				$1->flags |= NFT_SET_MAP;
+				$$ = $1;
+			}
 			|	map_block	TYPE
 						data_type_expr	COLON	COUNTER
 						stmt_separator
@@ -3171,6 +3194,17 @@ nat_stmt_args		:	stmt_expr
 				$<stmt>0->nat.addr = $6;
 				$<stmt>0->nat.ipportmap = true;
 			}
+			|	nf_key_proto INTERVAL TO	stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $4;
+				$<stmt>0->nat.internal_flags = STMT_NAT_F_INTERVAL;
+			}
+			|	INTERVAL TO	stmt_expr
+			{
+				$<stmt>0->nat.addr = $3;
+				$<stmt>0->nat.internal_flags = STMT_NAT_F_INTERVAL;
+			}
 			;
 
 masq_stmt		:	masq_stmt_alloc		masq_stmt_args
diff --git a/src/rule.c b/src/rule.c
index a312693f4edc..633ca13639ad 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -462,6 +462,9 @@ static void set_print_key_and_data(const struct set *set, struct output_ctx *oct
 
 	if (set_is_datamap(set->flags)) {
 		nft_print(octx, " : ");
+		if (set->data->flags & EXPR_F_INTERVAL)
+			nft_print(octx, "interval ");
+
 		if (use_typeof)
 			expr_print(set->data, octx);
 		else
diff --git a/src/statement.c b/src/statement.c
index 182edac8f2ec..fcb69bd22581 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -609,6 +609,8 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 		if (stmt->nat.ipportmap)
 			nft_print(octx, " addr . port");
+		else if (stmt->nat.internal_flags & STMT_NAT_F_INTERVAL)
+			nft_print(octx, " interval");
 
 		nft_print(octx, " to");
 	}
-- 
2.11.0

