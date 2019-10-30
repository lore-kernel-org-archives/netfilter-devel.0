Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE6DCA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7058A20856
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfJ3RSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:18:07 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:49982
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfJ3RSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:18:06 -0400
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iPrbg-000BwM-96; Wed, 30 Oct 2019 18:18:04 +0100
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] src: flowtable: add support for named flowtable listing
Date:   Wed, 30 Oct 2019 18:06:19 +0100
Message-Id: <20191030170619.45231-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to dump a named flowtable.

 # nft list flowtable inet t f
 table inet t {
         flowtable f {
                 hook ingress priority filter + 10
                 devices = { eth0, eth1 }
         }
 }

Also:
libnftables-json.adoc: fix missing quotes.

Fixes: db0697ce7f60 ("src: support for flowtable listing")
Fixes: 872f373dc50f ("doc: Add JSON schema documentation")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 doc/libnftables-json.adoc                     |  8 ++--
 include/rule.h                                | 12 ++++-
 src/evaluate.c                                | 29 ++++++++++++
 src/json.c                                    | 20 ++++++++-
 src/mnl.c                                     |  4 +-
 src/netlink.c                                 |  2 +-
 src/parser_bison.y                            | 12 +++--
 src/parser_json.c                             |  4 +-
 src/rule.c                                    | 64 +++++++++++++++++++++++++--
 tests/shell/testcases/listing/0020flowtable_0 | 21 +++++++++
 10 files changed, 157 insertions(+), 19 deletions(-)
 create mode 100755 tests/shell/testcases/listing/0020flowtable_0

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 6877f0549db1..871480b95ceb 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -117,7 +117,7 @@ ____
 *{ "add":* 'ADD_OBJECT' *}*
 
 'ADD_OBJECT' := 'TABLE' | 'CHAIN' | 'RULE' | 'SET' | 'MAP' | 'ELEMENT' |
-                'FLOWTABLE' | 'COUNTER | QUOTA' | 'CT_HELPER' | 'LIMIT' |
+                'FLOWTABLE' | 'COUNTER' | 'QUOTA' | 'CT_HELPER' | 'LIMIT' |
 		'CT_TIMEOUT' | 'CT_EXPECTATION'
 ____
 
@@ -161,9 +161,9 @@ ____
 
 'LIST_OBJECT' := 'TABLE' | 'TABLES' | 'CHAIN' | 'CHAINS' | 'SET' | 'SETS' |
                  'MAP' | 'MAPS | COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS' |
-                 'CT_HELPER' | 'CT_HELPERS' | 'LIMIT' | 'LIMITS | RULESET' |
-                 'METER' | 'METERS' | 'FLOWTABLES' | 'CT_TIMEOUT' |
-                 'CT_EXPECTATION'
+                 'CT_HELPER' | 'CT_HELPERS' | 'LIMIT' | 'LIMITS' | 'RULESET' |
+                 'METER' | 'METERS' | 'FLOWTABLE' | 'FLOWTABLES' |
+                 'CT_TIMEOUT' | 'CT_EXPECTATION'
 ____
 
 List ruleset elements. The plural forms are used to list all objects of that
diff --git a/include/rule.h b/include/rule.h
index ba40db8806fc..a718923b14a3 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -45,6 +45,11 @@ struct set_spec {
 	const char		*name;
 };
 
+struct flowtable_spec {
+	struct location		location;
+	const char		*name;
+};
+
 struct obj_spec {
 	struct location		location;
 	const char		*name;
@@ -69,7 +74,7 @@ struct handle {
 	struct chain_spec	chain;
 	struct set_spec		set;
 	struct obj_spec		obj;
-	const char		*flowtable;
+	struct flowtable_spec	flowtable;
 	struct handle_spec	handle;
 	struct position_spec	position;
 	struct position_spec	index;
@@ -470,6 +475,10 @@ extern struct flowtable *flowtable_alloc(const struct location *loc);
 extern struct flowtable *flowtable_get(struct flowtable *flowtable);
 extern void flowtable_free(struct flowtable *flowtable);
 extern void flowtable_add_hash(struct flowtable *flowtable, struct table *table);
+extern struct flowtable *flowtable_lookup(const struct table *table, const char *name);
+extern struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
+						const struct nft_cache *cache,
+						const struct table **table);
 
 void flowtable_print(const struct flowtable *n, struct output_ctx *octx);
 
@@ -535,7 +544,6 @@ enum cmd_ops {
  * @CMD_OBJ_QUOTAS:	multiple quotas
  * @CMD_OBJ_LIMIT:	limit
  * @CMD_OBJ_LIMITS:	multiple limits
- * @CMD_OBJ_FLOWTABLES:	flow tables
  * @CMD_OBJ_SECMARK:	secmark
  * @CMD_OBJ_SECMARKS:	multiple secmarks
  * @CMD_OBJ_SYNPROXY:	synproxy
diff --git a/src/evaluate.c b/src/evaluate.c
index a56cd2a56e99..81230fc7f4be 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -218,6 +218,23 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
 			 table->handle.table.name);
 }
 
