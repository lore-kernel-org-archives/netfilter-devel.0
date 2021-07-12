Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BDAC07E99
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 17:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBA66044F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 17:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhGLRHT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 13:07:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35908 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhGLRHS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 13:07:18 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A2D5960693
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jul 2021 19:04:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] src: support for nat with interval concatenation
Date:   Mon, 12 Jul 2021 19:04:24 +0200
Message-Id: <20210712170424.11071-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to combine concatenation and interval in NAT
mappings, e.g.

 add rule x y dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2-10.141.10.5 . 8888-8999 }

This generates the following NAT expression:

 [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]

which expects to obtain the following tuple:

 IP address (min), source port (min), IP address (max), source port (max)

to be obtained from the map. This representation simplifies the
delinearize path, since the datatype is specified as:

 ipv4_addr . inet_service.

A few more notes on this update:

- alloc_nftnl_setelem() needs a variant netlink_gen_data() to deal with
  the representation of the range on the rhs of the mapping. In contrast
  to interval concatenation in the key side, where the range is expressed
  as two netlink attributes, the data side of the set element mapping
  stores the interval concatenation in a contiguos memory area, see
  __netlink_gen_concat_expand() for reference.

- add range_expr_postprocess() to postprocess the data mapping range.
  If either one single IP address or port is used, then the minimum and
  maximum value in the range is the same value, e.g. to avoid listing
  80-80, this round simplify the range. This also invokes the range
  to prefix conversion routine.

This patch also adds tests/py and tests/shell.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                |  29 +++-
 src/netlink.c                                 | 157 ++++++++++++++++--
 src/netlink_delinearize.c                     |  28 +++-
 src/netlink_linearize.c                       |  22 ++-
 src/parser_bison.y                            |   7 +
 src/statement.c                               |  12 +-
 tests/py/ip/dnat.t                            |   4 +
 tests/py/ip/dnat.t.payload.ip                 |  36 ++++
 tests/py/ip/snat.t                            |   1 +
 tests/py/ip/snat.t.payload                    |   8 +
 .../testcases/sets/0067nat_concat_interval_0  |  33 ++++
 .../sets/dumps/0067nat_concat_interval_0.nft  |  19 +++
 12 files changed, 320 insertions(+), 36 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0067nat_concat_interval_0
 create mode 100644 tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 585182d3599f..31c244fd6dd1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1602,6 +1602,26 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static bool data_mapping_is_interval(struct expr *data)
+{
+	struct expr *i;
+
+	if (data->etype == EXPR_RANGE ||
+	    data->etype == EXPR_PREFIX)
+		return true;
+
+	if (data->etype != EXPR_CONCAT)
+		return false;
+
+	list_for_each_entry(i, &data->expressions, list) {
+		if (i->etype == EXPR_RANGE ||
+		    i->etype == EXPR_PREFIX)
+			return true;
+	}
+
+	return false;
+}
+
 static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *mapping = *expr;
@@ -1641,8 +1661,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 				  "Value must be a constant");
 
 	if (set_is_anonymous(set->flags) &&
-	    (mapping->right->etype == EXPR_RANGE ||
-	     mapping->right->etype == EXPR_PREFIX))
+	    data_mapping_is_interval(mapping->right))
 		set->data->flags |= EXPR_F_INTERVAL;
 
 	if (!(set->data->flags & EXPR_F_INTERVAL) &&
@@ -3885,13 +3904,13 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
 
-		if (set->data->flags & EXPR_F_INTERVAL)
-			set->data->len *= 2;
-
 		if (set->data->etype == EXPR_CONCAT &&
 		    set_expr_evaluate_concat(ctx, &set->data) < 0)
 			return -1;
 
+		if (set->data->flags & EXPR_F_INTERVAL)
+			set->data->len *= 2;
+
 		if (set->data->len == 0 && set->data->dtype->type != TYPE_VERDICT)
 			return set_key_data_error(ctx, set,
 						  set->data->dtype, type);
diff --git a/src/netlink.c b/src/netlink.c
index c5fd38044b41..b15fb535cc2e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -97,6 +97,9 @@ struct nftnl_expr *alloc_nft_expr(const char *name)
 	return nle;
 }
 
