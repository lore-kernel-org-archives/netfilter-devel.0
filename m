From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/2] src: limit stateful object support
Date: Wed, 23 Aug 2017 22:42:56 +0200
Message-ID: <20170823204256.31634-2-pablombg@gmail.com>
References: <20170823204256.31634-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35419 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754207AbdHWUnM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:43:12 -0400
Received: by mail-wr0-f194.google.com with SMTP id n53so380289wrb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:43:11 -0700 (PDT)
In-Reply-To: <20170823204256.31634-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for a new type of stateful object: limit.
Creation, deletion and listing operations are supported.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/linux/netfilter/nf_tables.h |   3 +-
 include/rule.h                      |  13 +++++
 include/statement.h                 |   1 +
 src/evaluate.c                      |   5 ++
 src/netlink.c                       |  19 +++++++
 src/parser_bison.y                  | 101 ++++++++++++++++++++++++++++++++++--
 src/rule.c                          |  43 ++++++++++++++-
 src/scanner.l                       |   1 +
 src/statement.c                     |   3 +-
 9 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 5441b19..f328944 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1278,7 +1278,8 @@ enum nft_ct_helper_attributes {
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
 #define NFT_OBJECT_CT_HELPER	3
-#define __NFT_OBJECT_MAX	4
+#define NFT_OBJECT_LIMIT	4
+#define __NFT_OBJECT_MAX	5
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/rule.h b/include/rule.h
index 10ac0e2..94f7bb5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -272,6 +272,14 @@ struct ct_helper {
 	uint8_t l4proto;
 };
 
+struct limit {
+	uint64_t	rate;
+	uint64_t	unit;
+	uint32_t	burst;
+	uint32_t	type;
+	uint32_t	flags;
+};
+
 /**
  * struct obj - nftables stateful object statement
  *
@@ -291,6 +299,7 @@ struct obj {
 		struct counter		counter;
 		struct quota		quota;
 		struct ct_helper	ct_helper;
+		struct limit		limit;
 	};
 };
 
@@ -357,6 +366,8 @@ enum cmd_ops {
  * @CMD_OBJ_COUNTERS:	multiple counters
  * @CMD_OBJ_QUOTA:	quota
  * @CMD_OBJ_QUOTAS:	multiple quotas
+ * @CMD_OBJ_LIMIT:	limit
+ * @CMD_OBJ_LIMITS:	multiple limits
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
@@ -381,6 +392,8 @@ enum cmd_obj {
 	CMD_OBJ_QUOTAS,
 	CMD_OBJ_CT_HELPER,
 	CMD_OBJ_CT_HELPERS,
+	CMD_OBJ_LIMIT,
+	CMD_OBJ_LIMITS,
 };
 
 struct export {
diff --git a/include/statement.h b/include/statement.h
index 6d8aaa8..2f702c3 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -325,5 +325,6 @@ extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt, struct output_ctx *octx);
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
+const char *get_unit(uint64_t u);
 
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 3989d5e..a92a66d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2997,6 +2997,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_LIMIT:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3022,6 +3023,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_LIMIT:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3111,9 +3113,12 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_COUNTER);
 	case CMD_OBJ_CT_HELPER:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
+	case CMD_OBJ_LIMIT:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
+	case CMD_OBJ_LIMITS:
 	case CMD_OBJ_SETS:
 		if (cmd->handle.table == NULL)
 			return 0;
diff --git a/src/netlink.c b/src/netlink.c
index f6eb08f..a165809 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -328,6 +328,13 @@ alloc_nftnl_obj(const struct handle *h, struct obj *obj)
 			nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO,
 					  obj->ct_helper.l3proto);
 		break;
+	case NFT_OBJECT_LIMIT:
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_LIMIT_RATE, obj->limit.rate);
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_LIMIT_UNIT, obj->limit.unit);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_LIMIT_BURST, obj->limit.burst);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_LIMIT_TYPE, obj->limit.type);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_LIMIT_FLAGS, obj->limit.flags);
+		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
 		break;
@@ -1743,6 +1750,18 @@ static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->ct_helper.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_HELPER_L3PROTO);
 		obj->ct_helper.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO);
 		break;
+	case NFT_OBJECT_LIMIT:
+		obj->limit.rate =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_LIMIT_RATE);
+		obj->limit.unit =
+			nftnl_obj_get_u64(nlo, NFTNL_OBJ_LIMIT_UNIT);
+		obj->limit.burst =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_LIMIT_BURST);
+		obj->limit.type =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_LIMIT_TYPE);
+		obj->limit.flags =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_LIMIT_FLAGS);
+		break;
 	}
 	obj->type = type;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca86df5..e410298 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -142,6 +142,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct counter		*counter;
 	struct quota		*quota;
 	struct ct		*ct;
+	struct limit		*limit;
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
@@ -393,6 +394,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
+%token LIMITS			"limits"
 
 %token LOG			"log"
 %token PREFIX			"prefix"
@@ -501,7 +503,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_block limit_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -589,8 +591,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -661,6 +663,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { xfree($$); }	counter_config
 %type <quota>			quota_config
 %destructor { xfree($$); }	quota_config
+%type <limit>			limit_config
+%destructor { xfree($$); }	limit_config
 
 %type <expr>			tcp_hdr_expr
 %destructor { expr_free($$); }	tcp_hdr_expr
@@ -864,6 +868,10 @@ add_cmd			:	TABLE		table_spec
 
 				$$ = cmd_alloc_obj_ct(CMD_ADD, type, &$3, &@$, $4);
 			}
+			|	LIMIT		obj_spec	limit_obj
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -943,6 +951,10 @@ create_cmd		:	TABLE		table_spec
 
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, type, &$3, &@$, $4);
 			}
+			|	LIMIT		obj_spec	limit_obj
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_LIMIT, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -996,6 +1008,10 @@ delete_cmd		:	TABLE		table_spec
 
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, type, &$3, &@$, $4);
 			}
+			|	LIMIT		obj_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
+			}
 			;
 
 list_cmd		:	TABLE		table_spec
@@ -1050,6 +1066,18 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
+			|	LIMITS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMITS, &$2, &@$, NULL);
+			}
+			|	LIMITS		TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMITS, &$3, &@$, NULL);
+			}
+			|	LIMIT		obj_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_LIMIT, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
@@ -1311,6 +1339,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	LIMIT		obj_identifier
+					obj_block_alloc	'{'	limit_block	'}'
+					stmt_separator
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_LIMIT;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -1516,6 +1555,15 @@ ct_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
+limit_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       limit_block     common_block
+			|       limit_block     stmt_separator
+			|       limit_block     limit_config
+			{
+				$1->limit = *$2;
+				$$ = $1;
+			}
+			;
 
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
@@ -1989,6 +2037,12 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
 				$$->limit.flags = $3;
 			}
+			|	LIMIT	NAME	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_LIMIT;
+				$$->objref.expr = $3;
+			}
 			;
 
 quota_mode		:	OVER		{ $$ = NFT_QUOTA_F_INV; }
@@ -2745,6 +2799,47 @@ ct_obj_alloc		:
 			}
 			;
 
+limit_config		:	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
+			{
+				struct limit *limit;
+				limit = xzalloc(sizeof(*limit));
+				limit->rate	= $3;
+				limit->unit	= $5;
+				limit->burst	= $6;
+				limit->type	= NFT_LIMIT_PKTS;
+				limit->flags	= $2;
+				$$ = limit;
+			}
+			|	RATE	limit_mode	NUM	STRING	limit_burst
+			{
+				struct limit *limit;
+				struct error_record *erec;
+				uint64_t rate, unit;
+
+				erec = rate_parse(&@$, $4, &rate, &unit);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				limit = xzalloc(sizeof(*limit));
+				limit->rate	= rate * $3;
+				limit->unit	= unit;
+				limit->burst	= $5;
+				limit->type	= NFT_LIMIT_PKT_BYTES;
+				limit->flags	= $2;
+				$$ = limit;
+			}
+			;
+
+limit_obj		:	limit_config
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_LIMIT;
+				$$->limit = *$1;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/rule.c b/src/rule.c
index ef12bec..ae973bd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -959,6 +959,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_COUNTER:
 		case CMD_OBJ_QUOTA:
 		case CMD_OBJ_CT_HELPER:
+		case CMD_OBJ_LIMIT:
 			obj_free(cmd->object);
 			break;
 		default:
@@ -1046,6 +1047,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_LIMIT:
 		return netlink_add_obj(ctx, &cmd->handle, cmd->object, flags);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -1132,6 +1134,9 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_HELPER:
 		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
 					  NFT_OBJECT_CT_HELPER);
+	case CMD_OBJ_LIMIT:
+		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
+					  NFT_OBJECT_LIMIT);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -1292,6 +1297,37 @@ static void obj_print_data(const struct obj *obj,
 		printf("\t\tl3proto %s", family2str(obj->ct_helper.l3proto));
 		break;
 		}
+	case NFT_OBJECT_LIMIT: {
+		bool inv = obj->limit.flags & NFT_LIMIT_F_INV;
+		const char *data_unit;
+		uint64_t rate;
+
+		printf(" %s {%s%s%s", obj->handle.obj,
+				      opts->nl, opts->tab, opts->tab);
+		switch (obj->limit.type) {
+		case NFT_LIMIT_PKTS:
+			printf("limit rate %s%" PRIu64 "/%s",
+			       inv ? "over " : "", obj->limit.rate,
+			       get_unit(obj->limit.unit));
+			if (obj->limit.burst > 0)
+				printf(" burst %u packets", obj->limit.burst);
+			break;
+		case NFT_LIMIT_PKT_BYTES:
+			data_unit = get_rate(obj->limit.rate, &rate);
+
+			printf("limit rate %s%" PRIu64 " %s/%s",
+			       inv ? "over " : "", rate, data_unit,
+			       get_unit(obj->limit.unit));
+			if (obj->limit.burst > 0) {
+				uint64_t burst;
+
+				data_unit = get_rate(obj->limit.burst, &burst);
+				printf(" burst %"PRIu64" %s", burst, data_unit);
+			}
+			break;
+		}
+		}
+		break;
 	default:
 		printf("unknown {%s", opts->nl);
 		break;
@@ -1302,11 +1338,12 @@ static const char *obj_type_name_array[] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "",
+	[NFT_OBJECT_LIMIT]	= "limit",
 };
 
 const char *obj_type_name(enum stmt_types type)
 {
-	assert(type <= NFT_OBJECT_CT_HELPER && obj_type_name_array[type]);
+	assert(type <= NFT_OBJECT_MAX && obj_type_name_array[type]);
 
 	return obj_type_name_array[type];
 }
@@ -1315,6 +1352,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_COUNTER]	= CMD_OBJ_COUNTER,
 	[NFT_OBJECT_QUOTA]	= CMD_OBJ_QUOTA,
 	[NFT_OBJECT_CT_HELPER]	= CMD_OBJ_CT_HELPER,
+	[NFT_OBJECT_LIMIT]	= CMD_OBJ_LIMIT,
 };
 
 uint32_t obj_type_to_cmd(uint32_t type)
@@ -1546,6 +1584,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_CT_HELPERS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
+	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_LIMITS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index b6ba32d..ef424e4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -300,6 +300,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "counters"		{ return COUNTERS; }
 "quotas"		{ return QUOTAS; }
+"limits"		{ return LIMITS; }
 
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
diff --git a/src/statement.c b/src/statement.c
index 58f8aaf..0b2c28b 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -175,6 +175,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "cthelper",
+	[NFT_OBJECT_LIMIT]	= "limit",
 };
 
 static const char *objref_type_name(uint32_t type)
@@ -286,7 +287,7 @@ struct stmt *log_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &log_stmt_ops);
 }
 
-static const char *get_unit(uint64_t u)
+const char *get_unit(uint64_t u)
 {
 	switch (u) {
 	case 1: return "second";
-- 
2.14.1

