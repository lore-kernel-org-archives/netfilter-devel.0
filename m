Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFF52877F2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236100; cv=none; b=heVXl8a3uvFz83qyLs1kOWTQXQo+M4GhZ6wvXp+wUSk4v8JPawvpCG7YCTv+9miXz3c94ZYfIJiBomcSOCkvqJkGRfJqmyhkyrUWnm4Eq71a2eaBnxEOfAmsnt+zm2ahDZgjwgW//scdxzoqbEDZ52TF35tSExmhJQBt8JdFnrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236100; c=relaxed/simple;
	bh=61A3fxaak5TKzblylUs8TNTv03rMRSKzSt6Vp/kHPAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHkAtsVCC+u0VumkHzuuG6Kd70bphQC0Q7Pv758zgnlDLWtThyyxYBF4NJT0m+eD8FV47foDqAP15UEP4ytOEcYDWyVptP9hBpf8zCFEyucMx5AWhfoU7PltqDxWibuIjjvxBEcuUqellS86T2qwdai4nIuS+WZJquR985ga8k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=D5zca1gg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="D5zca1gg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rfO3nPPn229U71HCYDzz0RFFoQQA0cKxErM03mOD1Aw=; b=D5zca1ggvUMywp5PHCq1OCYhr0
	emw6A5i4acea9yZbisjKJBFHER6Y6C+oV8xmcGtkCr7fc23KNZmux2d8ega6glfBqNbU0gxZDF6k5
	3xYZDlIsiiiGIgrT8bH/xAsVJ3Z88Dj1mtViAhZnyqMXSjCfM2t4iA8W1AsAZcSCbN/a032m1ZTrd
	Cd7D0Ym9vZUroM5n27tp5dU8STwqgkNDd7YTHNn8cGs8C4cJLK6iak3conlZX9mIPzA9NAHOymvff
	vavW6RFw8ABH0XpVqDMFhByRYdPifeymjPWpmQY3ObDzKyFXtdsGFeRoa030CeEC0jOWwhv8Bdvg+
	TmCfqG3Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxk-0000000008E-0NI1;
	Thu, 23 Oct 2025 18:14:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 13/28] Define string-based data types as Big Endian
Date: Thu, 23 Oct 2025 18:14:02 +0200
Message-ID: <20251023161417.13228-14-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Doesn't quite matter internally, but libnftnl should not attempt to
convert strings from host byte order when printing.

Fib expression byte order changes with NFT_FIB_RESULT_OIFNAME to Big
Endian.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ct.c                  |  2 +-
 src/datatype.c            | 10 +++++-----
 src/evaluate.c            | 18 +++++++++---------
 src/fib.c                 |  5 +++--
 src/intervals.c           |  5 -----
 src/json.c                |  2 +-
 src/meta.c                | 16 ++++++++--------
 src/mnl.c                 |  2 +-
 src/netlink.c             | 12 +++++-------
 src/netlink_delinearize.c | 14 +++++++-------
 src/osf.c                 |  3 +--
 src/parser_bison.y        | 10 +++++-----
 src/parser_json.c         |  4 ++--
 src/segtree.c             | 10 +++++-----
 14 files changed, 53 insertions(+), 60 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 4edbc0fc2997f..e9333c79dfd42 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -273,7 +273,7 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_HOST_ENDIAN,
 					      4 * BITS_PER_BYTE),
 	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
-					      BYTEORDER_HOST_ENDIAN,
+					      BYTEORDER_BIG_ENDIAN,
 					      NF_CT_HELPER_NAME_LEN * BITS_PER_BYTE),
 	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &nfproto_type,
 					      BYTEORDER_HOST_ENDIAN,
diff --git a/src/datatype.c b/src/datatype.c
index 55cd0267055bd..2ee7e7d5e9cf6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -324,7 +324,7 @@ void expr_chain_export(const struct expr *e, char *chain_name)
 		BUG("verdict expression length %u is too large (%u bits max)",
 		    e->len, NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE);
 
-	mpz_export_data(chain_name, e->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(chain_name, e->value, BYTEORDER_BIG_ENDIAN, len);
 }
 
 static void verdict_jump_chain_print(const char *what, const struct expr *e,
@@ -532,7 +532,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	data[len] = '\0';
 	nft_print(octx, "\"%s\"", data);
 }
@@ -542,7 +542,7 @@ static struct error_record *string_type_parse(struct parse_ctx *ctx,
 	      				      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
 				   sym->identifier);
 	return NULL;
