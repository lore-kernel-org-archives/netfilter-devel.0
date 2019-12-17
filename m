Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2F0C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289B12146E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLQL1r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:47 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57350 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfLQL1q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:46 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB0y-0006lV-51; Tue, 17 Dec 2019 12:27:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v3 06/10] src: add "typeof" build/parse/print support
Date:   Tue, 17 Dec 2019 12:27:09 +0100
Message-Id: <20191217112713.6017-7-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds two new expression operations to build and to parse the
userdata area that describe the set key and data typeof definitions.

For maps, the grammar enforces either

"type data_type : data_type" or or "typeof expression : expression".

Check both key and data for valid user typeof info first.
If they check out, flag set->key_typeof_valid as true and use it for
printing the key info.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h |   4 ++
 include/rule.h       |   1 +
 src/mnl.c            |  24 ++++++++
 src/netlink.c        | 129 ++++++++++++++++++++++++++++++++++++++-----
 src/payload.c        |  75 +++++++++++++++++++++++++
 src/rule.c           |  42 +++++++++++---
 6 files changed, 255 insertions(+), 20 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index d502fc2a8611..b3e79c490b1a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -10,6 +10,7 @@
 #include <utils.h>
 #include <list.h>
 #include <json.h>
+#include <libnftnl/udata.h>
 
 /**
  * enum expr_types
@@ -166,6 +167,9 @@ struct expr_ops {
 				       const struct expr *e2);
 	void			(*pctx_update)(struct proto_ctx *ctx,
 					       const struct expr *expr);
+	int			(*build_udata)(struct nftnl_udata_buf *udbuf,
+					       const struct expr *expr);
+	struct expr *		(*parse_udata)(const struct nftnl_udata *ud);
 };
 
 const struct expr_ops *expr_ops(const struct expr *e);
diff --git a/include/rule.h b/include/rule.h
index ce1f40db031e..6301fe35b591 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -307,6 +307,7 @@ struct set {
 	uint32_t		policy;
 	bool			root;
 	bool			automerge;
+	bool			key_typeof_valid;
 	struct {
 		uint32_t	size;
 	} desc;
diff --git a/src/mnl.c b/src/mnl.c
index 06b790c01acc..03afe79c23a8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -811,6 +811,26 @@ err:
 	return NULL;
 }
 
+static void set_key_expression(struct netlink_ctx *ctx,
+				struct expr *expr, uint32_t set_flags,
+				struct nftnl_udata_buf *udbuf,
+				unsigned int type)
+{
+	struct nftnl_udata *nest1, *nest2;
+
+	if (expr->flags & EXPR_F_CONSTANT ||
+	    set_flags & NFT_SET_ANONYMOUS ||
+	    !expr_ops(expr)->build_udata)
+		return;
+
+	nest1 = nftnl_udata_nest_start(udbuf, type);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_TYPEOF_EXPR, expr->etype);
+	nest2 = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_TYPEOF_DATA);
+	expr_ops(expr)->build_udata(udbuf, expr);
+	nftnl_udata_nest_end(udbuf, nest2);
+	nftnl_udata_nest_end(udbuf, nest1);
+}
+
 /*
  * Set
  */
@@ -881,6 +901,10 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				 set->automerge))
 		memory_allocation_error();
 
+	set_key_expression(ctx, set->key, set->flags, udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
+	if (set->data)
+		set_key_expression(ctx, set->data, set->flags, udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/netlink.c b/src/netlink.c
index 46897e43e723..a9ccebaf8efd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -27,11 +27,13 @@
 #include <libnftnl/udata.h>
 #include <libnftnl/ruleset.h>
 #include <libnftnl/common.h>
+#include <libnftnl/udata.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
 
 #include <nftables.h>
+#include <parser.h>
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
@@ -570,6 +572,31 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
+	case NFTNL_UDATA_SET_KEY_TYPEOF:
+	case NFTNL_UDATA_SET_DATA_TYPEOF:
+		if (len < 3)
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+	tb[type] = attr;
+	return 0;
+}
+
+static int set_key_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **tb = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_SET_TYPEOF_EXPR:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	case NFTNL_UDATA_SET_TYPEOF_DATA:
+		break;
 	default:
 		return 0;
 	}
