Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E169C35280
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 20:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26F3208C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 20:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgEAU71 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 16:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAU71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 16:59:27 -0400
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE4CC061A0C
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 13:59:26 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id C8B7E2003D;
        Fri,  1 May 2020 22:59:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id A326661DE;
        Fri,  1 May 2020 22:59:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x5i8JD+-OAj1; Fri,  1 May 2020 22:59:19 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP;
        Fri,  1 May 2020 22:59:19 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 387C1306A950; Fri,  1 May 2020 22:59:19 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [RFC] concat with dynamically sized fields like vlan id
Date:   Fri,  1 May 2020 22:59:15 +0200
Message-Id: <20200501205915.24682-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables commands like

 nft set bridge t s4 '{typeof vlan id . ip daddr; elements = { 3567 .
1.2.3.4 }; }'

Which would previously fail with
  Error: can not use variable sized data types (integer) in concat
  expressions

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 include/datatype.h                            |  6 ++-
 src/datatype.c                                | 32 +++++++++++++--
 src/evaluate.c                                | 39 ++++++++++++++-----
 src/expression.c                              | 11 +++++-
 src/netlink.c                                 | 33 ++++++++++++++--
 src/netlink_delinearize.c                     |  9 ++++-
 .../testcases/sets/dumps/typeof_sets_0.nft    |  9 +++++
 tests/shell/testcases/sets/typeof_sets_0      |  9 +++++
 8 files changed, 127 insertions(+), 21 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 04b4892b..1d1cd286 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -138,6 +138,7 @@ struct parse_ctx;
  * @flags:	flags
  * @size:	type size (fixed sized non-basetypes only)
  * @subtypes:	number of subtypes (concat type)
+ * @subsizes:	sizes of subtypes (concat type)
  * @name:	type name
  * @desc:	type description
  * @basetype:	basetype for subtypes, determines type compatibility
