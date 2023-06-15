Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DFBEB64DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 14:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241325AbjFOOop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbjFOOon (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 10:44:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE202736
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ty5YdZVcKWNhB27IbPVxCUG0igemwo6vok3aVbSoK4g=; b=nGvNmT25uH96JHKKGGtFA6ct1x
        nxL2TxIxp6aQLQ6/A1VMw8FMGU4d8ocM6Lz4szQD1JpIdWqeOxi0h3yKLFgLHtJzzqcLRJX9IBsLW
        XIGpRKm6kdhnStVgj3G8DQWcdJhz+BkXJ8ChTm9OlAhDvXunw/H77scyhEkBcjDdBNy1qI1lJ+m2M
        EyHXjIagQrQBu+B3bRoH5RYV0Q+hVv4xoLIJOU5c11uljfBR+l/jZMWifudgM6PNz7vquUooq1BjF
        IKIabbT+28np6Vewbr0TtZS66FYBUDoCyrRbPYB5Csu5O4uzzHZQ/SrQE7L6H4O5YsW5AL4R5foEQ
        i66+5taA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q9oDH-0003nr-Ko; Thu, 15 Jun 2023 16:44:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/3] Implement 'reset {set,map,element}' commands
Date:   Thu, 15 Jun 2023 16:44:14 +0200
Message-Id: <20230615144414.1393-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230615144414.1393-1-phil@nwl.cc>
References: <20230615144414.1393-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All these are used to reset state in set/map elements, i.e. reset the
timeout or zero quota and counter values.

While 'reset element' expects a (list of) elements to be specified which
should be reset, 'reset set/map' will reset all elements in the given
set/map.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc                  |  2 +-
 doc/nft.txt                                | 13 ++--
 include/linux/netfilter/nf_tables.h        |  2 +
 include/mnl.h                              |  6 +-
 include/netlink.h                          |  5 +-
 src/cache.c                                |  9 ++-
 src/evaluate.c                             |  5 ++
 src/mnl.c                                  | 22 ++++--
 src/netlink.c                              |  8 +--
 src/parser_bison.y                         | 12 ++++
 src/parser_json.c                          |  4 ++
 src/rule.c                                 | 15 +++-
 tests/shell/testcases/sets/reset_command_0 | 82 ++++++++++++++++++++++
 13 files changed, 162 insertions(+), 23 deletions(-)
 create mode 100755 tests/shell/testcases/sets/reset_command_0

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index f9288487e4b25..3e6e1db381d8f 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -175,7 +175,7 @@ kind, optionally filtered by *family* and for some, also *table*.
 ____
 *{ "reset":* 'RESET_OBJECT' *}*
 
-'RESET_OBJECT' := 'COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS' | 'RULE' | 'RULES'
+'RESET_OBJECT' := 'COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS' | 'RULE' | 'RULES' | 'SET' | 'MAP' | 'ELEMENT'
 ____
 
 Reset state in suitable objects, i.e. zero their internal counter.
diff --git a/doc/nft.txt b/doc/nft.txt
index 19ba55d965055..fe123d04f9b95 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -570,7 +570,7 @@ section describes nft set syntax in more detail.
 
 [verse]
 *add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
-{*delete* | *destroy* | *list* | *flush*} *set* ['family'] 'table' 'set'
+{*delete* | *destroy* | *list* | *flush* | *reset* } *set* ['family'] 'table' 'set'
 *list sets* ['family']
 *delete set* ['family'] 'table' *handle* 'handle'
 {*add* | *delete* | *destroy* } *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
@@ -585,6 +585,7 @@ be tuned with the flags that can be specified at set creation time.
 *destroy*:: Delete the specified set, it does not fail if it does not exist.
 *list*:: Display the elements in the specified set.
 *flush*:: Remove all elements from the specified set.
+*reset*:: Reset timeout and other state in all contained elements.
 
 .Set specifications
 [options="header"]
@@ -623,7 +624,7 @@ MAPS
 -----
 [verse]
 *add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] *}*
-{*delete* | *destroy* | *list* | *flush*} *map* ['family'] 'table' 'map'
+{*delete* | *destroy* | *list* | *flush* | *reset* } *map* ['family'] 'table' 'map'
 *list maps* ['family']
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
@@ -634,8 +635,7 @@ Maps store data based on some specific key used as input. They are uniquely iden
 *destroy*:: Delete the specified map, it does not fail if it does not exist.
 *list*:: Display the elements in the specified map.
 *flush*:: Remove all elements from the specified map.
