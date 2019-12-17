Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222BAC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F38692146E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfLQL1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:41 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbfLQL1l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:41 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB0t-0006kq-K8; Tue, 17 Dec 2019 12:27:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 05/10] parser: add typeof keyword for declarations
Date:   Tue, 17 Dec 2019 12:27:08 +0100
Message-Id: <20191217112713.6017-6-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add a typeof keyword to automatically use the correct type in set and map
declarations.

table filter {
	set blacklist {
		typeof ip saddr
	}

	chain input {
		ip saddr @blacklist counter drop
	}
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 src/scanner.l      |  1 +
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6d17539fa57e..799f7a308b07 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -223,6 +223,8 @@ int nft_lex(void *, void *, void *);
 %token WSCALE			"wscale"
 %token SACKPERM			"sack-perm"
 
+%token TYPEOF			"typeof"
+
 %token HOOK			"hook"
 %token DEVICE			"device"
 %token DEVICES			"devices"
@@ -658,8 +660,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
-%type <expr>			primary_expr shift_expr and_expr
-%destructor { expr_free($$); }	primary_expr shift_expr and_expr
+%type <expr>			primary_expr shift_expr and_expr typeof_expr
+%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
@@ -1671,6 +1673,29 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
+typeof_expr		:	primary_expr
+			{
+				if (expr_ops($1)->build_udata == NULL) {
+					erec_queue(error(&@1, "primary expression type '%s' lacks typeof serialization", expr_ops($1)->name),
+						   state->msgs);
+					expr_free($1);
+					YYERROR;
+				}
+
+				$$ = $1;
+			}
+			|	typeof_expr		DOT		primary_expr
+			{
+				struct location rhs[] = {
+					[1]	= @2,
+					[2]	= @3,
+				};
+
+				$$ = handle_concat_expr(&@$, $$, $1, $3, rhs);
+			}
+			;
+
+
 set_block_alloc		:	/* empty */
 			{
 				$$ = set_alloc(NULL);
@@ -1685,6 +1710,12 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->key = $3;
 				$$ = $1;
 			}
+			|	set_block	TYPEOF		typeof_expr	stmt_separator
+			{
+				$1->key = $3;
+				datatype_set($1->key, $3->dtype);
+				$$ = $1;
+			}
 			|	set_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags = $3;
@@ -1754,6 +1785,17 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= NFT_SET_MAP;
 				$$ = $1;
 			}
+			|	map_block	TYPEOF
+						typeof_expr	COLON	typeof_expr
+						stmt_separator
+			{
+				$1->key = $3;
+				datatype_set($1->key, $3->dtype);
+				$1->data = $5;
+
+				$1->flags |= NFT_SET_MAP;
+				$$ = $1;
+			}
 			|	map_block	TYPE
 						data_type_expr	COLON	COUNTER
 						stmt_separator
diff --git a/src/scanner.l b/src/scanner.l
index d32adf4897ae..4fbdcf2afa4b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -385,6 +385,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "saddr"			{ return SADDR; }
 "daddr"			{ return DADDR; }
 "type"			{ return TYPE; }
+"typeof"		{ return TYPEOF; }
 
 "vlan"			{ return VLAN; }
 "id"			{ return ID; }
-- 
2.24.1

