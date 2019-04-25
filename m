Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53782C282E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 476A820678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfDYM47 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:56:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55848 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfDYM47 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 08:56:59 -0400
Received: from localhost ([::1]:40706 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdvt-0007pb-7G; Thu, 25 Apr 2019 14:56:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] use UDATA defines from libnftnl
Date:   Thu, 25 Apr 2019 14:56:54 +0200
Message-Id: <20190425125654.15125-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userdata attribute names have been added to libnftnl, use them instead
of the local copy.

While being at it, rename udata_get_comment() in netlink_delinearize.c
and the callback it uses since the function is specific to rules. Also
integrate the existence check for NFTNL_RULE_USERDATA into it along with
the call to nftnl_rule_get_data().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h            | 32 ----------------------------
 src/mnl.c                 |  6 +++---
 src/monitor.c             |  2 +-
 src/netlink.c             | 45 ++++++++++++++++++++-------------------
 src/netlink_delinearize.c | 29 +++++++++++++------------
 src/netlink_linearize.c   |  2 +-
 src/parser_bison.y        |  6 ++++--
 src/segtree.c             |  4 +++-
 8 files changed, 50 insertions(+), 76 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index dc5e5b87f9331..8e70c129fcce0 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -637,38 +637,6 @@ extern void cache_flush(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
 extern void cache_release(struct nft_cache *cache);
 
-enum udata_type {
-	UDATA_TYPE_COMMENT,
-	__UDATA_TYPE_MAX,
-};
-#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
-
-#define UDATA_COMMENT_MAXLEN 128
-
-enum udata_set_type {
-	UDATA_SET_KEYBYTEORDER,
-	UDATA_SET_DATABYTEORDER,
-	UDATA_SET_MERGE_ELEMENTS,
-	__UDATA_SET_MAX,
-};
-#define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
-
-enum udata_set_elem_type {
-	UDATA_SET_ELEM_COMMENT,
-	UDATA_SET_ELEM_FLAGS,
-	__UDATA_SET_ELEM_MAX,
-};
-#define UDATA_SET_ELEM_MAX (__UDATA_SET_ELEM_MAX - 1)
-
-/**
- * enum udata_set_elem_flags - meaning of bits in UDATA_SET_ELEM_FLAGS
- *
- * @SET_ELEM_F_INTERVAL_OPEN:	set element denotes a half-open range
- */
-enum udata_set_elem_flags {
-	SET_ELEM_F_INTERVAL_OPEN	= 0x1,
-};
-
 struct timeout_protocol {
 	uint32_t array_size;
 	const char *const *state_to_name;
diff --git a/src/mnl.c b/src/mnl.c
index dde232c7e29c4..f6363560721c1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -780,17 +780,17 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 	if (!udbuf)
 		memory_allocation_error();
-	if (!nftnl_udata_put_u32(udbuf, UDATA_SET_KEYBYTEORDER,
+	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEYBYTEORDER,
 				 set->key->byteorder))
 		memory_allocation_error();
 
 	if (set->flags & NFT_SET_MAP &&
-	    !nftnl_udata_put_u32(udbuf, UDATA_SET_DATABYTEORDER,
+	    !nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_DATABYTEORDER,
 				 set->datatype->byteorder))
 		memory_allocation_error();
 
 	if (set->automerge &&
-	    !nftnl_udata_put_u32(udbuf, UDATA_SET_MERGE_ELEMENTS,
+	    !nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_MERGE_ELEMENTS,
 				 set->automerge))
 		memory_allocation_error();
 
diff --git a/src/monitor.c b/src/monitor.c
index 35dc4501b4c4f..a68d960bfd4e8 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -332,7 +332,7 @@ static bool set_elem_is_open_interval(struct expr *elem)
 {
 	switch (elem->etype) {
 	case EXPR_SET_ELEM:
-		return elem->elem_flags & SET_ELEM_F_INTERVAL_OPEN;
+		return elem->elem_flags & NFTNL_SET_ELEM_F_INTERVAL_OPEN;
 	case EXPR_MAPPING:
 		return set_elem_is_open_interval(elem->left);
 	default:
diff --git a/src/netlink.c b/src/netlink.c
index 9e0e07d4c5b08..c051ae6c43908 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -128,12 +128,12 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			memory_allocation_error();
 	}
 	if (elem->comment) {
-		if (!nftnl_udata_put_strz(udbuf, UDATA_SET_ELEM_COMMENT,
+		if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_ELEM_COMMENT,
 					  elem->comment))
 			memory_allocation_error();
 	}
 	if (expr->elem_flags) {
-		if (!nftnl_udata_put_u32(udbuf, UDATA_SET_ELEM_FLAGS,
+		if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_ELEM_FLAGS,
 					 expr->elem_flags))
 			memory_allocation_error();
 	}
@@ -522,9 +522,9 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	uint8_t len = nftnl_udata_len(attr);
 
 	switch (type) {
-	case UDATA_SET_KEYBYTEORDER:
-	case UDATA_SET_DATABYTEORDER:
-	case UDATA_SET_MERGE_ELEMENTS:
+	case NFTNL_UDATA_SET_KEYBYTEORDER:
+	case NFTNL_UDATA_SET_DATABYTEORDER:
+	case NFTNL_UDATA_SET_MERGE_ELEMENTS:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -538,7 +538,7 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				    const struct nftnl_set *nls)
 {
-	const struct nftnl_udata *ud[UDATA_SET_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
 	uint32_t flags, key, data, data_len, objtype = 0;
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
@@ -555,15 +555,15 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 			return NULL;
 		}
 
-		if (ud[UDATA_SET_KEYBYTEORDER])
-			keybyteorder =
-				nftnl_udata_get_u32(ud[UDATA_SET_KEYBYTEORDER]);
-		if (ud[UDATA_SET_DATABYTEORDER])
-			databyteorder =
-				nftnl_udata_get_u32(ud[UDATA_SET_DATABYTEORDER]);
-		if (ud[UDATA_SET_MERGE_ELEMENTS])
-			automerge =
-				nftnl_udata_get_u32(ud[UDATA_SET_MERGE_ELEMENTS]);
+#define GET_U32_UDATA(var, attr)				\
+		if (ud[attr])					\
+			var = nftnl_udata_get_u32(ud[attr])
+
+		GET_U32_UDATA(keybyteorder, NFTNL_UDATA_SET_KEYBYTEORDER);
+		GET_U32_UDATA(databyteorder, NFTNL_UDATA_SET_DATABYTEORDER);
+		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
+
+#undef GET_U32_UDATA
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -712,11 +712,11 @@ static int set_elem_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	uint8_t len = nftnl_udata_len(attr);
 
 	switch (type) {
-	case UDATA_SET_ELEM_COMMENT:
+	case NFTNL_UDATA_SET_ELEM_COMMENT:
 		if (value[len - 1] != '\0')
 			return -1;
 		break;
-	case UDATA_SET_ELEM_FLAGS:
+	case NFTNL_UDATA_SET_ELEM_FLAGS:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -730,7 +730,7 @@ static int set_elem_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 				 struct expr *expr)
 {
-	const struct nftnl_udata *ud[UDATA_SET_ELEM_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_ELEM_MAX + 1] = {};
 	const void *data;
 	uint32_t len;
 
@@ -738,11 +738,12 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 	if (nftnl_udata_parse(data, len, set_elem_parse_udata_cb, ud))
 		return;
 
-	if (ud[UDATA_SET_ELEM_COMMENT])
+	if (ud[NFTNL_UDATA_SET_ELEM_COMMENT])
 		expr->comment =
-			xstrdup(nftnl_udata_get(ud[UDATA_SET_ELEM_COMMENT]));
-	if (ud[UDATA_SET_ELEM_FLAGS])
-		expr->elem_flags = nftnl_udata_get_u32(ud[UDATA_SET_ELEM_FLAGS]);
+			xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_ELEM_COMMENT]));
+	if (ud[NFTNL_UDATA_SET_ELEM_FLAGS])
+		expr->elem_flags =
+			nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_ELEM_FLAGS]);
 }
 
 int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 40ab0256a7efe..2c9b0a32a932e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2575,7 +2575,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	}
 }
 
