From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: xt_recent: relax ip_pkt_list_tot
 restrictions
Date: Thu, 27 Nov 2014 13:06:15 +0100
Message-ID: <20141127120615.GA30450@salvia>
References: <1416834382-27242-1-git-send-email-fw@strlen.de>
 <20141127113810.GA4308@salvia>
 <20141127113936.GA5668@salvia>
 <20141127120052.GE24801@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41634 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbaK0MEH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:04:07 -0500
Content-Disposition: inline
In-Reply-To: <20141127120052.GE24801@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 27, 2014 at 01:00:52PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Nov 27, 2014 at 12:38:10PM +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Nov 24, 2014 at 02:06:22PM +0100, Florian Westphal wrote:
> > > > The maximum value for the hitcount parameter is given by
> > > > "ip_pkt_list_tot" parameter (default: 20).
> > > > 
> > > > Exceeding this value on the command line will cause the rule to be
> > > > rejected.  The parameter is also readonly, i.e. it cannot be changed
> > > > without module unload or reboot.
> > > > 
> > > > Store size per table, then base nstamps[] size on the hitcount instead.
> > > > 
> > > > The module parameter is retained for backwards compatibility.
> > > 
> > > Looks good to me.
> > > 
> > > I'll mangle this patch with these small nitpicks, please let me know
> > > if you have any concern with those. Thanks Florian.
> > > 
> > > diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> > > index cd691c1..df1dde2 100644
> > > --- a/net/netfilter/xt_recent.c
> > > +++ b/net/netfilter/xt_recent.c
> > > @@ -185,8 +185,7 @@ recent_entry_init(struct recent_table *t, const
> > > union nf_inet_addr *addr,
> > >         }
> > >  
> > >         nstamps_max += 1;
> > > -       e = kmalloc(sizeof(*e) + sizeof(e->stamps[0]) * nstamps_max,
> > > -                   GFP_ATOMIC);
> > > +       e = kcalloc(nstamps_max, sizeof(*e) + sizeof(e->stamps[0]), GFP_ATOMIC);
> > 
> > Forget this chunk, it resets to zero and this is not necessary.
> 
> Right, its also not doing the same as before though ;-)

I need more coffee :-). Thanks Florian
