Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDBBCA0ECA
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 07:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjILHeI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjILHeH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 03:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7FDCB9
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 00:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694503996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v+iAfsPFvjsfzPDGcD9KtNl/ttnFxu7eVs0sCPKeV4w=;
        b=ipmyQti7zwJXldTo3Ca/pyIRfsKR2UrUXuOZLiGdPHsJoR+jQnSvi7aeh96Q7NPIA5q2te
        8NWHoZw00lwPe53IIkBAaRqnHy3U6XZyoNb8y/AAIINKjteC8Vb9Y4kQ6JfWXLnjsDUPiq
        fgZ8cjj2yXeV7GcsSW0o5jBeSytxhak=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-v7fIlodkNaygoghPifIsng-1; Tue, 12 Sep 2023 03:33:15 -0400
X-MC-Unique: v7fIlodkNaygoghPifIsng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 193C63C0E21F
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 07:33:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AA5C2156721;
        Tue, 12 Sep 2023 07:33:14 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2] datatype: fix leak and cleanup reference counting for struct datatype
Date:   Tue, 12 Sep 2023 09:30:54 +0200
Message-ID: <20230912073304.1962613-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test `./tests/shell/run-tests.sh -V tests/shell/testcases/maps/nat_addr_port`
fails:

==118== 195 (112 direct, 83 indirect) bytes in 1 blocks are definitely lost in loss record 3 of 3
==118==    at 0x484682C: calloc (vg_replace_malloc.c:1554)
==118==    by 0x48A39DD: xmalloc (utils.c:37)
==118==    by 0x48A39DD: xzalloc (utils.c:76)
==118==    by 0x487BDFD: datatype_alloc (datatype.c:1205)
==118==    by 0x487BDFD: concat_type_alloc (datatype.c:1288)
==118==    by 0x488229D: stmt_evaluate_nat_map (evaluate.c:3786)
==118==    by 0x488229D: stmt_evaluate_nat (evaluate.c:3892)
==118==    by 0x488229D: stmt_evaluate (evaluate.c:4450)
==118==    by 0x488328E: rule_evaluate (evaluate.c:4956)
==118==    by 0x48ADC71: nft_evaluate (libnftables.c:552)
==118==    by 0x48AEC29: nft_run_cmd_from_buffer (libnftables.c:595)
==118==    by 0x402983: main (main.c:534)