+void __netlink_gen_data(const struct expr *expr,
+			struct nft_data_linearize *data, bool expand);
+
 static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 						  const struct expr *expr)
 {
@@ -130,11 +133,11 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	case EXPR_SET_ELEM_CATCHALL:
 		break;
 	default:
-		netlink_gen_data(key, &nld);
+		__netlink_gen_data(key, &nld, false);
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 		if (set->set_flags & NFT_SET_INTERVAL && key->field_count > 1) {
 			key->flags |= EXPR_F_INTERVAL_END;
-			netlink_gen_data(key, &nld);
+			__netlink_gen_data(key, &nld, false);
 			key->flags &= ~EXPR_F_INTERVAL_END;
 
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY_END,
@@ -185,7 +188,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		nftnl_udata_buf_free(udbuf);
 	}
 	if (set_is_datamap(set->set_flags) && data != NULL) {
-		netlink_gen_data(data, &nld);
+		__netlink_gen_data(data, &nld, !(data->flags & EXPR_F_SINGLETON));
 		switch (data->etype) {
 		case EXPR_VERDICT:
 			nftnl_set_elem_set_u32(nlse, NFTNL_SET_ELEM_VERDICT,
@@ -270,8 +273,8 @@ static int netlink_gen_concat_data_expr(int end, const struct expr *i,
 	return netlink_export_pad(data, i->value, i);
 }
 
-static void netlink_gen_concat_data(const struct expr *expr,
-				    struct nft_data_linearize *nld)
+static void __netlink_gen_concat(const struct expr *expr,
+				 struct nft_data_linearize *nld)
 {
 	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
 	int end = expr->flags & EXPR_F_INTERVAL_END;
@@ -287,6 +290,35 @@ static void netlink_gen_concat_data(const struct expr *expr,
 	nld->len = len;
 }
 
+static void __netlink_gen_concat_expand(const struct expr *expr,
+				        struct nft_data_linearize *nld)
+{
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE) * 2, offset = 0;
+	unsigned char data[len];
+	const struct expr *i;
+
+	memset(data, 0, len);
+
+	list_for_each_entry(i, &expr->expressions, list)
+		offset += netlink_gen_concat_data_expr(false, i, data + offset);
+
+	list_for_each_entry(i, &expr->expressions, list)
+		offset += netlink_gen_concat_data_expr(true, i, data + offset);
+
+	memcpy(nld->value, data, len);
+	nld->len = len;
+}
+
+static void netlink_gen_concat_data(const struct expr *expr,
+				    struct nft_data_linearize *nld,
+				    bool expand)
+{
+	if (expand)
+		__netlink_gen_concat_expand(expr, nld);
+	else
+		__netlink_gen_concat(expr, nld);
+}
+
 static void netlink_gen_constant_data(const struct expr *expr,
 				      struct nft_data_linearize *data)
 {
@@ -366,13 +398,14 @@ static void netlink_gen_prefix(const struct expr *expr,
 	nld->len = len;
 }
 
-void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
+void __netlink_gen_data(const struct expr *expr,
+			struct nft_data_linearize *data, bool expand)
 {
 	switch (expr->etype) {
 	case EXPR_VALUE:
 		return netlink_gen_constant_data(expr, data);
 	case EXPR_CONCAT:
-		return netlink_gen_concat_data(expr, data);
+		return netlink_gen_concat_data(expr, data, expand);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
 	case EXPR_RANGE:
@@ -384,6 +417,11 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 	}
 }
 
+void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
+{
+	__netlink_gen_data(expr, data, false);
+}
+
 struct expr *netlink_alloc_value(const struct location *loc,
 				 const struct nft_data_delinearize *nld)
 {
@@ -1053,10 +1091,28 @@ struct expr *range_expr_to_prefix(struct expr *range)
 	return range;
 }
 
-static struct expr *netlink_parse_interval_elem(const struct datatype *dtype,
+static struct expr *range_expr_reduce(struct expr *range)
+{
+	struct expr *expr;
+
+	if (!mpz_cmp(range->left->value, range->right->value)) {
+		expr = expr_get(range->left);
+		expr_free(range);
+		return expr;
+	}
+
+	if (range->left->dtype->type != TYPE_IPADDR &&
+	    range->left->dtype->type != TYPE_IP6ADDR)
+		return range;
+
+	return range_expr_to_prefix(range);
+}
+
+static struct expr *netlink_parse_interval_elem(const struct set *set,
 						struct expr *expr)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	const struct datatype *dtype = set->data->dtype;
 	struct expr *range, *left, *right;
 	char data[len];
 
@@ -1073,9 +1129,10 @@ static struct expr *netlink_parse_interval_elem(const struct datatype *dtype,
 	return range_expr_to_prefix(range);
 }
 
-static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
-					      struct expr *data)
+static struct expr *netlink_parse_concat_elem_key(const struct set *set,
+						  struct expr *data)
 {
+	const struct datatype *dtype = set->key->dtype;
 	const struct datatype *subtype;
 	struct expr *concat, *expr;
 	int off = dtype->subtypes;
@@ -1098,6 +1155,76 @@ static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
 		compound_expr_add(concat, expr);
 		data->len -= netlink_padding_len(expr->len);
 	}
+
+	expr_free(data);
+
+	return concat;
+}
+
+static struct expr *netlink_parse_concat_elem(const struct set *set,
+					      struct expr *data)
+{
+	const struct datatype *dtype = set->data->dtype;
+	struct expr *concat, *expr, *left, *range;
+	const struct datatype *subtype;
+	int off = dtype->subtypes;
+	struct list_head expressions;
+
+	init_list_head(&expressions);
+
+	concat = concat_expr_alloc(&data->location);
+	while (off > 0) {
+		subtype = concat_subtype_lookup(dtype->type, --off);
+
+		expr		= constant_expr_splice(data, subtype->size);
+		expr->dtype     = subtype;
+		expr->byteorder = subtype->byteorder;
+
+		if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
+		if (expr->dtype->basetype != NULL &&
+		    expr->dtype->basetype->type == TYPE_BITMASK)
+			expr = bitmask_expr_to_binops(expr);
+
+		data->len -= netlink_padding_len(expr->len);
+
+		list_add_tail(&expr->list, &expressions);
+	}
+
+	if (set->data->flags & EXPR_F_INTERVAL) {
+		assert(!list_empty(&expressions));
+
+		off = dtype->subtypes;
+
+		while (off > 0) {
+			left = list_first_entry(&expressions, struct expr, list);
+
+			subtype = concat_subtype_lookup(dtype->type, --off);
+
+			expr		= constant_expr_splice(data, subtype->size);
+			expr->dtype     = subtype;
+			expr->byteorder = subtype->byteorder;
+
+			if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+				mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
+			if (expr->dtype->basetype != NULL &&
+			    expr->dtype->basetype->type == TYPE_BITMASK)
+				expr = bitmask_expr_to_binops(expr);
+
+			data->len -= netlink_padding_len(expr->len);
+
+			list_del(&left->list);
+			range = range_expr_alloc(&data->location, left, expr);
+			range = range_expr_reduce(range);
+			compound_expr_add(concat, range);
+		}
+		assert(list_empty(&expressions));
+	} else {
+		list_splice_tail(&expressions, &concat->expressions);
+	}
+
 	expr_free(data);
 
 	return concat;
@@ -1169,7 +1296,7 @@ key_end:
 		datatype_set(key, set->key->dtype);
 		key->byteorder	= set->key->byteorder;
 		if (set->key->dtype->subtypes)
-			key = netlink_parse_concat_elem(set->key->dtype, key);
+			key = netlink_parse_concat_elem_key(set, key);
 
 		if (!(set->flags & NFT_SET_INTERVAL) &&
 		    key->byteorder == BYTEORDER_HOST_ENDIAN)
@@ -1232,10 +1359,10 @@ key_end:
 		datatype_set(data, set->data->dtype);
 		data->byteorder = set->data->byteorder;
 
-		if (set->data->flags & EXPR_F_INTERVAL)
-			data = netlink_parse_interval_elem(set->data->dtype, data);
-		else if (set->data->dtype->subtypes)
-			data = netlink_parse_concat_elem(set->data->dtype, data);
+		if (set->data->dtype->subtypes) {
+			data = netlink_parse_concat_elem(set, data);
+		} else if (set->data->flags & EXPR_F_INTERVAL)
+			data = netlink_parse_interval_elem(set, data);
 
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2723515df47a..0573d05c4863 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1028,7 +1028,8 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
-static bool is_nat_addr_map(const struct expr *addr, uint8_t family)
+static bool is_nat_addr_map(const struct expr *addr, uint8_t family,
+			    struct stmt *stmt)
 {
 	const struct expr *mappings, *data;
 	const struct set *set;
@@ -1047,14 +1048,31 @@ static bool is_nat_addr_map(const struct expr *addr, uint8_t family)
 	if (!(data->flags & EXPR_F_INTERVAL))
 		return false;
 
+	stmt->nat.family = family;
+
 	/* if we're dealing with an address:address map,
 	 * the length will be bit_sizeof(addr) + 32 (one register).
 	 */
 	switch (family) {
 	case NFPROTO_IPV4:
-		return data->len == 32 + 32;
+		if (data->len == 32 + 32) {
+			stmt->nat.type_flags |= STMT_NAT_F_INTERVAL;
+			return true;
+		} else if (data->len == 32 + 32 + 32 + 32) {
+			stmt->nat.type_flags |= STMT_NAT_F_INTERVAL |
+						STMT_NAT_F_CONCAT;
+			return true;
+		}
+		break;
 	case NFPROTO_IPV6:
-		return data->len == 128 + 128;
+		if (data->len == 128 + 128) {
+			stmt->nat.type_flags |= STMT_NAT_F_INTERVAL;
+			return true;
+		} else if (data->len == 128 + 32 + 128 + 32) {
+			stmt->nat.type_flags |= STMT_NAT_F_INTERVAL |
+						STMT_NAT_F_CONCAT;
+			return true;
+		}
 	}
 
 	return false;
@@ -1130,9 +1148,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
-	if (is_nat_addr_map(addr, family)) {
-		stmt->nat.family = family;
-		stmt->nat.type_flags |= STMT_NAT_F_INTERVAL;
+	if (is_nat_addr_map(addr, family, stmt)) {
 		ctx->stmt = stmt;
 		return;
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e2122602dd33..b2d63535970c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1178,11 +1178,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 					     amin_reg);
 			if (stmt->nat.addr->etype == EXPR_MAP &&
 			    stmt->nat.addr->mappings->set->data->flags & EXPR_F_INTERVAL) {
-				amax_reg = get_register(ctx, NULL);
-				registers++;
 				amin_reg += netlink_register_space(nat_addrlen(family));
-				netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
-						     amin_reg);
+				if (stmt->nat.type_flags & STMT_NAT_F_CONCAT) {
+					netlink_put_register(nle, nftnl_reg_pmin,
+							     amin_reg);
+				} else {
+					netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
+							     amin_reg);
+				}
 			}
 		}
 
@@ -1194,6 +1197,12 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 
 			pmin_reg = amin_reg;
 
+			if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL) {
+				pmin_reg += netlink_register_space(nat_addrlen(family));
+				netlink_put_register(nle, NFTNL_EXPR_NAT_REG_ADDR_MAX,
+						     pmin_reg);
+			}
+
 			/* if STMT_NAT_F_CONCAT is set, the mapped type is a
 			 * concatenation of 'addr . inet_service'.
 			 * The map lookup will then return the
@@ -1202,7 +1211,10 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 			 * will hold the inet_service part.
 			 */
 			pmin_reg += netlink_register_space(nat_addrlen(family));
-			netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
+			if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
+				netlink_put_register(nle, nftnl_reg_pmax, pmin_reg);
+			else
+				netlink_put_register(nle, nftnl_reg_pmin, pmin_reg);
 		}
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c1fcedd7ecce..ce11fc405ea1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3651,6 +3651,13 @@ nat_stmt_args		:	stmt_expr
 				$<stmt>0->nat.addr = $3;
 				$<stmt>0->nat.type_flags = STMT_NAT_F_INTERVAL;
 			}
+			|	nf_key_proto INTERVAL ADDR	DOT	PORT	TO	stmt_expr
+			{
+				$<stmt>0->nat.family = $1;
+				$<stmt>0->nat.addr = $7;
+				$<stmt>0->nat.type_flags = STMT_NAT_F_INTERVAL |
+							   STMT_NAT_F_CONCAT;
+			}
 			|	nf_key_proto PREFIX TO	stmt_expr
 			{
 				$<stmt>0->nat.family = $1;
diff --git a/src/statement.c b/src/statement.c
index b3e53451f5c7..7a65ba176296 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -703,12 +703,14 @@ static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			break;
 		}
 
-		if (stmt->nat.type_flags & STMT_NAT_F_CONCAT)
-			nft_print(octx, " addr . port");
-		else if (stmt->nat.type_flags & STMT_NAT_F_PREFIX)
+		if (stmt->nat.type_flags & STMT_NAT_F_PREFIX) {
 			nft_print(octx, " prefix");
-		else if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
-			nft_print(octx, " interval");
+		} else {
+			if (stmt->nat.type_flags & STMT_NAT_F_INTERVAL)
+				nft_print(octx, " interval");
+			if (stmt->nat.type_flags & STMT_NAT_F_CONCAT)
+				nft_print(octx, " addr . port");
+		}
 
 		nft_print(octx, " to");
 	}
