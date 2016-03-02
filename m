From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 14:44:38 +0100
Message-ID: <20160302134438.GE4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <20160302123339.GA4930@salvia>
 <20160302123738.GB4348@breakpoint.cc>
 <20160302124626.GA5243@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52237 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbcCBNol convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 08:44:41 -0500
Content-Disposition: inline
In-Reply-To: <20160302124626.GA5243@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 02, 2016 at 01:37:38PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > [ nft meta random ]
> > 
> > > I'm fine with the probability scaling, but I think we should keep this
> > > consistent with other selectors, so I would use lt and gte instead
> > > here.
> > > 
> > > We can potentially use ranges here too and other available operations
> > > such as prefixes (although this one I don't know use case for this).
> > 
> > Ok, so just to clarify.  You want me to submit v2 of nft meta random
> > patch set that turns:
> > 
> > meta random value
> > into
> > meta random lt value
> > 
> > ... and ...
> > 
> > meta random ne value
> > into
> > meta random ge value
> > 
> > Is that correct?
> 
> I think so, so this becomes consistent with other selectors that we
> have. Does this sound reasonable to you?

I tried to find an existing op that behaves this way, but did not find
any.

The first part (making meta random value translate to meta random le
value) seems fine, this is similar to e.g. tcp flags which uses '&' as
default op when user did not provide an operator.

But for a given operation, I could not find any place where we 'disobey'
the op and silently use something else.
So I disagree with second part -- i think meta random ne value
should be left as-is, i.e. NOT 'guess' that user wanted 'ge' instead.

I think users wanting 'negate meta random 0.9' should just
use 'meta random 0.1' 8-)

Regarding existing behaviour, this is what happens for
tcp flags:

"tcp flags syn":
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000002 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]

-> i.e. we assume user wants bit-test, i.e. 'tcp flags & syn != 0'.

Some users instead expect this to behave like iptables
 --syn, i.e.  'match if syn is set and ack cleared'.

But I think its fine as-is, since 'tcp flags ack' does the sane
thing and matches when ACK flag is set, rather than *only* ACK
being set.

"tcp flags eq syn":
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ cmp eq reg 1 0x00000002 ]
"tcp flags ne syn":
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ cmp neq reg 1 0x00000002 ]

So we do what we're told for both eq and ne.
And as you can see, ne is NOT the inverse of the implicit
'tcp flags syn'.

To get the negation of 'tcp flags syn' user needs to ask for
"tcp flags & syn == 0":
  [ payload load 1b @ transport header + 13 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000002 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000000 ]

... and I think nft behaviour is consistent in this regard:

We attempt to pick the most sane op if nothing was provided
(eq in most cases, bit-test for some others) and otherwise
do what we're told.

Could do something like this:

@@ -1239,6 +1239,12 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 
                /* fall through */
        case OP_NEQ:
+               if (rel->right->dtype->type == TYPE_PROBABILITY)
+                       return expr_binary_error(ctx->msgs,right, left,
+                                                "Relational expression (%s) is undefined "
+                                                "for probability type",
+                                                expr_op_symbols[rel->op]);
+               /* fallthrough */
        case OP_FLAGCMP:

... but that could also prevent someone from doing something smart, so
I'm reluctant to disallow this just because this doesn't do what some people expect
at first glance...