I think the reference handling for datatype is wrong. It was introduced
by commit 01a13882bb59 ('src: add reference counter for dynamic
datatypes').

We don't notice it most of the time, because instances are statically
allocated, where datatype_get()/datatype_free() is a NOP.

Fix and rework.

- Commit 01a13882bb59 comments "The reference counter of any newly
  allocated datatype is set to zero". That seems not workable.
  Previously, functions like datatype_clone() would have returned the
  refcnt set to zero. Some callers would then then set the refcnt to one, but
  some wouldn't (set_datatype_alloc()). Calling datatype_free() with a
  refcnt of zero will overflow to UINT_MAX and leak:

       if (--dtype->refcnt > 0)
          return;

  While there could be schemes with such asymmetric counting that juggle the
  appropriate number of datatype_get() and datatype_free() calls, this is
  confusing and error prone. The common pattern is that every
  alloc/clone/get/ref is paired with exactly one unref/free.

  Let datatype_clone() return references with refcnt set 1 and in
  general be always clear about where we transfer ownership (take a
  reference) and where we need to release it.

- set_datatype_alloc() needs to consistently return ownership to the
  reference. Previously, some code paths would and others wouldn't.

- Replace

    datatype_set(key, set_datatype_alloc(dtype, key->byteorder))

  with a __datatype_set() with takes ownership.

Signed-off-by: Thomas Haller <thaller@redhat.com>

Fixes: 01a13882bb59 ('src: add reference counter for dynamic datatypes')
---
Changes to v1:
- rename datatype_set_take() to __datatype_set()
- drop goto-out from expr_evaluate_map().
- drop first goto-out from netlink_delinearize_set().
- update code comments to move closing */ to next line.
- reword commit message.

 include/datatype.h        |  1 +
 include/expression.h      |  4 +++
 src/datatype.c            | 23 ++++++++++----
 src/evaluate.c            | 66 ++++++++++++++++++++++++---------------
 src/expression.c          |  2 +-
 src/netlink.c             | 31 +++++++++---------
 src/netlink_delinearize.c |  2 +-
 src/payload.c             |  3 +-
 8 files changed, 82 insertions(+), 50 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 6146eda1d2ec..52a2e943b252 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -176,6 +176,7 @@ extern const struct datatype *datatype_lookup(enum datatypes type);
 extern const struct datatype *datatype_lookup_byname(const char *name);
 extern struct datatype *datatype_get(const struct datatype *dtype);
 extern void datatype_set(struct expr *expr, const struct datatype *dtype);
+extern void __datatype_set(struct expr *expr, const struct datatype *dtype);
 extern void datatype_free(const struct datatype *dtype);
 struct datatype *datatype_clone(const struct datatype *orig_dtype);
 
diff --git a/include/expression.h b/include/expression.h
index 733dd3cfc89c..469f41ecd613 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -120,7 +120,11 @@ enum symbol_types {
  * @maxval:	expected maximum value
  */
 struct expr_ctx {
+	/* expr_ctx does not own the reference to dtype. The caller must ensure
+	 * the valid lifetime.
+	 */
 	const struct datatype	*dtype;
+
 	enum byteorder		byteorder;
 	unsigned int		len;
 	unsigned int		maxval;
diff --git a/src/datatype.c b/src/datatype.c
index 678a16b1f3af..70c84846f70e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1204,6 +1204,7 @@ static struct datatype *datatype_alloc(void)
 
 	dtype = xzalloc(sizeof(*dtype));
 	dtype->flags = DTYPE_F_ALLOC;
+	dtype->refcnt = 1;
 
 	return dtype;
 }
@@ -1221,12 +1222,19 @@ struct datatype *datatype_get(const struct datatype *ptr)
 	return dtype;
 }
 
+void __datatype_set(struct expr *expr, const struct datatype *dtype)
+{
+	const struct datatype *dtype_free;
+
+	dtype_free = expr->dtype;
+	expr->dtype = dtype;
+	datatype_free(dtype_free);
+}
+
 void datatype_set(struct expr *expr, const struct datatype *dtype)
 {
-	if (dtype == expr->dtype)
-		return;
-	datatype_free(expr->dtype);
-	expr->dtype = datatype_get(dtype);
+	if (dtype != expr->dtype)
+		__datatype_set(expr, datatype_get(dtype));
 }
 
 struct datatype *datatype_clone(const struct datatype *orig_dtype)
@@ -1238,7 +1246,7 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
 	dtype->name = xstrdup(orig_dtype->name);
 	dtype->desc = xstrdup(orig_dtype->desc);
 	dtype->flags = DTYPE_F_ALLOC | orig_dtype->flags;
-	dtype->refcnt = 0;
+	dtype->refcnt = 1;
 
 	return dtype;
 }
@@ -1251,6 +1259,9 @@ void datatype_free(const struct datatype *ptr)
 		return;
 	if (!(dtype->flags & DTYPE_F_ALLOC))
 		return;
+
+	assert(dtype->refcnt != 0);
+
 	if (--dtype->refcnt > 0)
 		return;
 
@@ -1303,7 +1314,7 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
 
 	/* Restrict dynamic datatype allocation to generic integer datatype. */
 	if (orig_dtype != &integer_type)
-		return orig_dtype;
+		return datatype_get(orig_dtype);
 
 	dtype = datatype_clone(orig_dtype);
 	dtype->byteorder = byteorder;
diff --git a/src/evaluate.c b/src/evaluate.c
index b0c6919f600a..897e13317630 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -82,7 +82,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
 	if (dtype->byteorder == key->byteorder)
 		return;
 
-	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
+	__datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
 }
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set);
@@ -1521,8 +1521,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			clone = datatype_clone(i->dtype);
 			clone->size = i->len;
 			clone->byteorder = i->byteorder;
-			clone->refcnt = 1;
-			i->dtype = clone;
+			__datatype_set(i, clone);
 		}
 
 		if (dtype == NULL && i->dtype->size == 0)
@@ -1550,7 +1549,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	(*expr)->flags |= flags;
-	datatype_set(*expr, concat_type_alloc(ntype));
+	__datatype_set(*expr, concat_type_alloc(ntype));
 	(*expr)->len   = size;
 
 	if (off > 0)
@@ -1888,7 +1887,6 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *map = *expr, *mappings;
 	struct expr_ctx ectx = ctx->ectx;
