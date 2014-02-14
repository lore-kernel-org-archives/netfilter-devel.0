From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix rule batch with anonymous set
 and module autoload
Date: Fri, 14 Feb 2014 13:34:11 +0100
Message-ID: <20140214123411.GA4422@localhost>
References: <1392377228-3748-1-git-send-email-pablo@netfilter.org>
 <20140214113755.GC19082@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39415 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaBNMeS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:34:18 -0500
Content-Disposition: inline
In-Reply-To: <20140214113755.GC19082@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 14, 2014 at 11:37:56AM +0000, Patrick McHardy wrote:
> [ sorry accidentally dropped netfilter-devel ]
> 
> On Fri, Feb 14, 2014 at 12:27:08PM +0100, Pablo Neira Ayuso wrote:
> > If some modules are missing while processing a rule batch, the updates
> > are aborted to start scratch since the nfnl lock was released. If the
> > rule-set contains this configuration (in this order):
> > 
> >  #1 rule using anonymous set
> >  #2 rule requiring module autoload
> > 
> > The anonymous set will be released when aborting. This patch fixes this
> > by passing a context variable (autoload) that can be used to decide if
> > the anonymous set has to be released or not.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I guess we can encapsulate that autoload into a context information structure
> > in the future in case any other information is needed in the rule destroy path
> > to make this look nicer.
> >
> > I started hacking on two patches to net-next, one to include table, chains and
> > set into the batch and follow up to add atomic updates for sets. @Patrick: I
> > think that should not interfer with your set enhancements.
> 
> Wouldn't be a big problem, they're pretty much contained to newset().
> 
> Regarding this patch - I'd really prefer to just fix batches to include sets
> instead of changing all these function signatures just to handle this very
> specific case.

If the patch that results from adding the set into the batch support
is ~100 LOC, we can pass that to -stable, but if it doesn't, we'll
have to pass this first or tell people that they need to load all
modules as a workaround.

> I'm wondering how this will work in case of anonymous sets though, right now
> we need two transactions so userspace can attach the new set to the lookup
> expression.

The set definition and the elements need to be included in the lookup
expression for anonymous sets, can you think of any better solution?
