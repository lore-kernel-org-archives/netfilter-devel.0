From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 14:09:48 +0200
Message-ID: <20140404120946.GD27267@macbook.localnet>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
 <20140404081723.GA3574@localhost>
 <20140404083328.GE6769@breakpoint.cc>
 <20140404094433.GA4275@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64054 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaDDMJv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:09:51 -0400
Content-Disposition: inline
In-Reply-To: <20140404094433.GA4275@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 11:44:33AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 04, 2014 at 10:33:28AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Mon, Mar 17, 2014 at 11:08:38PM +0100, Florian Westphal wrote:
> > > > bitmask types default to flagcmp now, thus do not suppress OP_EQ.  Else,
> > > > 
> > > > rule filter output tcp flags syn
> > > > rule filter output tcp flags == syn
> > > > 
> > > > are both displayed as 'flags syn'.
> > > 
> > > I believe that in other selectors:
> > > 
> > >         selector == value
> > >         selector value
> > > 
> > > are equivalent.
> > 
> > Yes, thats true.
> > 
> > > I think it's not just that we have to fix the printing, but make it
> > > consistent.
> > 
> > Not sure, this was changed recently, see
> > 6bad82aba5d304c7a2dd1b19fe57464dca327f4a
> > (evaluate: use flagcmp for single RHS bitmask expression).
> 
> That change is fine, I think we only have to fix tcp flags == syn to
> make it equivalent to tcp flags syn. I don't find a good reason why
> the should behave in a different way.

Because the implicit op for bitmasks is to test for any of the given bits.
tcp flags syn really should match on syn and syn/ack.

If an equality relation is explicitly specified by the user, it also needs
to be printed. Florian's change is all we need from what I can tell.