-	const struct datatype *dtype;
 	struct expr *key, *data;
 
 	if (map->map->etype == EXPR_CT &&
@@ -1930,12 +1928,16 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 						  ctx->ectx.len, NULL);
 		}
 
-		dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
-		if (dtype->type == TYPE_VERDICT)
+		if (ectx.dtype->type == TYPE_VERDICT)
 			data = verdict_expr_alloc(&netlink_location, 0, NULL);
-		else
+		else {
+			const struct datatype *dtype;
+
+			dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
 			data = constant_expr_alloc(&netlink_location, dtype,
 						   dtype->byteorder, ectx.len, NULL);
+			datatype_free(dtype);
+		}
 
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
@@ -3765,8 +3767,10 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	struct expr *one, *two, *data, *tmp;
-	const struct datatype *dtype;
-	int addr_type, err;
+	const struct datatype *dtype = NULL;
+	const struct datatype *dtype2;
+	int addr_type;
+	int err;
 
 	if (stmt->nat.family == NFPROTO_INET)
 		expr_family_infer(pctx, stmt->nat.addr, &stmt->nat.family);
@@ -3786,18 +3790,23 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	dtype = concat_type_alloc((addr_type << TYPE_BITS) | TYPE_INET_SERVICE);
 
 	expr_set_context(&ctx->ectx, dtype, dtype->size);
-	if (expr_evaluate(ctx, &stmt->nat.addr))
-		return -1;
+	if (expr_evaluate(ctx, &stmt->nat.addr)) {
+		err = -1;
+		goto out;
+	}
 
 	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
 	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr)) {
-		return stmt_binary_error(ctx, stmt->nat.addr, stmt,
+		err = stmt_binary_error(ctx, stmt->nat.addr, stmt,
 					 "transport protocol mapping is only "
 					 "valid after transport protocol match");
+		goto out;
 	}
 
-	if (stmt->nat.addr->etype != EXPR_MAP)
-		return 0;
+	if (stmt->nat.addr->etype != EXPR_MAP) {
+		err = 0;
+		goto out;
+	}
 
 	data = stmt->nat.addr->mappings->set->data;
 	if (data->flags & EXPR_F_INTERVAL)
@@ -3805,36 +3814,42 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 	datatype_set(data, dtype);
 
-	if (expr_ops(data)->type != EXPR_CONCAT)
-		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+	if (expr_ops(data)->type != EXPR_CONCAT) {
+		err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
 					   BYTEORDER_BIG_ENDIAN,
 					   &stmt->nat.addr);
+		goto out;
+	}
 
 	one = list_first_entry(&data->expressions, struct expr, list);
 	two = list_entry(one->list.next, struct expr, list);
 
-	if (one == two || !list_is_last(&two->list, &data->expressions))
-		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+	if (one == two || !list_is_last(&two->list, &data->expressions)) {
+		err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
 					   BYTEORDER_BIG_ENDIAN,
 					   &stmt->nat.addr);
+		goto out;
+	}
 
-	dtype = get_addr_dtype(stmt->nat.family);
+	dtype2 = get_addr_dtype(stmt->nat.family);
 	tmp = one;
-	err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
+	err = __stmt_evaluate_arg(ctx, stmt, dtype2, dtype2->size,
 				  BYTEORDER_BIG_ENDIAN,
 				  &tmp);
 	if (err < 0)
-		return err;
+		goto out;
 	if (tmp != one)
 		BUG("Internal error: Unexpected alteration of l3 expression");
 
 	tmp = two;
 	err = nat_evaluate_transport(ctx, stmt, &tmp);
 	if (err < 0)
-		return err;
+		goto out;
 	if (tmp != two)
 		BUG("Internal error: Unexpected alteration of l4 expression");
 
+out:
+	datatype_free(dtype);
 	return err;
 }
 
@@ -4549,8 +4564,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 			dtype = datatype_clone(i->dtype);
 			dtype->size = i->len;
 			dtype->byteorder = i->byteorder;
-			dtype->refcnt = 1;
-			i->dtype = dtype;
+			__datatype_set(i, dtype);
 		}
 
 		if (i->dtype->size == 0 && i->len == 0)
@@ -4573,7 +4587,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	(*expr)->flags |= flags;
-	datatype_set(*expr, concat_type_alloc(ntype));
+	__datatype_set(*expr, concat_type_alloc(ntype));
 	(*expr)->len   = size;
 
 	expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->len);