-*add element*:: Comma-separated list of elements to add into the specified map.
-*delete element*:: Comma-separated list of element keys to delete from the specified map.
+*reset*:: Reset timeout and other state in all contained elements.
 
 .Map specifications
 [options="header"]
@@ -682,7 +682,7 @@ ELEMENTS
 --------
 [verse]
 ____
-{*add* | *create* | *delete* | *destroy* | *get* } *element* ['family'] 'table' 'set' *{* 'ELEMENT'[*,* ...] *}*
+{*add* | *create* | *delete* | *destroy* | *get* | *reset* } *element* ['family'] 'table' 'set' *{* 'ELEMENT'[*,* ...] *}*
 
 'ELEMENT' := 'key_expression' 'OPTIONS' [*:* 'value_expression']
 'OPTIONS' := [*timeout* 'TIMESPEC'] [*expires* 'TIMESPEC'] [*comment* 'string']
@@ -702,6 +702,9 @@ listed elements may already exist.
 be non-trivial in very large and/or interval sets. In the latter case, the
 containing interval is returned instead of just the element itself.
 
+*reset* command resets timeout or other state attached to the given
+element(s).
+
 .Element options
 [options="header"]
 |=================
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 673e05073de82..c62e6ac563988 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -105,6 +105,7 @@ enum nft_verdicts {
  * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
  * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETSETELEM_RESET: get set elements and reset attached stateful expressio ns (enum nft_set_elem_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -140,6 +141,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYSETELEM,
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
+	NFT_MSG_GETSETELEM_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/mnl.h b/include/mnl.h
index c067669125395..cd5a2053b1661 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -68,9 +68,11 @@ int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 			const struct handle *h, const struct expr *init);
 int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd);
-int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls);
+int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			bool reset);
 struct nftnl_set *mnl_nft_setelem_get_one(struct netlink_ctx *ctx,
-					  struct nftnl_set *nls);
+					  struct nftnl_set *nls,
+					  bool reset);
 
 struct nftnl_obj_list *mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 					const char *table,
diff --git a/include/netlink.h b/include/netlink.h
index d52434c72bc2c..6766d7e8563fe 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -165,10 +165,11 @@ extern struct stmt *netlink_parse_set_expr(const struct set *set,
 					   const struct nftnl_expr *nle);
 
 extern int netlink_list_setelems(struct netlink_ctx *ctx,
-				 const struct handle *h, struct set *set);
+				 const struct handle *h, struct set *set,
+				 bool reset);
 extern int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc, struct set *cache_set,
-			       struct set *set, struct expr *init);
+			       struct set *set, struct expr *init, bool reset);
 extern int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				       struct set *set,
 				       struct nft_cache *cache);
diff --git a/src/cache.c b/src/cache.c
index 95adee7f8ac17..2dae94183bd80 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -280,6 +280,11 @@ static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
 		flags |= NFT_CACHE_SET | NFT_CACHE_FLOWTABLE |
 			 NFT_CACHE_OBJECT | NFT_CACHE_CHAIN;
 		break;
+	case CMD_OBJ_ELEMENTS:
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+		flags |= NFT_CACHE_SET;
+		break;
 	default:
 		flags |= NFT_CACHE_TABLE;
 		break;
@@ -1066,7 +1071,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
-							    set);
+							    set, false);
 				if (ret < 0)
 					goto cache_fails;
 			}
@@ -1079,7 +1084,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
-							    set);
+							    set, false);
 				if (ret < 0)
 					goto cache_fails;
 			}
diff --git a/src/evaluate.c b/src/evaluate.c
index af7c273c3a0b2..14927ac0bef60 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5450,6 +5450,11 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 			return table_not_found(ctx);
 
 		return 0;
+	case CMD_OBJ_ELEMENTS:
+		return setelem_evaluate(ctx, cmd);
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+		return cmd_evaluate_list(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index 91775c41b2461..9406fc4821236 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1870,14 +1870,21 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 }
 
 struct nftnl_set *mnl_nft_setelem_get_one(struct netlink_ctx *ctx,
-					  struct nftnl_set *nls_in)
+					  struct nftnl_set *nls_in,
+					  bool reset)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_set *nls_out;
 	struct nlmsghdr *nlh;
