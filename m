Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63137C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 11:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A53205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfHNLe0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 07:34:26 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33436 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbfHNLe0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 07:34:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxrXt-00025V-3h; Wed, 14 Aug 2019 13:34:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] src: json: support json restore for "th" pseudoheader
Date:   Wed, 14 Aug 2019 13:34:52 +0200
Message-Id: <20190814113452.13244-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Json output could not be restored back by nft because it did
not recognize the new "th" pseudoheader.

Fixes: a43a696443a150f44 ("proto: add pseudo th protocol to match d/sport in generic way")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 956233b92b92..d42bab704f7c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -503,7 +503,8 @@ static const struct proto_desc *proto_lookup_byname(const char *name)
 		&proto_udplite,
 		&proto_tcp,
 		&proto_dccp,
-		&proto_sctp
+		&proto_sctp,
+		&proto_th,
 	};
 	unsigned int i;
 
@@ -519,11 +520,10 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 {
 	const char *protocol, *field, *base;
 	int offset, len, val;
+	struct expr *expr;
 
 	if (!json_unpack(root, "{s:s, s:i, s:i}",
 			 "base", &base, "offset", &offset, "len", &len)) {
-		struct expr *expr;
-
 		if (!strcmp(base, "ll")) {
 			val = PROTO_BASE_LL_HDR;
 		} else if (!strcmp(base, "nh")) {
@@ -553,7 +553,12 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 				   protocol, field);
 			return NULL;
 		}
-		return payload_expr_alloc(int_loc, proto, val);
+		expr = payload_expr_alloc(int_loc, proto, val);
+
+		if (proto == &proto_th)
+			expr->payload.is_raw = true;
+
+		return expr;
 	}
 	json_error(ctx, "Invalid payload expression properties.");
 	return NULL;
-- 
2.21.0

