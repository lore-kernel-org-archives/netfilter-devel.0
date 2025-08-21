Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118592E4270
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767603; cv=none; b=nBsVpymQee5KcA0/Iebn/8yN/ZF9KBJrbv2F4/B4Q7MQk9LSmXJhIW/PpQ3Ng5E2BF6WIWJYouSP7RGdu91a9yjsjHA2qBrLAux9pGGFE+j6fULaltFuJAxU4eeHl3LE1e7almTshGZ3ZG/YQZsIKqRMjwQ2mX0x7AA31wMa7g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767603; c=relaxed/simple;
	bh=vP/sZdVBBOq5CJDYhElNV4lwSdAubGUbwfK6WWvlaq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uAmqgweyu11dwReVJwJZQK8OFciTt+47O2eKU3OTExCdX1vEoRuFc3GSSdxifWz9J04F8f/jLU4xS244fJf5nYlctKrMyDTYSV/uYpbd1iwzc85cO+fNJNdZ5rLxhqrekE2hB5rAA74NmBcbD8q7Q4IbfCrzmeHUNMOddKjvVas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id B1CEE2165AF3; Thu, 21 Aug 2025 11:13:09 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/7 nft v3] src: add tunnel template support
Date: Thu, 21 Aug 2025 11:12:56 +0200
Message-ID: <20250821091302.9032-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds tunnel template support, this allows to attach a
metadata template that provides the configuration for the tunnel driver.

Example of generic tunnel configuration:

 table netdev x {
        tunnel y {
                id 10
                ip saddr 192.168.2.10
                ip daddr 192.168.2.11
                sport 10
                dport 20
                ttl 10
        }
 }

This still requires the tunnel statement to attach this metadata
template, this comes in a follow up patch.

Joint work with Fernando.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v3: support for ipv6 by Pablo
---
 include/parser.h   |   1 +
 include/rule.h     |  13 ++++++
 src/cache.c        |   2 +
 src/evaluate.c     |  26 ++++++++++++
 src/json.c         |   7 +++
 src/mnl.c          |  40 +++++++++++++++++
 src/netlink.c      |  81 +++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 104 +++++++++++++++++++++++++++++++++++++++++++--
 src/parser_json.c  |   8 ++++
 src/rule.c         |  74 +++++++++++++++++++++++++++++++-
 src/scanner.l      |  12 ++++++
 11 files changed, 364 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 576e5e43..8cfd22e9 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -51,6 +51,7 @@ enum startcond_type {
 	PARSER_SC_SECMARK,
 	PARSER_SC_TCP,
 	PARSER_SC_TYPE,
+	PARSER_SC_TUNNEL,
 	PARSER_SC_VLAN,
 	PARSER_SC_XT,
 	PARSER_SC_CMD_DESTROY,
diff --git a/include/rule.h b/include/rule.h
index 470ae107..0fa87b52 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -492,6 +492,16 @@ struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
 
+struct tunnel {
+	uint32_t	id;
+	struct expr	*src;
+	struct expr	*dst;
+	uint16_t	sport;
+	uint16_t	dport;
+	uint8_t		tos;
+	uint8_t		ttl;
+};
+
 /**
  * struct obj - nftables stateful object statement
  *
@@ -518,6 +528,7 @@ struct obj {
 		struct secmark		secmark;
 		struct ct_expect	ct_expect;
 		struct synproxy		synproxy;
+		struct tunnel		tunnel;
 	};
 };
 
@@ -664,6 +675,8 @@ enum cmd_obj {
 	CMD_OBJ_CT_EXPECTATIONS,
 	CMD_OBJ_SYNPROXY,
 	CMD_OBJ_SYNPROXYS,
+	CMD_OBJ_TUNNEL,
+	CMD_OBJ_TUNNELS,
 	CMD_OBJ_HOOKS,
 };
 
diff --git a/src/cache.c b/src/cache.c
index d58fb59f..09aa20bf 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -443,6 +443,8 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_CT_EXPECTATIONS:
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
 		if (h->table.name &&
 		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
 			loc = &h->table.location;
diff --git a/src/evaluate.c b/src/evaluate.c
index aaeb7b4e..da8794dd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5856,6 +5856,29 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 	return 0;
 }
 
+static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
+{
+	if (obj->tunnel.src) {
+		expr_set_context(&ctx->ectx, obj->tunnel.src->dtype,
+				 obj->tunnel.src->dtype->size);
+		if (expr_evaluate(ctx, &obj->tunnel.src) < 0)
+			return -1;
+	}
+
+	if (obj->tunnel.dst) {
+		expr_set_context(&ctx->ectx, obj->tunnel.dst->dtype,
+				 obj->tunnel.dst->dtype->size);
+		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
+			return -1;
+	}
+
+	if (obj->tunnel.src->dtype != obj->tunnel.dst->dtype)
+		return __stmt_binary_error(ctx, &obj->location, NULL,
+					  "specify either ip or ip6 for address");
+
+	return 0;
+}
+
 static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	struct table *table;
@@ -5874,6 +5897,8 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 		return ct_timeout_evaluate(ctx, obj);
 	case NFT_OBJECT_CT_EXPECT:
 		return ct_expect_evaluate(ctx, obj);
+	case NFT_OBJECT_TUNNEL:
+		return tunnel_evaluate(ctx, obj);
 	default:
 		break;
 	}
@@ -5926,6 +5951,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_TUNNEL:
 		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
diff --git a/src/json.c b/src/json.c
index a1e8c047..bb14e1bd 100644
--- a/src/json.c
+++ b/src/json.c
@@ -487,6 +487,9 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		/* TODO */
+		break;
 	}
 
 	return nft_json_pack("{s:o}", type, root);
