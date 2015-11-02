From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Mon, 2 Nov 2015 14:00:58 +0100
Message-ID: <20151102130058.GA7484@breakpoint.cc>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151026225522.GA15583@salvia>
 <20151026230938.GA9420@breakpoint.cc>
 <20151027163552.GC9420@breakpoint.cc>
 <20151029203551.GA1883@salvia>
 <20151029221303.GE18062@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38063 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbbKBNBA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2015 08:01:00 -0500
Content-Disposition: inline
In-Reply-To: <20151029221303.GE18062@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > We can probably register the hooks from ctnetlink based on what we
> > already have, ie. if nf_conntrack_ipv4 is loaded and someone runs
> > conntrack -E (or whatever custom application to listen to events),
> > then we get the hooks registered.
> 
> Right, thats what the RFC patch I sent does, it asks all the loaded
> ones to register the hooks on ctnetlink bind (i.e. conntrack -L doesn't
> register anything either, but I'm not sure thats what we would want here
> since -L is just 'show me all conntrack entries' and there are none,
> it seems wrong to take a display request as a hint that conntrack should
> be enabled.
> 
> > On top of that, assuming someone modprobes nf_conntrack_ipv6 later on,
> > we'll have to iterate over the list of netns available and register
> > the hooks if anyone is already listening to events as well.
> 
> Hmm, I wonder if this is doable without adding any additional module
> dependencies... I'll check if its feasible.

So the current plan is to add a 'notification' call to
ctnetlink_glue_hook, i.e.

 .newproto       = ctnl_newproto,

and then, from nf_ct_l3proto_register(), do:
nfnl_ct = rcu_dereference(nfnl_ct_hook);
if (nfnl_ct)
	nfnl_ct->newproto(nfproto);

This would kick ctnetlink without adding a module dependency.

Downside is that ctnetlink would need some additional logic to
make newproto() do nothing unless we saw at least on bind attempt
before (otherwise we'd always register the hooks for a new conntracker
in all the network namespaces).

For that we'd have to iterate over all the network namespaces we have
and check a per-netns knob if ctnetlink was requested at some point in the
past.

It might be acceptable though since nf_ct_l3proto_register is only
called from module init hooks.

What do you think?

> > Remember we also now also have nfnetlink_log and _queue integration
> > with conntrack, there we should register the hooks too in case the
> > userspace application.
> 
> Ugh, I forgot.  I don't see how this is fixable at the moment
> Userspace has to set _CFG_F_CONNTRACK flag but I am not (yet) convinced
> that a mere presence of this flag should force register of the conntrack
> hooks.
> 
> We'd also need yet another exported pointer-hook to prevent direct
> module dependencies from nfqueue/nflog to conntrack.  Seems best way
> would be to add a "passive" register request function to
> 
> struct nfnl_ct_hook {
> 	...
> }
> 
> in nf_conntrack_netlink.c
> 
> [ passive in the sense of 'register hooks of all nf_conntrack_nfproto
>   modules loaded, but don't grab refcount on those modules and don't
>   modprobe anything ]

This is less intrusive than I thought and should not affect any hotpath,
we can check at config time wheter this feature is wanted and then

nfnl_ct_hook->register_hooks(net)
