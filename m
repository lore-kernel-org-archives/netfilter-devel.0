Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6A0C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A9B920989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="EPnY9KFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfEILeP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:34:15 -0400
Received: from mx1.riseup.net ([198.252.153.129]:56282 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfEILeP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:34:15 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2FFA11B94CA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 May 2019 04:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557401654; bh=Nj74gL9wrMEqFPb5vBPpjeIB+UHRpfJB45FobQ9AE5Y=;
        h=From:To:Cc:Subject:Date:From;
        b=EPnY9KFQKiF0iF8ZvJLtCRsnvLBPrNCe4/UbRIk4UL1JIu76ukUqpemhGFKGBVhOb
         0Nyuxp5/bN9akb3o8tB+3J9QqQTx2ZtFHxyq9C7CIqiNjnhTawPdGugsMDvGJQb/Ql
         iV/PE4nRCQDvxfCZKDGzsijDyfLscez4j+TU/QOc=
X-Riseup-User-ID: A9D2716FCF14C9A18C93FF8633BFD1D18669B59761D0F9B99D7031C25239C367
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id D8CA5120D9E;
        Thu,  9 May 2019 04:34:11 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft WIP] jump: Allow jump to a variable when using nft input files
Date:   Thu,  9 May 2019 13:33:58 +0200
Message-Id: <20190509113358.856-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in 'jump'
statements, e.g.

define dest = chainame

add rule ip filter input jump $dest

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/expression.h |  3 ++-
 src/expression.c     | 14 ++++++++++++--
 src/netlink.c        |  6 +++---
 src/parser_bison.y   | 16 ++++++++++------
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6416ac0..0379eba 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -403,7 +403,8 @@ extern void relational_expr_pctx_update(struct proto_ctx *ctx,
 					const struct expr *expr);
 
 extern struct expr *verdict_expr_alloc(const struct location *loc,
-				       int verdict, const char *chain);
+				       int verdict, const char *chain,
+				       struct expr *variable);
 
 extern struct expr *symbol_expr_alloc(const struct location *loc,
 				      enum symbol_types type, struct scope *scope,
diff --git a/src/expression.c b/src/expression.c
index eece12e..7956a9c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -236,15 +236,25 @@ static const struct expr_ops verdict_expr_ops = {
 };
 
 struct expr *verdict_expr_alloc(const struct location *loc,
-				int verdict, const char *chain)
+				int verdict, const char *chain,
+				struct expr *variable)
 {
+	struct symbol *sym;
 	struct expr *expr;
+	char *sym_chain;
 
 	expr = expr_alloc(loc, EXPR_VERDICT, &verdict_type,
 			  BYTEORDER_INVALID, 0);
 	expr->verdict = verdict;
-	if (chain != NULL)
+	if (chain != NULL) {
 		expr->chain = chain;
+	} else if (variable != NULL) {
+		sym = variable->sym;
+		if (sym->expr->value)
+			expr->chain = mpz_get_str(NULL, 10, sym->expr->value);
+		//printf("%s", expr->chain);
+	}
+	printf("%s", expr->chain);
 	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	return expr;
 }
diff --git a/src/netlink.c b/src/netlink.c
index c051ae6..ce1a8c4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -265,7 +265,7 @@ static struct expr *netlink_alloc_verdict(const struct location *loc,
 		break;
 	}
 
-	return verdict_expr_alloc(loc, nld->verdict, chain);
+	return verdict_expr_alloc(loc, nld->verdict, chain, NULL);
 }
 
 struct expr *netlink_alloc_data(const struct location *loc,
@@ -1160,7 +1160,7 @@ static void trace_print_verdict(const struct nftnl_trace *nlt,
 	verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
 	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET))
 		chain = xstrdup(nftnl_trace_get_str(nlt, NFTNL_TRACE_JUMP_TARGET));
-	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
+	expr = verdict_expr_alloc(&netlink_location, verdict, chain, NULL);
 
 	nft_print(octx, "verdict ");
 	expr_print(expr, octx);
@@ -1175,7 +1175,7 @@ static void trace_print_policy(const struct nftnl_trace *nlt,
 
 	policy = nftnl_trace_get_u32(nlt, NFTNL_TRACE_POLICY);
 
-	expr = verdict_expr_alloc(&netlink_location, policy, NULL);
+	expr = verdict_expr_alloc(&netlink_location, policy, NULL, NULL);
 
 	nft_print(octx, "policy ");
 	expr_print(expr, octx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9aea652..7f131ad 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3817,27 +3817,31 @@ relational_op		:	EQ		{ $$ = OP_EQ; }
 
 verdict_expr		:	ACCEPT
 			{
-				$$ = verdict_expr_alloc(&@$, NF_ACCEPT, NULL);
+				$$ = verdict_expr_alloc(&@$, NF_ACCEPT, NULL, NULL);
 			}
 			|	DROP
 			{
-				$$ = verdict_expr_alloc(&@$, NF_DROP, NULL);
+				$$ = verdict_expr_alloc(&@$, NF_DROP, NULL, NULL);
 			}
 			|	CONTINUE
 			{
-				$$ = verdict_expr_alloc(&@$, NFT_CONTINUE, NULL);
+				$$ = verdict_expr_alloc(&@$, NFT_CONTINUE, NULL, NULL);
+			}
+			|	JUMP			variable_expr
+			{
+				$$ = verdict_expr_alloc(&@$, NFT_JUMP, NULL, $2);
 			}
 			|	JUMP			identifier
 			{
-				$$ = verdict_expr_alloc(&@$, NFT_JUMP, $2);
+				$$ = verdict_expr_alloc(&@$, NFT_JUMP, $2, NULL);
 			}
 			|	GOTO			identifier
 			{
-				$$ = verdict_expr_alloc(&@$, NFT_GOTO, $2);
+				$$ = verdict_expr_alloc(&@$, NFT_GOTO, $2, NULL);
 			}
 			|	RETURN
 			{
-				$$ = verdict_expr_alloc(&@$, NFT_RETURN, NULL);
+				$$ = verdict_expr_alloc(&@$, NFT_RETURN, NULL, NULL);
 			}
 			;
 
-- 
2.20.1