@@ -577,6 +604,44 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static struct expr *set_make_key(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_TYPEOF_MAX + 1] = {};
+	const struct expr_ops *ops;
+	enum expr_types etype;
+	struct expr *expr;
+	int err;
+
+	if (!attr)
+		return NULL;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				set_key_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_SET_TYPEOF_EXPR] ||
+	    !ud[NFTNL_UDATA_SET_TYPEOF_DATA])
+		return NULL;
+
+	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
+	ops = expr_ops_by_type(etype);
+
+	expr = ops->parse_udata(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
+	if (!expr)
+		return NULL;
+
+	return expr;
+}
+
+static bool set_udata_key_valid(const struct expr *e, const struct datatype *d, uint32_t len)
+{
+	if (!e)
+		return false;
+
+	return div_round_up(e->len, BITS_PER_BYTE) == len / BITS_PER_BYTE;
+}
+
 struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				    const struct nftnl_set *nls)
 {
@@ -584,11 +649,17 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype = NULL;
+	struct expr *typeof_expr_key, *typeof_expr_data;
 	uint32_t flags, key, objtype = 0;
+	const struct datatype *dtype;
 	bool automerge = false;
 	const char *udata;
 	struct set *set;
 	uint32_t ulen;
+	uint32_t klen;
+
+	typeof_expr_key = NULL;
+	typeof_expr_data = NULL;
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_USERDATA)) {
 		udata = nftnl_set_get_data(nls, NFTNL_SET_USERDATA, &ulen);
@@ -606,6 +677,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
 
 #undef GET_U32_UDATA
+		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_KEY_TYPEOF]);
+		if (ud[NFTNL_UDATA_SET_DATA_TYPEOF])
+			typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_DATA_TYPEOF]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -626,12 +700,14 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			netlink_io_error(ctx, NULL,
 					 "Unknown data type in set key %u",
 					 data);
+			datatype_free(keytype);
 			return NULL;
 		}
 	}
 
 	if (set_is_objmap(flags)) {
 		objtype = nftnl_set_get_u32(nls, NFTNL_SET_OBJ_TYPE);
+		assert(!datatype);
 		datatype = &string_type;
 	}
 
@@ -641,24 +717,51 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
 
-	set->key     = constant_expr_alloc(&netlink_location,
-					   set_datatype_alloc(keytype, keybyteorder),
-					   keybyteorder,
-					   nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
-					   NULL);
+	if (datatype) {
+		dtype = set_datatype_alloc(datatype, databyteorder);
+		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
+
+		if (set_udata_key_valid(typeof_expr_data, dtype, klen)) {
+			datatype_free(datatype_get(dtype));
+			set->data = typeof_expr_data;
+		} else {
+			expr_free(typeof_expr_data);
+			set->data = constant_expr_alloc(&netlink_location,
+							dtype,
+							databyteorder, klen,
+							NULL);
+
+			/* Can't use 'typeof' keyword, so discard key too */
+			expr_free(typeof_expr_key);
+			typeof_expr_key = NULL;
+		}
+
+		if (dtype != datatype)
+			datatype_free(datatype);
+	}
+
+	dtype = set_datatype_alloc(keytype, keybyteorder);
+	klen = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
+
+	if (set_udata_key_valid(typeof_expr_key, dtype, klen)) {
+		datatype_free(datatype_get(dtype));
+		set->key = typeof_expr_key;
+		set->key_typeof_valid = true;
+	} else {
+		expr_free(typeof_expr_key);
+		set->key = constant_expr_alloc(&netlink_location, dtype,
+					       keybyteorder, klen,
+					       NULL);
+	}
+
+	if (dtype != keytype)
+		datatype_free(keytype);
+
 	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
 	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 
 	set->objtype = objtype;
 
-	set->data = NULL;
-	if (datatype)
-		set->data = constant_expr_alloc(&netlink_location,
-						set_datatype_alloc(datatype, databyteorder),
-						databyteorder,
-						nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE,
-						NULL);
-
 	if (nftnl_set_is_set(nls, NFTNL_SET_TIMEOUT))
 		set->timeout = nftnl_set_get_u64(nls, NFTNL_SET_TIMEOUT);
 	if (nftnl_set_is_set(nls, NFTNL_SET_GC_INTERVAL))
