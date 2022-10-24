Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34104ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Oct 2022 11:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJXLEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Oct 2022 07:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiJXLDl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2022 07:03:41 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E34A402F4
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Oct 2022 04:01:53 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Mwsb41dHKzDrQN
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Oct 2022 11:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1666609312; bh=49RA/8Hy/jPMTuQRp8hN2QnzlyPdPwP/EnRs5yRFq+w=;
        h=From:To:Cc:Subject:Date:From;
        b=F3sJ4wzunsrKOOgxs3+KHfZe/6LPIMUO6n3JietTxNooNvLueFHlvzWaYuemCLaah
         HlS4C2t6fN4pbVagDzYxjiSZlyXZ2YRFxk397RMPVusjEbxy5sLXuAHs5481T1Hbxa
         8HuODDKCLQPN5WUI0QllExBPrSatsfq+owgDDiIE=
X-Riseup-User-ID: 8F679A75167294461A37B59CC50F9481423FC9BA9AA2B15606A73E4CDCF6B6F4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4Mwsb25wfvz5wF5;
        Mon, 24 Oct 2022 11:01:50 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v3] src: add support to command "destroy"
Date:   Mon, 24 Oct 2022 13:01:22 +0200
Message-Id: <20221024110122.1248-1-ffmancera@riseup.net>
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
---
 doc/nft.txt                                   | 26 +++++--
 include/rule.h                                |  2 +
 src/cache.c                                   |  1 +
 src/evaluate.c                                |  3 +
 src/libnftables.c                             | 17 ++++-
 src/parser_bison.y                            | 75 ++++++++++++++++++-
 src/parser_json.c                             | 16 ++--
 src/rule.c                                    |  1 +
 src/scanner.l                                 |  1 +
 .../testcases/rule_management/0011destroy_0   |  8 ++
 .../testcases/rule_management/0012destroy_0   |  7 ++
 .../rule_management/dumps/0011destroy_0.nft   |  4 +
 .../rule_management/dumps/0012destroy_0.nft   |  4 +
 13 files changed, 145 insertions(+), 20 deletions(-)
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
index a376825d..fea9293b 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -30,8 +30,8 @@ static int nft_netlink(struct nft_ctx *nft,
 	};
 	struct cmd *cmd;
 	struct mnl_err *err, *tmp;
+	int ret = 0, err_num = 0;
 	LIST_HEAD(err_list);
-	int ret = 0;
 
 	if (list_empty(cmds))
 		goto out;
@@ -75,8 +75,12 @@ static int nft_netlink(struct nft_ctx *nft,
 			last_seqnum = cmd->seqnum;
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
-				nft_cmd_error(&ctx, cmd, err);
-				errno = err->err;
+				if (!(err->err == ENOENT &&
+				    cmd->op == CMD_DESTROY)) {
+					nft_cmd_error(&ctx, cmd, err);
+					errno = err->err;
+					err_num++;
+				}
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
 					break;
@@ -89,6 +93,13 @@ static int nft_netlink(struct nft_ctx *nft,
 			last_seqnum = UINT32_MAX;
 		}
 	}
+
+	/* discard return code value when all the errors are ENOENT from
+	 * destroy operations.
+	 */
+	if (!err_num)
+		ret = 0;
+
 	/* nfnetlink uses the first netlink message header in the batch whose
 	 * sequence number is zero to report for EOPNOTSUPP and EPERM errors in
 	 * some scenarios. Now it is safe to release pending errors here.
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