-static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+static int parse_rule_udata_cb(const struct nftnl_udata *attr, void *data)
 {
 	unsigned char *value = nftnl_udata_get(attr);
 	uint8_t type = nftnl_udata_type(attr);
@@ -2583,7 +2583,7 @@ static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	const struct nftnl_udata **tb = data;
 
 	switch (type) {
-	case UDATA_TYPE_COMMENT:
+	case NFTNL_UDATA_RULE_COMMENT:
 		if (value[len - 1] != '\0')
 			return -1;
 		break;
@@ -2594,17 +2594,24 @@ static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
-static char *udata_get_comment(const void *data, uint32_t data_len)
+static char *nftnl_rule_get_comment(const struct nftnl_rule *nlr)
 {
-	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
+	const struct nftnl_udata *tb[NFTNL_UDATA_RULE_MAX + 1] = {};
+	const void *data;
+	uint32_t len;
 
-	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) < 0)
+	if (!nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA))
 		return NULL;
 
-	if (!tb[UDATA_TYPE_COMMENT])
+	data = nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
+
+	if (nftnl_udata_parse(data, len, parse_rule_udata_cb, tb) < 0)
+		return NULL;
+
+	if (!tb[NFTNL_UDATA_RULE_COMMENT])
 		return NULL;
 
