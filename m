Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E46C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 16:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381964AbhLCQLc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381962AbhLCQL3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 11:11:29 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD210C061353
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 08:08:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mtB6S-00026r-CB; Fri, 03 Dec 2021 17:08:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] ipopt: drop unused 'ptr' argument
Date:   Fri,  3 Dec 2021 17:07:53 +0100
Message-Id: <20211203160755.8720-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203160755.8720-1-fw@strlen.de>
References: <20211203160755.8720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its always 0, so remove it.
Looks like this was intended to support variable options that have
array-like members, but so far this isn't implemented, better remove
dead code and implement it properly when such support is needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/ipopt.h    |  2 +-
 src/ipopt.c        | 23 ++---------------------
 src/parser_bison.y |  4 ++--
 src/parser_json.c  |  4 ++--
 4 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/include/ipopt.h b/include/ipopt.h
index d8d48066ae50..03420dc6221d 100644
--- a/include/ipopt.h
+++ b/include/ipopt.h
@@ -6,7 +6,7 @@
 #include <statement.h>
 
 extern struct expr *ipopt_expr_alloc(const struct location *loc,
-				      uint8_t type, uint8_t field, uint8_t ptr);
+				      uint8_t type, uint8_t field);
 
 extern void ipopt_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len,
diff --git a/src/ipopt.c b/src/ipopt.c
index 5f9f908c0b34..42ea41cd705b 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -66,27 +66,8 @@ const struct exthdr_desc *ipopt_protocols[UINT8_MAX] = {
 	[IPOPT_RA]		= &ipopt_ra,
 };
 
-static unsigned int calc_offset(const struct exthdr_desc *desc,
-				const struct proto_hdr_template *tmpl,
-				unsigned int arg)
-{
-	if (!desc || tmpl == &ipopt_unknown_template)
-		return 0;
-
-	switch (desc->type) {
-	case IPOPT_RR:
-	case IPOPT_LSRR:
-	case IPOPT_SSRR:
-		if (tmpl == &desc->templates[IPOPT_FIELD_ADDR_0])
-			return (tmpl->offset < 24) ? 0 : arg;
-		return 0;
-	default:
-		return 0;
-	}
-}
-
 struct expr *ipopt_expr_alloc(const struct location *loc, uint8_t type,
-			       uint8_t field, uint8_t ptr)
+			       uint8_t field)
 {
 	const struct proto_hdr_template *tmpl;
 	const struct exthdr_desc *desc;
@@ -102,7 +83,7 @@ struct expr *ipopt_expr_alloc(const struct location *loc, uint8_t type,
 	expr->exthdr.desc   = desc;
 	expr->exthdr.tmpl   = tmpl;
 	expr->exthdr.op     = NFT_EXTHDR_OP_IPV4;
-	expr->exthdr.offset = tmpl->offset + calc_offset(desc, tmpl, ptr);
+	expr->exthdr.offset = tmpl->offset;
 	expr->exthdr.raw_type = desc->type;
 
 	return expr;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 355758e1befb..357850dececc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5331,11 +5331,11 @@ ip_hdr_expr		:	IP	ip_hdr_field	close_scope_ip
 			}
 			|	IP	OPTION	ip_option_type ip_option_field	close_scope_ip
 			{
-				$$ = ipopt_expr_alloc(&@$, $3, $4, 0);
+				$$ = ipopt_expr_alloc(&@$, $3, $4);
 			}
 			|	IP	OPTION	ip_option_type close_scope_ip
 			{
-				$$ = ipopt_expr_alloc(&@$, $3, IPOPT_FIELD_TYPE, 0);
+				$$ = ipopt_expr_alloc(&@$, $3, IPOPT_FIELD_TYPE);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 			}
 			;
diff --git a/src/parser_json.c b/src/parser_json.c
index 7a2d30ff665c..2fad308f7783 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -689,7 +689,7 @@ static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
 
 	if (json_unpack(root, "{s:s}", "field", &field)) {
 		expr = ipopt_expr_alloc(int_loc, descval,
-					 IPOPT_FIELD_TYPE, 0);
+					 IPOPT_FIELD_TYPE);
 		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 
 		return expr;
@@ -698,7 +698,7 @@ static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
 		json_error(ctx, "Unknown ip option field '%s'.", field);
 		return NULL;
 	}
-	return ipopt_expr_alloc(int_loc, descval, fieldval, 0);
+	return ipopt_expr_alloc(int_loc, descval, fieldval);
 }
 
 static int json_parse_sctp_chunk_field(const struct exthdr_desc *desc,
-- 
2.32.0

