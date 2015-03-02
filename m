From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 16:21:36 +0100
Message-ID: <20150302152136.GA3075@salvia>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131853.GP6142@acer.localdomain>
 <20150302140312.GA22752@salvia>
 <20150302141859.GA11849@acer.localdomain>
 <20150302143037.GA27583@salvia>
 <20150302143642.GC11849@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33350 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbbCBPSD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 10:18:03 -0500
Content-Disposition: inline
In-Reply-To: <20150302143642.GC11849@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 02:36:47PM +0000, Patrick McHardy wrote:
> On 02.03, Pablo Neira Ayuso wrote:
> > On Mon, Mar 02, 2015 at 02:19:00PM +0000, Patrick McHardy wrote:
> > > On 02.03, Pablo Neira Ayuso wrote:
> > > > On Mon, Mar 02, 2015 at 01:19:01PM +0000, Patrick McHardy wrote:
> > > > > > 
> > > > > > 3) SYMPROXY6. Don't check for e->ipv6.flags, we can instead check
> > > > > >    for e->ipv6.proto as other extensions do, if zero then it doesn't
> > > > > >    fulfill the dependency.
> > > > > 
> > > > > But we don't perform a protocol match in ip6_tables if the IP6T_F_PROTO
> > > > > flag is not given. ip6_tables differs from ip_tables in this regard.
> > > > 
> > > > This just makes sure that SYNPROXY6 is not called for non-tcp traffic
> > > > in the rule loading path, which should be OK.
> > > 
> > > Yeah, but for ip6_tables we actually need the check the way it is,
> > > without IP6T_F_PROTO we will not perform the protocol match.
> > 
> >         if (!(e->ipv6.flags & IP6T_F_PROTO) ||
> >             e->ipv6.proto != IPPROTO_TCP ||
> >             e->ipv6.invflags & XT_INV_PROTO)
> >                 return -EINVAL;
> > 
> > e->ipv6.flags & IP6T_F_PROTO seems redundant to me, it just says
> > e->ipv6.proto is set.
> 
> No, it also instructs ip6_tables to actually match on that value.
> 
> > If that flag is not set, then e->ipv6.proto is left unset. But the
> > effect should be the same since 0 != IPPROTO_TCP.
> > 
> > This is just relaxing the validation in SYNPROXY6 to only check
> > e->ipv6.proto which is what nft_compat sets.
> > 
> > Am I missing anything?
> 
> Yes, ip6_tables only performs the protocol match when that flag is set.
> Look:
> 
>         /* look for the desired protocol header */
>         if((ip6info->flags & IP6T_F_PROTO)) {
> 		...
> 		if (ip6info->proto == protohdr) {
> 	
> This is where ip6_tables and ip_tables are different, ip_tables
> takes ipinfo->proto as an indicator, ip6_tables the flag.

I'm not altering the ip6_tables core logic.

ip6tables from userspace sets IP6T_F_PROTO, the core handles things as
you described, but SYNPROXY6 only checks if e->ipv6.proto != IPPROTO_TCP.

REJECT6 does exactly the same that I need:

                if (e->ipv6.proto != IPPROTO_TCP ||                              
                    (e->ipv6.invflags & XT_INV_PROTO)) {                         
                        pr_info("TCP_RESET illegal for non-tcp\n");              
                        return -EINVAL;                                          
                }

I just want to relax the check in SYNPROXY6, so it works fine with
nft_compat. I think nothing will break.
