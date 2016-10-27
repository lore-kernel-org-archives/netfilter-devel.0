From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser: add offset keyword and parser rule
Date: Thu, 27 Oct 2016 22:14:06 +0200
Message-ID: <1477599246-9319-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53232 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750823AbcJ0UOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 16:14:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93FD0A8205
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 22:14:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 868A1DA7E9
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 22:14:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DD29DA7E9
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 22:14:14 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is required by the numgen and jhash expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Sorry, I applied Laura's 3/4 and 4/4 but there were several dependencies
that I'm fixing up in this patch.

 src/parser_bison.y | 7 ++++++-
 src/scanner.l      | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7377492baf86..35504de1a689 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -410,6 +410,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token NUMGEN			"numgen"
 %token INC			"inc"
 %token MOD			"mod"
+%token OFFSET			"offset"
 
 %token JHASH			"jhash"
 %token SEED			"seed"
@@ -482,7 +483,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
-%type <val>			nf_nat_flags nf_nat_flag
+%type <val>			nf_nat_flags nf_nat_flag offset_opt
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
@@ -2486,6 +2487,10 @@ meta_stmt		:	META	meta_key	SET	expr
 			}
 			;
 
+offset_opt		:	/* empty */	{ $$ = 0; }
+			|	OFFSET	NUM	{ $$ = $2; }
+			;
+
 numgen_type		:	INC		{ $$ = NFT_NG_INCREMENTAL; }
 			|	RANDOM		{ $$ = NFT_NG_RANDOM; }
 			;
diff --git a/src/scanner.l b/src/scanner.l
index 467954374f11..157b561bb874 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -462,6 +462,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
 "mod"			{ return MOD; }
+"offset"		{ return OFFSET; }
 
 "jhash"			{ return JHASH; }
 "seed"			{ return SEED; }
-- 
2.1.4

