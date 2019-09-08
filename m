Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B383C4360D
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 19:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF794216C8
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 19:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="TdTTdUSt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfIHThj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 15:37:39 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41782 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfIHThj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 15:37:39 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 0D6141A0201
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 12:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567971458; bh=xYEhq1xoqi5vL6Qa/ZGpjlJIbBcC1RRczjA4h9G7sR0=;
        h=From:To:Cc:Subject:Date:From;
        b=TdTTdUStb47NsUur4bMj68SLPGJ4wHxHs3XusFmGDQdU7It3/1J0XrUP4ELdlW7Nz
         wcTu9Av50RcecokoDWHpjLXtxN8Pnf+AHA7JGi/RS7df8UvpNlKdMJoubPoHAj40Vz
         t4vcQQS4mdXzxIqmjS8lhXGYUYLRREKjGhvdaX/8=
X-Riseup-User-ID: 78F99CE9FF247B5E1CACC19C541930E80A159B1D57020DC5CFCC5A2BD59EE4CB
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 6D89D1202AF;
        Sun,  8 Sep 2019 12:37:32 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v3] src: add synproxy stateful object support
Date:   Sun,  8 Sep 2019 21:37:21 +0200
Message-Id: <20190908193720.26163-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for "synproxy" stateful object. For example (for TCP port 80 and
using maps with saddr):

