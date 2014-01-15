From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] expression: fix printing of binary operation
Date: Wed, 15 Jan 2014 11:49:39 +0000
Message-ID: <20140115114939.GA21225@macbook.localnet>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
 <1389784167-10198-2-git-send-email-pablo@netfilter.org>
 <20140115112129.GB17728@macbook.localnet>
 <20140115112717.GC17728@macbook.localnet>
 <20140115114134.GA10872@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44017 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaAOLtn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:49:43 -0500
Content-Disposition: inline
In-Reply-To: <20140115114134.GA10872@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:41:34PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 15, 2014 at 11:27:17AM +0000, Patrick McHardy wrote:
> > On Wed, Jan 15, 2014 at 11:21:29AM +0000, Patrick McHardy wrote:
> > > 
> > > That doesn't look right, binops can also occur outside of relational
> > > expressions. I'd suggest to special case OP_EQ and not print it by
> > > default unless the LHS is an EXPR_BINOP.
> > 
> > Something like this:
> > 
> > 
> > diff --git a/src/expression.c b/src/expression.c
> > index 71154cc..518f71c 100644
> > --- a/src/expression.c
> > +++ b/src/expression.c
> > @@ -356,7 +356,7 @@ const char *expr_op_symbols[] = {
> >  	[OP_XOR]	= "^",
> >  	[OP_LSHIFT]	= "<<",
> >  	[OP_RSHIFT]	= ">>",
> > -	[OP_EQ]		= NULL,
> > +	[OP_EQ]		= "==",
> >  	[OP_NEQ]	= "!=",
> >  	[OP_LT]		= "<",
> >  	[OP_GT]		= ">",
> > @@ -407,7 +407,9 @@ struct expr *unary_expr_alloc(const struct location *loc,
> >  static void binop_expr_print(const struct expr *expr)
> >  {
> >  	expr_print(expr->left);
> > -	if (expr_op_symbols[expr->op] != NULL)
> > +	if (expr_op_symbols[expr->op] &&
> > +	    (expr->op != OP_EQ ||
> > +	     expr->left->ops->type == EXPR_BINOP))
> >  		printf(" %s ", expr_op_symbols[expr->op]);
> >  	else
> >  		printf(" ");
> 
> This looks a bit more complicated. To my understanding, the right-hand
> side of the relational tree contains the value. The left-hand side
> contains the binop tree, whose left-hand side is the meta mark and the
> right-hand side is the value to apply the operation. The print
> function doesn't have context to know what's on the right-hand side of
> the upper relational expression. Thinking how to fix this...

This OP_EQ case is the upper relational expression. Try it, it works fine :)
