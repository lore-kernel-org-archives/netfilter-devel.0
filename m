Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FA5C04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB01E2133D
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 18:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="VGO0IpKT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfELSQJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 14:16:09 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40340 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbfELSQJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 14:16:09 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 955C21A319F;
        Sun, 12 May 2019 11:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557684968; bh=XM7AkXsz80lc158nzlbksb0Q8hq5W0PYV+4b2X2oSNE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VGO0IpKTdlVjpZEwz4N3nWal9SsfNDmx6FT2dd4iZ/WPz/4DCHwaR/5+FNO99pIAR
         SH9HRXdMSUm2VJLEHvdNsvcn9TZGRijJbdDnJKYeW4V5SpE8HLjhliON1JLqENy8Qj
         5qsVXHH36B+Zz6O0CAzkcnGw7BAxmAcawctfxe50=
X-Riseup-User-ID: 7F8DC017886C5025E50A276647D2C99BAA39686EBF65D39949B075DEE7DE2F6A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id AEDD5120502;
        Sun, 12 May 2019 11:16:07 -0700 (PDT)
Subject: Re: [PATCH nft WIP] jump: Allow jump to a variable when using nft
 input files
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190509113358.856-1-ffmancera@riseup.net>
 <20190509145701.bwg5wrkv47eahhlp@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <23cad3e6-a0d2-d19d-03df-0aab6258417f@riseup.net>
Date:   Sun, 12 May 2019 20:16:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190509145701.bwg5wrkv47eahhlp@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Pablo, comments below.

