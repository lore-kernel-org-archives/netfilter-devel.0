Return-Path: <SRS0=62bg=Y4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF853CA9EB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 20:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D682067D
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 20:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfKDU6u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:58:50 -0500
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:52914
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbfKDU6u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Nov 2019 15:58:50 -0500
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iRjR0-0007A3-TT; Mon, 04 Nov 2019 21:58:46 +0100
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] src: flowtable: add support for delete command by handle
Date:   Mon,  4 Nov 2019 21:23:59 +0100
Message-Id: <20191104202359.26136-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also, display handle when listing with '-a'.

Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 doc/libnftables-json.adoc                          |  3 +++
 doc/nft.txt                                        |  1 +
 src/json.c                                         |  3 ++-
 src/mnl.c                                          |  8 ++++++--
 src/netlink.c                                      |  2 ++
 src/parser_bison.y                                 | 17 ++++++++++++++---
 src/parser_json.c                                  | 20 +++++++++++++++-----
 src/rule.c                                         |  5 ++++-
 .../shell/testcases/flowtable/0010delete_handle_0  | 22 ++++++++++++++++++++++
 9 files changed, 69 insertions(+), 12 deletions(-)
 create mode 100755 tests/shell/testcases/flowtable/0010delete_handle_0

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 871480b95ceb..858abbf73fbf 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -409,6 +409,7 @@ ____
 	"family":* 'STRING'*,
 	"table":* 'STRING'*,
 	"name":* 'STRING'*,
+	"handle":* 'NUMBER'*,
 	"hook":* 'STRING'*,
 	"prio":* 'NUMBER'*,
 	"dev":* 'FT_INTERFACE'
@@ -426,6 +427,8 @@ This object represents a named flowtable.
 	The table's name.
 *name*::
 	The flow table's name.
+*handle*::
+	The flow table's handle. In input, it is used by the *delete* command only.
 *hook*::
 	The flow table's hook.
 *prio*::
diff --git a/doc/nft.txt b/doc/nft.txt
index ed2157638032..1521171b7bab 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -588,6 +588,7 @@ FLOWTABLES
 {*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
 *list flowtables* ['family']
 {*delete* | *list*} *flowtable* ['family'] 'table' 'flowtable'
+*delete* *flowtable* ['family'] 'table' *handle* 'handle'
 
 Flowtables allow you to accelerate packet forwarding in software. Flowtables
 entries are represented through a tuple that is composed of the input interface,
diff --git a/src/json.c b/src/json.c
index d079da9ea9eb..f0a701177454 100644
--- a/src/json.c
+++ b/src/json.c
@@ -410,10 +410,11 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 
 	mpz_export_data(&priority, ftable->priority.expr->value,
 			BYTEORDER_HOST_ENDIAN, sizeof(int));
-	root = json_pack("{s:s, s:s, s:s, s:s, s:i}",
+	root = json_pack("{s:s, s:s, s:s, s:I, s:s, s:i}",
 			"family", family2str(ftable->handle.family),
 			"name", ftable->handle.flowtable.name,
 			"table", ftable->handle.table.name,
+			"handle", ftable->handle.handle.id,
 			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hooknum),
 			"prio", priority);
 
diff --git a/src/mnl.c b/src/mnl.c
index 36ccda58c268..fdba0af83902 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1474,8 +1474,12 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 				cmd->handle.family);
 	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_TABLE,
 				cmd->handle.table.name);
-	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
-				cmd->handle.flowtable.name);
+	if (cmd->handle.flowtable.name)
+		nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
+					cmd->handle.flowtable.name);
+	else if (cmd->handle.handle.id)
+		nftnl_flowtable_set_u64(flo, NFTNL_FLOWTABLE_HANDLE,
+				        cmd->handle.handle.id);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELFLOWTABLE, cmd->handle.family,
diff --git a/src/netlink.c b/src/netlink.c
index a727c7eb76b0..7306e358ca39 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1133,6 +1133,8 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_TABLE));
 	flowtable->handle.flowtable.name =
 		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_NAME));
+	flowtable->handle.handle.id =
+		nftnl_flowtable_get_u64(nlo, NFTNL_FLOWTABLE_HANDLE);
 	dev_array = nftnl_flowtable_get(nlo, NFTNL_FLOWTABLE_DEVICES);
 	while (dev_array[len])
 		len++;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 94494f6f5005..6f525d5b8524 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -559,8 +559,8 @@ int nft_lex(void *, void *, void *);
 
 %type <handle>			table_spec tableid_spec chain_spec chainid_spec flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
 %destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