@@ -2035,6 +2038,10 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SYNPROXY);
 		break;
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_TUNNEL);
+		break;
 	case CMD_OBJ_FLOWTABLE:
 		root = do_list_flowtable_json(ctx, cmd, table);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 66840296..e17f2c2f 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1478,6 +1478,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
 	struct obj *obj = cmd->object;
+	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
@@ -1566,6 +1567,45 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS,
 				  obj->synproxy.flags);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_TUNNEL_ID, obj->tunnel.id);
+		if (obj->tunnel.sport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT,
+					  obj->tunnel.sport);
+		if (obj->tunnel.dport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT,
+					  obj->tunnel.dport);
+		if (obj->tunnel.tos)
+			nftnl_obj_set_u8(nlo, NFTNL_OBJ_TUNNEL_TOS,
+					  obj->tunnel.tos);
+		if (obj->tunnel.ttl)
+			nftnl_obj_set_u8(nlo, NFTNL_OBJ_TUNNEL_TTL,
+					  obj->tunnel.ttl);
+		if (obj->tunnel.src) {
+			netlink_gen_data(obj->tunnel.src, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_SRC,
+						  nld.value[0]);
+			} else {
+				nftnl_obj_set_data(nlo,
+						   NFTNL_OBJ_TUNNEL_IPV6_SRC,
+						   nld.value, nld.len);
+			}
+		}
+		if (obj->tunnel.dst) {
+			netlink_gen_data(obj->tunnel.dst, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_DST,
+						  nld.value[0]);
+		        } else {
+				nftnl_obj_set_data(nlo,
+						   NFTNL_OBJ_TUNNEL_IPV6_DST,
+						   nld.value, nld.len);
+			}
+		}
+		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index 94cbcbfc..f0a9c02b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1744,6 +1744,51 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static struct in6_addr all_zeroes;
+
+static struct expr *
+netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
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
+	expr->dtype     = dtype;
+	expr->byteorder = BYTEORDER_BIG_ENDIAN;
+
+	return expr;
+}
+
 static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 {
 	unsigned char *value = nftnl_udata_get(attr);
@@ -1858,6 +1903,42 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->synproxy.flags =
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ID))
+			obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_SPORT)) {
+			obj->tunnel.sport =
+				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_DPORT)) {
+			obj->tunnel.dport =
+				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TOS)) {
+			obj->tunnel.tos =
+				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TTL)) {
+			obj->tunnel.ttl =
+				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
+		}
+		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
 		obj_free(obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1e4b3f8a..367c6b3b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -411,6 +411,7 @@ int nft_lex(void *, void *, void *);
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
+%token TOS			"tos"
 %token PROTOCOL			"protocol"
 %token CHECKSUM			"checksum"
 
@@ -605,9 +606,12 @@ int nft_lex(void *, void *, void *);
 %token LAST			"last"
 %token NEVER			"never"
 
+%token TUNNEL			"tunnel"
+
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
+%token TUNNELS			"tunnels"
 %token SYNPROXYS		"synproxys"
 %token HELPERS			"helpers"
 
@@ -761,7 +765,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -880,8 +884,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -1084,6 +1088,7 @@ close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPL
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
+close_scope_tunnel	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TUNNEL); }
 close_scope_xt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_XT); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