diff --git a/src/expression.c b/src/expression.c
index cb222a2b08b9..87d5a9fcbe09 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1013,7 +1013,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
 	if (!dtype)
 		goto err_free;
 
-	concat_expr->dtype = datatype_get(dtype);
+	__datatype_set(concat_expr, dtype);
 	concat_expr->len = len;
 
 	return concat_expr;
diff --git a/src/netlink.c b/src/netlink.c
index 59cde9a48313..4d3c1cf1505d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -798,6 +798,10 @@ enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype)
 
 static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 {
+	/* The function always returns ownership of a reference. But for
+	 * &verdict_Type and datatype_lookup(), those are static instances,
+	 * we can omit the datatype_get() call.
+	 */
 	switch (type) {
 	case NFT_DATA_VERDICT:
 		return &verdict_type;
@@ -933,12 +937,14 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
-	const struct datatype *keytype, *datatype = NULL;
 	struct expr *typeof_expr_key, *typeof_expr_data;
 	struct setelem_parse_ctx set_parse_ctx;
+	const struct datatype *datatype = NULL;
+	const struct datatype *keytype = NULL;
+	const struct datatype *dtype2 = NULL;
+	const struct datatype *dtype = NULL;
 	const char *udata, *comment = NULL;
 	uint32_t flags, key, objtype = 0;
-	const struct datatype *dtype;
 	uint32_t data_interval = 0;
 	bool automerge = false;
 	struct set *set;
@@ -990,8 +996,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			netlink_io_error(ctx, NULL,
 					 "Unknown data type in set key %u",
 					 data);
-			datatype_free(keytype);
-			return NULL;
+			set = NULL;
+			goto out;
 		}
 	}
 
@@ -1029,19 +1035,18 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	if (datatype) {
 		uint32_t dlen;
 
-		dtype = set_datatype_alloc(datatype, databyteorder);
+		dtype2 = set_datatype_alloc(datatype, databyteorder);
 		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
 
 		dlen = data_interval ?  klen / 2 : klen;
 
 		if (set_udata_key_valid(typeof_expr_data, dlen)) {
 			typeof_expr_data->len = klen;
-			datatype_free(datatype_get(dtype));
 			set->data = typeof_expr_data;
 		} else {
 			expr_free(typeof_expr_data);
 			set->data = constant_expr_alloc(&netlink_location,
-							dtype,
+							dtype2,
 							databyteorder, klen,
 							NULL);
 
@@ -1052,16 +1057,12 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 		if (data_interval)
 			set->data->flags |= EXPR_F_INTERVAL;
-
-		if (dtype != datatype)
-			datatype_free(datatype);
 	}
 
 	dtype = set_datatype_alloc(keytype, keybyteorder);
 	klen = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
 
 	if (set_udata_key_valid(typeof_expr_key, klen)) {
-		datatype_free(datatype_get(dtype));
 		set->key = typeof_expr_key;
 		set->key_typeof_valid = true;
 	} else {
@@ -1071,9 +1072,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					       NULL);
 	}
 
-	if (dtype != keytype)
-		datatype_free(keytype);
-
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 
@@ -1101,6 +1099,11 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		}
 	}
 
+out:
+	datatype_free(datatype);
+	datatype_free(keytype);
+	datatype_free(dtype2);
+	datatype_free(dtype);
 	return set;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 19c3f0bd0b26..41cb37a3ccb3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2768,7 +2768,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		}
 		ctx->flags &= ~RULE_PP_IN_CONCATENATION;
 		list_splice(&tmp, &expr->expressions);
-		datatype_set(expr, concat_type_alloc(ntype));
+		__datatype_set(expr, concat_type_alloc(ntype));
 		break;
 	}
 	case EXPR_UNARY:
diff --git a/src/payload.c b/src/payload.c
index dcd87485c068..a02942b3382a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -253,8 +253,7 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
 		dtype = datatype_clone(&xinteger_type);
 		dtype->size = len;
 		dtype->byteorder = BYTEORDER_BIG_ENDIAN;
-		dtype->refcnt = 1;
-		expr->dtype = dtype;
+		__datatype_set(expr, dtype);
 	}
 
 	if (ud[NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC]) {
-- 
2.41.0