table ip foo {
	synproxy https-synproxy {
		mss 1460
		wscale 7
		timestamp sack-perm
	}

	synproxy other-synproxy {
		mss 1460
		wscale 5
	}

	chain bar {
		tcp dport 80 synproxy name "https-synproxy"
		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: fix a typo
v3: one option per line
---
 include/linux/netfilter/nf_tables.h |   3 +-
 include/rule.h                      |  11 +++
 src/evaluate.c                      |   5 ++
 src/json.c                          |  20 ++++-
 src/mnl.c                           |   8 ++
 src/netlink.c                       |   8 ++
 src/parser_bison.y                  | 124 +++++++++++++++++++++++++++-
 src/parser_json.c                   |  22 ++++-
 src/rule.c                          |  49 +++++++++++
 src/scanner.l                       |   1 +
 src/statement.c                     |   1 +
 11 files changed, 246 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0ff932d..ed8881a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1481,7 +1481,8 @@ enum nft_ct_expectation_attributes {
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
 #define NFT_OBJECT_CT_EXPECT	9
-#define __NFT_OBJECT_MAX	10
+#define NFT_OBJECT_SYNPROXY	10
+#define __NFT_OBJECT_MAX	11
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/rule.h b/include/rule.h
index 0ef6aac..2708cbe 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -399,6 +399,12 @@ struct limit {
 	uint32_t	flags;
 };
 
+struct synproxy {
+	uint16_t	mss;
+	uint8_t		wscale;
+	uint32_t	flags;
+};
+
 struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
@@ -426,6 +432,7 @@ struct obj {
 		struct ct_timeout	ct_timeout;
 		struct secmark		secmark;
 		struct ct_expect	ct_expect;
+		struct synproxy		synproxy;
 	};
 };
 
@@ -529,6 +536,8 @@ enum cmd_ops {
  * @CMD_OBJ_FLOWTABLES:	flow tables
  * @CMD_OBJ_SECMARK:	secmark
  * @CMD_OBJ_SECMARKS:	multiple secmarks
+ * @CMD_OBJ_SYNPROXY:	synproxy
+ * @CMD_OBJ_SYNPROXYS:	multiple synproxys
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -561,6 +570,8 @@ enum cmd_obj {
 	CMD_OBJ_SECMARK,
 	CMD_OBJ_SECMARKS,
 	CMD_OBJ_CT_EXPECT,
+	CMD_OBJ_SYNPROXY,
+	CMD_OBJ_SYNPROXYS,
 };
 
 struct markup {
diff --git a/src/evaluate.c b/src/evaluate.c
index 29fe966..a56cd2a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3743,6 +3743,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_SYNPROXY:
 		return obj_evaluate(ctx, cmd->object);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3766,6 +3767,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_SYNPROXY:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3911,6 +3913,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SECMARK);
 	case CMD_OBJ_CT_EXPECT:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
+	case CMD_OBJ_SYNPROXY:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
@@ -3918,6 +3922,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_SECMARKS:
+	case CMD_OBJ_SYNPROXYS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
diff --git a/src/json.c b/src/json.c
index 55ce053..6adc801 100644
--- a/src/json.c
+++ b/src/json.c
@@ -282,8 +282,8 @@ static json_t *obj_print_json(const struct obj *obj)
 {
 	const char *rate_unit = NULL, *burst_unit = NULL;
 	const char *type = obj_type_name(obj->type);
+	json_t *root, *tmp, *flags;
 	uint64_t rate, burst;
-	json_t *root, *tmp;
 
 	root = json_pack("{s:s, s:s, s:s, s:I}",
 			"family", family2str(obj->handle.family),
@@ -368,6 +368,24 @@ static json_t *obj_print_json(const struct obj *obj)
 						    json_string(burst_unit));
 		}
 
+		json_object_update(root, tmp);
+		json_decref(tmp);
+		break;
+	case NFT_OBJECT_SYNPROXY:
+		flags = json_array();
+		tmp = json_pack("{s:i, s:i}",
+				"mss", obj->synproxy.mss,
+				"wscale", obj->synproxy.wscale);
+		if (obj->synproxy.flags & NF_SYNPROXY_OPT_TIMESTAMP)
+			json_array_append_new(flags, json_string("timestamp"));
+		if (obj->synproxy.flags & NF_SYNPROXY_OPT_SACK_PERM)
+			json_array_append_new(flags, json_string("sack-perm"));
+
+		if (json_array_size(flags) > 0)
+			json_object_set_new(tmp, "flags", flags);
+		else
+			json_decref(flags);
+
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 9c1f535..cbd0de4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1034,6 +1034,14 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		nftnl_obj_set_str(nlo, NFTNL_OBJ_SECMARK_CTX,
 				  obj->secmark.ctx);
 		break;
+	case NFT_OBJECT_SYNPROXY:
+		nftnl_obj_set_u16(nlo, NFTNL_OBJ_SYNPROXY_MSS,
+				  obj->synproxy.mss);
+		nftnl_obj_set_u8(nlo, NFTNL_OBJ_SYNPROXY_WSCALE,
+				 obj->synproxy.wscale);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS,
+				  obj->synproxy.flags);
+		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index f8e1120..1e669e5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1030,6 +1030,14 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->ct_expect.size =
 			nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_EXPECT_SIZE);
 		break;
+	case NFT_OBJECT_SYNPROXY:
+		obj->synproxy.mss =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_SYNPROXY_MSS);
+		obj->synproxy.wscale =
+			nftnl_obj_get_u8(nlo, NFTNL_OBJ_SYNPROXY_WSCALE);
+		obj->synproxy.flags =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
+		break;
 	}
 	obj->type = type;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b7db1a2..3fccea6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -151,6 +151,7 @@ int nft_lex(void *, void *, void *);
 	struct counter		*counter;
 	struct quota		*quota;
 	struct secmark		*secmark;
+	struct synproxy		*synproxy;
 	struct ct		*ct;
 	struct limit		*limit;
 	const struct datatype	*datatype;
@@ -461,6 +462,7 @@ int nft_lex(void *, void *, void *);
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
+%token SYNPROXYS		"synproxys"
 %token HELPERS			"helpers"
 
 %token LOG			"log"
@@ -592,7 +594,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -700,8 +702,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -787,6 +789,9 @@ int nft_lex(void *, void *, void *);
 %destructor { xfree($$); }	limit_config
 %type <secmark>			secmark_config
 %destructor { xfree($$); }	secmark_config
+%type <synproxy>		synproxy_config
+%destructor { xfree($$); }	synproxy_config
+%type <val>			synproxy_ts	synproxy_sack
 
 %type <expr>			tcp_hdr_expr
 %destructor { expr_free($$); }	tcp_hdr_expr
@@ -1012,6 +1017,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
+			|	SYNPROXY	obj_spec	synproxy_obj
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -1105,6 +1114,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
+			|	SYNPROXY	obj_spec	synproxy_obj
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -1189,6 +1202,14 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
+			|	SYNPROXY	obj_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
+			}
+			|	SYNPROXY	objid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
+			}
 			;
 
 get_cmd			:	ELEMENT		set_spec	set_block_expr