diff --git a/src/payload.c b/src/payload.c
index 3576400bbfc8..29242537237e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -105,6 +105,79 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	proto_ctx_update(ctx, desc->base, &expr->location, desc);
 }
 
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_DESC 0
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE 1
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_MAX 2
+
+static unsigned int expr_payload_type(const struct proto_desc *desc,
+				      const struct proto_hdr_template *tmpl)
+{
+	return (unsigned int)(tmpl - &desc->templates[0]);
+}
+
+static int payload_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				    const struct expr *expr)
+{
+	const struct proto_hdr_template *tmpl = expr->payload.tmpl;
+	const struct proto_desc *desc = expr->payload.desc;
+	unsigned int type = expr_payload_type(desc, tmpl);
+
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_DESC, desc->id);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE, type);
+
+	return 0;
+}
+
+static const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud)
+{
+	return proto_find_desc(nftnl_udata_get_u32(ud));
+}
+
+static int payload_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+	case NFTNL_UDATA_SET_KEY_PAYLOAD_DESC:
+	case NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+	return 0;
+}
+
+static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_KEY_PAYLOAD_MAX + 1] = {};
+	const struct proto_desc *desc;
+	unsigned int type;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				payload_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_SET_KEY_PAYLOAD_DESC] ||
+	    !ud[NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE])
+		return NULL;
+
+	desc = find_proto_desc(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_DESC]);
+	if (!desc)
+		return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE]);
+
+	return payload_expr_alloc(&internal_location, desc, type);
+}
+
 const struct expr_ops payload_expr_ops = {
 	.type		= EXPR_PAYLOAD,
 	.name		= "payload",
@@ -113,6 +186,8 @@ const struct expr_ops payload_expr_ops = {
 	.cmp		= payload_expr_cmp,
 	.clone		= payload_expr_clone,
 	.pctx_update	= payload_expr_pctx_update,
+	.build_udata	= payload_expr_build_udata,
+	.parse_udata	= payload_expr_parse_udata,
 };
 
 /*
diff --git a/src/rule.c b/src/rule.c
index f8cd4a73054b..57f1fc838399 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -438,6 +438,38 @@ const char *set_policy2str(uint32_t policy)
 	}
 }
 
+static void set_print_key(const struct expr *expr, struct output_ctx *octx)
+{
+	const struct datatype *dtype = expr->dtype;
+
+	if (dtype->size || dtype->type == TYPE_VERDICT)
+		nft_print(octx, "%s", dtype->name);
+	else
+		expr_print(expr, octx);
+}
+
+static void set_print_key_and_data(const struct set *set, struct output_ctx *octx)
+{
+	bool use_typeof = set->key_typeof_valid;
+
+	nft_print(octx, "%s ", use_typeof ? "typeof" : "type");
+
+	if (use_typeof)
+		expr_print(set->key, octx);
+	else
+		set_print_key(set->key, octx);
+
+	if (set_is_datamap(set->flags)) {
+		nft_print(octx, " : ");
+		if (use_typeof)
+			expr_print(set->data, octx);
+		else
+			set_print_key(set->data, octx);
+	} else if (set_is_objmap(set->flags)) {
+		nft_print(octx, " : %s", obj_type_name(set->objtype));
+	}
+}
+
 static void set_print_declaration(const struct set *set,
 				  struct print_fmt_options *opts,
 				  struct output_ctx *octx)
@@ -465,13 +497,9 @@ static void set_print_declaration(const struct set *set,
 
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, set->handle.handle.id);
-	nft_print(octx, "%s", opts->nl);
-	nft_print(octx, "%s%stype %s",
-		  opts->tab, opts->tab, set->key->dtype->name);
-	if (set_is_datamap(set->flags))
-		nft_print(octx, " : %s", set->data->dtype->name);
-	else if (set_is_objmap(set->flags))
-		nft_print(octx, " : %s", obj_type_name(set->objtype));
+	nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
+
+	set_print_key_and_data(set, octx);
 
 	nft_print(octx, "%s", opts->stmt_separator);
 
-- 
2.24.1

