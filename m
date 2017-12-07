From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: reduce hook array sizes to what
 is needed
Date: Thu, 7 Dec 2017 14:24:07 +0100
Message-ID: <20171207132407.GD24449@breakpoint.cc>
References: <20171207130620.7585-1-fw@strlen.de>
 <20171207130620.7585-2-fw@strlen.de>
 <20171207131430.GA24920@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755692AbdLGNZb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 08:25:31 -0500
Content-Disposition: inline
In-Reply-To: <20171207131430.GA24920@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 07, 2017 at 02:06:18PM +0100, Florian Westphal wrote:
> > Not all families share the same hook count.
> > 
> > Can't use the corresponding ARP, BRIDGE, DECNET defines because they are
> > defined in uapi headers and including them causes build failures.
> > 
> > struct net before:
> > /* size: 6592, cachelines: 103, members: 46 */
> > after:
> > /* size: 5952, cachelines: 93, members: 46 */
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  include/net/netns/netfilter.h | 13 ++++++++-----
> >  net/netfilter/core.c          | 10 ++++++++++
> >  2 files changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
> > index b39c563c2fce..46842a1f77fb 100644
> > --- a/include/net/netns/netfilter.h
> > +++ b/include/net/netns/netfilter.h
> > @@ -17,11 +17,14 @@ struct netns_nf {
> >  #ifdef CONFIG_SYSCTL
> >  	struct ctl_table_header *nf_log_dir_header;
> >  #endif
> > -	struct nf_hook_entries __rcu *hooks_ipv4[NF_MAX_HOOKS];
> > -	struct nf_hook_entries __rcu *hooks_ipv6[NF_MAX_HOOKS];
> > -	struct nf_hook_entries __rcu *hooks_arp[NF_MAX_HOOKS];
> > -	struct nf_hook_entries __rcu *hooks_bridge[NF_MAX_HOOKS];
> > -	struct nf_hook_entries __rcu *hooks_decnet[NF_MAX_HOOKS];
> > +	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
> > +	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
> > +	/* in/out/forward only */
> > +	struct nf_hook_entries __rcu *hooks_arp[3];
> > +	/* note: 'BROUTE' isn't a real hook (called via function pointer) */
> > +	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
> > +	/* also supports a 'HELLO' and 'ROUTE' type */
> > +	struct nf_hook_entries __rcu *hooks_decnet[NF_INET_NUMHOOKS + 2];
> 
> Just a suggestion, for a follow up patch: Get rid of magic numbers and
> add some NF_ARP_NUMHOOKS and NF_DECNET_NUMHOOKS too, so similar
> definition.
> 
> Make sense to you?

Yes, I will add new define to include/linux/netfilter_defs.h
for this.

I'll send a v3.