@@ -1273,6 +1294,18 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
+			|	SYNPROXYS	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXYS, &$2, &@$, NULL);
+			}
+			|	SYNPROXYS	TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXYS, &$3, &@$, NULL);
+			}
+			|	SYNPROXY	obj_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -1592,6 +1625,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	SYNPROXY	obj_identifier
+					obj_block_alloc '{'	synproxy_block	'}'
+					stmt_separator
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_SYNPROXY;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -1928,6 +1972,16 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
+synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|	synproxy_block	common_block
+			|	synproxy_block	stmt_separator
+			|	synproxy_block	synproxy_config
+			{
+				$1->synproxy = *$2;
+				$$ = $1;
+			}
+			;
+
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
 			|	DSCP	{ $$ = xstrdup("dscp"); }
@@ -2788,6 +2842,12 @@ synproxy_stmt_alloc	:	SYNPROXY
 			{
 				$$ = synproxy_stmt_alloc(&@$);
 			}
+			|	SYNPROXY	NAME	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_SYNPROXY;
+				$$->objref.expr = $3;
+			}
 			;
 
 synproxy_args		:	synproxy_arg
@@ -2817,6 +2877,64 @@ synproxy_arg		:	MSS	NUM
 			}
 			;
 
+synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
+			{
+				struct synproxy *synproxy;
+				uint32_t flags = 0;
+
+				synproxy = xzalloc(sizeof(*synproxy));
+				synproxy->mss = $2;
+				flags |= NF_SYNPROXY_OPT_MSS;
+				synproxy->wscale = $4;
+				flags |= NF_SYNPROXY_OPT_WSCALE;
+				if ($5)
+					flags |= $5;
+				if ($6)
+					flags |= $6;
+				synproxy->flags = flags;
+				$$ = synproxy;
+			}
+			|	MSS	NUM	stmt_separator	WSCALE	NUM	stmt_separator	synproxy_ts	synproxy_sack
+			{
+				struct synproxy *synproxy;
+				uint32_t flags = 0;
+
+				synproxy = xzalloc(sizeof(*synproxy));
+				synproxy->mss = $2;
+				flags |= NF_SYNPROXY_OPT_MSS;
+				synproxy->wscale = $5;
+				flags |= NF_SYNPROXY_OPT_WSCALE;
+				if ($7)
+					flags |= $7;
+				if ($8)
+					flags |= $8;
+				synproxy->flags = flags;
+				$$ = synproxy;
+			}
+			;
+
+synproxy_obj		:	synproxy_config
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_SYNPROXY;
+				$$->synproxy = *$1;
+			}
+			;
+
+synproxy_ts		:	/* empty */	{ $$ = 0; }
+			|	TIMESTAMP
+			{
+				$$ = NF_SYNPROXY_OPT_TIMESTAMP;
+			}
+			;
+
+synproxy_sack		:	/* empty */	{ $$ = 0; }
+			|	SACKPERM
+			{
+				$$ = NF_SYNPROXY_OPT_SACK_PERM;
+			}
+			;
+
 primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 8ca07d7..8fd46d2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3019,8 +3019,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	const char *family, *tmp, *rate_unit = "packets", *burst_unit = "bytes";
 	uint32_t l3proto = NFPROTO_UNSPEC;
 	struct handle h = { 0 };
+	int inv = 0, flags = 0;
 	struct obj *obj;
-	int inv = 0;
+	json_t *jflags;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -3196,6 +3197,25 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		obj->limit.unit = seconds_from_unit(tmp);
 		obj->limit.flags = inv ? NFT_LIMIT_F_INV : 0;
 		break;
+	case CMD_OBJ_SYNPROXY:
+		obj->type = NFT_OBJECT_SYNPROXY;
+		if (json_unpack_err(ctx, root, "{s:i, s:i}",
+				    "mss", &obj->synproxy.mss,
+				    "wscale", &obj->synproxy.wscale)) {
+			obj_free(obj);
+			return NULL;
+		}
+		obj->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
+		obj->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
+		if (!json_unpack(root, "{s:o}", "flags", &jflags)) {
+			flags = json_parse_synproxy_flags(ctx, jflags);
+			if (flags < 0) {
+				obj_free(obj);
+				return NULL;
+			}
+			obj->synproxy.flags |= flags;
+		}
+		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
 	}
