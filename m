From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Thu, 29 Oct 2015 23:13:03 +0100
Message-ID: <20151029221303.GE18062@breakpoint.cc>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151026225522.GA15583@salvia>
 <20151026230938.GA9420@breakpoint.cc>
 <20151027163552.GC9420@breakpoint.cc>
 <20151029203551.GA1883@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60755 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964969AbbJ2WNG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 18:13:06 -0400
Content-Disposition: inline
In-Reply-To: <20151029203551.GA1883@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > (nothing happens)
> > (modprobe nf_conntrack_ipv4)
> > (conntrack -E starts to display events)
> > 
> > new behaviour:
> > (modprobe nf_conntrack_ipv4)
> > (conntrack -E doesn't display events since conntrack module doesn't
> >  see packets due to lack of nf hooks).
> > 
> > My first attempt to fix this was to hook into nfnetlink bind,
> > but that doesn't really work in a backwards-compatible fashion since
> > it only makes 'modprobe nf_conntrack_ipv4; conntrack -E' work, but
> > not nf_conntrack_ipv4 module load *after* a event listener is already
> > running.
> 
> So conntrack -L currently uses NFPROTO_UNSPEC by default and from
> conntrack -E we subscribe to the generic groups.

Yes.

> > Other alternative is to request all the protocol trackers during
> > ctnetlink bind request but that sucks.
> 
> Agreed, that sucks :).

Good, I would have hated implementing it ;)

> > Any suggestion?  I don't really see a way out of this.
> 
> We can probably register the hooks from ctnetlink based on what we
> already have, ie. if nf_conntrack_ipv4 is loaded and someone runs
> conntrack -E (or whatever custom application to listen to events),
> then we get the hooks registered.

Right, thats what the RFC patch I sent does, it asks all the loaded
ones to register the hooks on ctnetlink bind (i.e. conntrack -L doesn't
register anything either, but I'm not sure thats what we would want here
since -L is just 'show me all conntrack entries' and there are none,
it seems wrong to take a display request as a hint that conntrack should
be enabled.

> On top of that, assuming someone modprobes nf_conntrack_ipv6 later on,
> we'll have to iterate over the list of netns available and register
> the hooks if anyone is already listening to events as well.

Hmm, I wonder if this is doable without adding any additional module
dependencies... I'll check if its feasible.

> Remember we also now also have nfnetlink_log and _queue integration
> with conntrack, there we should register the hooks too in case the
> userspace application.

Ugh, I forgot.  I don't see how this is fixable at the moment
Userspace has to set _CFG_F_CONNTRACK flag but I am not (yet) convinced
that a mere presence of this flag should force register of the conntrack
hooks.

We'd also need yet another exported pointer-hook to prevent direct
module dependencies from nfqueue/nflog to conntrack.  Seems best way
would be to add a "passive" register request function to

struct nfnl_ct_hook {
	...
}

in nf_conntrack_netlink.c

[ passive in the sense of 'register hooks of all nf_conntrack_nfproto
  modules loaded, but don't grab refcount on those modules and don't
  modprobe anything ]

> Another possible solution: We add a sysctl switch to the core that
> indicates if conntrack/defrag hooks are enabled by default (should be
> 1 to maintain backward compatility).
> 
> When unset, the user needs to explicitly indicate:
> 
>         iptables -I ... -j CT --track
> 
> that we want connection tracking, so we stop playing guess games,
> which (although transparent) seems a bit fragile to me.

Not really, I mean if someone has a -m conntrack or DNAT or whatever
rule its crystal clear that we need conntrack enabled.
So I don't really think there are any 'guess games' to be played.

The only corner-cases that I see is loaded conntrack, no rule
dependencies at all (no nat, no stateful filtering of any kind)
but e.g. traffic accouting via ctnetlink.

[ The -j CT --track thing has other advantages such as allowing
  fine grained control over what needs tracking rather than the 'notrack'
  stuff have right now, I'd definitely would like to see this as well ]

> The second path is something that we need to explore anyway for nft as
> you indicated in your previous email, so this can probably solve the
> problem both for iptables and nft in a more generic way.

Right.

> Will be giving another spin to this tomorrow, just arrived from a long
> trip.

Take your time, this beast won't be ready for next -next (he he) anyway.