+	int msg_type;
 	int err;
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
+	if (reset)
+		msg_type = NFT_MSG_GETSETELEM_RESET;
+	else
+		msg_type = NFT_MSG_GETSETELEM;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, msg_type,
 				    nftnl_set_get_u32(nls_in, NFTNL_SET_FAMILY),
 				    NLM_F_ACK, ctx->seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls_in);
@@ -1900,12 +1907,19 @@ struct nftnl_set *mnl_nft_setelem_get_one(struct netlink_ctx *ctx,
 	return nls_out;
 }
 
-int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls)
+int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			bool reset)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	int msg_type;
+
+	if (reset)
+		msg_type = NFT_MSG_GETSETELEM_RESET;
+	else
+		msg_type = NFT_MSG_GETSETELEM;
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
+	nlh = nftnl_nlmsg_build_hdr(buf, msg_type,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				    NLM_F_DUMP, ctx->seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
diff --git a/src/netlink.c b/src/netlink.c
index 3352ad0abb610..ed61cd896511a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1515,7 +1515,7 @@ static int list_setelements(struct nftnl_set *s, struct netlink_ctx *ctx)
 }
 
 int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
-			  struct set *set)
+			  struct set *set, bool reset)
 {
 	struct nftnl_set *nls;
 	int err;
@@ -1530,7 +1530,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	if (h->handle.id)
 		nftnl_set_set_u64(nls, NFTNL_SET_HANDLE, h->handle.id);
 
-	err = mnl_nft_setelem_get(ctx, nls);
+	err = mnl_nft_setelem_get(ctx, nls, reset);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		if (errno == EINTR)
@@ -1558,7 +1558,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc, struct set *cache_set,
-			struct set *set, struct expr *init)
+			struct set *set, struct expr *init, bool reset)
 {
 	struct nftnl_set *nls, *nls_out = NULL;
 	int err = 0;
@@ -1577,7 +1577,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 
 	netlink_dump_set(nls, ctx);
 
-	nls_out = mnl_nft_setelem_get_one(ctx, nls);
+	nls_out = mnl_nft_setelem_get_one(ctx, nls, reset);
 	if (!nls_out) {
 		nftnl_set_free(nls);
 		return -1;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 763c1b2dcd612..979deab88470c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1716,6 +1716,18 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULE, &$2, &@$, NULL);
 			}
+			|	ELEMENT		set_spec	set_block_expr
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
+			}
+			|	SET		set_or_id_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
+			|	MAP		set_or_id_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_MAP, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/parser_json.c b/src/parser_json.c
index f1cc39505382c..6ac2d11a1a800 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3099,6 +3099,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	case CMD_DESTROY:
 	case CMD_LIST:
 	case CMD_FLUSH:
+	case CMD_RESET:
 		return cmd_alloc(op, obj, &h, int_loc, NULL);
 	default:
 		break;
@@ -3848,6 +3849,9 @@ static struct cmd *json_parse_cmd_reset(struct json_ctx *ctx,
 		{ "quotas", CMD_OBJ_QUOTAS, json_parse_cmd_list_multiple },
 		{ "rule", CMD_OBJ_RULE, json_parse_cmd_reset_rule },
 		{ "rules", CMD_OBJ_RULES, json_parse_cmd_reset_rule },
+		{ "element", CMD_OBJ_ELEMENTS, json_parse_cmd_add_element },
+		{ "set", CMD_OBJ_SET, json_parse_cmd_add_set },
+		{ "map", CMD_OBJ_MAP, json_parse_cmd_add_set },
 	};
 	unsigned int i;
 	json_t *tmp;
diff --git a/src/rule.c b/src/rule.c
index 900352d25d6d4..b69855ec8b0fe 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2386,7 +2386,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd, bool reset)
 {
 	struct set *set, *new_set;
 	struct expr *init;
@@ -2404,7 +2404,7 @@ static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	/* Fetch from kernel the elements that have been requested .*/
 	err = netlink_get_setelem(ctx, &cmd->handle, &cmd->location,
-				  cmd->elem.set, new_set, init);
+				  cmd->elem.set, new_set, init, reset);
 	if (err >= 0)
 		__do_list_set(ctx, cmd, new_set);
 