+static int flowtable_not_found(struct eval_ctx *ctx, const struct location *loc,
+			       const char *ft_name)
+{
+	const struct table *table;
+	struct flowtable *ft;
+
+	ft = flowtable_lookup_fuzzy(ft_name, &ctx->nft->cache, &table);
+	if (ft == NULL)
+		return cmd_error(ctx, loc, "%s", strerror(ENOENT));
+
+	return cmd_error(ctx, loc,
+			"%s; did you mean flowtable ‘%s’ in table %s ‘%s’?",
+			strerror(ENOENT), ft->handle.flowtable.name,
+			family2str(ft->handle.family),
+			table->handle.table.name);
+}
+
 /*
  * Symbol expression: parse symbol and evaluate resulting expression.
  */
@@ -3834,6 +3851,7 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	struct flowtable *ft;
 	struct table *table;
 	struct set *set;
 
@@ -3899,6 +3917,17 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return chain_not_found(ctx);
 
 		return 0;
+	case CMD_OBJ_FLOWTABLE:
+		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		if (table == NULL)
+			return table_not_found(ctx);
+
+		ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+		if (ft == NULL)
+			return flowtable_not_found(ctx, &ctx->cmd->handle.flowtable.location,
+						   ctx->cmd->handle.flowtable.name);
+
+		return 0;
 	case CMD_OBJ_QUOTA:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_QUOTA);
 	case CMD_OBJ_COUNTER:
diff --git a/src/json.c b/src/json.c
index 56b20549bd73..d079da9ea9eb 100644
--- a/src/json.c
+++ b/src/json.c
@@ -412,7 +412,7 @@ static json_t *flowtable_print_json(const struct flowtable *ftable)
 			BYTEORDER_HOST_ENDIAN, sizeof(int));
 	root = json_pack("{s:s, s:s, s:s, s:s, s:i}",
 			"family", family2str(ftable->handle.family),
-			"name", ftable->handle.flowtable,
+			"name", ftable->handle.flowtable.name,
 			"table", ftable->handle.table.name,
 			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hooknum),
 			"prio", priority);
@@ -1724,6 +1724,21 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 	return root;
 }
 
+static json_t *do_list_flowtable_json(struct netlink_ctx *ctx,
+				      struct cmd *cmd, struct table *table)
+{
+	json_t *root = json_array();
+	struct flowtable *ft;
+
+	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+	if (ft == NULL)
+		return json_null();
+
+	json_array_append_new(root, flowtable_print_json(ft));
+
+	return root;
+}
+
 static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	json_t *root = json_array(), *tmp;
@@ -1815,6 +1830,9 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARKS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SECMARK);
 		break;
+	case CMD_OBJ_FLOWTABLE:
+		root = do_list_flowtable_json(ctx, cmd, table);
+		break;
 	case CMD_OBJ_FLOWTABLES:
 		root = do_list_flowtables_json(ctx, cmd);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 933e18d97cbd..36ccda58c268 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1429,7 +1429,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_TABLE,
 				cmd->handle.table.name);
 	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
-				cmd->handle.flowtable);
+				cmd->handle.flowtable.name);
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
 				cmd->flowtable->hooknum);
 	mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
@@ -1475,7 +1475,7 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_TABLE,
 				cmd->handle.table.name);
 	nftnl_flowtable_set_str(flo, NFTNL_FLOWTABLE_NAME,
-				cmd->handle.flowtable);
+				cmd->handle.flowtable.name);
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELFLOWTABLE, cmd->handle.family,
diff --git a/src/netlink.c b/src/netlink.c
index c47771d3c801..a727c7eb76b0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1131,7 +1131,7 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_FAMILY);
 	flowtable->handle.table.name =
 		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_TABLE));
-	flowtable->handle.flowtable =
+	flowtable->handle.flowtable.name =
 		xstrdup(nftnl_flowtable_get_str(nlo, NFTNL_FLOWTABLE_NAME));
 	dev_array = nftnl_flowtable_get(nlo, NFTNL_FLOWTABLE_DEVICES);
 	while (dev_array[len])
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7f9b1752f41d..94494f6f5005 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1315,6 +1315,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$2, &@$, NULL);
 			}
+			|	FLOWTABLE	flowtable_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
+			}
 			|	MAPS		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAPS, &$2, &@$, NULL);
