Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B60ECAAD1
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 12:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiHaMiE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 08:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiHaMiD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 08:38:03 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2B49B75
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 05:38:02 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MHkGx54zPzDqGK
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1661949481; bh=gCw3OVi/f9hI5O/EfK2gdO19FE+GoYFHUqIIXfP58+c=;
        h=From:To:Cc:Subject:Date:From;
        b=jKafbijZtg96mBhJgHYBwDUDSF9Jan2OeEjpFMQvkAdNbgywHYQbh5H6EadEoYDK5
         HJRCPs9D8lp1fgSX1jEu18k/v/ngcF0E59CInPDf/qOspuVz9g0NYUNb0EMp9zKm6E
         EV4v9HXKk4FJtPLp+xco/BNHNGn0XFENnadflQXs=
X-Riseup-User-ID: F1DBA48175226A469C88AD59B5D90B07BEA0E892C872BF342CB312F4B0DF34DE
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MHkGw67DXz5vTr;
        Wed, 31 Aug 2022 12:38:00 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] json: add set statement list support
Date:   Wed, 31 Aug 2022 14:37:31 +0200
Message-Id: <20220831123731.26249-1-ffmancera@riseup.net>
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
 src/json.c        | 19 ++++++++++++++++++-
 src/parser_json.c | 29 ++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

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
 
-- 
2.30.2

