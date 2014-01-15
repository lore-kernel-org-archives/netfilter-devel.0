From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] expression: fix printing of binary operation
Date: Wed, 15 Jan 2014 11:28:25 +0000
Message-ID: <20140115112825.GE17728@macbook.localnet>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
 <1389784167-10198-2-git-send-email-pablo@netfilter.org>
 <20140115112129.GB17728@macbook.localnet>
 <20140115112506.GA10697@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOL23 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:28:29 -0500
Content-Disposition: inline
In-Reply-To: <20140115112506.GA10697@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:25:06PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 15, 2014 at 11:21:29AM +0000, Patrick McHardy wrote:
> > On Wed, Jan 15, 2014 at 12:09:27PM +0100, Pablo Neira Ayuso wrote:
> > > This patch adds a special print function for the relational case in
> > > which == is assumed, so it's not printed. It also fixes the output of
> > > binary operations from:
> > > 
> > > & 0x00000003 0x00000001
> > > 
> > > to:
> > > 
> > > and 0x00000003 == 0x00000001
> > > 
> > > diff --git a/src/expression.c b/src/expression.c
> > > index 6da5c10..452b0d7 100644
> > > --- a/src/expression.c
> > > +++ b/src/expression.c
> > > @@ -411,7 +411,9 @@ static void binop_expr_print(const struct expr *expr)
> > >  		printf(" %s ", expr_op_symbols[expr->op]);
> > >  	else
> > >  		printf(" ");
> > > +
> > >  	expr_print(expr->right);
> > > +	printf(" ==");
> > 
> > That doesn't look right, binops can also occur outside of relational
> > expressions. I'd suggest to special case OP_EQ and not print it by
> > default unless the LHS is an EXPR_BINOP.
> 
> Indeed, this can be !=.

Yep, that as well. The patch I just sent should handle it correctly.