@@ -2224,15 +2228,17 @@ set_identifier		:	identifier
 
 flowtable_spec		:	table_spec	identifier
 			{
-				$$		= $1;
-				$$.flowtable	= $2;
+				$$			= $1;
+				$$.flowtable.name	= $2;
+				$$.flowtable.location	= @2;
 			}
 			;
 
 flowtable_identifier	:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
-				$$.flowtable	= $1;
+				$$.flowtable.name	= $1;
+				$$.flowtable.location	= @1;
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index a9bcb84faf44..3b86a0ae543f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2967,7 +2967,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (json_unpack_err(ctx, root, "{s:s, s:s, s:s}",
 			    "family", &family,
 			    "table", &h.table.name,
-			    "name", &h.flowtable))
+			    "name", &h.flowtable.name))
 		return NULL;
 
 	if (parse_family(family, &h.family)) {
@@ -2975,7 +2975,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 		return NULL;
 	}
 	h.table.name = xstrdup(h.table.name);
-	h.flowtable = xstrdup(h.flowtable);
+	h.flowtable.name = xstrdup(h.flowtable.name);
 
 	if (op == CMD_DELETE)
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
diff --git a/src/rule.c b/src/rule.c
index c258f12e5c77..a2811d18fa31 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -105,7 +105,7 @@ void handle_free(struct handle *h)
 	xfree(h->table.name);
 	xfree(h->chain.name);
 	xfree(h->set.name);
-	xfree(h->flowtable);
+	xfree(h->flowtable.name);
 	xfree(h->obj.name);
 }
 
@@ -125,8 +125,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->set.name = xstrdup(src->set.name);
 		dst->set.location = src->set.location;
 	}
-	if (dst->flowtable == NULL && src->flowtable != NULL)
-		dst->flowtable = xstrdup(src->flowtable);
+	if (dst->flowtable.name == NULL && src->flowtable.name != NULL)
+		dst->flowtable.name = xstrdup(src->flowtable.name);
 	if (dst->obj.name == NULL && src->obj.name != NULL)
 		dst->obj.name = xstrdup(src->obj.name);
 	if (dst->handle.id == 0)
@@ -2156,7 +2156,7 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 	if (opts->table != NULL)
 		nft_print(octx, " %s", opts->table);
 
-	nft_print(octx, " %s {%s", flowtable->handle.flowtable, opts->nl);
+	nft_print(octx, " %s {%s", flowtable->handle.flowtable.name, opts->nl);
 
 	nft_print(octx, "%s%shook %s priority %s%s",
 		  opts->tab, opts->tab,
@@ -2193,6 +2193,60 @@ void flowtable_print(const struct flowtable *s, struct output_ctx *octx)
 	do_flowtable_print(s, &opts, octx);
 }
 
+struct flowtable *flowtable_lookup(const struct table *table, const char *name)
+{
+	struct flowtable *ft;
+
+	list_for_each_entry(ft, &table->flowtables, list) {
+		if (!strcmp(ft->handle.flowtable.name, name))
+			return ft;
+	}
+	return NULL;
+}
+
+struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
+					 const struct nft_cache *cache,
+					 const struct table **t)
+{
+	struct string_misspell_state st;
+	struct table *table;
+	struct flowtable *ft;
+
+	string_misspell_init(&st);
+
+	list_for_each_entry(table, &cache->list, list) {
+		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!strcmp(ft->handle.flowtable.name, ft_name)) {
+				*t = table;
+				return ft;
+			}
+			if (string_misspell_update(ft->handle.flowtable.name,
+						   ft_name, ft, &st))
+				*t = table;
+		}
+	}
+	return st.obj;
+}
+
+static int do_list_flowtable(struct netlink_ctx *ctx, struct cmd *cmd,
+			     struct table *table)
+{
+	struct flowtable *ft;
+
+	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+	if (ft == NULL)
+		return -1;
+
+	nft_print(&ctx->nft->output, "table %s %s {\n",
+		  family2str(table->handle.family),
+		  table->handle.table.name);
+
+	flowtable_print(ft, &ctx->nft->output);
+	nft_print(&ctx->nft->output, "}\n");
+
+	return 0;
+}
+
 static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct print_fmt_options opts = {
@@ -2388,6 +2442,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_SYNPROXYS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_FLOWTABLE:
+		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_flowtables(ctx, cmd);
 	default:
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
new file mode 100755
index 000000000000..6f630f14a8ba
--- /dev/null
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# list only the flowtable asked for with table
+
+EXPECTED="table inet filter {
+	flowtable f {
+		hook ingress priority filter
+		devices = { lo }
+	}
+}"
+
+set -e
+
+$NFT -f - <<< "$EXPECTED"
+
+GET="$($NFT list flowtable inet filter f)"
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

