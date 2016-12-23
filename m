From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 05/10] src: add/create/delete stateful objects
Date: Fri, 23 Dec 2016 15:26:50 +0100
Message-ID: <1482503215-25422-5-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40192 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941235AbcLWO1T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 250842519A0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F44C8E66A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B15BE8E66C
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:10 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows you to add and to delete objects, eg.

 # nft add quota filter test 1234567 bytes
 # nft list quotas
 table ip filter {
        quota test {
                 1234567 bytes
        }

 }
 # nft delete quota filter test

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h      |   5 ++
 include/netlink.h  |   5 ++
 include/rule.h     |   3 +-
 src/evaluate.c     |   5 ++
 src/mnl.c          |  30 ++++++++++
 src/netlink.c      |  95 +++++++++++++++++++++++++++++++
 src/parser_bison.y | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 src/rule.c         |  21 +++++++
 8 files changed, 322 insertions(+), 3 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index ad036aefabbd..d178bd27a75a 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -88,6 +88,11 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
 					const char *table);
+int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
+			  uint32_t seqnum);
+int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
+			  uint32_t seqnum);
+
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 					 uint32_t family);
 int mnl_nft_event_listener(struct mnl_socket *nf_sock,
diff --git a/include/netlink.h b/include/netlink.h
index ce577871761f..841211c43760 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -171,12 +171,17 @@ extern int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *
 
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc);
+extern int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
+			   struct obj *obj, bool excl);
+extern int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
+			      struct location *loc, enum stmt_types type);
 
 extern void netlink_dump_table(const struct nftnl_table *nlt);
 extern void netlink_dump_chain(const struct nftnl_chain *nlc);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr);
 extern void netlink_dump_expr(const struct nftnl_expr *nle);
 extern void netlink_dump_set(const struct nftnl_set *nls);
+extern void netlink_dump_obj(struct nftnl_obj *nlo);
 
 extern int netlink_batch_send(struct list_head *err_list);
 
diff --git a/include/rule.h b/include/rule.h
index e0f891393276..88acbcc7b163 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -282,7 +282,7 @@ struct obj *obj_alloc(const struct location *loc);
 void obj_free(struct obj *obj);
 void obj_add_hash(struct obj *obj, struct table *table);
 void obj_print(const struct obj *n);