@@ -552,7 +552,7 @@ const struct datatype string_type = {
 	.type		= TYPE_STRING,
 	.name		= "string",
 	.desc		= "string",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.print		= string_type_print,
 	.json		= string_type_json,
 	.parse		= string_type_parse,
@@ -1609,7 +1609,7 @@ static struct error_record *priority_type_parse(struct parse_ctx *ctx,
 	} else {
 		erec_destroy(erec);
 		*res = constant_expr_alloc(&sym->location, &string_type,
-					   BYTEORDER_HOST_ENDIAN,
+					   BYTEORDER_BIG_ENDIAN,
 					   strlen(sym->identifier) * BITS_PER_BYTE,
 					   sym->identifier);
 	}
diff --git a/src/evaluate.c b/src/evaluate.c
index a5cc418191989..be366140c12f2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -376,7 +376,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 	}
 
 	memset(data + len, 0, data_len - len);
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	if (strlen(data) == 0)
 		return expr_error(ctx->msgs, expr,
@@ -388,7 +388,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		 * expression length to avoid problems on big endian.
 		 */
 		value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    expr->len, data);
 		expr_free(expr);
 		*exprp = value;
@@ -406,7 +406,7 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 		xstrunescape(data, unescaped_str);
 
 		value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    expr->len, unescaped_str);
 		expr_free(expr);
 		*exprp = value;
@@ -415,14 +415,14 @@ static int expr_evaluate_string(struct eval_ctx *ctx, struct expr **exprp)
 
 	data[datalen] = 0;
 	value = constant_expr_alloc(&expr->location, ctx->ectx.dtype,
-				    BYTEORDER_HOST_ENDIAN,
+				    BYTEORDER_BIG_ENDIAN,
 				    expr->len, data);
 
 	prefix = prefix_expr_alloc(&expr->location, value,
 				   datalen * BITS_PER_BYTE);
 	datatype_set(prefix, ctx->ectx.dtype);
 	prefix->flags |= EXPR_F_CONSTANT;
-	prefix->byteorder = BYTEORDER_HOST_ENDIAN;
+	prefix->byteorder = BYTEORDER_BIG_ENDIAN;
 	prefix->len = expr->len;
 
 	expr_free(expr);
@@ -3120,7 +3120,7 @@ static int verdict_validate_chain(struct eval_ctx *ctx,
 				  "chain name length 0 not allowed");
 
 	memset(buf, 0, sizeof(buf));
-	mpz_export_data(buf, chain->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(buf, chain->value, BYTEORDER_BIG_ENDIAN, len);
 
 	if (strnlen(buf, sizeof(buf)) < sizeof(buf))
 		return 0;
@@ -5010,7 +5010,7 @@ static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
 
 	if (stmt_evaluate_arg(ctx, stmt,
 			      &string_type, NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
-			      BYTEORDER_HOST_ENDIAN, &stmt->objref.expr) < 0)
+			      BYTEORDER_BIG_ENDIAN, &stmt->objref.expr) < 0)
 		return -1;
 
 	if (!expr_is_constant(stmt->objref.expr))