-	return xstrdup(nftnl_udata_get(tb[UDATA_TYPE_COMMENT]));
+	return xstrdup(nftnl_udata_get(tb[NFTNL_UDATA_RULE_COMMENT]));
 }
 
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
@@ -2630,13 +2637,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	pctx->table = table_lookup(&h, &ctx->nft->cache);
 	assert(pctx->table != NULL);
 
-	if (nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA)) {
-		const void *data;
-		uint32_t len;
-
-		data = nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
-		pctx->rule->comment = udata_get_comment(data, len);
-	}
+	pctx->rule->comment = nftnl_rule_get_comment(nlr);
 
 	nftnl_expr_foreach(nlr, netlink_parse_rule_expr, pctx);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index df763544634ef..2c6aa64d3ac1c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1432,7 +1432,7 @@ void netlink_linearize_rule(struct netlink_ctx *ctx, struct nftnl_rule *nlr,
 		if (!udata)
 			memory_allocation_error();
 
-		if (!nftnl_udata_put_strz(udata, UDATA_TYPE_COMMENT,
+		if (!nftnl_udata_put_strz(udata, NFTNL_UDATA_RULE_COMMENT,
 					  rule->comment))
 			memory_allocation_error();
 		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4a2a81cde6a7a..9aea652653329 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -28,6 +28,7 @@
 #include <netinet/icmp6.h>
 #include <libnftnl/common.h>
 #include <libnftnl/set.h>
+#include <libnftnl/udata.h>
 
 #include <rule.h>
 #include <statement.h>
@@ -2185,8 +2186,9 @@ ruleid_spec		:	chain_spec	handle_spec
 
 comment_spec		:	COMMENT		string
 			{
-				if (strlen($2) > UDATA_COMMENT_MAXLEN) {
-					erec_queue(error(&@2, "comment too long, %d characters maximum allowed", UDATA_COMMENT_MAXLEN),
+				if (strlen($2) > NFTNL_UDATA_COMMENT_MAXLEN) {
+					erec_queue(error(&@2, "comment too long, %d characters maximum allowed",
+							 NFTNL_UDATA_COMMENT_MAXLEN),
 						   state->msgs);
 					YYERROR;
 				}
diff --git a/src/segtree.c b/src/segtree.c
index 4353e85a02c55..a21270a08c46c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -13,6 +13,8 @@
 #include <inttypes.h>
 #include <arpa/inet.h>
 
+#include <libnftnl/udata.h>
+
 #include <rule.h>
 #include <expression.h>
 #include <gmputil.h>
@@ -562,7 +564,7 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 	if (ei->flags & EI_F_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
 	if (ei->flags & EI_F_INTERVAL_OPEN)
-		expr->elem_flags |= SET_ELEM_F_INTERVAL_OPEN;
+		expr->elem_flags |= NFTNL_SET_ELEM_F_INTERVAL_OPEN;
 
 	compound_expr_add(set, expr);
 }
-- 
2.21.0