diff --git a/tests/py/ip/dnat.t b/tests/py/ip/dnat.t
index 089017c84704..7454467184d2 100644
--- a/tests/py/ip/dnat.t
+++ b/tests/py/ip/dnat.t
@@ -11,3 +11,7 @@ iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080;ok
 
 dnat to ct mark map { 0x00000014 : 1.2.3.4};ok
 dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
+
+dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888 - 8999 };ok
+dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 };ok
+dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 };ok
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index dd18dae2a1be..40afcd3397a2 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -91,3 +91,39 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 ]
 
+# dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888 - 8999 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+        element 0201a8c0 00005000  : 000a8d0a 0000b822 ff0a8d0a 00002723 0 [end]
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
+
+# dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+        element 0201a8c0 00005000  : 000a8d0a 00005000 ff0a8d0a 00005000 0 [end]
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
+
+# dnat ip interval addr . port to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+        element 0201a8c0 00005000  : 020a8d0a 0000b822 020a8d0a 00002723 0 [end]
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 10 proto_min reg 9 proto_max reg 11 ]
+
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index c6e8a8e68f9d..b0b7da5b61bd 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -11,4 +11,5 @@ iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
 
 snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
 snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
+snat ip interval to ip saddr map { 10.141.12.14 : 192.168.2.0/24 };ok
 snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 };ok
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index ef4c1ce9f150..400546381604 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -87,3 +87,11 @@ ip
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 addr_max reg 9 flags 0x40 ]
 