@@ -5336,7 +5336,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	} else if (set_is_objmap(set->flags)) {
 		assert(set->data == NULL);
 		set->data = constant_expr_alloc(&netlink_location, &string_type,
-						BYTEORDER_HOST_ENDIAN,
+						BYTEORDER_BIG_ENDIAN,
 						NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
 						NULL);
 
@@ -5414,7 +5414,7 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 	if (prio->expr->dtype->type == TYPE_INTEGER)
 		return true;
 
-	mpz_export_data(prio_str, prio->expr->value, BYTEORDER_HOST_ENDIAN,
+	mpz_export_data(prio_str, prio->expr->value, BYTEORDER_BIG_ENDIAN,
 			NFT_NAME_MAXLEN);
 	loc = prio->expr->location;
 
diff --git a/src/fib.c b/src/fib.c
index 4db7cd2bbc9c3..571277ddf434a 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -179,6 +179,7 @@ const struct expr_ops fib_expr_ops = {
 struct expr *fib_expr_alloc(const struct location *loc,
 			    unsigned int flags, unsigned int result)
 {
+	enum byteorder bo = BYTEORDER_HOST_ENDIAN;
 	const struct datatype *type;
 	unsigned int len = 4 * BITS_PER_BYTE;
 	struct expr *expr;
@@ -190,6 +191,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 	case NFT_FIB_RESULT_OIFNAME:
 		type = &ifname_type;
 		len = IFNAMSIZ * BITS_PER_BYTE;
+		bo = BYTEORDER_BIG_ENDIAN;
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		type = &fib_addr_type;
@@ -203,8 +205,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		len = BITS_PER_BYTE;
 	}
 
-	expr = expr_alloc(loc, EXPR_FIB, type,
-			  BYTEORDER_HOST_ENDIAN, len);
+	expr = expr_alloc(loc, EXPR_FIB, type, bo, len);
 
 	expr->fib.result = result;
 	expr->fib.flags	= flags;
diff --git a/src/intervals.c b/src/intervals.c
index a63c58ac96066..438957c52d391 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -42,8 +42,6 @@ static void setelem_expr_to_range(struct expr *expr)
 
 		mpz_init(rop);
 		mpz_bitmask(rop, expr->key->len - expr->key->prefix_len);
-		if (expr_basetype(expr)->type == TYPE_STRING)
-			mpz_switch_byteorder(expr->key->prefix->value, expr->len / BITS_PER_BYTE);
 
 		mpz_ior(rop, rop, expr->key->prefix->value);
 		key = constant_range_expr_alloc(&expr->location,
@@ -57,9 +55,6 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr->key = key;
 		break;
 	case EXPR_VALUE:
-		if (expr_basetype(expr)->type == TYPE_STRING)
-			mpz_switch_byteorder(expr->key->value, expr->len / BITS_PER_BYTE);
-
 		key = constant_range_expr_alloc(&expr->location,
 						expr->key->dtype,
 						expr->key->byteorder,
diff --git a/src/json.c b/src/json.c
index 0afce5415f541..46d8a73333374 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1220,7 +1220,7 @@ json_t *string_type_json(const struct expr *expr, struct output_ctx *octx)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len+1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	data[len] = '\0';
 
 	return json_string(data);
diff --git a/src/meta.c b/src/meta.c
index c36486029cca8..4eccb2cadf3b0 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -370,7 +370,7 @@ const struct datatype ifname_type = {
 	.type		= TYPE_IFNAME,
 	.name		= "ifname",
 	.desc		= "network interface name",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= IFNAMSIZ * BITS_PER_BYTE,
 	.basetype	= &string_type,
 };
@@ -630,14 +630,14 @@ const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SKUID]	= META_TEMPLATE("skuid",     &uid_type,
@@ -650,10 +650,10 @@ const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_BRI_IIFNAME]	= META_TEMPLATE("ibrname",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obrname",  &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",   &pkttype_type,
 						BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
@@ -676,10 +676,10 @@ const struct meta_template meta_templates[] = {
 						BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFKIND]	= META_TEMPLATE("iifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,
 						2 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
@@ -702,7 +702,7 @@ const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SDIFNAME]	= META_TEMPLATE("sdifname", &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_HOST_ENDIAN),
+						BYTEORDER_BIG_ENDIAN),
 	[NFT_META_BRI_BROUTE]	= META_TEMPLATE("broute",   &integer_type,
 						1    , BYTEORDER_HOST_ENDIAN),
 	[NFT_META_BRI_IIFHWADDR] = META_TEMPLATE("ibrhwaddr", &etheraddr_type,
diff --git a/src/mnl.c b/src/mnl.c
index ab4a7dbc8d252..6e32fc3467ce9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -748,7 +748,7 @@ static void nft_dev_add(struct nft_dev *dev_array, const struct expr *expr, int
 	if (ifname_len > sizeof(ifname))
 		BUG("Interface length %u exceeds limit\n", ifname_len);
 
-	mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN, ifname_len);
+	mpz_export_data(ifname, expr->value, BYTEORDER_BIG_ENDIAN, ifname_len);
 
 	if (strnlen(ifname, IFNAMSIZ) >= IFNAMSIZ)
 		BUG("Interface length %zu exceeds limit, no NUL byte\n", strnlen(ifname, IFNAMSIZ));
diff --git a/src/netlink.c b/src/netlink.c
index 3258f9ab9056e..2a6caa9c76565 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -487,7 +487,7 @@ static void netlink_gen_chain(const struct expr *expr,
 	memset(chain, 0, sizeof(chain));
 
 	mpz_export_data(chain, expr->chain->value,
-			BYTEORDER_HOST_ENDIAN, len);
+			BYTEORDER_BIG_ENDIAN, len);
 	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
 }
 
@@ -623,7 +623,7 @@ static struct expr *netlink_alloc_verdict(const struct location *loc,
 	case NFT_JUMP:
 	case NFT_GOTO:
 		chain = constant_expr_alloc(loc, &string_type,
-					    BYTEORDER_HOST_ENDIAN,
+					    BYTEORDER_BIG_ENDIAN,
 					    strlen(nld->chain) * BITS_PER_BYTE,
 					    nld->chain);
 		break;
@@ -1376,9 +1376,8 @@ static struct expr *concat_elem_expr(const struct set *set, struct expr *key,
 		expr->byteorder = subtype->byteorder;
 	}
 
-	if (expr_basetype(expr)->type == TYPE_STRING ||
-	    (!(set->flags & NFT_SET_INTERVAL) &&
-	     expr->byteorder == BYTEORDER_HOST_ENDIAN))
+	if (!(set->flags & NFT_SET_INTERVAL) &&
+	    expr->byteorder == BYTEORDER_HOST_ENDIAN)
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
 	if (expr->dtype->basetype != NULL &&
@@ -1623,8 +1622,7 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
 
 		data = netlink_alloc_value(&netlink_location, &nld);
 		data->dtype = &string_type;
-		data->byteorder = BYTEORDER_HOST_ENDIAN;
-		mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
+		data->byteorder = BYTEORDER_BIG_ENDIAN;
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
 out:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 990edc824ad9e..54be0682b0899 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1876,7 +1876,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 					   &nld.len);
 		expr = netlink_alloc_value(&netlink_location, &nld);
 		datatype_set(expr, &string_type);
-		expr->byteorder = BYTEORDER_HOST_ENDIAN;
+		expr->byteorder = BYTEORDER_BIG_ENDIAN;
 	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_OBJREF_SET_SREG)) {
 		struct expr *left, *right;
 		enum nft_registers sreg;
@@ -1905,7 +1905,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 
 		right = set_ref_expr_alloc(loc, set);
 		expr = map_expr_alloc(loc, left, right);
-		expr_set_type(expr, &string_type, BYTEORDER_HOST_ENDIAN);
+		expr_set_type(expr, &string_type, BYTEORDER_BIG_ENDIAN);
 		type = set->objtype;
 	} else {
 		netlink_error(ctx, loc, "unknown objref expression type %u",
@@ -2752,12 +2752,12 @@ static struct expr *string_wildcard_expr_alloc(struct location *loc,
 	char data[len + 2];
 	int pos;
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 	pos = div_round_up(expr_mask_to_prefix(mask), BITS_PER_BYTE);
 	data[pos] = '*';
 	data[pos + 1] = '\0';
 
-	return constant_expr_alloc(loc, expr->dtype, BYTEORDER_HOST_ENDIAN,
+	return constant_expr_alloc(loc, expr->dtype, BYTEORDER_BIG_ENDIAN,
 				   expr->len + BITS_PER_BYTE, data);
 }
 
@@ -2770,7 +2770,7 @@ static bool __expr_postprocess_string(struct expr **exprp)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len + 1];
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
 
 	if (data[len - 1] != '\0')
 		return false;
@@ -2781,7 +2781,7 @@ static bool __expr_postprocess_string(struct expr **exprp)
 		data[len]	= '*';
 		data[len + 1]	= '\0';
 		expr = constant_expr_alloc(&expr->location, expr->dtype,
-					   BYTEORDER_HOST_ENDIAN,
+					   BYTEORDER_BIG_ENDIAN,
 					   (len + 2) * BITS_PER_BYTE, data);
 		expr_free(*exprp);
 		*exprp = expr;
@@ -2799,7 +2799,7 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 		return expr;
 
 	mask = constant_expr_alloc(&expr->location, &integer_type,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   expr->len + BITS_PER_BYTE, NULL);
 	mpz_clear(mask->value);
 	mpz_init_bitmask(mask->value, expr->len);
diff --git a/src/osf.c b/src/osf.c
index a8f80b2bbaacb..2ff8490ae1790 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -75,8 +75,7 @@ struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
 	const struct datatype *type = &string_type;
 	struct expr *expr;
 
-	expr = expr_alloc(loc, EXPR_OSF, type,
-			  BYTEORDER_HOST_ENDIAN, len);
+	expr = expr_alloc(loc, EXPR_OSF, type, BYTEORDER_BIG_ENDIAN, len);
 	expr->osf.ttl = ttl;
 	expr->osf.flags = flags;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3c21c7584d01f..8e34b86a0f400 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -176,7 +176,7 @@ static struct expr *ifname_expr_alloc(const struct location *location,
 		return NULL;
 	}
 
-	expr = constant_expr_alloc(location, &ifname_type, BYTEORDER_HOST_ENDIAN,
+	expr = constant_expr_alloc(location, &ifname_type, BYTEORDER_BIG_ENDIAN,
 				   length * BITS_PER_BYTE, name);
 
 	free_const(name);
@@ -2800,7 +2800,7 @@ extended_prio_spec	:	int_num
 				struct prio_spec spec = {0};
 
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen($1) * BITS_PER_BYTE,
 								$1);
 				free_const($1);
@@ -2813,7 +2813,7 @@ extended_prio_spec	:	int_num
 				char str[NFT_NAME_MAXLEN];
 				snprintf(str, sizeof(str), "%s + %" PRIu64, $1, $3);
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
 				free_const($1);
@@ -2826,7 +2826,7 @@ extended_prio_spec	:	int_num
 
 				snprintf(str, sizeof(str), "%s - %" PRIu64, $1, $3);
 				spec.expr = constant_expr_alloc(&@$, &string_type,
-								BYTEORDER_HOST_ENDIAN,
+								BYTEORDER_BIG_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
 				free_const($1);
@@ -5471,7 +5471,7 @@ chain_expr		:	variable_expr
 			|	identifier
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
+							 BYTEORDER_BIG_ENDIAN,
 							 strlen($1) * BITS_PER_BYTE,
 							 $1);
 				free_const($1);
diff --git a/src/parser_json.c b/src/parser_json.c
index e78262505d243..a7d6a0f5997c1 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1412,7 +1412,7 @@ static struct expr *json_alloc_chain_expr(const char *chain)
 	if (!chain)
 		return NULL;
 
-	return constant_expr_alloc(int_loc, &string_type, BYTEORDER_HOST_ENDIAN,
+	return constant_expr_alloc(int_loc, &string_type, BYTEORDER_BIG_ENDIAN,
 				   strlen(chain) * BITS_PER_BYTE, chain);
 }
 
@@ -3020,7 +3020,7 @@ static struct expr *ifname_expr_alloc(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	return constant_expr_alloc(int_loc, &ifname_type, BYTEORDER_HOST_ENDIAN,
+	return constant_expr_alloc(int_loc, &ifname_type, BYTEORDER_BIG_ENDIAN,
 				   length * BITS_PER_BYTE, name);
 }
 
diff --git a/src/segtree.c b/src/segtree.c
index 88207a3987b8f..b9c35dcb297ce 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -33,7 +33,7 @@ static enum byteorder get_key_byteorder(const struct expr *e)
 		 */
 		return BYTEORDER_BIG_ENDIAN;
 	case TYPE_STRING:
-		return BYTEORDER_HOST_ENDIAN;
+		return BYTEORDER_BIG_ENDIAN;
 	default:
 		break;
 	}
@@ -201,7 +201,7 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	data[str_len] = '*';
 
 	expr = constant_expr_alloc(&e->location, e->dtype,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   (str_len + 1) * BITS_PER_BYTE, data);
 
 	return __expr_to_set_elem(e, expr);
@@ -412,11 +412,11 @@ void concat_range_aggregate(struct expr *set)
 				unsigned int str_len = prefix_len / BITS_PER_BYTE;
 				char data[str_len + 2];
 
-				mpz_export_data(data, r1->value, BYTEORDER_HOST_ENDIAN, str_len);
+				mpz_export_data(data, r1->value, BYTEORDER_BIG_ENDIAN, str_len);
 				data[str_len] = '*';
 
 				tmp = constant_expr_alloc(&r1->location, r1->dtype,
-							  BYTEORDER_HOST_ENDIAN,
+							  BYTEORDER_BIG_ENDIAN,
 							  (str_len + 1) * BITS_PER_BYTE, data);
 				tmp->len = r2->len;
 				list_replace(&r2->list, &tmp->list);
@@ -495,7 +495,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
 	data[str_len] = '*';
 
 	expr = constant_expr_alloc(&low->location, low->dtype,
-				   BYTEORDER_HOST_ENDIAN,
+				   BYTEORDER_BIG_ENDIAN,
 				   len * BITS_PER_BYTE, data);
 
 	return __expr_to_set_elem(low, expr);
-- 
2.51.0

