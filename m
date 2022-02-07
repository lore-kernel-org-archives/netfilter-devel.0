Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21780C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiBGNtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380483AbiBGN2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 08:28:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ED8C0401C1
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:28:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nH44H-00079F-7o; Mon, 07 Feb 2022 14:28:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] parser_json: permit empty device list
Date:   Mon,  7 Feb 2022 14:28:16 +0100
Message-Id: <20220207132816.21129-4-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220207132816.21129-1-fw@strlen.de>
References: <20220207132816.21129-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Normal input parser allows flowtables without 'devices' token, which
makes the json export part elide 'dev' entirely, this then breaks on
re-import:

$ nft -j -f json.dump
/tmp/json_1:1:14-14: Error: Object item not found: dev

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 2ab0196461e2..4913260434f4 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3158,7 +3158,7 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	const char *family, *hook, *hookstr;
 	struct flowtable *flowtable;
 	struct handle h = { 0 };
-	json_t *devs;
+	json_t *devs = NULL;
 	int prio;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
@@ -3187,14 +3187,15 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 	if (op == CMD_DELETE || op == CMD_LIST)
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
 
-	if (json_unpack_err(ctx, root, "{s:s, s:I, s:o}",
+	if (json_unpack_err(ctx, root, "{s:s, s:I}",
 			    "hook", &hook,
-			    "prio", &prio,
-			    "dev", &devs)) {
+			    "prio", &prio)) {
 		handle_free(&h);
 		return NULL;
 	}
 
+	json_unpack(root, "{s:o}", &devs);
+
 	hookstr = chain_hookname_lookup(hook);
 	if (!hookstr) {
 		json_error(ctx, "Invalid flowtable hook '%s'.", hook);
@@ -3209,12 +3210,14 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 				    BYTEORDER_HOST_ENDIAN,
 				    sizeof(int) * BITS_PER_BYTE, &prio);
 
-	flowtable->dev_expr = json_parse_flowtable_devs(ctx, devs);
-	if (!flowtable->dev_expr) {
-		json_error(ctx, "Invalid flowtable dev.");
-		flowtable_free(flowtable);
-		handle_free(&h);
-		return NULL;
+	if (devs) {
+		flowtable->dev_expr = json_parse_flowtable_devs(ctx, devs);
+		if (!flowtable->dev_expr) {
+			json_error(ctx, "Invalid flowtable dev.");
+			flowtable_free(flowtable);
+			handle_free(&h);
+			return NULL;
+		}
 	}
 	return cmd_alloc(op, cmd_obj, &h, int_loc, flowtable);
 }
-- 
2.34.1