-%type <handle>			set_spec setid_spec set_identifier flowtable_identifier obj_spec objid_spec obj_identifier
-%destructor { handle_free(&$$); } set_spec setid_spec set_identifier obj_spec objid_spec obj_identifier
+%type <handle>			set_spec setid_spec set_identifier flowtableid_spec flowtable_identifier obj_spec objid_spec obj_identifier
+%destructor { handle_free(&$$); } set_spec setid_spec set_identifier flowtableid_spec obj_spec objid_spec obj_identifier
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
@@ -1151,6 +1151,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
 			}
+			|	FLOWTABLE	flowtableid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
+			}
 			|	COUNTER		obj_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
@@ -2225,7 +2229,6 @@ set_identifier		:	identifier
 			}
 			;
 
-
 flowtable_spec		:	table_spec	identifier
 			{
 				$$			= $1;
@@ -2234,6 +2237,14 @@ flowtable_spec		:	table_spec	identifier
 			}
 			;
 
+flowtableid_spec	:	table_spec	HANDLE NUM
+			{
+				$$			= $1;
+				$$.handle.location	= @$;
+				$$.handle.id		= $3;
+			}
+			;
+
 flowtable_identifier	:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
diff --git a/src/parser_json.c b/src/parser_json.c
index 3b86a0ae543f..031930e2d708 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2964,20 +2964,30 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	json_t *devs;
 	int prio;
 
-	if (json_unpack_err(ctx, root, "{s:s, s:s, s:s}",
+	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
-			    "table", &h.table.name,
-			    "name", &h.flowtable.name))
+			    "table", &h.table.name))
+		return NULL;
+
+	if (op != CMD_DELETE &&
+	    json_unpack_err(ctx, root, "{s:s}", "name", &h.flowtable.name)) {
+		return NULL;
+	} else if (op == CMD_DELETE &&
+		   json_unpack(root, "{s:s}", "name", &h.flowtable.name) &&
+		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
+		json_error(ctx, "Either name or handle required to delete a flowtable.");
 		return NULL;
+	}
 
 	if (parse_family(family, &h.family)) {
 		json_error(ctx, "Unknown family '%s'.", family);
 		return NULL;
 	}
 	h.table.name = xstrdup(h.table.name);
-	h.flowtable.name = xstrdup(h.flowtable.name);
+	if (h.flowtable.name)
+		h.flowtable.name = xstrdup(h.flowtable.name);
 
-	if (op == CMD_DELETE)
+	if (op == CMD_DELETE || op == CMD_LIST)
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
 
 	if (json_unpack_err(ctx, root, "{s:s, s:I, s:o}",
diff --git a/src/rule.c b/src/rule.c
index a2811d18fa31..ff9e8e6c0e57 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2156,8 +2156,11 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 	if (opts->table != NULL)
 		nft_print(octx, " %s", opts->table);
 
-	nft_print(octx, " %s {%s", flowtable->handle.flowtable.name, opts->nl);
+	nft_print(octx, " %s {", flowtable->handle.flowtable.name);
 
+	if (nft_output_handle(octx))
+		nft_print(octx, " # handle %" PRIu64, flowtable->handle.handle.id);
+	nft_print(octx, "%s", opts->nl);
 	nft_print(octx, "%s%shook %s priority %s%s",
 		  opts->tab, opts->tab,
 		  hooknum2str(NFPROTO_NETDEV, flowtable->hooknum),
diff --git a/tests/shell/testcases/flowtable/0010delete_handle_0 b/tests/shell/testcases/flowtable/0010delete_handle_0
new file mode 100755
index 000000000000..303967ddb44a
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0010delete_handle_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# delete flowtable by handle
+
+set -e
+
+$NFT add table inet t
+$NFT add flowtable inet t f { hook ingress priority filter\; devices = { lo }\; }
+
+FH=$($NFT list ruleset -a | awk '/flowtable f/ { print $NF }')
+
+$NFT delete flowtable inet t handle $FH
+
+EXPECTED="table inet t {
+}"
+
+GET="$($NFT list ruleset)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

