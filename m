From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Can't fail and free after table replacement
Date: Fri, 4 Apr 2014 10:13:14 +0200
Message-ID: <20140404081314.GB3548@localhost>
References: <e9465527b268e8ad308384c839f0b2051da3efb7.1396452712.git.tgraf@suug.ch>
 <20140403213757.GA3834@localhost>
 <20140403220826.GC6769@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Graf <tgraf@suug.ch>, bart.de.schuymer@pandora.be,
	kaber@trash.net, kadlec@blackhole.kfki.hu,
	stephen@networkplumber.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57889 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaDDINX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:13:23 -0400
Content-Disposition: inline
In-Reply-To: <20140403220826.GC6769@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 12:08:26AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Apr 02, 2014 at 05:35:13PM +0200, Thomas Graf wrote:
> > > All xtables variants suffer from the defect that the copy_to_user()
> > > to copy the counters to user memory may fail after the table has
> > > already been exchanged and thus exposed. Return an error at this
> > > point will result in freeing the already exposed table. Any
> > > subsequent packet processing will result in a kernel panic.
> > > 
> > > We can't copy the counters before exposing the new tables as we
> > > want provide the counter state after the old table has been
> > > unhooked. Therefore convert this into a silent error.
> > > 
> > > Cc: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Thomas Graf <tgraf@suug.ch>
> > > ---
> > >  net/bridge/netfilter/ebtables.c | 4 +---
> > >  net/ipv4/netfilter/arp_tables.c | 5 +++--
> > >  net/ipv4/netfilter/ip_tables.c  | 5 +++--
> > >  net/ipv6/netfilter/ip6_tables.c | 5 +++--
> > >  4 files changed, 10 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> > > index 0e474b1..7a3dc98 100644
> > > --- a/net/bridge/netfilter/ebtables.c
> > > +++ b/net/bridge/netfilter/ebtables.c
> > > @@ -1044,10 +1044,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
> > >  	if (repl->num_counters &&
> > >  	   copy_to_user(repl->counters, counterstmp,
> > >  	   repl->num_counters * sizeof(struct ebt_counter))) {
> > > -		ret = -EFAULT;
> > > +		/* Silent error, can't fail, new table is already in place */
> > >  	}
> > > -	else
> > > -		ret = 0;
> > >  
> > 
> > This seems good to me.
> > 
> > Perhaps we can spot a warning like in rtnetlink to inform the user
> > that counters are not reliable anymore?
> 
> you mean net_warn_ratelimit() ?
> 
> Sure, can be added.
> 
> However given that this bug has been around for 9 years I don't think
> its really needed, if it fails kernel panic'd, so its safe to say
> that the counters are reliable ;)

But we are not crashing anymore, right? That swapped out scenario may
happen in a short-time stress situation from the memory POV. Let's
just be informative, it's just one extra line ahead.
