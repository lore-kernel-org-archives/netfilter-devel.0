Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CDAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB4521852
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390290AbfGYJOM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:14:12 -0400
Received: from mail.us.es ([193.147.175.20]:47974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390283AbfGYJOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:14:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A26CFBAEE4
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90189DA732
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85B6C11510C; Thu, 25 Jul 2019 11:14:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDAFDA732
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 11:14:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.183.64])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AB25C4265A31
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v1 1/2] src: add tunnel support
Date:   Thu, 25 Jul 2019 11:13:59 +0200
Message-Id: <20190725091400.30057-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support to attach tunnel metadata.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 15 +++++++++++
 src/evaluate.c     | 23 ++++++++++++++++
 src/mnl.c          | 38 +++++++++++++++++++++++++++
 src/netlink.c      | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 50 ++++++++++++++++++++++++++++++++---
 src/rule.c         | 21 +++++++++++++++
 src/scanner.l      |  4 ++-
 7 files changed, 224 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ee881b9ccd17..00c16e39e980 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -406,6 +406,18 @@ struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
 
+struct tunnel {
+	const char	*type;
+	uint32_t	id;
+	struct expr	*src;
+	struct expr	*dst;
+	uint32_t	label;
+	uint16_t	sport;
+	uint16_t	dport;
+	uint8_t		tos;
+	uint8_t		ttl;
+};
+
 /**
  * struct obj - nftables stateful object statement
  *
@@ -426,6 +438,7 @@ struct obj {
 		struct quota		quota;
 		struct ct_helper	ct_helper;
 		struct limit		limit;
+		struct tunnel		tunnel;
 		struct ct_timeout	ct_timeout;
 		struct secmark		secmark;
 		struct ct_expect	ct_expect;
@@ -558,6 +571,8 @@ enum cmd_obj {
 	CMD_OBJ_CT_HELPERS,
 	CMD_OBJ_LIMIT,
 	CMD_OBJ_LIMITS,
+	CMD_OBJ_TUNNEL,
+	CMD_OBJ_TUNNELS,
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
 	CMD_OBJ_CT_TIMEOUT,
diff --git a/src/evaluate.c b/src/evaluate.c
index 48c65cd2f35a..0c2a8d0a9571 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3520,9 +3520,31 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 	return 0;
 }
 
+static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
+{
+	if (obj->tunnel.src != NULL) {
+		__expr_set_context(&ctx->ectx, &ipaddr_type,
+				   BYTEORDER_BIG_ENDIAN,
+				   sizeof(struct in_addr) * BITS_PER_BYTE, 0);
+		if (expr_evaluate(ctx, &obj->tunnel.src) < 0)
+			return -1;
+        }
+	if (obj->tunnel.dst != NULL) {
+		__expr_set_context(&ctx->ectx, &ipaddr_type,
+				   BYTEORDER_BIG_ENDIAN,
+				   sizeof(struct in_addr) * BITS_PER_BYTE, 0);
+		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	switch (obj->type) {
+	case NFT_OBJECT_TUNNEL:
+		return tunnel_evaluate(ctx, obj);
 	case NFT_OBJECT_CT_TIMEOUT:
 		return ct_timeout_evaluate(ctx, obj);
 	case NFT_OBJECT_CT_EXPECT:
@@ -3604,6 +3626,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_TUNNEL:
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
diff --git a/src/mnl.c b/src/mnl.c
index eab8d5486437..e9021e4515ae 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -951,6 +951,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		    unsigned int flags)
 {
 	struct obj *obj = cmd->object;
+	struct nft_data_linearize nld;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
 
@@ -985,6 +986,43 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_LIMIT_TYPE, obj->limit.type);
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_LIMIT_FLAGS, obj->limit.flags);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_TUNNEL_ID, obj->tunnel.id);
+		if (obj->tunnel.sport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT,
+					  obj->tunnel.sport);
+		if (obj->tunnel.dport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT,
+					  obj->tunnel.dport);
+		if (obj->tunnel.tos)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_TOS,
+					  obj->tunnel.tos);
+		if (obj->tunnel.ttl)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_TTL,
+					  obj->tunnel.ttl);
+		if (obj->tunnel.src) {
+			netlink_gen_data(obj->tunnel.src, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_SRC,
+						  nld.value[0]);
+			}
+		} else {
+			nftnl_obj_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC,
+				      nld.value);
+		}
+		if (obj->tunnel.dst) {
+			netlink_gen_data(obj->tunnel.dst, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_DST,
+						  nld.value[0]);
+			} else {
+				nftnl_obj_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST,
+					      nld.value);
+			}
+		}
+		break;
 	case NFT_OBJECT_CT_HELPER:
 		nftnl_obj_set_str(nlo, NFTNL_OBJ_CT_HELPER_NAME,
 				  obj->ct_helper.name);
diff --git a/src/netlink.c b/src/netlink.c
index 14b0df410726..bcb5ecc6bb32 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -936,6 +936,51 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static struct in6_addr all_zeroes;
+
+static struct expr *netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo,
+						  int attr)
+{
+	struct nft_data_delinearize nld;
+	const struct datatype *dtype;
+	const uint32_t *addr6;
+	struct expr *expr;
+	uint32_t addr;
+
+	memset(&nld, 0, sizeof(nld));
+
+	switch (attr) {
+	case NFTNL_OBJ_TUNNEL_IPV4_SRC:
+	case NFTNL_OBJ_TUNNEL_IPV4_DST:
+		addr = nftnl_obj_get_u32(nlo, attr);
+		if (!addr)
+			return NULL;
+
+		dtype = &ipaddr_type;
+		nld.value = &addr;
+		nld.len = sizeof(struct in_addr);
+		break;
+	case NFTNL_OBJ_TUNNEL_IPV6_SRC:
+	case NFTNL_OBJ_TUNNEL_IPV6_DST:
+		addr6 = nftnl_obj_get(nlo, attr);
+		if (!memcmp(addr6, &all_zeroes, sizeof(all_zeroes)))
+			return NULL;
+
+		dtype = &ip6addr_type;
+		nld.value = addr6;
+		nld.len = sizeof(struct in6_addr);
+		break;
+	default:
+		return NULL;
+	}
+
+	expr = netlink_alloc_value(&netlink_location, &nld);
+	expr->dtype	= dtype;
+	expr->byteorder	= BYTEORDER_BIG_ENDIAN;
+
+	return expr;
+}
+
 struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 				    struct nftnl_obj *nlo)
 {
@@ -1008,6 +1053,38 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->ct_expect.size =
 			nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_EXPECT_SIZE);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		obj->tunnel.id = nftnl_obj_get_u64(nlo, NFTNL_OBJ_TUNNEL_ID);
+		obj->tunnel.sport =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
+		obj->tunnel.dport =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
+		obj->tunnel.tos =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_TOS) >> 2;
+		obj->tunnel.ttl =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_TTL);
+
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo,
+					NFTNL_OBJ_TUNNEL_IPV4_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo,
+					NFTNL_OBJ_TUNNEL_IPV4_DST);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo,
+					NFTNL_OBJ_TUNNEL_IPV6_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo,
+					NFTNL_OBJ_TUNNEL_IPV6_DST);
+		}
+		break;
 	}
 	obj->type = type;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53e669521efa..d3b64b641700 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -459,6 +459,7 @@ int nft_lex(void *, void *, void *);
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
+%token TUNNELS			"tunnels"
 %token HELPERS			"helpers"
 
 %token LOG			"log"
@@ -589,7 +590,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block tunnel_block limit_block secmark_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -697,8 +698,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj tunnel_obj secmark_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj tunnel_obj secmark_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -1009,6 +1010,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}'	stmt_separator
+			{
+				$$ = cmd_alloc_obj_ct(CMD_ADD, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -1102,6 +1107,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}'	stmt_separator
+			{
+				$$ = cmd_alloc_obj_ct(CMD_CREATE, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -1589,6 +1598,15 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	TUNNEL	obj_identifier  obj_block_alloc '{'     tunnel_block     '}' stmt_separator
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_TUNNEL;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -3698,6 +3716,32 @@ limit_obj		:	limit_config
 			}
 			;
 
+tunnel_config		:	TYPE	string		stmt_separator	{	$<obj>0->tunnel.type = $2;	}
+			|	ID	NUM		stmt_separator	{	$<obj>0->tunnel.id = $2;	}
+			|	IP	SADDR	expr	stmt_separator	{	$<obj>0->tunnel.src = $3;	}
+			|	IP	DADDR	expr	stmt_separator	{	$<obj>0->tunnel.dst = $3;	}
+			|	SPORT	NUM		stmt_separator	{	$<obj>0->tunnel.sport = $2;	}
+			|	DPORT	NUM		stmt_separator	{	$<obj>0->tunnel.dport = $2;	}
+			|	DSCP	NUM		stmt_separator	{	$<obj>0->tunnel.tos = $2 << 2;	}
+			|	TTL	NUM		stmt_separator	{	$<obj>0->tunnel.ttl = $2;	}
+			;
+
+tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       tunnel_block     common_block
+			|       tunnel_block     stmt_separator
+			|       tunnel_block     tunnel_config
+			{
+				$$ = $1;
+			}
+			;
+
+tunnel_obj		:
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_TUNNEL;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/rule.c b/src/rule.c
index 293606576044..b99786ba967a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1442,6 +1442,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_CT_TIMEOUT:
 		case CMD_OBJ_CT_EXPECT:
 		case CMD_OBJ_LIMIT:
+		case CMD_OBJ_TUNNEL:
 		case CMD_OBJ_SECMARK:
 			obj_free(cmd->object);
 			break;
@@ -1533,6 +1534,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_TUNNEL:
 	case CMD_OBJ_SECMARK:
 		return mnl_nft_obj_add(ctx, cmd, flags);
 	case CMD_OBJ_FLOWTABLE:
@@ -1617,6 +1619,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_LIMIT:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_LIMIT);
+	case CMD_OBJ_TUNNEL:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_SECMARK:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SECMARK);
 	case CMD_OBJ_FLOWTABLE:
@@ -1903,6 +1907,18 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, "%s", opts->nl);
 		}
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nft_print(octx, " %s {%s", obj->handle.obj.name, opts->nl);
+
+		nft_print(octx, "%s%sid %u%s",
+			  opts->tab, opts->tab, obj->tunnel.id, opts->nl);
+
+		if (obj->tunnel.dst) {
+			nft_print(octx, "%s%sip daddr ",
+				  opts->tab, opts->tab);
+			expr_print(obj->tunnel.dst, octx);
+		}
+		break;
 	default:
 		nft_print(octx, " unknown {%s", opts->nl);
 		break;
@@ -1914,6 +1930,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "ct helper",
 	[NFT_OBJECT_LIMIT]	= "limit",
+	[NFT_OBJECT_TUNNEL]	= "tunnel",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
@@ -1931,6 +1948,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_QUOTA]	= CMD_OBJ_QUOTA,
 	[NFT_OBJECT_CT_HELPER]	= CMD_OBJ_CT_HELPER,
 	[NFT_OBJECT_LIMIT]	= CMD_OBJ_LIMIT,
+	[NFT_OBJECT_TUNNEL]	= CMD_OBJ_TUNNEL,
 	[NFT_OBJECT_CT_TIMEOUT] = CMD_OBJ_CT_TIMEOUT,
 	[NFT_OBJECT_SECMARK]	= CMD_OBJ_SECMARK,
 	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
@@ -2297,6 +2315,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_LIMITS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_SECMARKS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SECMARK);
diff --git a/src/scanner.l b/src/scanner.l
index 4ed5f9241381..f8575638a47b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -326,6 +326,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "quotas"		{ return QUOTAS; }
 "limits"		{ return LIMITS; }
 
+"tunnel"		{ return TUNNEL; }
+"tunnels"		{ return TUNNELS; }
+
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
 "group"			{ return GROUP; }
@@ -577,7 +580,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "reqid"			{ return REQID; }
 "spnum"			{ return SPNUM; }
 "transport"		{ return TRANSPORT; }
-"tunnel"		{ return TUNNEL; }
 
 "in"			{ return IN; }
 "out"			{ return OUT; }
-- 
2.11.0

