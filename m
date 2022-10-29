Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72917C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Oct 2022 09:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJ2JXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Oct 2022 05:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ2JXM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2022 05:23:12 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3412E786C8
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 02:23:10 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Mzv8s5hKJzDqM3
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 09:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1667035389; bh=C2ASUUSwWrjsoPhHJvGktdsXYYY9i1NlzjE+/uvrekU=;
        h=From:To:Cc:Subject:Date:From;
        b=tI//wCz2grMOxUWxsfNclNIoY2N6kgmwbiOdSVdkf4LDoHJM3fe2b4RvR5/kaUxIg
         ySp0hMB1B8AZgLT9vV3bw9Dg5WoGe6ImHFY5sO+wxyEkq1/6Sety19jSlHaHUUUl78
         ZMxm2r9/V6cR6RYU93Jv8+8vyc+84YB8a49jTkrA=
X-Riseup-User-ID: 5D22A444D57EE474EF541ACEC01A0078E3EE20BD3D48C5051D7638832420CA75
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4Mzv8q0QGjz1yRB;
        Sat, 29 Oct 2022 09:23:06 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v5] src: add support to command "destroy"
Date:   Sat, 29 Oct 2022 11:22:29 +0200
Message-Id: <20221029092229.69727-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"destroy" command performs a deletion as "delete" command but does not fail
when the object does not exist. As there is no NLM_F_* flag for ignoring such
error, it needs to be ignored directly on error handling.

Example of use:

	# nft list ruleset
        table ip filter {
                chain output {
                }
        }
        # nft destroy table ip missingtable
	# echo $?
	0
        # nft list ruleset
        table ip filter {
                chain output {
                }
        }

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: improve error handling
v3: update manpage
v4: use NFT_MSG_DESTROY* from kernel patch
v5: add variable to handle msg_type
---
 doc/nft.txt                                   | 26 +++++--
 include/linux/netfilter/nf_tables.h           | 14 ++++
 include/rule.h                                |  2 +
 src/cache.c                                   |  1 +
 src/evaluate.c                                |  3 +
 src/libnftables.c                             |  1 +
 src/mnl.c                                     | 46 +++++++++---
 src/parser_bison.y                            | 75 ++++++++++++++++++-
 src/parser_json.c                             | 16 ++--
 src/rule.c                                    |  1 +
 src/scanner.l                                 |  1 +
 .../testcases/rule_management/0011destroy_0   |  8 ++
 .../testcases/rule_management/0012destroy_0   |  7 ++
 .../rule_management/dumps/0011destroy_0.nft   |  4 +
 .../rule_management/dumps/0012destroy_0.nft   |  4 +
 15 files changed, 182 insertions(+), 27 deletions(-)
 create mode 100755 tests/shell/testcases/rule_management/0011destroy_0
 create mode 100755 tests/shell/testcases/rule_management/0012destroy_0
 create mode 100644 tests/shell/testcases/rule_management/dumps/0011destroy_0.nft
 create mode 100644 tests/shell/testcases/rule_management/dumps/0012destroy_0.nft

