From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 05/17] bison: permit 'label' on rhs side of expression
Date: Wed, 28 Jun 2017 12:06:47 +0200
Message-ID: <20170628100659.26976-6-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33358 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KG6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:58 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

needed to make 'ct event set label' work, as its also a token.
This change is broken:
 ct event set label
 and
 ct event set label,new

 cause conflict in grammar.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a95c16adde61..66f031d3ca69 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2806,6 +2806,7 @@ keyword_expr		:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
 			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
 			|	RESET			{ $$ = symbol_value(&@$, "reset"); }
+			|	LABEL			{ $$ = symbol_value(&@$, "label"); }
 			;
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
-- 
2.13.0