@@ -153,6 +154,7 @@ struct datatype {
 	unsigned int			flags;
 	unsigned int			size;
 	unsigned int			subtypes;
+	unsigned int			*subsizes;
 	const char			*name;
 	const char			*desc;
 	const struct datatype		*basetype;
@@ -273,7 +275,9 @@ extern const struct datatype policy_type;
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
-extern const struct datatype *concat_type_alloc(uint32_t type);
+extern const struct datatype *concat_type_alloc(uint32_t type,
+						unsigned int numsizes,
+						unsigned int *sizes);
 
 static inline uint32_t concat_subtype_add(uint32_t type, uint32_t subtype)
 {
diff --git a/src/datatype.c b/src/datatype.c
index 0110846f..52053a42 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1116,22 +1116,30 @@ void datatype_free(const struct datatype *ptr)
 
 	xfree(dtype->name);
 	xfree(dtype->desc);
+	xfree(dtype->subsizes);
 	xfree(dtype);
 }
 
-const struct datatype *concat_type_alloc(uint32_t type)
+/**
+ * @type: bitshifted TYPEID | TYPEID | ...
+ * @numsizes: size of sizes argument (number of entries)
+ * @sizes: for dtype with size==0, this gives the respective dynamic length
+ */
+const struct datatype *concat_type_alloc(uint32_t type, unsigned int numsizes,
+					 unsigned int *sizes)
 {
 	const struct datatype *i;
 	struct datatype *dtype;
 	char desc[256] = "concatenation of (";
 	char name[256] = "";
-	unsigned int size = 0, subtypes = 0, n;
+	unsigned int size = 0, subtypes = 0, n, k = 0, *subsizes;
 
 	n = div_round_up(fls(type), TYPE_BITS);
+	subsizes = xzalloc(n * sizeof(subsizes[0]));
 	while (n > 0 && concat_subtype_id(type, --n)) {
 		i = concat_subtype_lookup(type, n);
 		if (i == NULL)
-			return NULL;
+			goto err;
 
 		if (subtypes != 0) {
 			strncat(desc, ", ", sizeof(desc) - strlen(desc) - 1);
@@ -1140,7 +1148,19 @@ const struct datatype *concat_type_alloc(uint32_t type)
 		strncat(desc, i->desc, sizeof(desc) - strlen(desc) - 1);
 		strncat(name, i->name, sizeof(name) - strlen(name) - 1);
 
-		size += netlink_padded_len(i->size);
+		subsizes[n] = i->size;
+		if (subsizes[n] == 0 && k < numsizes) {
+			char ssize[20] = "";
+			subsizes[n] = sizes[k++];
+			snprintf(ssize, sizeof(ssize), "(%u)", subsizes[n]);
+			strncat(desc, ssize, sizeof(desc) - strlen(desc) - 1);
+			strncat(name, ssize, sizeof(name) - strlen(name) - 1);
+		}
+
+		if (subsizes[n] == 0)
+			goto err;
+
+		size += netlink_padded_len(subsizes[n]);
 		subtypes++;
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
@@ -1149,11 +1169,15 @@ const struct datatype *concat_type_alloc(uint32_t type)
 	dtype->type	= type;
 	dtype->size	= size;
 	dtype->subtypes = subtypes;
+	dtype->subsizes = subsizes;
 	dtype->name	= xstrdup(name);
 	dtype->desc	= xstrdup(desc);
 	dtype->parse	= concat_type_parse;
 
 	return dtype;
+err:
+	xfree(subsizes);
+	return NULL;
 }
 
 const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
diff --git a/src/evaluate.c b/src/evaluate.c
index 59714131..ec96dd58 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1227,42 +1227,63 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr,
 	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	struct expr *i, *next;
+	unsigned int* sizes = NULL;
+	unsigned int numsizes = 0;
 
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
 		unsigned dsize_bytes;
+		unsigned int subtype_size;
 
-		if (expr_is_constant(*expr) && dtype && off == 0)
+		if (expr_is_constant(*expr) && dtype && off == 0) {
+			xfree(sizes);
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "unexpected concat component, "
 						 "expecting %s",
 						 dtype->desc);
-
+		}
 		if (dtype == NULL)
 			tmp = datatype_lookup(TYPE_INVALID);
 		else
 			tmp = concat_subtype_lookup(type, --off);
-		expr_set_context(&ctx->ectx, tmp, tmp->size);
-
-		if (eval && list_member_evaluate(ctx, &i) < 0)
+		subtype_size = tmp->size;
+		if (subtype_size == 0 && dtype && dtype->subtypes > 0)
+			subtype_size = dtype->subsizes[off];
+		else if (subtype_size == 0)
+			subtype_size = i->len;
+		expr_set_context(&ctx->ectx, tmp, subtype_size);
+
+		if (eval && list_member_evaluate(ctx, &i) < 0) {
+			xfree(sizes);
 			return -1;
+		}
 		flags &= i->flags;
 
-		if (dtype == NULL && i->dtype->size == 0)
+		if (dtype == NULL && i->dtype->size == 0 && i->len == 0) {
+			xfree(sizes);
 			return expr_binary_error(ctx->msgs, i, *expr,
 						 "can not use variable sized "
 						 "data types (%s) in concat "
 						 "expressions",
 						 i->dtype->name);
+		}
 
 		ntype = concat_subtype_add(ntype, i->dtype->type);
 
-		dsize_bytes = div_round_up(i->dtype->size, BITS_PER_BYTE);
+		if (i->dtype->size == 0) {
+			numsizes++;
+			sizes = xrealloc(sizes, numsizes * sizeof(sizes[0]));
+			sizes[numsizes - 1] = i->len;
+			dsize_bytes = div_round_up(i->len, BITS_PER_BYTE);
+		} else {
+			dsize_bytes = div_round_up(i->dtype->size, BITS_PER_BYTE);
+		}
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
 	}
 
 	(*expr)->flags |= flags;
-	datatype_set(*expr, concat_type_alloc(ntype));
+	datatype_set(*expr, concat_type_alloc(ntype, numsizes, sizes));
 	(*expr)->len   = (*expr)->dtype->size;
+	xfree(sizes); sizes = NULL;
 
 	if (off > 0)
 		return expr_error(ctx->msgs, *expr,
@@ -2918,7 +2939,7 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	default:
 		return -1;
 	}
-	dtype = concat_type_alloc((addr_type << TYPE_BITS) | TYPE_INET_SERVICE);
+	dtype = concat_type_alloc((addr_type << TYPE_BITS) | TYPE_INET_SERVICE, 0, NULL);
 
 	expr_set_context(&ctx->ectx, dtype, dtype->size);
 	if (expr_evaluate(ctx, &stmt->nat.addr))
diff --git a/src/expression.c b/src/expression.c
index a6bde70f..20d06374 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -909,7 +909,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 	const struct datatype *dtype;
 	struct expr *concat_expr;
 	uint32_t dt = 0;
-	unsigned int i;
+	unsigned int i, numsizes = 0, *sizes = NULL;
 	int err;
 
 	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
@@ -949,19 +949,26 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 
 		dt = concat_subtype_add(dt, expr->dtype->type);
 		compound_expr_add(concat_expr, expr);
+		if (expr->dtype->size == 0) {
+			numsizes++;
+			sizes = xrealloc(sizes, numsizes * sizeof(sizes[0]));
+			sizes[numsizes-1] = expr->len;
+		}
 	}
 
-	dtype = concat_type_alloc(dt);
+	dtype = concat_type_alloc(dt, numsizes, sizes);
 	if (!dtype)
 		goto err_free;
 
 	concat_expr->dtype = datatype_get(dtype);
 	concat_expr->len = dtype->size;