diff --git a/doc/nft.txt b/doc/nft.txt
index 02cf13a5..76544b2e 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -322,9 +322,10 @@ TABLES
 ------
 [verse]
 {*add* | *create*} *table* ['family'] 'table' [ {*comment* 'comment' *;*'} *{ flags* 'flags' *; }*]
-{*delete* | *list* | *flush*} *table* ['family'] 'table'
+{*delete* | *destroy* | *list* | *flush*} *table* ['family'] 'table'
 *list tables* ['family']
 *delete table* ['family'] *handle* 'handle'
+*destroy table* ['family'] *handle* 'handle'
 
 Tables are containers for chains, sets and stateful objects. They are identified
 by their address family and their name. The address family must be one of *ip*,
@@ -368,6 +369,7 @@ add table inet mytable
 [horizontal]
 *add*:: Add a new table for the given family with the given name.
 *delete*:: Delete the specified table.
+*destroy*:: Delete the specified table, won't fail if it doesn't exist.
 *list*:: List all chains and rules of the specified table.
 *flush*:: Flush all chains and rules of the specified table.
 
@@ -375,9 +377,10 @@ CHAINS
 ------
 [verse]
 {*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] [*comment* 'comment' *;*'] *}*]
-{*delete* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
+{*delete* | *destroy* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
 *list chains* ['family']
 *delete chain* ['family'] 'table' *handle* 'handle'
+*destroy chain* ['family'] 'table' *handle* 'handle'
 *rename chain* ['family'] 'table' 'chain' 'newname'
 
 Chains are containers for rules. They exist in two kinds, base chains and
@@ -390,6 +393,7 @@ organization.
 are specified, the chain is created as a base chain and hooked up to the networking stack.
 *create*:: Similar to the *add* command, but returns an error if the chain already exists.
 *delete*:: Delete the specified chain. The chain must not contain any rules or be used as jump target.
+*destroy*:: Delete the specified chain, won't fail if it doesn't exist. The chain must not contain any rules or be used as jump target.
 *rename*:: Rename the specified chain.
 *list*:: List all rules of the specified chain.
 *flush*:: Flush all rules of the specified chain.
@@ -482,6 +486,7 @@ RULES
 {*add* | *insert*} *rule* ['family'] 'table' 'chain' [*handle* 'handle' | *index* 'index'] 'statement' ... [*comment* 'comment']
 *replace rule* ['family'] 'table' 'chain' *handle* 'handle' 'statement' ... [*comment* 'comment']
 *delete rule* ['family'] 'table' 'chain' *handle* 'handle'
+*destroy rule* ['family'] 'table' 'chain' *handle* 'handle'
 
 Rules are added to chains in the given table. If the family is not specified, the
 ip family is used. Rules are constructed from two kinds of components according
@@ -509,6 +514,7 @@ case the rule is inserted after the specified rule.
 beginning of the chain or before the specified rule.
 *replace*:: Similar to *add*, but the rule replaces the specified rule.
 *delete*:: Delete the specified rule.
+*destroy*:: Delete the specified rule, won't fail if it doesn't exist.
 
 .*add a rule to ip table output chain*
 -------------
@@ -559,10 +565,10 @@ section describes nft set syntax in more detail.
 
 [verse]
 *add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
-{*delete* | *list* | *flush*} *set* ['family'] 'table' 'set'
+{*delete* | *destroy* | *list* | *flush*} *set* ['family'] 'table' 'set'
 *list sets* ['family']
 *delete set* ['family'] 'table' *handle* 'handle'
-{*add* | *delete*} *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
+{*add* | *delete* | *destroy* } *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
 
 Sets are element containers of a user-defined data type, they are uniquely
 identified by a user-defined name and attached to tables. Their behaviour can
@@ -571,6 +577,7 @@ be tuned with the flags that can be specified at set creation time.
 [horizontal]
 *add*:: Add a new set in the specified table. See the Set specification table below for more information about how to specify properties of a set.
 *delete*:: Delete the specified set.
+*destroy*:: Delete the specified set, won't fail if it doesn't exist.
 *list*:: Display the elements in the specified set.
 *flush*:: Remove all elements from the specified set.
 
@@ -612,7 +619,7 @@ MAPS
 -----
 [verse]
 *add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] *}*
-{*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
+{*delete* | *destroy* | *list* | *flush*} *map* ['family'] 'table' 'map'
 *list maps* ['family']
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
@@ -620,6 +627,7 @@ Maps store data based on some specific key used as input. They are uniquely iden
 [horizontal]
 *add*:: Add a new map in the specified table.
 *delete*:: Delete the specified map.
+*destroy*:: Delete the specified map, won't fail if it doesn't exist.
 *list*:: Display the elements in the specified map.
 *flush*:: Remove all elements from the specified map.
 *add element*:: Comma-separated list of elements to add into the specified map.
@@ -654,7 +662,7 @@ ELEMENTS
 --------
 [verse]
 ____
-{*add* | *create* | *delete* | *get* } *element* ['family'] 'table' 'set' *{* 'ELEMENT'[*,* ...] *}*
+{*add* | *create* | *delete* | *destroy* | *get* } *element* ['family'] 'table' 'set' *{* 'ELEMENT'[*,* ...] *}*
 
 'ELEMENT' := 'key_expression' 'OPTIONS' [*:* 'value_expression']
 'OPTIONS' := [*timeout* 'TIMESPEC'] [*expires* 'TIMESPEC'] [*comment* 'string']
@@ -692,7 +700,7 @@ FLOWTABLES
 [verse]
 {*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
 *list flowtables* ['family']
-{*delete* | *list*} *flowtable* ['family'] 'table' 'flowtable'
+{*delete* | *destroy* | *list*} *flowtable* ['family'] 'table' 'flowtable'
 *delete* *flowtable* ['family'] 'table' *handle* 'handle'
 
 Flowtables allow you to accelerate packet forwarding in software. Flowtables
@@ -716,6 +724,7 @@ and subtraction can be used to set relative priority, e.g. filter + 5 equals to
 [horizontal]
 *add*:: Add a new flowtable for the given family with the given name.
 *delete*:: Delete the specified flowtable.
+*destroy*:: Delete the specified flowtable, won't fail if it doesn't exist.
 *list*:: List all flowtables.
 
 LISTING
@@ -732,7 +741,7 @@ kernel modules, such as nf_conntrack.
 STATEFUL OBJECTS
 ----------------
 [verse]
-{*add* | *delete* | *list* | *reset*} 'type' ['family'] 'table' 'object'
+{*add* | *delete* | *destroy* | *list* | *reset*} 'type' ['family'] 'table' 'object'
 *delete* 'type' ['family'] 'table' *handle* 'handle'
 *list counters* ['family']
 *list quotas* ['family']
@@ -745,6 +754,7 @@ keywords "type name" are used e.g. "counter name".
 [horizontal]
 *add*:: Add a new stateful object in the specified table.
 *delete*:: Delete the specified object.
+*destroy*:: Delete the specified object, won't fail if it doesn't exist.
 *list*:: Display stateful information the object holds.
 *reset*:: List-and-reset stateful object.
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 466fd3f4..04423356 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -97,6 +97,13 @@ enum nft_verdicts {
  * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
+ * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
+ * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
+ * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
+ * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
+ * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +131,13 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_DESTROYTABLE,
+	NFT_MSG_DESTROYCHAIN,
+	NFT_MSG_DESTROYRULE,
+	NFT_MSG_DESTROYSET,
+	NFT_MSG_DESTROYSETELEM,
+	NFT_MSG_DESTROYOBJ,
+	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/rule.h b/include/rule.h
index ad9f9127..4003c490 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -562,6 +562,7 @@ void flowtable_print(const struct flowtable *n, struct output_ctx *octx);
  * @CMD_EXPORT:		export the ruleset in a given format
  * @CMD_MONITOR:	event listener
  * @CMD_DESCRIBE:	describe an expression
+ * @CMD_DESTROY:	destroy object
  */
 enum cmd_ops {
 	CMD_INVALID,
@@ -579,6 +580,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	CMD_DESTROY,
 };
 
 /**
diff --git a/src/cache.c b/src/cache.c
index 85de970f..a570fd6c 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -391,6 +391,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags = NFT_CACHE_FULL;
 			break;
 		case CMD_DELETE:
+		case CMD_DESTROY:
 			flags |= NFT_CACHE_TABLE |
 				 NFT_CACHE_CHAIN |
 				 NFT_CACHE_SET |
diff --git a/src/evaluate.c b/src/evaluate.c
index 0bf6a0d1..391a51f0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1547,6 +1547,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 		}
 		break;
 	case CMD_DELETE:
+	case CMD_DESTROY:
 		ret = set_delete(ctx->msgs, ctx->cmd, set, init,
 				 ctx->nft->debug_mask);
 		break;
@@ -5368,6 +5369,7 @@ static const char * const cmd_op_name[] = {
 	[CMD_EXPORT]	= "export",
 	[CMD_MONITOR]	= "monitor",
 	[CMD_DESCRIBE]	= "describe",
+	[CMD_DESTROY]   = "destroy",
 };
 
 static const char *cmd_op_to_name(enum cmd_ops op)
@@ -5400,6 +5402,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_INSERT:
 		return cmd_evaluate_add(ctx, cmd);
 	case CMD_DELETE:
+	case CMD_DESTROY:
 		return cmd_evaluate_delete(ctx, cmd);
 	case CMD_GET:
 		return cmd_evaluate_get(ctx, cmd);
diff --git a/src/libnftables.c b/src/libnftables.c
index a376825d..28488b0d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -89,6 +89,7 @@ static int nft_netlink(struct nft_ctx *nft,
 			last_seqnum = UINT32_MAX;
 		}
 	}
+
 	/* nfnetlink uses the first netlink message header in the batch whose
 	 * sequence number is zero to report for EOPNOTSUPP and EPERM errors in
 	 * some scenarios. Now it is safe to release pending errors here.
diff --git a/src/mnl.c b/src/mnl.c
index e87b0338..7010dc51 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -592,6 +592,7 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELRULE;
 	struct handle *h = &cmd->handle;
 	struct nftnl_rule *nlr;
 	struct nlmsghdr *nlh;
@@ -602,8 +603,11 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
 
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYRULE;
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELRULE,
+				    msg_type,
 				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
 				    0, ctx->seqnum);
 
@@ -847,6 +851,7 @@ int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 
 int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELCHAIN;
 	struct nftnl_chain *nlc;
 	struct nlmsghdr *nlh;
 
@@ -856,8 +861,11 @@ int mnl_nft_chain_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, cmd->handle.family);
 
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYCHAIN;
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELCHAIN,
+				    msg_type,
 				    cmd->handle.family,
 				    0, ctx->seqnum);
 
@@ -992,6 +1000,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELTABLE;
 	struct nftnl_table *nlt;
 	struct nlmsghdr *nlh;
 
@@ -1001,10 +1010,11 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
 
-	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELTABLE,
-				    cmd->handle.family,
-				    0, ctx->seqnum);
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYTABLE;
+
+	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch), msg_type,
+			            cmd->handle.family, 0, ctx->seqnum);
 
 	if (cmd->handle.table.name) {
 		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
@@ -1238,6 +1248,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELSET;
 	const struct handle *h = &cmd->handle;
 	struct nftnl_set *nls;
 	struct nlmsghdr *nlh;
@@ -1248,8 +1259,11 @@ int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	nftnl_set_set_u32(nls, NFTNL_SET_FAMILY, h->family);
 
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYSET;
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELSET,
+				    msg_type,
 				    h->family,
 				    0, ctx->seqnum);
 
@@ -1453,6 +1467,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELOBJ;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
 
@@ -1463,8 +1478,11 @@ int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type)
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_FAMILY, cmd->handle.family);
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, type);
 
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYOBJ;
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELOBJ, cmd->handle.family,
+				    msg_type, cmd->handle.family,
 				    0, ctx->seqnum);
 
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
@@ -1737,6 +1755,7 @@ int mnl_nft_setelem_flush(struct netlink_ctx *ctx, const struct cmd *cmd)
 int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 			const struct handle *h, const struct expr *init)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELSETELEM;
 	struct nftnl_set *nls;
 	int err;
 
@@ -1753,7 +1772,10 @@ int mnl_nft_setelem_del(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, NFT_MSG_DELSETELEM, 0,
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYSETELEM;
+
+	err = mnl_nft_setelem_batch(nls, cmd, ctx->batch, msg_type, 0,
 				    ctx->seqnum, init, ctx);
 	nftnl_set_free(nls);
 
@@ -1960,6 +1982,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
+	enum nf_tables_msg_types msg_type = NFT_MSG_DELFLOWTABLE;
 	struct nftnl_flowtable *flo;
 	const char **dev_array;
 	struct nlmsghdr *nlh;
@@ -1981,8 +2004,11 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 		nft_flowtable_dev_array_free(dev_array);
 	}
 
+	if (cmd->op == CMD_DESTROY)
+		msg_type = NFT_MSG_DESTROYFLOWTABLE;
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
-				    NFT_MSG_DELFLOWTABLE, cmd->handle.family,
+				    msg_type, cmd->handle.family,
 				    0, ctx->seqnum);
 
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 760c23cf..02fde05f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -291,6 +291,8 @@ int nft_lex(void *, void *, void *);
 %token DESCRIBE			"describe"
 %token IMPORT			"import"
 %token EXPORT			"export"
+%token DESTROY			"destroy"
+
 %token MONITOR			"monitor"
 
 %token ALL			"all"
@@ -640,8 +642,8 @@ int nft_lex(void *, void *, void *);
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
+%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd destroy_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd destroy_cmd
 
 %type <handle>			table_spec tableid_spec table_or_id_spec
 %destructor { handle_free(&$$); } table_spec tableid_spec table_or_id_spec
@@ -1080,6 +1082,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	EXPORT		export_cmd	close_scope_export	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	close_scope_monitor	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
+			|	DESTROY		destroy_cmd	{ $$ = $2; }
 			;
 
 add_cmd			:	TABLE		table_spec
@@ -1387,6 +1390,74 @@ delete_cmd		:	TABLE		table_or_id_spec
 			}
 			;
 
+destroy_cmd		:	TABLE		table_or_id_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_TABLE, &$2, &@$, NULL);
+			}
+			|	CHAIN		chain_or_id_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_CHAIN, &$2, &@$, NULL);
+			}
+			|	RULE		ruleid_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_RULE, &$2, &@$, NULL);
+			}
+			|	SET		set_or_id_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
+			|	MAP		set_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
+			|	ELEMENT		set_spec	set_block_expr
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
+			}
+			|	FLOWTABLE	flowtable_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
+			}
+			|	FLOWTABLE	flowtableid_spec
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
+			}
+			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
+						'{'	flowtable_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
+			}
+			|	COUNTER		obj_or_id_spec	close_scope_counter
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_COUNTER, &$2, &@$, NULL);
+			}
+			|	QUOTA		obj_or_id_spec	close_scope_quota
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_QUOTA, &$2, &@$, NULL);
+			}
+			|	CT	ct_obj_type	obj_spec	ct_obj_alloc	close_scope_ct
+			{
+				$$ = cmd_alloc_obj_ct(CMD_DESTROY, $2, &$3, &@$, $4);
+				if ($2 == NFT_OBJECT_CT_TIMEOUT)
+					init_list_head(&$4->ct_timeout.timeout_list);
+			}
+			|	LIMIT		obj_or_id_spec	close_scope_limit
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_LIMIT, &$2, &@$, NULL);
+			}
+			|	SECMARK		obj_or_id_spec	close_scope_secmark
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SECMARK, &$2, &@$, NULL);
+			}
+			|	SYNPROXY	obj_or_id_spec	close_scope_synproxy
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
+			}
+			;
+
+
 get_cmd			:	ELEMENT		set_spec	set_block_expr
 			{
 				$$ = cmd_alloc(CMD_GET, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
diff --git a/src/parser_json.c b/src/parser_json.c
index 76c268f8..75241244 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2923,7 +2923,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:o}", "expr", &tmp))
 		return NULL;
-	else if (op == CMD_DELETE &&
+	else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		 json_unpack_err(ctx, root, "{s:I}", "handle", &h.handle.id))
 		return NULL;
 
@@ -2934,7 +2934,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 	h.table.name = xstrdup(h.table.name);
 	h.chain.name = xstrdup(h.chain.name);
 
-	if (op == CMD_DELETE)
+	if (op == CMD_DELETE || op == CMD_DESTROY)
 		return cmd_alloc(op, obj, &h, int_loc, NULL);
 
 	if (!json_is_array(tmp)) {
@@ -3030,7 +3030,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.set.name)) {
 		return NULL;
-	} else if (op == CMD_DELETE &&
+	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   json_unpack(root, "{s:s}", "name", &h.set.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a set.");
@@ -3047,6 +3047,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 
 	switch (op) {
 	case CMD_DELETE:
+	case CMD_DESTROY:
 	case CMD_LIST:
 	case CMD_FLUSH:
 		return cmd_alloc(op, obj, &h, int_loc, NULL);
@@ -3228,7 +3229,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (op != CMD_DELETE &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.flowtable.name)) {
 		return NULL;
-	} else if (op == CMD_DELETE &&
+	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   json_unpack(root, "{s:s}", "name", &h.flowtable.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete a flowtable.");
@@ -3243,7 +3244,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (h.flowtable.name)
 		h.flowtable.name = xstrdup(h.flowtable.name);
 
-	if (op == CMD_DELETE || op == CMD_LIST)
+	if (op == CMD_DELETE || op == CMD_LIST || op == CMD_DESTROY)
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
 
 	if (json_unpack_err(ctx, root, "{s:s, s:I}",
@@ -3332,7 +3333,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	     cmd_obj == NFT_OBJECT_CT_HELPER) &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.obj.name)) {
 		return NULL;
-	} else if (op == CMD_DELETE &&
+	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
 		   cmd_obj != NFT_OBJECT_CT_HELPER &&
 		   json_unpack(root, "{s:s}", "name", &h.obj.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
@@ -3348,7 +3349,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	if (h.obj.name)
 		h.obj.name = xstrdup(h.obj.name);
 
-	if (op == CMD_DELETE || op == CMD_LIST) {
+	if (op == CMD_DELETE || op == CMD_LIST || op == CMD_DESTROY) {
 		if (cmd_obj == NFT_OBJECT_CT_HELPER)
 			return cmd_alloc_obj_ct(op, NFT_OBJECT_CT_HELPER,
 						&h, int_loc, obj_alloc(int_loc));
@@ -3861,6 +3862,7 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		{ "reset", CMD_RESET, json_parse_cmd_reset },
 		{ "flush", CMD_FLUSH, json_parse_cmd_flush },
 		{ "rename", CMD_RENAME, json_parse_cmd_rename },
+		{ "destroy", CMD_DESTROY, json_parse_cmd_add },
 		//{ "export", CMD_EXPORT, json_parse_cmd_export },
 		//{ "monitor", CMD_MONITOR, json_parse_cmd_monitor },
 		//{ "describe", CMD_DESCRIBE, json_parse_cmd_describe }
diff --git a/src/rule.c b/src/rule.c
index d1ee6c2e..11295648 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2718,6 +2718,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_REPLACE:
 		return do_command_replace(ctx, cmd);
 	case CMD_DELETE:
+	case CMD_DESTROY:
 		return do_command_delete(ctx, cmd);
 	case CMD_GET:
 		return do_command_get(ctx, cmd);
diff --git a/src/scanner.l b/src/scanner.l
index 1371cd04..04e9044d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -357,6 +357,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "import"                { scanner_push_start_cond(yyscanner, SCANSTATE_CMD_IMPORT); return IMPORT; }
 "export"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_EXPORT); return EXPORT; }
 "monitor"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_MONITOR); return MONITOR; }
+"destroy"		{ return DESTROY; }
 
 "position"		{ return POSITION; }
 "index"			{ return INDEX; }
diff --git a/tests/shell/testcases/rule_management/0011destroy_0 b/tests/shell/testcases/rule_management/0011destroy_0
new file mode 100755
index 00000000..895c24a4
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0011destroy_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+$NFT add table t
+$NFT add chain t c
+$NFT insert rule t c accept # should have handle 2
+
+$NFT destroy rule t c handle 2
diff --git a/tests/shell/testcases/rule_management/0012destroy_0 b/tests/shell/testcases/rule_management/0012destroy_0
new file mode 100755
index 00000000..1b61155e
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0012destroy_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+$NFT add table t
+$NFT add chain t c
+
+$NFT destroy rule t c handle 3333
diff --git a/tests/shell/testcases/rule_management/dumps/0011destroy_0.nft b/tests/shell/testcases/rule_management/dumps/0011destroy_0.nft
new file mode 100644
index 00000000..1e0d1d60
--- /dev/null
+++ b/tests/shell/testcases/rule_management/dumps/0011destroy_0.nft
@@ -0,0 +1,4 @@
+table ip t {
+	chain c {
+	}
+}
diff --git a/tests/shell/testcases/rule_management/dumps/0012destroy_0.nft b/tests/shell/testcases/rule_management/dumps/0012destroy_0.nft
new file mode 100644
index 00000000..1e0d1d60
--- /dev/null
+++ b/tests/shell/testcases/rule_management/dumps/0012destroy_0.nft
@@ -0,0 +1,4 @@
+table ip t {
+	chain c {
+	}
+}
-- 
2.30.2

