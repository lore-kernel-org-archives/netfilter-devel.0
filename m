From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 16:24:40 +0200
Message-ID: <20140404142333.GA28798@macbook.localnet>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
 <20140404081723.GA3574@localhost>
 <20140404083328.GE6769@breakpoint.cc>
 <20140404094433.GA4275@localhost>
 <20140404120946.GD27267@macbook.localnet>
 <20140404140430.GB28581@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaDDOYn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:24:43 -0400
Content-Disposition: inline
In-Reply-To: <20140404140430.GB28581@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 04:04:30PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 04, 2014 at 02:09:48PM +0200, Patrick McHardy wrote:
> > On Fri, Apr 04, 2014 at 11:44:33AM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Apr 04, 2014 at 10:33:28AM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > On Mon, Mar 17, 2014 at 11:08:38PM +0100, Florian Westphal wrote:
> > > > > > bitmask types default to flagcmp now, thus do not suppress OP_EQ.  Else,
> > > > > > 
> > > > > > rule filter output tcp flags syn
> > > > > > rule filter output tcp flags == syn
> > > > > > 
> > > > > > are both displayed as 'flags syn'.
> > > > > 
> > > > > I believe that in other selectors:
> > > > > 
> > > > >         selector == value
> > > > >         selector value
> > > > > 
> > > > > are equivalent.
> > > > 
> > > > Yes, thats true.
> > > > 
> > > > > I think it's not just that we have to fix the printing, but make it
> > > > > consistent.
> > > > 
> > > > Not sure, this was changed recently, see
> > > > 6bad82aba5d304c7a2dd1b19fe57464dca327f4a
> > > > (evaluate: use flagcmp for single RHS bitmask expression).
> > > 
> > > That change is fine, I think we only have to fix tcp flags == syn to
> > > make it equivalent to tcp flags syn. I don't find a good reason why
> > > the should behave in a different way.
> > 
> > Because the implicit op for bitmasks is to test for any of the given bits.
> > tcp flags syn really should match on syn and syn/ack.
> 
> That's fine with me. The problem that I see is the inconsistent
> interpretation depending on if the value is a flag or not.

I don't see it as inconsistent, its just that the implicit op can mean
different things. Its basically meant to "do the right thing", which
IMO is the current behaviour. For me tcp flags syn also matching on syn/ack
is what I'd expect.

> > If an equality relation is explicitly specified by the user, it also needs
> > to be printed. Florian's change is all we need from what I can tell.
> 
> Then we have to document that in some cases key == value and key
> value are equivalent, and when it comes to flags it is not, which is
> still rare to me.

Sure. I think I already have it in my documentation. Its basically simply
documenting what the implicit op means in which context.
