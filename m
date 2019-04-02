Return-Path: <SRS0=UyK1=SE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0A4C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB20720883
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfDBNez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:34:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42150 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbfDBNez (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:34:55 -0400
Received: from localhost ([::1]:55240 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hBJYy-0004C0-G9; Tue, 02 Apr 2019 15:34:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Rewrite echo support
Date:   Tue,  2 Apr 2019 15:34:43 +0200
Message-Id: <20190402133443.6140-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of guessing which object to update with retrieved handle,
introduce a list containing struct cmd <-> json_t associations. Upon
batch commit, allocated cmd objects are assigned a unique netlink
sequence number. Monitor events contain that number as well, so they may
be associated to the cmd object which triggered them. Using
json_cmd_assoc list the event may in turn be associated to the input's
JSON object which should receive the handle value.

This also fixes incorrect behaviour if JSON input contained "insert"
commands.

Fixes: bb32d8db9a125 ("JSON: Add support for echo option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 py/nftables.py              |   3 +
 src/parser_json.c           | 283 ++++++++++++------------------------
 tests/json_echo/run-test.py | 206 ++++++++++++++++++--------
 3 files changed, 243 insertions(+), 249 deletions(-)

diff --git a/py/nftables.py b/py/nftables.py
index 6891cb1ce177b..f07163573f9a6 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -106,6 +106,9 @@ class Nftables:
         self.nft_ctx_buffer_output(self.__ctx)
         self.nft_ctx_buffer_error(self.__ctx)
 
+    def __del__(self):
+        self.nft_ctx_free(self.__ctx)
+
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
         return self.nft_ctx_output_get_flags(self.__ctx) & flag
diff --git a/src/parser_json.c b/src/parser_json.c
index 7b190bc78103e..704d85dc4556f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3324,6 +3324,46 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 	return 0;
 }
 
+struct json_cmd_assoc {
+	struct json_cmd_assoc *next;
+	const struct cmd *cmd;
+	json_t *json;
+};
+
+static struct json_cmd_assoc *json_cmd_list = NULL;
+
+static void json_cmd_assoc_free(void)
+{
+	struct json_cmd_assoc *cur;
+
+	while (json_cmd_list) {
+		cur = json_cmd_list;
+		json_cmd_list = cur->next;
+		free(cur);
+	}
+}
+
+static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
+{
+	struct json_cmd_assoc *new = xzalloc(sizeof *new);
+
+	new->next	= json_cmd_list;
+	new->json	= json;
+	new->cmd	= cmd;
+	json_cmd_list	= new;
+}
+
+static json_t *seqnum_to_json(const uint32_t seqnum)
+{
+	const struct json_cmd_assoc *cur;
+
+	for (cur = json_cmd_list; cur; cur = cur->next) {
+		if (cur->cmd->seqnum == seqnum)
+			return cur->json;
+	}
+	return NULL;
+}
+
 static int __json_parse(struct json_ctx *ctx)
 {
 	struct eval_ctx ectx = {
@@ -3377,6 +3417,9 @@ static int __json_parse(struct json_ctx *ctx)
 			return -1;
 		}
 		list_splice_tail(&list, ctx->cmds);
+
+		if (nft_output_echo(&ctx->nft->output))
+			json_cmd_assoc_add(value, cmd);
 	}
 
 	return 0;
@@ -3451,213 +3494,76 @@ static int json_echo_error(struct netlink_mon_handler *monh,
 	return MNL_CB_ERROR;
 }
 
-static int obj_prop_check(json_t *obj, const char *key, const char *value)
-{
-	const char *cmp;
-
-	if (!value)
-		return 0;
-
-	if (json_unpack(obj, "{s:s}", key, &cmp) || strcmp(value, cmp))
-		return 1;
-
-	return 0;
-}
-
-static bool obj_info_matches(json_t *obj, const char *family, const char *table,
-			     const char *chain, const char *name)
+static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
 {
-	if (obj_prop_check(obj, "family", family) ||
-	    obj_prop_check(obj, "table", table) ||
-	    obj_prop_check(obj, "chain", chain) ||
-	    obj_prop_check(obj, "name", name))
-		return false;
-
-	return true;
-}
-
-static int json_update_table(struct netlink_mon_handler *monh,
-			     json_t *array, const struct nlmsghdr *nlh)
-{
-	const char *family, *name;
 	struct nftnl_table *nlt;
-	uint64_t handle;
-	json_t *value;
-	size_t index;
-
-	nlt = netlink_table_alloc(nlh);
-	family = family2str(nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY));
-	name = strdupa(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
-	handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
-	nftnl_table_free(nlt);
-
-	json_array_foreach(array, index, value) {
-		if (json_unpack(value, "{s:{s:o}}", "add", "table", &value) ||
-		    !obj_info_matches(value, family, NULL, NULL, name))
-			continue;
-
-		json_object_set_new(value, "handle", json_integer(handle));
-		return MNL_CB_OK;
-	}
-
-	return json_echo_error(monh, "JSON table object '%s %s' not found.\n",
-			       family, name);
-}
-
-static int json_update_chain(struct netlink_mon_handler *monh,
-			     json_t *array, const struct nlmsghdr *nlh)
-{
-	const char *family, *table, *name;
 	struct nftnl_chain *nlc;
-	uint64_t handle;
-	json_t *value;
-	size_t index;
-
-	nlc = netlink_chain_alloc(nlh);
-	family = family2str(nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY));
-	table = strdupa(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE));
-	name = strdupa(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
-	handle = nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
-	nftnl_chain_free(nlc);
-
-	json_array_foreach(array, index, value) {
-		if (json_unpack(value, "{s:{s:o}}", "add", "chain", &value) ||
-		    !obj_info_matches(value, family, table, NULL, name))
-			continue;
-
-		json_object_set_new(value, "handle", json_integer(handle));
-		return MNL_CB_OK;
-	}
-	return json_echo_error(monh,
-			       "JSON chain object '%s %s %s' not found.\n",
-			       family, table, name);
-}
-
-static int json_update_rule(struct netlink_mon_handler *monh,
-			    json_t *array, const struct nlmsghdr *nlh)
-{
-	const char *family, *table, *chain;
 	struct nftnl_rule *nlr;
-	uint64_t handle;
-	json_t *value;
-	size_t index;
-
-	nlr = netlink_rule_alloc(nlh);
-	family = family2str(nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY));
-	table = strdupa(nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE));
-	chain = strdupa(nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN));
-	handle = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
-	nftnl_rule_free(nlr);
-
-	json_array_foreach(array, index, value) {
-		if (json_unpack(value, "{s:{s:o}}", "add", "rule", &value) ||
-		    !obj_info_matches(value, family, table, chain, NULL))
-			continue;
-
-		/* this is a hack - assume rules are added in order and caller
-		 * sets the handle for each we previously returned */
-		if (json_object_get(value, "handle"))
-			continue;
-
-		json_object_set_new(value, "handle", json_integer(handle));
-		return MNL_CB_OK;
-	}
-	return json_echo_error(monh,
-			       "JSON rule object in '%s %s %s' without handle not found\n",
-			       family, table, chain);
-}
-
-static int json_update_set(struct netlink_mon_handler *monh,
-			   json_t *array, const struct nlmsghdr *nlh)
-{
-	const char *family, *table, *name;
 	struct nftnl_set *nls;
-	uint64_t handle;
+	struct nftnl_obj *nlo;
+	uint64_t handle = 0;
 	uint32_t flags;
-	json_t *value;
-	size_t index;
 
-	nls = netlink_set_alloc(nlh);
-	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-	if (flags & NFT_SET_ANONYMOUS) {
+	switch (NFNL_MSG_TYPE(nlh->nlmsg_type)) {
+	case NFT_MSG_NEWTABLE:
+		nlt = netlink_table_alloc(nlh);
+		handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
+		nftnl_table_free(nlt);
+		break;
+	case NFT_MSG_NEWCHAIN:
+		nlc = netlink_chain_alloc(nlh);
+		handle = nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
+		nftnl_chain_free(nlc);
+		break;
+	case NFT_MSG_NEWRULE:
+		nlr = netlink_rule_alloc(nlh);
+		handle = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
+		nftnl_rule_free(nlr);
+		break;
+	case NFT_MSG_NEWSET:
+		nls = netlink_set_alloc(nlh);
+		flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
+		if (!(flags & NFT_SET_ANONYMOUS))
+			handle = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
 		nftnl_set_free(nls);
-		return MNL_CB_OK;
-	}
-
-	family = family2str(nftnl_set_get_u32(nls, NFTNL_SET_FAMILY));
-	table = strdupa(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
-	name = strdupa(nftnl_set_get_str(nls, NFTNL_SET_NAME));
-	handle = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
-	nftnl_set_free(nls);
-
-	json_array_foreach(array, index, value) {
-		if (json_unpack(value, "{s:{s:o}}", "add", "set", &value) ||
-		    !obj_info_matches(value, family, table, NULL, name))
-			continue;
-
-		json_object_set_new(value, "handle", json_integer(handle));
-		return MNL_CB_OK;
+		break;
+	case NFT_MSG_NEWOBJ:
+		nlo = netlink_obj_alloc(nlh);
+		handle = nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
+		nftnl_obj_free(nlo);
+		break;
 	}
-	return json_echo_error(monh, "JSON set object '%s %s %s' not found.\n",
-			       family, table, name);
+	return handle;
 }
-
-static int json_update_obj(struct netlink_mon_handler *monh,
-			   json_t *array, const struct nlmsghdr *nlh)
+int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 {
-	const char *family, *table, *name, *type;
-	struct nftnl_obj *nlo;
-	uint64_t handle;
-	json_t *value;
-	size_t index;
-
-	nlo = netlink_obj_alloc(nlh);
-	family = family2str(nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY));
-	table = strdupa(nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE));
-	name = strdupa(nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
-	type = obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE));
-	handle = nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
-	nftnl_obj_free(nlo);
-
-	json_array_foreach(array, index, value) {
-		if (json_unpack(value, "{s:{s:o}}", "add", type, &value) ||
-		    !obj_info_matches(value, family, table, NULL, name))
-			continue;
+	json_t *tmp, *json = seqnum_to_json(nlh->nlmsg_seq);
+	uint64_t handle = handle_from_nlmsg(nlh);
+	void *iter;
 
-		json_object_set_new(value, "handle", json_integer(handle));
+	/* might be anonymous set, ignore message */
+	if (!json || !handle)
 		return MNL_CB_OK;
-	}
-	return json_echo_error(monh, "JSON %s object '%s %s %s' not found.\n",
-			       type, family, table, name);
-}
 