-const char *obj_type_name(enum stmt_types type);
+const char *obj_type_name(uint32_t type);
 
 /**
  * enum cmd_ops - command operations
@@ -415,6 +415,7 @@ struct cmd {
 		struct table	*table;
 		struct monitor	*monitor;
 		struct export	*export;
+		struct obj	*object;
 	};
 	const void		*arg;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index b3630c303920..9bc3b7d6477a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2758,6 +2758,9 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
 		return table_evaluate(ctx, cmd->table);
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
+		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -2778,6 +2781,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/mnl.c b/src/mnl.c
index 534d02f4ff32..9458e21bf8b4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -796,6 +796,36 @@ err:
 	return NULL;
 }
 
+int mnl_nft_obj_batch_add(struct nftnl_obj *nln, unsigned int flags,
+			  uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch),
+			NFT_MSG_NEWOBJ,
+			nftnl_obj_get_u32(nln, NFTNL_OBJ_FAMILY),
+			NLM_F_CREATE | flags, seqnum);
+	nftnl_obj_nlmsg_build_payload(nlh, nln);
+	mnl_nft_batch_continue();
+
+	return 0;
+}
+
+int mnl_nft_obj_batch_del(struct nftnl_obj *nln, unsigned int flags,
+			  uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch),
+			NFT_MSG_DELOBJ,
+			nftnl_obj_get_u32(nln, NFTNL_OBJ_FAMILY),
+			flags, seqnum);
+	nftnl_obj_nlmsg_build_payload(nlh, nln);
+	mnl_nft_batch_continue();
+
+	return 0;
+}
+
 static int obj_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_obj_list *nln_list = data;
diff --git a/src/netlink.c b/src/netlink.c
index bbf675f90def..d11b3c01f264 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -21,6 +21,7 @@
 #include <libnftnl/trace.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
+#include <libnftnl/object.h>
 #include <libnftnl/set.h>
 #include <libnftnl/udata.h>
 #include <libnftnl/common.h>
@@ -270,6 +271,51 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *expr)
 	return nlse;
 }
 
+static struct nftnl_obj *
+__alloc_nftnl_obj(const struct handle *h, uint32_t type)
+{
+	struct nftnl_obj *nlo;
+
+	nlo = nftnl_obj_alloc();
+	if (nlo == NULL)
+		memory_allocation_error();
+
+	nftnl_obj_set_u32(nlo, NFTNL_OBJ_FAMILY, h->family);
+	nftnl_obj_set_str(nlo, NFTNL_OBJ_TABLE, h->table);
+	if (h->obj != NULL)
+		nftnl_obj_set_str(nlo, NFTNL_OBJ_NAME, h->obj);
+
+	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, type);
+
+	return nlo;
+}
+
+static struct nftnl_obj *
+alloc_nftnl_obj(const struct handle *h, struct obj *obj)
+{
+	struct nftnl_obj *nlo;
+
+	nlo = __alloc_nftnl_obj(h, obj->type);
+
+	switch (obj->type) {
+	case NFT_OBJECT_COUNTER:
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_CTR_PKTS,
+				  obj->counter.packets);
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_CTR_BYTES,
+				  obj->counter.bytes);
+		break;
+	case NFT_OBJECT_QUOTA:
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_QUOTA_BYTES,
+				  obj->quota.bytes);
+		nftnl_obj_set_u64(nlo, NFTNL_OBJ_QUOTA_CONSUMED,
+				  obj->quota.used);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS,
+				  obj->quota.flags);
+		break;
+	}
+	return nlo;
+}
+
 void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
 			  unsigned int len, struct nft_data_linearize *data)
 {
@@ -1608,6 +1654,55 @@ out:
 	return err;
 }
 
+void netlink_dump_obj(struct nftnl_obj *nln)
+{
+#ifdef DEBUG
+	char buf[4096];
+
+	if (!(debug_level & DEBUG_NETLINK))
+		return;
+
+	nftnl_obj_snprintf(buf, sizeof(buf), nln, 0, 0);
+	fprintf(stdout, "%s\n", buf);
+#endif
+}
+
+int netlink_add_obj(struct netlink_ctx *ctx, const struct handle *h,
+		    struct obj *obj, bool excl)
+{
+	struct nftnl_obj *nlo;
+	int err;
+
+	nlo = alloc_nftnl_obj(h, obj);
+	netlink_dump_obj(nlo);
+
+	err = mnl_nft_obj_batch_add(nlo, excl ? NLM_F_EXCL : 0, ctx->seqnum);
+	if (err < 0)
+		netlink_io_error(ctx, &obj->location, "Could not add %s: %s",
+				 obj_type_name(obj->type), strerror(errno));
+	nftnl_obj_free(nlo);
+
+	return err;
+}
+
+int netlink_delete_obj(struct netlink_ctx *ctx, const struct handle *h,
+		       struct location *loc, uint32_t type)
+{
+	struct nftnl_obj *nlo;
+	int err;
+
+	nlo = __alloc_nftnl_obj(h, type);
+	netlink_dump_obj(nlo);
+
+	err = mnl_nft_obj_batch_del(nlo, 0, ctx->seqnum);
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not delete %s: %s",
+				 obj_type_name(type), strerror(errno));
+	nftnl_obj_free(nlo);
+
+	return err;
+}
+
 static struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 					   struct nftnl_obj *nlo)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2213f3808db4..fd3f0d8251a6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -133,6 +133,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct stmt		*stmt;
 	struct expr		*expr;
 	struct set		*set;
+	struct obj		*obj;
+	struct counter		*counter;
+	struct quota		*quota;
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
@@ -444,8 +447,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%type <handle>			set_spec set_identifier obj_spec
-%destructor { handle_free(&$$); } set_spec set_identifier obj_spec
+%type <handle>			set_spec set_identifier obj_spec obj_identifier
+%destructor { handle_free(&$$); } set_spec set_identifier obj_spec obj_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
 
 %type <string>			dev_spec quota_unit
@@ -468,6 +471,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <set>			map_block_alloc map_block
 %destructor { set_free($$); }	map_block_alloc
 
+%type <obj>			obj_block_alloc counter_block quota_block
+%destructor { obj_free($$); }	obj_block_alloc
+
 %type <list>			stmt_list
 %destructor { stmt_list_free($$); xfree($$); } stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt
@@ -553,6 +559,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
+%type <obj>			counter_obj quota_obj
+%destructor { obj_free($$); }	counter_obj quota_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -616,6 +624,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
 
+%type <counter>			counter_config
+%destructor { xfree($$); }	counter_config
+%type <quota>			quota_config
+%destructor { xfree($$); }	quota_config
+
 %%
 
 input			:	/* empty */
@@ -768,6 +781,23 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
+			|	COUNTER		obj_spec
+			{
+				struct obj *obj;
+
+				obj = obj_alloc(&@$);
+				obj->type = NFT_OBJECT_COUNTER;
+				handle_merge(&obj->handle, &$2);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, obj);
+			}
+			|	COUNTER		obj_spec	counter_obj
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
+			}
+			|	QUOTA		obj_spec	quota_obj
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -817,6 +847,23 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
+			|	COUNTER		obj_spec
+			{
+				struct obj *obj;
+
+				obj = obj_alloc(&@$);
+				obj->type = NFT_OBJECT_COUNTER;
+				handle_merge(&obj->handle, &$2);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, obj);
+			}
+			|	COUNTER		obj_spec	counter_obj
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, $3);
+			}
+			|	QUOTA		obj_spec	quota_obj
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -849,6 +896,14 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SETELEM, &$2, &@$, $3);
 			}
