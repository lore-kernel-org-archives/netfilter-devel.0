Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD73ECAAD5
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Sep 2022 10:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiIBKwm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiIBKwl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2022 06:52:41 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDBAC123D
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2022 03:52:40 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MJvrR5m9kzDqTD
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2022 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662115959; bh=DGsK4YW29Qw0ayxTHlFcHEflfJMAKTWbBx2Pq4EebiU=;
        h=From:To:Cc:Subject:Date:From;
        b=VfWRt+6jFhNAtiPWyCnYswGBXF3ZX1EsmYHK5G/SeK23U6Bj4/OD1pnKS27+0X+vQ
         8mMLzUEiP/v1RLfovETJ8S6aPJUB2e2is8/J2iIIuW7a0BsiZuuKJWIryHK4pVneKD
         vGW9yr1e8nY5aTw6bFDJHCAkUI6l3Cb4JRc0fa2Y=
X-Riseup-User-ID: 2C372175775722A7C30B9D679273ABA1C388E2E60F4BCB90AB2062E75790366C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MJvrQ6gK0z5vw3;
        Fri,  2 Sep 2022 10:52:38 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: add table map statement support
Date:   Fri,  2 Sep 2022 12:52:04 +0200
Message-Id: <20220902105204.36066-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When listing a map with statements with JSON support, the statement list were
ignored.

Output example:

{
  "map": {
    "family": "ip",
    "name": "m",
    "table": "t",
    "type": "ipv4_addr",
    "handle": 1,
    "map": "mark",
    "stmt": [
      {
        "counter": {
          "packets": 0,
          "bytes": 0
        }
      }
    ]
  }
}

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1588
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/json.c                                    | 70 +++++++++++--------
 src/parser_json.c                             |  5 +-
 tests/shell/testcases/json/0002table_map_0    |  9 +++
 .../testcases/json/dumps/0002table_map_0.nft  |  6 ++
 4 files changed, 61 insertions(+), 29 deletions(-)
 create mode 100755 tests/shell/testcases/json/0002table_map_0
 create mode 100644 tests/shell/testcases/json/dumps/0002table_map_0.nft

diff --git a/src/json.c b/src/json.c
index 55959eea..1f2889c6 100644
--- a/src/json.c
+++ b/src/json.c
@@ -77,6 +77,34 @@ static json_t *set_dtype_json(const struct expr *key)
 	return root;
 }
 
+static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	char buf[1024];
+	FILE *fp;
+
+	/* XXX: Can't be supported at this point:
+	 * xt_stmt_xlate() ignores output_fp.
+	 */
+	if (stmt->ops->type == STMT_XT)
+		return json_pack("{s:n}", "xt");
+
+	if (stmt->ops->json)
+		return stmt->ops->json(stmt, octx);
+
+	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
+		stmt->ops->name);
+
+	fp = octx->output_fp;
+	octx->output_fp = fmemopen(buf, 1024, "w");
+
+	stmt->ops->print(stmt, octx);
+
+	fclose(octx->output_fp);
+	octx->output_fp = fp;
+
+	return json_pack("s", buf);
+}
+
 static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 {
 	json_t *root, *tmp;
@@ -152,6 +180,20 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_object_set_new(root, "elem", array);
 	}
 
+	if (!list_empty(&set->stmt_list)) {
+		json_t *array, *tmp;
+		struct stmt *stmt;
+
+		array = json_array();
+
+		list_for_each_entry(stmt, &set->stmt_list, list) {
+			tmp = stmt_print_json(stmt, octx);
+			json_array_append_new(array, tmp);
+		}
+
+		json_object_set_new(root, "stmt", array);
+	}
+
 	return json_pack("{s:o}", type, root);
 }
 
@@ -168,34 +210,6 @@ static json_t *element_print_json(struct output_ctx *octx,
 			 "elem", root);
 }
 
-static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
-{
-	char buf[1024];
-	FILE *fp;
-
-	/* XXX: Can't be supported at this point:
-	 * xt_stmt_xlate() ignores output_fp.
-	 */
-	if (stmt->ops->type == STMT_XT)
-		return json_pack("{s:n}", "xt");
-
-	if (stmt->ops->json)
-		return stmt->ops->json(stmt, octx);
-
-	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
-		stmt->ops->name);
-
-	fp = octx->output_fp;
-	octx->output_fp = fmemopen(buf, 1024, "w");
-
-	stmt->ops->print(stmt, octx);
-
-	fclose(octx->output_fp);
-	octx->output_fp = fp;
-
-	return json_pack("s", buf);
-}
-
 static json_t *rule_print_json(struct output_ctx *octx,
 			       const struct rule *rule)
 {
diff --git a/src/parser_json.c b/src/parser_json.c
index fc72c25f..7180474e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3002,8 +3002,8 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 {
 	struct handle h = { 0 };
 	const char *family = "", *policy, *dtype_ext = NULL;
+	json_t *tmp, *stmt_json;
 	struct set *set;
-	json_t *tmp;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
 			    "family", &family,
@@ -3114,6 +3114,9 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 		set->gc_int *= 1000;
 	json_unpack(root, "{s:i}", "size", &set->desc.size);
 
+	if (!json_unpack(root, "{s:o}", "stmt", &stmt_json))
+		json_parse_set_stmt_list(ctx, &set->stmt_list, stmt_json);
+
 	handle_merge(&set->handle, &h);
 
 	if (op == CMD_ADD)
diff --git a/tests/shell/testcases/json/0002table_map_0 b/tests/shell/testcases/json/0002table_map_0
new file mode 100755
index 00000000..4b54527b
--- /dev/null
+++ b/tests/shell/testcases/json/0002table_map_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t", "handle": 4}}, {"map": {"family": "ip", "name": "m", "table": "t", "type": "ipv4_addr", "handle": 1, "map": "mark", "stmt": [{"counter": {"packets": 0, "bytes": 0}}]}}]}'
+
+$NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/dumps/0002table_map_0.nft b/tests/shell/testcases/json/dumps/0002table_map_0.nft
new file mode 100644
index 00000000..357e92cc
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0002table_map_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	map m {
+		type ipv4_addr : mark
+		counter
+	}
+}
-- 
2.30.2

