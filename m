Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0D1C43603
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A315C206D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfLPMme (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:42:34 -0500
Received: from correo.us.es ([193.147.175.20]:32934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfLPMmd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 07:42:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 492F0E8E90
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3551DDA716
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:42:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2AC3CDA715; Mon, 16 Dec 2019 13:42:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3B89DA716;
        Mon, 16 Dec 2019 13:42:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 13:42:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C946742EF42B;
        Mon, 16 Dec 2019 13:42:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 3/3] expr: add parse and build userdata interface
Date:   Mon, 16 Dec 2019 13:42:22 +0100
Message-Id: <20191216124222.356618-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191216124222.356618-1-pablo@netfilter.org>
References: <20191216124222.356618-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds two new expression operations to build and to parse the
userdata area that describe the set key and data typeof definitions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |   4 ++
 src/mnl.c            |  28 +++++---------
 src/netlink.c        | 105 +++++++++++++++++----------------------------------
 src/payload.c        |  80 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+), 89 deletions(-)

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
diff --git a/src/mnl.c b/src/mnl.c
index bcf633002f15..1d6d82e3332d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -816,28 +816,18 @@ static void set_key_expression(struct netlink_ctx *ctx,
 				struct nftnl_udata_buf *udbuf,
 				unsigned int type)
 {
-	struct output_ctx octx = {};
-	char buf[64];
+	struct nftnl_udata *nest1, *nest2;
 
 	if (expr->flags & EXPR_F_CONSTANT ||
 	    set_flags & NFT_SET_ANONYMOUS)
 		return;
 
-	buf[0] = 0;
-	/* Set definition uses typeof to define datatype. */
-	octx.output_fp = fmemopen(buf, sizeof(buf), "w");
-	if (octx.output_fp) {
-		char *end;
-
-		expr_print(expr, &octx);
-		fclose(octx.output_fp);
-		end = strchr(buf, '&');
-		if (end)
-			* end = 0;
-
-		if (!nftnl_udata_put(udbuf, type, strlen(buf) + 1, buf))
-			memory_allocation_error();
-	}
+	nest1 = nftnl_udata_nest_start(udbuf, type);
+	nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_TYPEOF_EXPR, expr->etype);
+	nest2 = nftnl_udata_nest_start(udbuf, NFTNL_UDATA_SET_TYPEOF_DATA);
+	expr_ops(expr)->build_udata(udbuf, expr);
+	nftnl_udata_nest_end(udbuf, nest2);
+	nftnl_udata_nest_end(udbuf, nest1);
 }
 
 /*
@@ -910,9 +900,9 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				 set->automerge))
 		memory_allocation_error();
 
-	set_key_expression(ctx, set->key, set->flags, udbuf, NFTNL_UDATA_SET_TYPEOF_KEY);
+	set_key_expression(ctx, set->key, set->flags, udbuf, NFTNL_UDATA_SET_KEY_TYPEOF);
 	if (set->data)
-		set_key_expression(ctx, set->data, set->flags, udbuf, NFTNL_UDATA_SET_TYPEOF_DATA);
+		set_key_expression(ctx, set->data, set->flags, udbuf, NFTNL_UDATA_SET_DATA_TYPEOF);
 
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
diff --git a/src/netlink.c b/src/netlink.c
index 790c663ccd6d..3ceeba68dc94 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -27,6 +27,7 @@
 #include <libnftnl/udata.h>
 #include <libnftnl/ruleset.h>
 #include <libnftnl/common.h>
+#include <libnftnl/udata.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter.h>
@@ -571,8 +572,8 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
-	case NFTNL_UDATA_SET_TYPEOF_KEY:
-	case NFTNL_UDATA_SET_TYPEOF_DATA:
+	case NFTNL_UDATA_SET_KEY_TYPEOF:
+	case NFTNL_UDATA_SET_DATA_TYPEOF:
 		if (len < 3)
 			return -1;
 		break;
@@ -583,87 +584,50 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
-static int parse_desc(struct nft_ctx *nft, const char *buf, struct list_head *cmds)
+static int set_key_parse_udata(const struct nftnl_udata *attr, void *data)
 {
-	static const struct input_descriptor indesc_udata = {
-		.type	= INDESC_BUFFER,
-		.name	= "<setudata>",
-	};
-	struct error_record *erec, *nexte;
-	LIST_HEAD(errors);
-	int ret;
-
-	parser_init(nft, nft->state, &errors, cmds, nft->top_scope);
-	nft->scanner = scanner_init(nft->state);
-	scanner_push_buffer(nft->scanner, &indesc_udata, buf);
-
-	ret = nft_parse(nft, nft->scanner, nft->state);
-
-	list_for_each_entry_safe(erec, nexte, &errors, list) {
-		list_del(&erec->list);
-		erec_destroy(erec);
-	}
+	const struct nftnl_udata **tb = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
 
-	if (nft->scanner) {
-		scanner_destroy(nft);
-		nft->scanner = NULL;
+	switch (type) {
+	case NFTNL_UDATA_SET_TYPEOF_EXPR:
+		if (len != sizeof(uint32_t))
+			return -1;
+		break;
+	case NFTNL_UDATA_SET_TYPEOF_DATA:
+		break;
+	default:
+		return 0;
 	}
-
-	if (ret != 0 || nft->state->nerrs > 0)
-		return -1;
-
+	tb[type] = attr;
 	return 0;
 }
 
-static struct expr *set_make_key(const struct nftnl_udata *ud)
+static struct expr *set_make_key(const struct nftnl_udata *attr)
 {
-	struct cmd *cmd, *nextc;
-	struct nft_ctx *nft;
-	char cmdline[1024];
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_TYPEOF_MAX + 1] = {};
+	const struct expr_ops *ops;
+	enum expr_types etype;
 	struct expr *expr;
-	const char *buf;
-	LIST_HEAD(cmds);
-	uint8_t len;
-	int i;
-
-	if (!ud)
-		return NULL;
+	int err;
 
-	len = nftnl_udata_len(ud);
-	if (!len)
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				set_key_parse_udata, ud);
+	if (err < 0)
 		return NULL;
 
-	buf = nftnl_udata_get(ud);
-	if (!buf)
+	if (!ud[NFTNL_UDATA_SET_TYPEOF_EXPR] ||
+	    !ud[NFTNL_UDATA_SET_TYPEOF_DATA])
 		return NULL;
 
-	for (i = 0; i < len; i++) {
-		if (buf[i] > 'z')
-			return NULL;
-		if (buf[i] == ' ' || buf[i] == '6')
-			continue;
-		if (buf[i] < 'a') {
-			if (buf[i] == '\0' && i == len - 1)
-				continue;
+	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
+	ops = expr_ops_by_type(etype);
 
-			return NULL;
-		}
-	}
-
-	snprintf(cmdline, sizeof(cmdline), "describe %s\n", buf);
-
-	nft = __nft_ctx_new();
-	parse_desc(nft, cmdline, &cmds);
-
-	expr = NULL;
-	list_for_each_entry_safe(cmd, nextc, &cmds, list) {
-		if (cmd->op == CMD_DESCRIBE && !expr)
-			expr = expr_get(cmd->expr);
-		list_del(&cmd->list);
-		cmd_free(cmd);
-	}
+	expr = ops->parse_udata(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
+	if (!expr)
+		return NULL;
 
-	__nft_ctx_free(nft);
 	return expr;
 }
 
@@ -710,8 +674,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
 
 #undef GET_U32_UDATA
-		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_KEY]);
-		typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
+		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_KEY_TYPEOF]);
+		if (ud[NFTNL_UDATA_SET_DATA_TYPEOF])
+			typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_DATA_TYPEOF]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
diff --git a/src/payload.c b/src/payload.c
index 3576400bbfc8..664d95df67e8 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -105,6 +105,84 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	proto_ctx_update(ctx, desc->base, &expr->location, desc);
 }
 
+#define NFTNL_SET_KEY_PAYLOAD_DESC 1
+#define NFTNL_SET_KEY_PAYLOAD_TYPE 2
+
+static unsigned int expr_payload_type(const struct proto_desc *desc,
+				      const struct proto_hdr_template *tmpl)
+{
+	unsigned int offset = (unsigned int)(tmpl - &desc->templates[0]);
+
+	return offset / sizeof(*tmpl);
+}
+
+static int payload_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				    const struct expr *expr)
+{
+	const struct proto_hdr_template *tmpl = expr->payload.tmpl;
+	const struct proto_desc *desc = expr->payload.desc;
+	unsigned int type = expr_payload_type(desc, tmpl);
+
+	nftnl_udata_put_u32(udbuf, NFTNL_SET_KEY_PAYLOAD_DESC, desc->id);
+	nftnl_udata_put_u32(udbuf, NFTNL_SET_KEY_PAYLOAD_TYPE, type);
+
+	return 0;
+}
+
+static const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud)
+{
+	return NULL;
+}
+
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_DESC 0
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_TYPE 1
+#define NFTNL_UDATA_SET_KEY_PAYLOAD_MAX 2
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
+	desc = find_proto_desc(ud[NFTNL_SET_KEY_PAYLOAD_DESC]);
+	if (!desc)
+		return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_SET_KEY_PAYLOAD_TYPE]);
+
+	return payload_expr_alloc(&internal_location, desc, type);
+}
+
 const struct expr_ops payload_expr_ops = {
 	.type		= EXPR_PAYLOAD,
 	.name		= "payload",
@@ -113,6 +191,8 @@ const struct expr_ops payload_expr_ops = {
 	.cmp		= payload_expr_cmp,
 	.clone		= payload_expr_clone,
 	.pctx_update	= payload_expr_pctx_update,
+	.build_udata	= payload_expr_build_udata,
+	.parse_udata	= payload_expr_parse_udata,
 };
 
 /*
-- 
2.11.0

