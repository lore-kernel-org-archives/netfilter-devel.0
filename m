Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C35ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Sep 2022 17:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiIDRSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Sep 2022 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbiIDRSj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Sep 2022 13:18:39 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C9733A2F
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Sep 2022 10:18:38 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MLJJs6DlZzDrZZ
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Sep 2022 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662311917; bh=yR6b2kkQ6V2ivCLwGV942MzngDFSHinE26K/Ag5lmso=;
        h=From:To:Cc:Subject:Date:From;
        b=NthewNfJwN5U3nGL9YaSSVItaIe8kXJTxHX5El5e8taCJ3nIutHPzJiWPAY4WY8pe
         GAy0F1vsDNxkmJq0LwqkINv0o5DOcunKmjmkatyanvLRKAo8xrArEU3eYIiuwAgnGK
         TSRmvNWEFcGsk1Qs+NMnbSCPsmo0yQDfGFvqL1Ns=
X-Riseup-User-ID: 325E8B51ABB72BBEF87998726AA5A9F984185A965BDD625BFA0A07A0EA16D35B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MLJJs08p3z5vNH;
        Sun,  4 Sep 2022 17:18:36 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2] json: fix empty statement list output in sets and maps
Date:   Sun,  4 Sep 2022 19:18:26 +0200
Message-Id: <20220904171826.74525-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

JSON output of sets and map should not include the statements list if is
empty. The statement output should be stateless also.

In addition, removes duplicated code.

Fixes: 07958ec53830 ("json: add set statement list support")
Fixes: e66f3187d891 ("json: add table map statement support")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v2: fix typo in commit message
---
 src/json.c                                    | 64 ++++++++++---------
 .../shell/testcases/json/0001set_statements_0 |  2 +-
 tests/shell/testcases/json/0002table_map_0    |  2 +-
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/src/json.c b/src/json.c
index 1f2889c6..87f87f37 100644
--- a/src/json.c
+++ b/src/json.c
@@ -105,6 +105,25 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	return json_pack("s", buf);
 }
 
+static json_t *set_stmt_list_json(const struct list_head *stmt_list,
+				   struct output_ctx *octx)
+{
+	unsigned int flags = octx->flags;
+	json_t *root, *tmp;
+	struct stmt *i;
+
+	root = json_array();
+	octx->flags |= NFT_CTX_OUTPUT_STATELESS;
+
+	list_for_each_entry(i, stmt_list, list) {
+		tmp = stmt_print_json(i, octx);
+		json_array_append_new(root, tmp);
+	}
+	octx->flags = flags;
+
+	return root;
+}
+
 static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 {
 	json_t *root, *tmp;
@@ -180,19 +199,10 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_object_set_new(root, "elem", array);
 	}
 
-	if (!list_empty(&set->stmt_list)) {
-		json_t *array, *tmp;
-		struct stmt *stmt;
-
-		array = json_array();
-
-		list_for_each_entry(stmt, &set->stmt_list, list) {
-			tmp = stmt_print_json(stmt, octx);
-			json_array_append_new(array, tmp);
-		}
-
-		json_object_set_new(root, "stmt", array);
-	}
+	if (!list_empty(&set->stmt_list))
+		json_object_set_new(root, "stmt",
+				    set_stmt_list_json(&set->stmt_list,
+						       octx));
 
 	return json_pack("{s:o}", type, root);
 }
@@ -1453,29 +1463,21 @@ json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 			 "bytes", stmt->counter.bytes);
 }
 
-static json_t *set_stmt_list_json(const struct list_head *stmt_list,
-	                           struct output_ctx *octx)
-{
-	json_t *root, *tmp;
-	struct stmt *i;
-
-	root = json_array();
-
-	list_for_each_entry(i, stmt_list, list) {
-		tmp = stmt_print_json(i, octx);
-		json_array_append_new(root, tmp);
-	}
-
-	return root;
-}
-
 json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s, s:o, s:o, s:s+}}", "set",
+	json_t *root;
+
+	root = json_pack("{s:s, s:o, s:s+}",
 			 "op", set_stmt_op_names[stmt->set.op],
 			 "elem", expr_print_json(stmt->set.key, octx),
-			 "stmt", set_stmt_list_json(&stmt->set.stmt_list, octx),
 			 "set", "@", stmt->set.set->set->handle.set.name);
+
+	if (!list_empty(&stmt->set.stmt_list))
+		json_object_set_new(root, "stmt",
+				    set_stmt_list_json(&stmt->set.stmt_list,
+						       octx));
+
+	return json_pack("{s:o}", "set", root);
 }
 
 json_t *objref_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
diff --git a/tests/shell/testcases/json/0001set_statements_0 b/tests/shell/testcases/json/0001set_statements_0
index 1c72d35b..388b0bfe 100755
--- a/tests/shell/testcases/json/0001set_statements_0
+++ b/tests/shell/testcases/json/0001set_statements_0
@@ -4,6 +4,6 @@ set -e
 
 $NFT flush ruleset
 
-RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "testt", "handle": 3}}, {"set": {"family": "ip", "name": "ssh_meter", "table": "testt", "type": "ipv4_addr", "handle": 2, "size": 65535}}, {"chain": {"family": "ip", "table": "testt", "name": "testc", "handle": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}, {"rule": {"family": "ip", "table": "testt", "chain": "testc", "handle": 3, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"match": {"op": "in", "left": {"ct": {"key": "state"}}, "right": "new"}}, {"set": {"op": "add", "elem": {"payload": {"protocol": "ip", "field": "saddr"}}, "stmt": [{"limit": {"rate": 10, "burst": 5, "per": "second"}}], "set": "@ssh_meter"}}, {"accept": null}]}}]}'
+RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "testt", "handle": 11}}, {"set": {"family": "ip", "name": "ssh_meter", "table": "testt", "type": "ipv4_addr", "handle": 1, "size": 65535}}, {"chain": {"family": "ip", "table": "testt", "name": "testc", "handle": 2, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}, {"rule": {"family": "ip", "table": "testt", "chain": "testc", "handle": 3, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"match": {"op": "in", "left": {"ct": {"key": "state"}}, "right": "new"}}, {"set": {"op": "add", "elem": {"payload": {"protocol": "ip", "field": "saddr"}}, "set": "@ssh_meter", "stmt": [{"limit": {"rate": 10, "burst": 5, "per": "second"}}]}}, {"accept": null}]}}]}'
 
 $NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/0002table_map_0 b/tests/shell/testcases/json/0002table_map_0
index 4b54527b..9619de2d 100755
--- a/tests/shell/testcases/json/0002table_map_0
+++ b/tests/shell/testcases/json/0002table_map_0
@@ -4,6 +4,6 @@ set -e
 
 $NFT flush ruleset
 
-RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t", "handle": 4}}, {"map": {"family": "ip", "name": "m", "table": "t", "type": "ipv4_addr", "handle": 1, "map": "mark", "stmt": [{"counter": {"packets": 0, "bytes": 0}}]}}]}'
+RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t", "handle": 12}}, {"map": {"family": "ip", "name": "m", "table": "t", "type": "ipv4_addr", "handle": 1, "map": "mark", "stmt": [{"counter": null}]}}]}'
 
 $NFT -j -f - <<< $RULESET
-- 
2.30.2

