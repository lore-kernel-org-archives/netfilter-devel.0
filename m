From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Thu, 29 Oct 2015 21:35:51 +0100
Message-ID: <20151029203551.GA1883@salvia>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151026225522.GA15583@salvia>
 <20151026230938.GA9420@breakpoint.cc>
 <20151027163552.GC9420@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36137 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbJ2U2r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 16:28:47 -0400
Content-Disposition: inline
In-Reply-To: <20151027163552.GC9420@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, Oct 27, 2015 at 05:35:52PM +0100, Florian Westphal wrote:
> Ahem.  There are strings attached... :-/
> 
> So conntrack -L or conntrack -E do not enable connection tracking
> if its not enabled (on current kernels).
> 
> So one has to load ipv4/ipv6 etc tracker explicitly.
> 
> Problem *after* patches is that this doesn't suffice.
> 
> So old behaviour:
> conntrack -E
> 
> (nothing happens)
> (modprobe nf_conntrack_ipv4)
> (conntrack -E starts to display events)
> 
> new behaviour:
> (modprobe nf_conntrack_ipv4)
> (conntrack -E doesn't display events since conntrack module doesn't
>  see packets due to lack of nf hooks).
> 
> My first attempt to fix this was to hook into nfnetlink bind,
> but that doesn't really work in a backwards-compatible fashion since
> it only makes 'modprobe nf_conntrack_ipv4; conntrack -E' work, but
> not nf_conntrack_ipv4 module load *after* a event listener is already
> running.

So conntrack -L currently uses NFPROTO_UNSPEC by default and from
conntrack -E we subscribe to the generic groups.

> Other alternative is to request all the protocol trackers during
> ctnetlink bind request but that sucks.

Agreed, that sucks :).

> Any suggestion?  I don't really see a way out of this.

We can probably register the hooks from ctnetlink based on what we
already have, ie. if nf_conntrack_ipv4 is loaded and someone runs
conntrack -E (or whatever custom application to listen to events),
then we get the hooks registered.

On top of that, assuming someone modprobes nf_conntrack_ipv6 later on,
we'll have to iterate over the list of netns available and register
the hooks if anyone is already listening to events as well.

Remember we also now also have nfnetlink_log and _queue integration
with conntrack, there we should register the hooks too in case the
userspace application.

Another possible solution: We add a sysctl switch to the core that
indicates if conntrack/defrag hooks are enabled by default (should be
1 to maintain backward compatility).

When unset, the user needs to explicitly indicate:

        iptables -I ... -j CT --track

that we want connection tracking, so we stop playing guess games,
which (although transparent) seems a bit fragile to me.

The second path is something that we need to explore anyway for nft as
you indicated in your previous email, so this can probably solve the
problem both for iptables and nft in a more generic way.

Will be giving another spin to this tomorrow, just arrived from a long
trip.

Thanks!
