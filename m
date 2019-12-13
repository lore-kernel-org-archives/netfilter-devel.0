Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDA6C341DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AACE24728
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfLMQEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:04:05 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40348 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728164AbfLMQEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 11:04:05 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifnQA-0004Db-Sy; Fri, 13 Dec 2019 17:04:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 06/11] src: add "typeof" print support
Date:   Fri, 13 Dec 2019 17:03:40 +0100
Message-Id: <20191213160345.30057-7-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213160345.30057-1-fw@strlen.de>
References: <20191213160345.30057-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the 'udata' facility to store the original string in the kernel,
then use the existing 'describe' facility to resolve it back to a name.

This isn't strictly required, we can fall back to the 'type, width'
format where needed.  This can happen in any of these cases:

 - no udata description
 - unknown expression/udata has garbage string
 - udata is inconsistent (udata expression maps to a data type with a
   different size than the set key size)

'type, width' allows to list and restore sets even if the original
'typeof' expression description gets lost.

Because the grammar enforces (for maps), to use either

type data_type : data_type
or
typeof expression : expression

we need to check both key and data for a valid descriptive name.
If both check out, flag set->key_typeof_valid as true, then use that
during printing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h |   1 +
 src/mnl.c      |  33 ++++++++++
 src/netlink.c  | 163 +++++++++++++++++++++++++++++++++++++++++++++----
 src/rule.c     |  38 ++++++++----
 4 files changed, 211 insertions(+), 24 deletions(-)

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
index 06b790c01acc..75113c74c224 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -811,6 +811,35 @@ err:
 	return NULL;
 }
 
+static void set_key_expression(struct netlink_ctx *ctx,
+				struct expr *expr, uint32_t set_flags,
+				struct nftnl_udata_buf *udbuf,
+				unsigned int type)
+{
+	struct output_ctx octx = {};
+	char buf[64];
+
+	if (expr->flags & EXPR_F_CONSTANT ||
+	    set_flags & NFT_SET_ANONYMOUS)
+		return;
+
+	buf[0] = 0;
+	/* Set definition uses typeof to define datatype. */
+	octx.output_fp = fmemopen(buf, sizeof(buf), "w");
+	if (octx.output_fp) {
+		char *end;
+
+		expr_print(expr, &octx);
+		fclose(octx.output_fp);
+		end = strchr(buf, '&');
+		if (end)
+			* end = 0;
+
+		if (!nftnl_udata_put(udbuf, type, strlen(buf) + 1, buf))
+			memory_allocation_error();
+	}
+}
+
 /*
  * Set
  */
@@ -881,6 +910,10 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				 set->automerge))
 		memory_allocation_error();
 
+	set_key_expression(ctx, set->key, set->flags, udbuf, NFTNL_UDATA_SET_TYPEOF_KEY);
+	if (set->data)
+		set_key_expression(ctx, set->data, set->flags, udbuf, NFTNL_UDATA_SET_TYPEOF_DATA);
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/netlink.c b/src/netlink.c
index 46897e43e723..790c663ccd6d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -32,6 +32,7 @@
 #include <linux/netfilter.h>
 
 #include <nftables.h>
+#include <parser.h>
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
@@ -570,6 +571,11 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
+	case NFTNL_UDATA_SET_TYPEOF_KEY:
+	case NFTNL_UDATA_SET_TYPEOF_DATA:
+		if (len < 3)
+			return -1;
+		break;
 	default:
 		return 0;
 	}
@@ -577,6 +583,98 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int parse_desc(struct nft_ctx *nft, const char *buf, struct list_head *cmds)
+{
+	static const struct input_descriptor indesc_udata = {
+		.type	= INDESC_BUFFER,
+		.name	= "<setudata>",
+	};
+	struct error_record *erec, *nexte;
+	LIST_HEAD(errors);
+	int ret;
+
+	parser_init(nft, nft->state, &errors, cmds, nft->top_scope);
+	nft->scanner = scanner_init(nft->state);
+	scanner_push_buffer(nft->scanner, &indesc_udata, buf);
+
+	ret = nft_parse(nft, nft->scanner, nft->state);
+
+	list_for_each_entry_safe(erec, nexte, &errors, list) {
+		list_del(&erec->list);
+		erec_destroy(erec);
+	}
+
+	if (nft->scanner) {
+		scanner_destroy(nft);
+		nft->scanner = NULL;
+	}
+
+	if (ret != 0 || nft->state->nerrs > 0)
+		return -1;
+
+	return 0;
+}
+
+static struct expr *set_make_key(const struct nftnl_udata *ud)
+{
+	struct cmd *cmd, *nextc;
+	struct nft_ctx *nft;
+	char cmdline[1024];
+	struct expr *expr;
+	const char *buf;
+	LIST_HEAD(cmds);
+	uint8_t len;
+	int i;
+
+	if (!ud)
+		return NULL;
+
+	len = nftnl_udata_len(ud);
+	if (!len)
+		return NULL;
+
+	buf = nftnl_udata_get(ud);
+	if (!buf)
+		return NULL;
+
+	for (i = 0; i < len; i++) {
+		if (buf[i] > 'z')
+			return NULL;
+		if (buf[i] == ' ' || buf[i] == '6')
+			continue;
+		if (buf[i] < 'a') {
+			if (buf[i] == '\0' && i == len - 1)
+				continue;
+
+			return NULL;
+		}
+	}
+
+	snprintf(cmdline, sizeof(cmdline), "describe %s\n", buf);
+
+	nft = __nft_ctx_new();
+	parse_desc(nft, cmdline, &cmds);
+
+	expr = NULL;
+	list_for_each_entry_safe(cmd, nextc, &cmds, list) {
+		if (cmd->op == CMD_DESCRIBE && !expr)
+			expr = expr_get(cmd->expr);
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+
+	__nft_ctx_free(nft);
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
@@ -584,11 +682,17 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
@@ -606,6 +710,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
 
 #undef GET_U32_UDATA
+		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_KEY]);
+		typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -626,12 +732,14 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
 
@@ -641,24 +749,53 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
+
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
diff --git a/src/rule.c b/src/rule.c
index a94860865f31..04b1f57260fd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -444,8 +444,32 @@ static void set_print_key(const struct expr *expr, struct output_ctx *octx)
 
 	if (dtype->size || dtype->type == TYPE_VERDICT)
 		nft_print(octx, "%s", dtype->name);
-	else
+	else if (expr->flags & EXPR_F_CONSTANT)
 		nft_print(octx, "%s,%d", dtype->name, expr->len);
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
 }
 
 static void set_print_declaration(const struct set *set,
@@ -475,17 +499,9 @@ static void set_print_declaration(const struct set *set,
 
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, set->handle.handle.id);
-	nft_print(octx, "%s", opts->nl);
-	nft_print(octx, "%s%stype ",
-		  opts->tab, opts->tab);
-	set_print_key(set->key, octx);
+	nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 
-	if (set_is_datamap(set->flags)) {
-		nft_print(octx, " : ");
-		set_print_key(set->data, octx);
-	} else if (set_is_objmap(set->flags)) {
-		nft_print(octx, " : %s", obj_type_name(set->objtype));
-	}
+	set_print_key_and_data(set, octx);
 
 	nft_print(octx, "%s", opts->stmt_separator);
 
-- 
2.23.0