@@ -2420,7 +2420,7 @@ static int do_command_get(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		return do_get_setelems(ctx, cmd);
+		return do_get_setelems(ctx, cmd, false);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -2457,6 +2457,15 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_list(ctx, cmd);
 	case CMD_OBJ_RULE:
 		return netlink_reset_rules(ctx, cmd, false);
+	case CMD_OBJ_ELEMENTS:
+		return do_get_setelems(ctx, cmd, true);
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+		ret = netlink_list_setelems(ctx, &cmd->handle, cmd->set, true);
+		if (ret < 0)
+			return ret;
+
+		return do_command_list(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
new file mode 100755
index 0000000000000..7a088aea2c2f4
--- /dev/null
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -0,0 +1,82 @@
+#!/bin/bash
+
+set -e
+set -x
+
+RULESET="table t {
+	set s {
+		type ipv4_addr . inet_proto . inet_service
+		flags interval, timeout
+		counter
+		timeout 30s
+		elements = {
+			1.0.0.1 . udp . 53 counter packets 5 bytes 30,
+			2.0.0.2 . tcp . 22 counter packets 10 bytes 100 timeout 15s
+		}
+	}
+	map m {
+		type ipv4_addr : ipv4_addr
+		quota 50 bytes
+		elements = {
+			1.2.3.4 quota 50 bytes used 10 bytes : 10.2.3.4,
+			5.6.7.8 quota 100 bytes used 50 bytes : 50.6.7.8
+		}
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
+
+sleep 2
+
+drop_ms() {
+	sed 's/s[0-9]*ms/s/g'
+}
+expires_seconds() {
+	sed -n 's/.*expires \([0-9]*\)s.*/\1/p'
+}
+
+# 'reset element' output is supposed to match 'get element' one
+# apart from changing expires ms value
+EXP=$($NFT get element t s '{ 1.0.0.1 . udp . 53 }' | drop_ms)
+OUT=$($NFT reset element t s '{ 1.0.0.1 . udp . 53 }' | drop_ms)
+$DIFF -u <(echo "$EXP") <(echo "$OUT")
+
+EXP=$($NFT get element t m '{ 1.2.3.4 }')
+OUT=$($NFT reset element t m '{ 1.2.3.4 }')
+$DIFF -u <(echo "$EXP") <(echo "$OUT")
+
+# assert counter value is zeroed
+$NFT get element t s '{ 1.0.0.1 . udp . 53 }' | grep -q 'counter packets 0 bytes 0'
+
+# assert expiry is reset
+VAL=$($NFT get element t s '{ 1.0.0.1 . udp . 53 }' | expires_seconds)
+[[ $VAL -gt 28 ]]
+
+# assert quota value is reset
+$NFT get element t m '{ 1.2.3.4 }' | grep -q 'quota 50 bytes : 10.2.3.4'
+
+# assert other elements remain unchanged
+$NFT get element t s '{ 2.0.0.2 . tcp . 22 }'
+OUT=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }')
+grep -q 'counter packets 10 bytes 100 timeout 15s' <<< "$OUT"
+VAL=$(expires_seconds <<< "$OUT")
+[[ $val -lt 14 ]]
+$NFT get element t m '{ 5.6.7.8 }' | grep -q 'quota 100 bytes used 50 bytes'
+
+# 'reset set' output is supposed to match 'list set' one, again strip the ms values
+EXP=$($NFT list set t s | drop_ms)
+OUT=$($NFT reset set t s | drop_ms)
+$DIFF -u <(echo "$EXP") <(echo "$OUT")
+
+EXP=$($NFT list map t m | drop_ms)
+OUT=$($NFT reset map t m | drop_ms)
+$DIFF -u <(echo "$EXP") <(echo "$OUT")
+
+# assert expiry of element with custom timeout is correct
+VAL=$($NFT get element t s '{ 2.0.0.2 . tcp . 22 }' | expires_seconds)
+[[ $VAL -lt 15 ]]
+
+# assert remaining elements are now all reset
+OUT=$($NFT list ruleset)
+grep -q '2.0.0.2 . tcp . 22 counter packets 0 bytes 0' <<< "$OUT"
+grep -q '5.6.7.8 quota 100 bytes : 50.6.7.8' <<< "$OUT"
-- 
2.40.0

