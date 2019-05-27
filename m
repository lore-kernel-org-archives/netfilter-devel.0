Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142B7C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E3B20859
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfE0LhI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 07:37:08 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34828 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0LhI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 07:37:08 -0400
Received: from localhost ([::1]:47918 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVDwA-0005pR-Ma; Mon, 27 May 2019 13:37:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_json: Fix and simplify verdict expression parsing
Date:   Mon, 27 May 2019 13:37:00 +0200
Message-Id: <20190527113700.8541-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parsing of the "target" property was flawed in two ways:

* The value was extracted twice. Drop the first unconditional one.
* Expression allocation required since commit f1e8a129ee428 was broken,
  The expression was allocated only if the property was not present.

Fixes: f1e8a129ee428 ("src: Introduce chain_expr in jump and goto statements")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 19cdefd392014..4c7ee9911c42f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1053,13 +1053,22 @@ static struct expr *json_parse_range_expr(struct json_ctx *ctx,
 	return range_expr_alloc(int_loc, expr_low, expr_high);
 }
 
+static struct expr *json_alloc_chain_expr(const char *chain)
+{
+	if (!chain)
+		return NULL;
+
+	return constant_expr_alloc(int_loc, &string_type, BYTEORDER_HOST_ENDIAN,
+				   NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE, chain);
+}
+
 static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 					    const char *type, json_t *root)
 {
 	const struct {
 		int verdict;
 		const char *name;
-		bool chain;
+		bool need_chain;
 	} verdict_tbl[] = {
 		{ NFT_CONTINUE, "continue", false },
 		{ NFT_JUMP, "jump", true },
@@ -1068,27 +1077,19 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 		{ NF_ACCEPT, "accept", false },
 		{ NF_DROP, "drop", false },
 	};
-	struct expr *chain_expr = NULL;
 	const char *chain = NULL;
 	unsigned int i;
 
-	json_unpack(root, "{s:s}", "target", &chain);
-	if (!chain)
-		chain_expr = constant_expr_alloc(int_loc, &string_type,
-						 BYTEORDER_HOST_ENDIAN,
-						 NFT_CHAIN_MAXNAMELEN *
-						 BITS_PER_BYTE, chain);
-
 	for (i = 0; i < array_size(verdict_tbl); i++) {
 		if (strcmp(type, verdict_tbl[i].name))
 			continue;
 
-		if (verdict_tbl[i].chain &&
+		if (verdict_tbl[i].need_chain &&
 		    json_unpack_err(ctx, root, "{s:s}", "target", &chain))
 			return NULL;
 
-		return verdict_expr_alloc(int_loc,
-					  verdict_tbl[i].verdict, chain_expr);
+		return verdict_expr_alloc(int_loc, verdict_tbl[i].verdict,
+					  json_alloc_chain_expr(chain));
 	}
 	json_error(ctx, "Unknown verdict '%s'.", type);
 	return NULL;
-- 
2.21.0

