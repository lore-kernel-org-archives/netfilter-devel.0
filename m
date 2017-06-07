From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] src: rename ct eventmask to event
Date: Wed, 7 Jun 2017 13:07:51 +0200
Message-ID: <20170607110751.GC18283@breakpoint.cc>
References: <20170607102410.21024-1-fw@strlen.de>
 <20170607102410.21024-2-fw@strlen.de>
 <20170607103820.GB9280@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45040 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751257AbdFGLIT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 07:08:19 -0400
Content-Disposition: inline
In-Reply-To: <20170607103820.GB9280@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 07, 2017 at 12:24:10PM +0200, Florian Westphal wrote:
> > diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
> > index 667126e656ae..1c90ec1c769d 100644
> > --- a/tests/py/any/ct.t
> > +++ b/tests/py/any/ct.t
> > @@ -100,11 +100,11 @@ ct original mark 42;fail
> [...]
> > +ct event set new or related or destroy or foobar;fail
> > +ct event set 'new | related | destroy | label';ok;ct event set new | related | destroy | label
> 
> I would replace this by the new syntax in the tests too.
> 
> So anyone looking at test for example relies on this new one, it is
> more compact and readable IMO.

Good point, we still print
ct event set new | related | destroy | label

because we lack the OP_FLAGCMP postprocessing that relational expression
does (it converts the rhs binops into list in case of OP_FLAGCMP).

Flagcmp is also a bit different thing:
   tcp flags syn,ack
is short-hand for
   'tcp flags & (syn|ack) != 0'

but when using 'ct event set foo,bar'
its same as
ct event set foo|bar.

This gets ugly... I see no way to autodetect which output format
we should use.

I could of course stick a check for the key type into
netlink_delinerize.c but thats ugly.

Alterntively I could hook into ct_stmt_print and dissect there.

Any idea/preference?