+	xfree(sizes);
 
 	return concat_expr;
 
 err_free:
 	expr_free(concat_expr);
+	xfree(sizes);
 	return NULL;
 }
 
diff --git a/src/netlink.c b/src/netlink.c
index bb014320..531819d0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -630,7 +630,10 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 		return &verdict_type;
 	default:
 		if (type & ~TYPE_MASK)
-			return concat_type_alloc(type);
+			// This won't work for dynamically sized types,
+			// but in case of typeof dtype_map_from_kernel
+			// won't be called.
+			return concat_type_alloc(type, 0, NULL);
 		return datatype_lookup(type);
 	}
 }
@@ -773,7 +776,12 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
-	keytype = dtype_map_from_kernel(key);
+	if (typeof_expr_key && typeof_expr_key->dtype->type == key)
+		keytype = typeof_expr_key->dtype;
+	else
+		/* Parsing CONCAT type would possibly require expr context
+		 * information (integer len) */
+		keytype = dtype_map_from_kernel(key);
 	if (keytype == NULL) {
 		netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
 				 key);
@@ -785,7 +793,12 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		uint32_t data;
 
 		data = nftnl_set_get_u32(nls, NFTNL_SET_DATA_TYPE);
-		datatype = dtype_map_from_kernel(data);
+		if (typeof_expr_data && typeof_expr_data->dtype->type == data)
+			datatype = typeof_expr_data->dtype;
+		else
+			/* Parsing CONCAT type would possibly require expr
+			 * context information (integer len) */
+			datatype = dtype_map_from_kernel(data);
 		if (datatype == NULL) {
 			netlink_io_error(ctx, NULL,
 					 "Unknown data type in set key %u",
@@ -1001,9 +1014,21 @@ static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
 
 	concat = concat_expr_alloc(&data->location);
 	while (off > 0) {
+		unsigned int dsize_bytes;
 		subtype = concat_subtype_lookup(dtype->type, --off);
 
-		expr		= constant_expr_splice(data, subtype->size);
+		if (subtype->size != 0)
+			assert(subtype->size == dtype->subsizes[off]);
+		/**
+		 * for vlan id 3567, data looks like [ 0d ef 00 00 ... ]
+		 * constant_expr_splice will mask it with ff f0 00 00 ..., so expr will contain 0d e0
+		 * which is not what we need. vlan id (without concat) also puts 0d ef into its reg,
+		 * so the leading zero should be preserved.
+		 * This is all due to vlan id having 12 bits which is not a multiple of BITS_PER_BYTE
+		 * and the way expr_evaluate_integer handle these.
+		 */
+		dsize_bytes     = div_round_up(dtype->subsizes[off], BITS_PER_BYTE);
+		expr		= constant_expr_splice(data, BITS_PER_BYTE * dsize_bytes);
 		expr->dtype     = subtype;
 		expr->byteorder = subtype->byteorder;
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f721d15c..3946ed5f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2216,6 +2216,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		unsigned int type = expr->dtype->type, ntype = 0;
 		int off = expr->dtype->subtypes;
 		const struct datatype *dtype;
+		unsigned int numsizes = 0, *sizes = NULL;
 
 		list_for_each_entry(i, &expr->expressions, list) {
 			if (type) {
@@ -2225,8 +2226,14 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_postprocess(ctx, &i);
 
 			ntype = concat_subtype_add(ntype, i->dtype->type);
+			if (i->dtype->size == 0) {
+				numsizes++;
+				sizes = xrealloc(sizes, numsizes * sizeof(sizes[0]));
+				sizes[numsizes-1] = i->len;
+			}
 		}
-		datatype_set(expr, concat_type_alloc(ntype));
+		datatype_set(expr, concat_type_alloc(ntype, numsizes, sizes));
+		xfree(sizes);
 		break;
 	}
 	case EXPR_UNARY:
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 565369fb..fb133987 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -14,6 +14,11 @@ table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s4 {
+		type integer . ipv4_addr
+		elements = { 0 . 13.239.0.0 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -21,4 +26,8 @@ table inet t {
 	chain c2 {
 		vlan id @s2 accept
 	}
+
+	chain c4 {
+		ether type vlan @ll,112,16 & 4095 . ip saddr @s4 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 9b2712e5..7cfbd53a 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -20,6 +20,11 @@ EXPECTED="table inet t {
 		elements = { 2, 3, 103 }
 	}
 
+	set s4 {
+		typeof vlan id . ip saddr
+		elements = { 3567 . 1.2.3.4 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -27,6 +32,10 @@ EXPECTED="table inet t {
 	chain c2 {
 		ether type vlan vlan id @s2 accept
 	}
+
+	chain c4 {
+		ether type vlan vlan id . ip saddr @s4 accept
+	}
 }"
 
 set -e
-- 
2.20.1