+# snat ip interval to ip saddr map { 10.141.12.14 : 192.168.2.0/24 }
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+        element 0e0c8d0a  : 0002a8c0 ff02a8c0 0 [end]
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat snat ip addr_min reg 1 addr_max reg 9 ]
diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
new file mode 100755
index 000000000000..f1f4f735f20f
--- /dev/null
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip nat {
+       map ipportmap {
+                type ipv4_addr : interval ipv4_addr . inet_service
+                flags interval
+                elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999 }
+       }
+       chain prerouting {
+                type nat hook prerouting priority dstnat; policy accept;
+                ip protocol tcp dnat ip interval addr . port to ip saddr map @ipportmap
+       }
+}"
+
+$NFT -f - <<< $EXPECTED
+$NFT add element ip nat ipportmap { 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
+
+EXPECTED="table ip nat {
+        map ipportmap2 {
+                type ipv4_addr . ipv4_addr : interval ipv4_addr . inet_service
+                flags interval
+                elements = { 192.168.1.2 . 192.168.2.2 : 127.0.0.1/8  . 42 - 43 }
+        }
+
+        chain prerouting {
+                type nat hook prerouting priority dstnat; policy accept;
+                ip protocol tcp dnat ip interval addr . port to ip saddr . ip daddr map @ipportmap2
+        }
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
new file mode 100644
index 000000000000..8fa79aba1573
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -0,0 +1,19 @@
+table ip nat {
+	map ipportmap {
+		type ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999, 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
+	}
+
+	map ipportmap2 {
+		type ipv4_addr . ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { 192.168.1.2 . 192.168.2.2 : 127.0.0.0-127.255.255.255 . 42-43 }
+	}
+
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		ip protocol tcp dnat ip interval addr . port to ip saddr map @ipportmap
+		ip protocol tcp dnat ip interval addr . port to ip saddr . ip daddr map @ipportmap2
+	}
+}
-- 
2.20.1