-int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
-{
-	json_t *root = monh->ctx->nft->json_root;
-	json_t *array;
+	tmp = json_object_get(json, "add");
+	if (!tmp)
+		tmp = json_object_get(json, "insert");
+	if (!tmp)
+		/* assume loading JSON dump */
+		tmp = json;
 
-	if (!root)
+	iter = json_object_iter(tmp);
+	if (!iter) {
+		json_echo_error(monh, "Empty JSON object in cmd list\n");
 		return MNL_CB_OK;
-
-	if (json_unpack(root, "{s:o}", "nftables", &array)) {
-		erec_queue(error(int_loc, "Invalid JSON root element\n"),
-			   monh->ctx->msgs);
-		return MNL_CB_STOP;
 	}
-
-	switch (NFNL_MSG_TYPE(nlh->nlmsg_type)) {
-	case NFT_MSG_NEWTABLE:
-		return json_update_table(monh, array, nlh);
-	case NFT_MSG_NEWCHAIN:
-		return json_update_chain(monh, array, nlh);
-	case NFT_MSG_NEWRULE:
-		return json_update_rule(monh, array, nlh);
-	case NFT_MSG_NEWSET:
-		return json_update_set(monh, array, nlh);
-	case NFT_MSG_NEWOBJ:
-		return json_update_obj(monh, array, nlh);
+	json = json_object_iter_value(iter);
+	if (!json_is_object(json) || json_object_iter_next(tmp, iter)) {
+		json_echo_error(monh, "Malformed JSON object in cmd list\n");
+		return MNL_CB_OK;
 	}
 
+	json_object_set_new(json, "handle", json_integer(handle));
 	return MNL_CB_OK;
 }
 
@@ -3667,6 +3573,7 @@ void json_print_echo(struct nft_ctx *ctx)
 		return;
 
 	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+	json_cmd_assoc_free();
 	json_decref(ctx->json_root);
 	ctx->json_root = NULL;
 }
diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 52a9f259e6fcc..0132b1393860a 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -24,6 +24,8 @@ nftables.set_echo_output(True)
 
 flush_ruleset = { "flush": { "ruleset": None } }
 
+list_ruleset = { "list": { "ruleset": None } }
+
 add_table = { "add": {
     "table": {
         "family": "inet",
@@ -99,113 +101,195 @@ def do_command(cmd):
         exit_err("command failed: %s" % err)
     return out
 
+def do_list_ruleset():
+    echo = nftables.get_echo_output()
+    nftables.set_echo_output(False)
+    out = do_command(list_ruleset)
+    nftables.set_echo_output(echo)
+    return out
+
+def get_handle(output, search):
+    try:
+        for item in output["nftables"]:
+            if "add" in item:
+                data = item["add"]
+            elif "insert" in item:
+                data = item["insert"]
+            else:
+                data = item
+
+            k = search.keys()[0]
+
+            if not k in data:
+                continue
+            found = True
+            for key in search[k].keys():
+                if key == "handle":
+                    continue
+                if not key in data[k] or search[k][key] != data[k][key]:
+                    found = False
+                    break
+            if not found:
+                continue
+
+            return data[k]["handle"]
+    except Exception as e:
+        exit_dump(e, output)
+
 # single commands first
 
 do_flush()
 
 print "Adding table t"
 out = do_command(add_table)
-try:
-    table_out = out["nftables"][0]
-    table_handle = out["nftables"][0]["add"]["table"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_table["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_table["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_table["add"]["table"]["handle"] = handle
 
 print "Adding chain c"
 out = do_command(add_chain)
-try:
-    chain_out = out["nftables"][0]
-    chain_handle = out["nftables"][0]["add"]["chain"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_chain["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_chain["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_chain["add"]["chain"]["handle"] = handle
 
 print "Adding set s"
 out = do_command(add_set)
-try:
-    set_out = out["nftables"][0]
-    set_handle = out["nftables"][0]["add"]["set"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_set["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_set["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_set["add"]["set"]["handle"] = handle
 
 print "Adding rule"
 out = do_command(add_rule)
-try:
-    rule_out = out["nftables"][0]
-    rule_handle = out["nftables"][0]["add"]["rule"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_rule["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_rule["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_rule["add"]["rule"]["handle"] = handle
 
 print "Adding counter"
 out = do_command(add_counter)
-try:
-    counter_out = out["nftables"][0]
-    counter_handle = out["nftables"][0]["add"]["counter"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_counter["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_counter["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_counter["add"]["counter"]["handle"] = handle
 
 print "Adding quota"
 out = do_command(add_quota)
-try:
-    quota_out = out["nftables"][0]
-    quota_handle = out["nftables"][0]["add"]["quota"]["handle"]
-except Exception as e:
-    exit_dump(e, out)
+handle = get_handle(out, add_quota["add"])
+
+out = do_list_ruleset()
+handle_cmp = get_handle(out, add_quota["add"])
+
+if handle != handle_cmp:
+    exit_err("handle mismatch!")
+
+add_quota["add"]["quota"]["handle"] = handle
 
 # adjust names and add items again
-# Note: Add second chain to same table, otherwise its handle will be the same
-# as before. Same for the set and the rule. Bug?
-
-table_out["add"]["table"]["name"] = "t2"
-#chain_out["add"]["chain"]["table"] = "t2"
-chain_out["add"]["chain"]["name"] = "c2"
-#set_out["add"]["set"]["table"] = "t2"
-set_out["add"]["set"]["name"] = "s2"
-#rule_out["add"]["rule"]["table"] = "t2"
-#rule_out["add"]["rule"]["chain"] = "c2"
-counter_out["add"]["counter"]["name"] = "c2"
-quota_out["add"]["quota"]["name"] = "q2"
+# Note: Handles are per-table, hence add renamed objects to first table
+#       to make sure assigned handle differs from first run.
+
+add_table["add"]["table"]["name"] = "t2"
+add_chain["add"]["chain"]["name"] = "c2"
+add_set["add"]["set"]["name"] = "s2"
+add_counter["add"]["counter"]["name"] = "c2"
+add_quota["add"]["quota"]["name"] = "q2"
 
 print "Adding table t2"
-out = do_command(table_out)
-if out["nftables"][0]["add"]["table"]["handle"] == table_handle:
+out = do_command(add_table)
+handle = get_handle(out, add_table["add"])
+if handle == add_table["add"]["table"]["handle"]:
    exit_err("handle not changed in re-added table!")
 
 print "Adding chain c2"
-out = do_command(chain_out)
-if out["nftables"][0]["add"]["chain"]["handle"] == chain_handle:
+out = do_command(add_chain)
+handle = get_handle(out, add_chain["add"])
+if handle == add_chain["add"]["chain"]["handle"]:
    exit_err("handle not changed in re-added chain!")
 
 print "Adding set s2"
-out = do_command(set_out)
-if out["nftables"][0]["add"]["set"]["handle"] == set_handle:
+out = do_command(add_set)
+handle = get_handle(out, add_set["add"])
+if handle == add_set["add"]["set"]["handle"]:
    exit_err("handle not changed in re-added set!")
 
 print "Adding rule again"
-out = do_command(rule_out)
-if out["nftables"][0]["add"]["rule"]["handle"] == rule_handle:
+out = do_command(add_rule)
+handle = get_handle(out, add_rule["add"])
+if handle == add_rule["add"]["rule"]["handle"]:
    exit_err("handle not changed in re-added rule!")
 
 print "Adding counter c2"
-out = do_command(counter_out)
-if out["nftables"][0]["add"]["counter"]["handle"] == counter_handle:
+out = do_command(add_counter)
+handle = get_handle(out, add_counter["add"])
+if handle == add_counter["add"]["counter"]["handle"]:
    exit_err("handle not changed in re-added counter!")
 
 print "Adding quota q2"
-out = do_command(quota_out)
-if out["nftables"][0]["add"]["quota"]["handle"] == quota_handle:
+out = do_command(add_quota)
+handle = get_handle(out, add_quota["add"])
+if handle == add_quota["add"]["quota"]["handle"]:
    exit_err("handle not changed in re-added quota!")
 
 # now multiple commands
 
+# reset name changes again
+add_table["add"]["table"]["name"] = "t"
+add_chain["add"]["chain"]["name"] = "c"
+add_set["add"]["set"]["name"] = "s"
+add_counter["add"]["counter"]["name"] = "c"
+add_quota["add"]["quota"]["name"] = "q"
+
 do_flush()
 
 print "doing multi add"
-add_multi = [ add_table, add_chain, add_set, add_rule ]
+# XXX: Add table separately, otherwise this triggers cache bug
+out = do_command(add_table)
+thandle = get_handle(out, add_table["add"])
+add_multi = [ add_chain, add_set, add_rule ]
 out = do_command(add_multi)
-out = out["nftables"]
 
-if not "handle" in out[0]["add"]["table"] or \
-   not "handle" in out[1]["add"]["chain"] or \
-   not "handle" in out[2]["add"]["set"] or \
-   not "handle" in out[3]["add"]["rule"]:
-       exit_err("handle(s) missing in multi cmd output!")
+chandle = get_handle(out, add_chain["add"])
+shandle = get_handle(out, add_set["add"])
+rhandle = get_handle(out, add_rule["add"])
+
+out = do_list_ruleset()
+
+if thandle != get_handle(out, add_table["add"]):
+    exit_err("table handle mismatch!")
+
+if chandle != get_handle(out, add_chain["add"]):
+    exit_err("chain handle mismatch!")
+
+if shandle != get_handle(out, add_set["add"]):
+    exit_err("set handle mismatch!")
+
+if rhandle != get_handle(out, add_rule["add"]):
+    exit_err("rule handle mismatch!")
-- 
2.21.0