diff --git a/src/rule.c b/src/rule.c
index 1912513..03b07e6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -32,6 +32,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/nf_synproxy.h>
 #include <net/if.h>
 #include <linux/netfilter_bridge.h>
 
@@ -1451,6 +1452,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_CT_EXPECT:
 		case CMD_OBJ_LIMIT:
 		case CMD_OBJ_SECMARK:
+		case CMD_OBJ_SYNPROXY:
 			obj_free(cmd->object);
 			break;
 		case CMD_OBJ_FLOWTABLE:
@@ -1542,6 +1544,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_SYNPROXY:
 		return mnl_nft_obj_add(ctx, cmd, flags);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_add(ctx, cmd, flags);
@@ -1627,6 +1630,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_LIMIT);
 	case CMD_OBJ_SECMARK:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SECMARK);
+	case CMD_OBJ_SYNPROXY:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SYNPROXY);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_del(ctx, cmd);
 	default:
@@ -1778,6 +1783,22 @@ static void print_proto_timeout_policy(uint8_t l4, const uint32_t *timeout,
 	nft_print(octx, " }%s", opts->stmt_separator);
 }
 
+static const char *synproxy_sack_to_str(const uint32_t flags)
+{
+        if (flags & NF_SYNPROXY_OPT_SACK_PERM)
+                return "sack-perm";
+
+        return "";
+}
+
+static const char *synproxy_timestamp_to_str(const uint32_t flags)
+{
+        if (flags & NF_SYNPROXY_OPT_TIMESTAMP)
+                return "timestamp";
+
+        return "";
+}
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts,
 			   struct output_ctx *octx)
@@ -1911,6 +1932,30 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, "%s", opts->nl);
 		}
 		break;
+	case NFT_OBJECT_SYNPROXY: {
+		uint32_t flags = obj->synproxy.flags;
+		const char *sack_str = synproxy_sack_to_str(flags);
+		const char *ts_str = synproxy_timestamp_to_str(flags);
+
+		nft_print(octx, " %s {", obj->handle.obj.name);
+		if (nft_output_handle(octx))
+			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+
+		if (flags & NF_SYNPROXY_OPT_MSS) {
+			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
+			nft_print(octx, "mss %u", obj->synproxy.mss);
+		}
+		if (flags & NF_SYNPROXY_OPT_WSCALE) {
+			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
+			nft_print(octx, "wscale %u", obj->synproxy.wscale);
+		}
+		if (flags & (NF_SYNPROXY_OPT_TIMESTAMP | NF_SYNPROXY_OPT_SACK_PERM)) {
+			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
+			nft_print(octx, "%s %s", ts_str, sack_str);
+		}
+		nft_print(octx, "%s", opts->stmt_separator);
+		}
+		break;
 	default:
 		nft_print(octx, " unknown {%s", opts->nl);
 		break;
@@ -1924,6 +1969,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_LIMIT]	= "limit",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
+	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 };
 
@@ -1941,6 +1987,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_LIMIT]	= CMD_OBJ_LIMIT,
 	[NFT_OBJECT_CT_TIMEOUT] = CMD_OBJ_CT_TIMEOUT,
 	[NFT_OBJECT_SECMARK]	= CMD_OBJ_SECMARK,
+	[NFT_OBJECT_SYNPROXY]	= CMD_OBJ_SYNPROXY,
 	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
 };
 
@@ -2308,6 +2355,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_SECMARKS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SECMARK);
+	case CMD_OBJ_SYNPROXYS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_flowtables(ctx, cmd);
 	default:
diff --git a/src/scanner.l b/src/scanner.l
index fdf84ba..3de5a9e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -330,6 +330,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "counters"		{ return COUNTERS; }
 "quotas"		{ return QUOTAS; }
 "limits"		{ return LIMITS; }
+"synproxys"		{ return SYNPROXYS; }
 
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
diff --git a/src/statement.c b/src/statement.c
index 12689ee..5aa5b1e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -209,6 +209,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_LIMIT]	= "limit",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
+	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 };
 
-- 
2.20.1

