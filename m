From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft crap] ct original ip saddr ... handling
Date: Thu, 29 Jun 2017 00:31:39 +0200
Message-ID: <20170628223139.GB9307@breakpoint.cc>
References: <20170628100659.26976-1-fw@strlen.de>
 <20170628163545.GA3874@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37514 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751689AbdF1Wcn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 18:32:43 -0400
Content-Disposition: inline
In-Reply-To: <20170628163545.GA3874@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > There are no shift/reduce errors, things compile fine, and all
> > test cases work.  Its just that we break 'ct event set label':
> > 
> > Works:
> > ct event set new or reply
> > ct event set new,reply
> > ct event set new,label
> > fails:
> > ct event set label ('expects COMMA')
> 
> This can be fixed, it's just a matter we need more time, right?

Actually this makes it work for me:

diff --git a/src/parser_bison.y b/src/parser_bison.y
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2432,11 +2432,11 @@ fib_tuple		:  	fib_flag	DOT	fib_tuple
 			;
 
 shift_expr		:	primary_expr
-			|	shift_expr		LSHIFT		primary_expr
+			|	shift_expr		LSHIFT		primary_rhs_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
 			}
-			|	shift_expr		RSHIFT		primary_expr
+			|	shift_expr		RSHIFT		primary_rhs_expr
 			{
 				$$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
 			}
@@ -3154,6 +3154,7 @@ list_stmt_expr		:	symbol_rhs_expr	COMMA	symbol_rhs_expr
 			;
 
 ct_stmt_expr		:	expr
+			|	keyword_expr
 			|	list_stmt_expr
 			;

(I added keyword_expr before and that causes reduce error, but did
 not have time to figure out where they come from).

Restricting shift_expr RHS to primary_rhs_expr makes this work for
me, all test cases that are expected to pass work.

Only effect AFAICS this has is that this:

nft add rule f i iif lshift mark eq 0
<cmdline>:1:25-28: Error: Right hand side of binary operation (<<) must be constant

turns into
<cmdline>:1:25-28: Error: syntax error, unexpected mark
add rule f i iif lshift mark eq 0

so I think restricting shift_expr rhs in grammar is fine.