+			|	COUNTER		obj_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	QUOTA		obj_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
+			}
 			;
 
 list_cmd		:	TABLE		table_spec
@@ -1043,6 +1098,28 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->sets);
 				$$ = $1;
 			}
+			|	table_block	COUNTER		obj_identifier
+					obj_block_alloc	'{'	counter_block	'}'
+					stmt_seperator
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_COUNTER;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
+			|	table_block	QUOTA		obj_identifier
+					obj_block_alloc	'{'	quota_block	'}'
+					stmt_seperator
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_QUOTA;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -1193,6 +1270,32 @@ type_identifier_list	:	type_identifier
 			}
 			;
 
+obj_block_alloc		:       /* empty */
+			{
+				$$ = obj_alloc(NULL);
+			}
+			;
+
+counter_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       counter_block     common_block
+			|       counter_block     stmt_seperator
+			|       counter_block     counter_config
+			{
+				$1->counter = *$2;
+				$$ = $1;
+			}
+			;
+
+quota_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       quota_block     common_block
+			|       quota_block     stmt_seperator
+			|       quota_block     quota_config
+			{
+				$1->quota = *$2;
+				$$ = $1;
+			}
+			;
+
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
 			|	DSCP	{ $$ = xstrdup("dscp"); }
@@ -1325,6 +1428,13 @@ obj_spec		:	table_spec	identifier
 			}
 			;
 
+obj_identifier		:	identifier
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.obj		= $1;
+			}
+			;
+
 handle_spec		:	HANDLE		NUM
 			{
 				memset(&$$, 0, sizeof($$));
@@ -2325,6 +2435,53 @@ initializer_expr	:	rhs_expr
 			|	list_rhs_expr
 			;
 
+counter_config		:	PACKETS		NUM	BYTES	NUM
+			{
+				struct counter *counter;
+
+				counter = xzalloc(sizeof(*counter));
+				counter->packets = $2;
+				counter->bytes = $4;
+				$$ = counter;
+			}
+			;
+
+counter_obj		:	counter_config
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_COUNTER;
+				$$->counter = *$1;
+			}
+			;
+
+quota_config		:	quota_mode NUM quota_unit quota_used
+			{
+				struct error_record *erec;
+				struct quota *quota;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $3, &rate);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				quota = xzalloc(sizeof(*quota));
+				quota->bytes	= $2 * rate;
+				quota->used	= $4;
+				quota->flags	= $1;
+				$$ = quota;
+			}
+			;
+
+quota_obj		:	quota_config
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_QUOTA;
+				$$->quota = *$1;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/rule.c b/src/rule.c
index 05f0eb87b162..29b1450666db 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -44,6 +44,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->chain = xstrdup(src->chain);
 	if (dst->set == NULL && src->set != NULL)
 		dst->set = xstrdup(src->set);
+	if (dst->obj == NULL && src->obj != NULL)
+		dst->obj = xstrdup(src->obj);
 	if (dst->handle.id == 0)
 		dst->handle = src->handle;
 	if (dst->position.id == 0)
@@ -875,6 +877,10 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_EXPORT:
 			export_free(cmd->export);
 			break;
+		case CMD_OBJ_COUNTER:
+		case CMD_OBJ_QUOTA:
+			obj_free(cmd->object);
+			break;
 		default:
 			BUG("invalid command object type %u\n", cmd->obj);
 		}
@@ -940,6 +946,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			bool excl)
 {
 	struct chain *chain;
+	struct obj *obj;
 	struct set *set;
 
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
@@ -951,6 +958,11 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 					      excl) < 0)
 				return -1;
 		}
+		list_for_each_entry(obj, &table->objs, list) {
+			handle_merge(&obj->handle, &table->handle);
+			if (netlink_add_obj(ctx, &obj->handle, obj, excl) < 0)
+				return -1;
+		}
 		list_for_each_entry(set, &table->sets, list) {
 			handle_merge(&set->handle, &table->handle);
 			if (do_add_set(ctx, &set->handle, set, excl) < 0)
@@ -980,6 +992,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_set(ctx, &cmd->handle, cmd->set, excl);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr, excl);
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_QUOTA:
+		return netlink_add_obj(ctx, &cmd->handle, cmd->object, excl);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -1043,6 +1058,12 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
 		return do_delete_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_COUNTER:
+		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
+					  NFT_OBJECT_COUNTER);
+	case CMD_OBJ_QUOTA:
+		return netlink_delete_obj(ctx, &cmd->handle, &cmd->location,
+					  NFT_OBJECT_QUOTA);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.1.4

