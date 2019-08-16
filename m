Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C00DC3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32C3206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfHPOpM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:45:12 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46188 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfHPOpM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:45:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTa-0002ok-BB; Fri, 16 Aug 2019 16:45:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 6/8] src: add "typeof" print support
Date:   Fri, 16 Aug 2019 16:42:39 +0200
Message-Id: <20190816144241.11469-7-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the 'udata' facility to store the original string in the kernel,
then use the existing 'describe' facility to resolve it back to a name.

This isn't strictly required, in case resolution fails, the udata is
inconsistent (e.g., because set specifies a size that is not identical
to the expressions size that we get when decoding the expression), if
the udata is missing, etc. then the "type, width" format is used.

This allows us to list and restore such sets even if we can't
reconstruct the original expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftables.c |   2 +-
 src/mnl.c         |  33 ++++++++++
 src/netlink.c     | 156 ++++++++++++++++++++++++++++++++++++++++++----
 src/rule.c        |  13 ++--
 4 files changed, 186 insertions(+), 18 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index a1e2fd662a7a..e9ebc3f389fc 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -424,7 +424,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			.msgs	= msgs,
 		};
 		if (cmd_evaluate(&ectx, cmd) < 0 &&
-		    ++nft->state->nerrs == nft->parser_max_errors)
+		    ++nft->state->nerrs >= nft->parser_max_errors)
 			return -1;
 	}
 
diff --git a/src/mnl.c b/src/mnl.c
index 034f21709a19..5e5f3628cfe1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -787,6 +787,35 @@ err:
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
@@ -857,6 +886,10 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
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
index 773b98cec61a..99f7a3b0bca7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -32,6 +32,7 @@
 #include <linux/netfilter.h>
 
 #include <nftables.h>
+#include <parser.h>
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
@@ -556,6 +557,11 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
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
@@ -563,6 +569,98 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
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
+	parser_init(nft, nft->state, &errors, cmds);
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
+		if (buf[i] == ' ')
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
@@ -570,11 +668,17 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
@@ -592,6 +696,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
 
 #undef GET_U32_UDATA
+		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_KEY]);
+		typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -612,12 +718,14 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
 
@@ -627,24 +735,46 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
 
-	set->key     = constant_expr_alloc(&netlink_location,
-					   set_datatype_alloc(keytype, keybyteorder),
-					   keybyteorder,
-					   nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE,
-					   NULL);
+	dtype = set_datatype_alloc(keytype, keybyteorder);
+	klen = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
+
+	if (set_udata_key_valid(typeof_expr_key, dtype, klen)) {
+		datatype_free(datatype_get(dtype));
+		set->key = typeof_expr_key;
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
+		}
+
+		if (dtype != datatype)
+			datatype_free(datatype);
+	}
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
index 59369c9082a3..db9401c6a035 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -440,10 +440,15 @@ static void set_print_key(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
 
-	if (dtype->size)
-		nft_print(octx, " %s", dtype->name);
-	else
-		nft_print(octx, " %s,%d", dtype->name, expr->len);
+	if (dtype->size || dtype->type == TYPE_VERDICT)
+		nft_print(octx, "%s", dtype->name);
+	else if (expr->flags & EXPR_F_CONSTANT)
+		nft_print(octx, "%s,%d", dtype->name, expr->len);
+	else {
+		nft_print(octx, "typeof(");
+		expr_print(expr, octx);
+		nft_print(octx, ")");
+	}
 }
 
 static void set_print_declaration(const struct set *set,
-- 
2.21.0