@@ -1300,6 +1305,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}' close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -1403,6 +1412,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}'	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -1500,6 +1513,10 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
+			|	TUNNEL		obj_or_id_spec	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
+			}
 			;
 
 destroy_cmd		:	TABLE		table_or_id_spec
@@ -1567,6 +1584,10 @@ destroy_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
+			|	TUNNEL		obj_or_id_spec	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
+			}
 			;
 
 
@@ -2046,6 +2067,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	TUNNEL	obj_identifier
+					obj_block_alloc '{'     tunnel_block     '}'
+					stmt_separator close_scope_tunnel
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
@@ -4926,6 +4958,72 @@ limit_obj		:	/* empty */
 			}
 			;
 
+tunnel_config		:	ID	NUM
+			{
+				$<obj>0->tunnel.id = $2;
+			}
+			|	IP	SADDR	expr	close_scope_ip
+			{
+				$<obj>0->tunnel.src = $3;
+				datatype_set($3, &ipaddr_type);
+			}
+			|	IP	DADDR	expr	close_scope_ip
+			{
+				$<obj>0->tunnel.dst = $3;
+				datatype_set($3, &ipaddr_type);
+			}
+			|	IP6	SADDR	expr	close_scope_ip6
+			{
+				$<obj>0->tunnel.src = $3;
+				datatype_set($3, &ip6addr_type);
+			}
+			|	IP6	DADDR	expr	close_scope_ip6
+			{
+				$<obj>0->tunnel.dst = $3;
+				datatype_set($3, &ip6addr_type);
+			}
+			|	SPORT	NUM
+			{
+				$<obj>0->tunnel.sport = $2;
+			}
+			|	DPORT	NUM
+			{
+				$<obj>0->tunnel.dport = $2;
+			}
+			|	TTL	NUM
+			{
+				$<obj>0->tunnel.ttl = $2;
+			}
+			|	TOS	NUM
+			{
+				$<obj>0->tunnel.tos = $2;
+			}
+			;
+
+tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       tunnel_block     common_block
+			|       tunnel_block     stmt_separator
+			|       tunnel_block     tunnel_config	stmt_separator
+			{
+				$$ = $1;
+			}
+			|       tunnel_block     comment_spec
+			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					free_const($2);
+					YYERROR;
+				}
+				$<obj>1->comment = $2;
+			}
+			;
+
+tunnel_obj		:	/* empty */
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_TUNNEL;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/parser_json.c b/src/parser_json.c
index 71e44f19..ebb96d79 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3212,6 +3212,7 @@ static int string_to_nft_object(const char *str)
 		[NFT_OBJECT_SECMARK]	= "secmark",
 		[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 		[NFT_OBJECT_SYNPROXY]	= "synproxy",
+		[NFT_OBJECT_TUNNEL]	= "tunnel",
 	};
 	unsigned int i;
 
@@ -3712,6 +3713,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 
 		obj->synproxy.flags |= flags;
 		break;
+	case CMD_OBJ_TUNNEL:
+		/* TODO */
+		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
 	}
@@ -3748,6 +3752,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
 		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
@@ -3883,6 +3888,7 @@ static struct cmd *json_parse_cmd_list_multiple(struct json_ctx *ctx,
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_CT_HELPERS:
+	case CMD_OBJ_TUNNELS:
 		if (!json_unpack(root, "{s:s}", "table", &tmp))
 			h.table.name = xstrdup(tmp);
 		break;
@@ -3921,6 +3927,8 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "ct helpers", CMD_OBJ_CT_HELPERS, json_parse_cmd_list_multiple },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
+		{ "tunnels", CMD_OBJ_TUNNELS, json_parse_cmd_list_multiple },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "limits", CMD_OBJ_LIMIT, json_parse_cmd_list_multiple },
 		{ "ruleset", CMD_OBJ_RULESET, json_parse_cmd_list_multiple },
diff --git a/src/rule.c b/src/rule.c
index 0ad948ea..5b79facb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1439,6 +1439,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_LIMIT:
 		case CMD_OBJ_SECMARK:
 		case CMD_OBJ_SYNPROXY:
+		case CMD_OBJ_TUNNEL:
 			obj_free(cmd->object);
 			break;
 		case CMD_OBJ_FLOWTABLE:
@@ -1539,6 +1540,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_TUNNEL:
 		return mnl_nft_obj_add(ctx, cmd, flags);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_add(ctx, cmd, flags);
@@ -1619,6 +1621,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SECMARK);
 	case CMD_OBJ_SYNPROXY:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_TUNNEL:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_del(ctx, cmd);
 	default:
@@ -1689,7 +1693,8 @@ void obj_free(struct obj *obj)
 		return;
 	free_const(obj->comment);
 	handle_free(&obj->handle);
-	if (obj->type == NFT_OBJECT_CT_TIMEOUT) {
+	switch (obj->type) {
+	case NFT_OBJECT_CT_TIMEOUT: {
 		struct timeout_state *ts, *next;
 
 		list_for_each_entry_safe(ts, next, &obj->ct_timeout.timeout_list, head) {
@@ -1697,6 +1702,14 @@ void obj_free(struct obj *obj)
 			free_const(ts->timeout_str);
 			free(ts);
 		}
+		}
+		break;
+	case NFT_OBJECT_TUNNEL:
+		expr_free(obj->tunnel.src);
+		expr_free(obj->tunnel.dst);
+		break;
+	default:
+		break;
 	}
 	free(obj);
 }
@@ -1956,6 +1969,60 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, "%s", opts->stmt_separator);
 		}
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nft_print(octx, " %s {", obj->handle.obj.name);
+		if (nft_output_handle(octx))
+			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+
+		obj_print_comment(obj, opts, octx);
+
+		nft_print(octx, "%s%s%sid %u",
+			  opts->nl, opts->tab, opts->tab, obj->tunnel.id);
+
+		if (obj->tunnel.src) {
+			if (obj->tunnel.src->len == 32) {
+				nft_print(octx, "%s%s%sip saddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.src, octx);
+			} else if (obj->tunnel.src->len == 128) {
+				nft_print(octx, "%s%s%sip6 saddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.src, octx);
+			}
+		}
+		if (obj->tunnel.dst) {
+			if (obj->tunnel.dst->len == 32) {
+				nft_print(octx, "%s%s%sip daddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.dst, octx);
+			} else if (obj->tunnel.dst->len == 128) {
+				nft_print(octx, "%s%s%sip6 daddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.dst, octx);
+			}
+		}
+		if (obj->tunnel.sport) {
+			nft_print(octx, "%s%s%ssport %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.sport);
+		}
+		if (obj->tunnel.dport) {
+			nft_print(octx, "%s%s%sdport %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.dport);
+		}
+		if (obj->tunnel.tos) {
+			nft_print(octx, "%s%s%stos %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.tos);
+		}
+		if (obj->tunnel.ttl) {
+			nft_print(octx, "%s%s%sttl %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.ttl);
+		}
+		nft_print(octx, "%s", opts->stmt_separator);
+		break;
 	default:
 		nft_print(octx, " unknown {%s", opts->nl);
 		break;
@@ -1971,6 +2038,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
+	[NFT_OBJECT_TUNNEL]	= "tunnel",
 };
 
 const char *obj_type_name(unsigned int type)
@@ -1989,6 +2057,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_SECMARK]	= CMD_OBJ_SECMARK,
 	[NFT_OBJECT_SYNPROXY]	= CMD_OBJ_SYNPROXY,
 	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
+	[NFT_OBJECT_TUNNEL]	= CMD_OBJ_TUNNEL,
 };
 
 enum cmd_obj obj_type_to_cmd(uint32_t type)
@@ -2458,6 +2527,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_SYNPROXYS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_FLOWTABLE:
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
diff --git a/src/scanner.l b/src/scanner.l
index b69d8e81..5e848890 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -223,6 +223,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_SECMARK
 %s SCANSTATE_TCP
 %s SCANSTATE_TYPE
+%s SCANSTATE_TUNNEL
 %s SCANSTATE_VLAN
 %s SCANSTATE_XT
 %s SCANSTATE_CMD_DESTROY
@@ -403,6 +404,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"maps"			{ return MAPS; }
 	"secmarks"		{ return SECMARKS; }
 	"synproxys"		{ return SYNPROXYS; }
+	"tunnel"		{ return TUNNEL; }
+	"tunnels"		{ return TUNNELS; }
 	"hooks"			{ return HOOKS; }
 }
 
@@ -811,6 +814,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"sack-perm"		{ return SACK_PERM; }
 }
 
+"tunnel"		{ scanner_push_start_cond(yyscanner, SCANSTATE_TUNNEL); return TUNNEL; }
+<SCANSTATE_TUNNEL>{
+	"id"			{ return ID; }
+	"sport"			{ return SPORT; }
+	"dport"			{ return DPORT; }
+	"ttl"			{ return TTL; }
+	"tos"			{ return TOS; }
+}
+
 "notrack"		{ return NOTRACK; }
 
 "all"			{ return ALL; }
-- 
2.50.1