On 5/9/19 4:57 PM, Pablo Neira Ayuso wrote:
> On Thu, May 09, 2019 at 01:33:58PM +0200, Fernando Fernandez Mancera wrote:
>> This patch introduces the use of nft input files variables in 'jump'
>> statements, e.g.
>>
>> define dest = chainame
>>
>> add rule ip filter input jump $dest
> 
> You need two patches to achieve this.
> 
> First patch should replace the chain string by an expression, ie.
> 
> diff --git a/include/expression.h b/include/expression.h
> index 6416ac090d9f..d3de4abfd435 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -240,7 +240,7 @@ struct expr {
>                 struct {
>                         /* EXPR_VERDICT */
>                         int                     verdict;
> -                       const char              *chain;
> +                       struct expr             *chain;
>                 };
>                 struct {
>                         /* EXPR_VALUE */
> 
> Then, this first patch should also update the whole codebase to use
> this new chain expression. From the parser, you will have to call
> constant_expr_alloc() using the string_type datatype to store the
> chain string. Still from this initial patch, you also have to call
> expr_evaluate() from stmt_evaluate_verdict() on this new chain
> expression field. You will also need to update the netlink_delinearize
> path to allocate the constant expression so ruleset listing does not
> break
I have been working on this but I am facing a problem with the chain
value. There is a patch below, it compiles but I am getting the
following error. As you can see the chain value is full of random data.

# nft add table ip foo
# nft add chain ip foo bar
# nft add chain ip foo bar2
# nft --debug=eval add rule ip foo bar jump bar2

Evaluate add
add rule ip foo bar jump bar2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Evaluate verdict
add rule ip foo bar jump bar2
                    ^^^^^^^^^
jump "P5¨$V"

Evaluate verdict
add rule ip foo bar jump bar2
                    ^^^^^^^^^
jump "P5¨$V"

Error: Could not process rule: No such file or directory
add rule ip foo bar jump bar2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think that I am missing something when extracting the value with
mpz_get_str(). Thanks!

From 9299a7e3717d9c9eced1664f8aec1b9b7fa23bda Mon Sep 17 00:00:00 2001
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
Date: Sun, 12 May 2019 20:03:29 +0200
Subject: [PATCH] jump: Introduce chain_expr in jump statements

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/expression.h |  4 ++--
 src/datatype.c       |  6 ++++--
 src/evaluate.c       |  6 ++++++
 src/expression.c     | 11 ++++++-----
 src/netlink.c        | 27 ++++++++++++++++++++-------
 src/parser_bison.y   | 16 ++++++++++++----
 6 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6416ac0..ef41255 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -240,7 +240,7 @@ struct expr {
 		struct {
 			/* EXPR_VERDICT */
 			int			verdict;
-			const char		*chain;
+			struct expr		*chain;
 		};
 		struct {
 			/* EXPR_VALUE */
@@ -403,7 +403,7 @@ extern void relational_expr_pctx_update(struct
proto_ctx *ctx,
 					const struct expr *expr);

 extern struct expr *verdict_expr_alloc(const struct location *loc,
-				       int verdict, const char *chain);
+				       int verdict, struct expr *chain);

 extern struct expr *symbol_expr_alloc(const struct location *loc,
 				      enum symbol_types type, struct scope *scope,
diff --git a/src/datatype.c b/src/datatype.c
index ac9f2af..bfa5efc 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -262,10 +262,12 @@ static void verdict_type_print(const struct expr
*expr, struct output_ctx *octx)
 		nft_print(octx, "break");
 		break;
 	case NFT_JUMP:
-		nft_print(octx, "jump %s", expr->chain);
+		nft_print(octx, "jump ");
+		datatype_print(expr->chain, octx);
 		break;
 	case NFT_GOTO:
-		nft_print(octx, "goto %s", expr->chain);
+		nft_print(octx, "goto ");
+		datatype_print(expr->chain, octx);
 		break;
 	case NFT_RETURN:
 		nft_print(octx, "return");
diff --git a/src/evaluate.c b/src/evaluate.c
index 3593eb8..c1e612d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1940,6 +1940,7 @@ static int stmt_evaluate_arg(struct eval_ctx *ctx,
struct stmt *stmt,

 static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	unsigned int len = NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE;
 	if (stmt_evaluate_arg(ctx, stmt, &verdict_type, 0, 0, &stmt->expr) < 0)
 		return -1;

@@ -1947,6 +1948,11 @@ static int stmt_evaluate_verdict(struct eval_ctx
*ctx, struct stmt *stmt)
 	case EXPR_VERDICT:
 		if (stmt->expr->verdict != NFT_CONTINUE)
 			stmt->flags |= STMT_F_TERMINAL;
+		if (stmt->expr->verdict == NFT_JUMP)
+			stmt->expr->chain = expr_alloc(&stmt->location,
+						       EXPR_VALUE, &string_type,
+						       BYTEORDER_HOST_ENDIAN,
+						       len);
 		break;
 	case EXPR_MAP:
 		break;
diff --git a/src/expression.c b/src/expression.c
index eece12e..55a4ad7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -207,17 +207,18 @@ static bool verdict_expr_cmp(const struct expr
*e1, const struct expr *e2)

 	if ((e1->verdict == NFT_JUMP ||
 	     e1->verdict == NFT_GOTO) &&
-	    strcmp(e1->chain, e2->chain))
-		return false;
+	     (expr_basetype(e1) == expr_basetype(e2) &&
+	     !mpz_cmp(e1->value, e2->value)))
+		return true;

-	return true;
+	return false;
 }

 static void verdict_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->verdict = expr->verdict;
 	if (expr->chain != NULL)
-		new->chain = xstrdup(expr->chain);
+		mpz_init_set(new->chain->value, expr->chain->value);
 }

 static void verdict_expr_destroy(struct expr *expr)
@@ -236,7 +237,7 @@ static const struct expr_ops verdict_expr_ops = {
 };

 struct expr *verdict_expr_alloc(const struct location *loc,
-				int verdict, const char *chain)
+				int verdict, struct expr *chain)
 {
 	struct expr *expr;

diff --git a/src/netlink.c b/src/netlink.c
index c051ae6..348a195 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -218,12 +218,15 @@ static void netlink_gen_constant_data(const struct
expr *expr,
 static void netlink_gen_verdict(const struct expr *expr,
 				struct nft_data_linearize *data)
 {
+	char *chain;
+
 	data->verdict = expr->verdict;

 	switch (expr->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", expr->chain);
+		chain = mpz_get_str(NULL, 10, expr->chain->value);
+		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
 		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
 	}
@@ -253,19 +256,22 @@ struct expr *netlink_alloc_value(const struct
location *loc,
 static struct expr *netlink_alloc_verdict(const struct location *loc,
 					  const struct nft_data_delinearize *nld)
 {
-	char *chain;
+	struct expr *chain_expr;

 	switch (nld->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		chain = xstrdup(nld->chain);
+		chain_expr->chain = constant_expr_alloc(loc, &string_type,
+							BYTEORDER_HOST_ENDIAN,
+							sizeof(nld->chain) *
+							BITS_PER_BYTE, nld->chain);
 		break;
 	default:
-		chain = NULL;
+		chain_expr = NULL;
 		break;
 	}

-	return verdict_expr_alloc(loc, nld->verdict, chain);
+	return verdict_expr_alloc(loc, nld->verdict, chain_expr);
 }

 struct expr *netlink_alloc_data(const struct location *loc,
@@ -1153,14 +1159,21 @@ static void trace_print_expr(const struct
nftnl_trace *nlt, unsigned int attr,
 static void trace_print_verdict(const struct nftnl_trace *nlt,
 				 struct output_ctx *octx)
 {
+	struct expr *chain_expr = NULL;
 	const char *chain = NULL;
 	unsigned int verdict;
 	struct expr *expr;

 	verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
-	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET))
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET)) {
 		chain = xstrdup(nftnl_trace_get_str(nlt, NFTNL_TRACE_JUMP_TARGET));
-	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
+		chain_expr = constant_expr_alloc(&netlink_location,
+						 &string_type,
+						 BYTEORDER_HOST_ENDIAN,
+						 sizeof(chain) * BITS_PER_BYTE,
+						 chain);
+	}
+	expr = verdict_expr_alloc(&netlink_location, verdict, chain_expr);

 	nft_print(octx, "verdict ");
 	expr_print(expr, octx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9aea652..5f61b14 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -618,8 +618,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc
flow_stmt_legacy_alloc

-%type <expr>			symbol_expr verdict_expr integer_expr variable_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
variable_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr
chain_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
variable_expr chain_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -3827,11 +3827,11 @@ verdict_expr		:	ACCEPT
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_CONTINUE, NULL);
 			}
-			|	JUMP			identifier
+			|	JUMP			chain_expr
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_JUMP, $2);
 			}
-			|	GOTO			identifier
+			|	GOTO			chain_expr
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_GOTO, $2);
 			}
@@ -3841,6 +3841,14 @@ verdict_expr		:	ACCEPT
 			}
 			;

+chain_expr		:	identifier
+			{
+				$$ = constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof($1) * BITS_PER_BYTE, &$1);
+			}
+			;
+
 meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $2);
-- 
2.20.1
