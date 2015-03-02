From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Mon, 2 Mar 2015 15:30:40 +0000
Message-ID: <20150302153035.GF11849@acer.localdomain>
References: <1425301864-18442-1-git-send-email-pablo@netfilter.org>
 <20150302131853.GP6142@acer.localdomain>
 <20150302140312.GA22752@salvia>
 <20150302141859.GA11849@acer.localdomain>
 <20150302143037.GA27583@salvia>
 <20150302143642.GC11849@acer.localdomain>
 <20150302152136.GA3075@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34562 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbCBPbK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 10:31:10 -0500
Content-Disposition: inline
In-Reply-To: <20150302152136.GA3075@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.03, Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2015 at 02:36:47PM +0000, Patrick McHardy wrote:
> > > > > This just makes sure that SYNPROXY6 is not called for non-tcp traffic
> > > > > in the rule loading path, which should be OK.
> > > > 
> > > > Yeah, but for ip6_tables we actually need the check the way it is,
> > > > without IP6T_F_PROTO we will not perform the protocol match.
> > > 
> > >         if (!(e->ipv6.flags & IP6T_F_PROTO) ||
> > >             e->ipv6.proto != IPPROTO_TCP ||
> > >             e->ipv6.invflags & XT_INV_PROTO)
> > >                 return -EINVAL;
> > > 
> > > e->ipv6.flags & IP6T_F_PROTO seems redundant to me, it just says
> > > e->ipv6.proto is set.
> > 
> > No, it also instructs ip6_tables to actually match on that value.
> > 
> > > If that flag is not set, then e->ipv6.proto is left unset. But the
> > > effect should be the same since 0 != IPPROTO_TCP.
> > > 
> > > This is just relaxing the validation in SYNPROXY6 to only check
> > > e->ipv6.proto which is what nft_compat sets.
> > > 
> > > Am I missing anything?
> > 
> > Yes, ip6_tables only performs the protocol match when that flag is set.
> > Look:
> > 
> >         /* look for the desired protocol header */
> >         if((ip6info->flags & IP6T_F_PROTO)) {
> > 		...
> > 		if (ip6info->proto == protohdr) {
> > 	
> > This is where ip6_tables and ip_tables are different, ip_tables
> > takes ipinfo->proto as an indicator, ip6_tables the flag.
> 
> I'm not altering the ip6_tables core logic.
> 
> ip6tables from userspace sets IP6T_F_PROTO, the core handles things as
> you described, but SYNPROXY6 only checks if e->ipv6.proto != IPPROTO_TCP.

It will allow an ip6tables rule containing e->ipv6.proto == IPPROTO_TCP
but not IP6T_F_PROTO, meaning that the protocol match is not performed,
ergo any protocol can hit the target at runtime if such a rule is set.

I'm not saying that this will necessarily break something since
ip6tables does set that flag, but we usually do perform full validation
in ip*tables in the kernel, this patch changes that logic.

> REJECT6 does exactly the same that I need:
> 
>                 if (e->ipv6.proto != IPPROTO_TCP ||                              
>                     (e->ipv6.invflags & XT_INV_PROTO)) {                         
>                         pr_info("TCP_RESET illegal for non-tcp\n");              
>                         return -EINVAL;                                          
>                 }

That contains the same problem. I'd say most people have copy and
pasted this from iptables without realizing the difference.

> I just want to relax the check in SYNPROXY6, so it works fine with
> nft_compat. I think nothing will break.

Not with our current userspace, I agree. But its a change in policy
for ip*tables to rely on that.
