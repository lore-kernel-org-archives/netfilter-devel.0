Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19626ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 10:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiIAKcH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 06:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiIAKcG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 06:32:06 -0400
X-Greylist: delayed 68189 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Sep 2022 03:32:05 PDT
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A9A122050
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 03:32:05 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MJHR85WZNz9s4M
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2022 10:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1662028324; bh=FQudl51P6qQiW03EglFAkeTF92dV2O+1Tg8QGAVKNz8=;
        h=From:To:Cc:Subject:Date:From;
        b=WyAPByHEn08YQzLYDl0PTn2q7j1bAxvbQLSuo9U6k0AFLTaMJudOcww8agmf7Z7/v
         KPfUtrcqKk9fPlEQOaXUFSEcymzaV7WT8Th/EhlsYrLtzs9DvYd00kVH27BW7+go6K
         qm6/LCCJ1rE/A5l48Y8jx0IYGmS5c9hy8TYaoZLs=
X-Riseup-User-ID: 833573A7CAF07BEAA314EBA20FFD26E0ED8FFF56E093627372279F79D6BEAF7F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MJHR76Wc8z5vTc;
        Thu,  1 Sep 2022 10:32:03 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2] json: add set statement list support
Date:   Thu,  1 Sep 2022 12:31:43 +0200
Message-Id: <20220901103143.87974-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When listing a set with statements with JSON support, the statements were
ignored.

Output example:

{
  "set": {
    "op": "add",
    "elem": {
      "payload": {
        "protocol": "ip",
        "field": "saddr"
      }
    },
    "stmt": [
      {
        "limit": {
          "rate": 10,
          "burst": 5,
          "per": "second"
        }
      },
      {
        "counter": {
          "packets": 0,
          "bytes": 0
        }
      }
    ],
    "set": "@my_ssh_meter"
  }
}

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1495
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v2: extend testcases
---
 src/json.c                                    | 19 +++++++++++-
 src/parser_json.c                             | 29 ++++++++++++++++++-
 .../shell/testcases/json/0001set_statements_0 |  9 ++++++
 .../json/dumps/0001set_statements_0.nft       | 12 ++++++++
 4 files changed, 67 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/json/0001set_statements_0
 create mode 100644 tests/shell/testcases/json/dumps/0001set_statements_0.nft

diff --git a/src/json.c b/src/json.c
index a525fd1b..55959eea 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1439,11 +1439,28 @@ json_t *counter_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 			 "bytes", stmt->counter.bytes);
 }
 
+static json_t *set_stmt_list_json(const struct list_head *stmt_list,
+	                           struct output_ctx *octx)
+{
+	json_t *root, *tmp;
+	struct stmt *i;
+
+	root = json_array();
+
+	list_for_each_entry(i, stmt_list, list) {
+		tmp = stmt_print_json(i, octx);
+		json_array_append_new(root, tmp);
+	}
+
+	return root;
+}
+
 json_t *set_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	return json_pack("{s:{s:s, s:o, s:s+}}", "set",
+	return json_pack("{s:{s:s, s:o, s:o, s:s+}}", "set",
 			 "op", set_stmt_op_names[stmt->set.op],
 			 "elem", expr_print_json(stmt->set.key, octx),
+			 "stmt", set_stmt_list_json(&stmt->set.stmt_list, octx),
 			 "set", "@", stmt->set.set->set->handle.set.name);
 }
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 9e93927a..a8dbb890 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2227,13 +2227,36 @@ static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static void json_parse_set_stmt_list(struct json_ctx *ctx,
+				      struct list_head *stmt_list,
+				      json_t *stmt_json)
+{
+	struct list_head *head;
+	struct stmt *tmp;
+	json_t *value;
+	size_t index;
+
+	if (!stmt_json)
+		return;
+
+	if (!json_is_array(stmt_json))
+		json_error(ctx, "Unexpected object type in stmt");
+
+	head = stmt_list;
+	json_array_foreach(stmt_json, index, value) {
+		tmp = json_parse_stmt(ctx, value);
+		list_add(&tmp->list, head);
+		head = &tmp->list;
+	}
+}
+
 static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
 	const char *opstr, *set;
 	struct expr *expr, *expr2;
+	json_t *elem, *stmt_json;
 	struct stmt *stmt;
-	json_t *elem;
 	int op;
 
 	if (json_unpack_err(ctx, value, "{s:s, s:o, s:s}",
@@ -2268,6 +2291,10 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 	stmt->set.op = op;
 	stmt->set.key = expr;
 	stmt->set.set = expr2;
+
+	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json))
+		json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json);
+
 	return stmt;
 }
 
diff --git a/tests/shell/testcases/json/0001set_statements_0 b/tests/shell/testcases/json/0001set_statements_0
new file mode 100755
index 00000000..1c72d35b
--- /dev/null
+++ b/tests/shell/testcases/json/0001set_statements_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT flush ruleset
+
+RULESET='{"nftables": [{"metainfo": {"version": "1.0.5", "release_name": "Lester Gooch #4", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "testt", "handle": 3}}, {"set": {"family": "ip", "name": "ssh_meter", "table": "testt", "type": "ipv4_addr", "handle": 2, "size": 65535}}, {"chain": {"family": "ip", "table": "testt", "name": "testc", "handle": 1, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}, {"rule": {"family": "ip", "table": "testt", "chain": "testc", "handle": 3, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"match": {"op": "in", "left": {"ct": {"key": "state"}}, "right": "new"}}, {"set": {"op": "add", "elem": {"payload": {"protocol": "ip", "field": "saddr"}}, "stmt": [{"limit": {"rate": 10, "burst": 5, "per": "second"}}], "set": "@ssh_meter"}}, {"accept": null}]}}]}'
+
+$NFT -j -f - <<< $RULESET
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.nft b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
new file mode 100644
index 00000000..ee4a8670
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
@@ -0,0 +1,12 @@
+table ip testt {
+	set ssh_meter {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+	}
+
+	chain testc {
+		type filter hook input priority filter; policy accept;
+		tcp dport 22 ct state new add @ssh_meter { ip saddr limit rate 10/second } accept
+	}
+}
-- 
2.30.2

