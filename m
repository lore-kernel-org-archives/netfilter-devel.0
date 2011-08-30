From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: nat: work around shared nfct struct in
 bridge case
Date: Tue, 30 Aug 2011 17:27:55 +0200
Message-ID: <20110830152755.GG7548@Chamillionaire.breakpoint.cc>
References: <1314710938-25342-1-git-send-email-fw@strlen.de>
 <4E5CE92B.2010006@trash.net>
 <20110830140013.GF7548@Chamillionaire.breakpoint.cc>
 <4E5CEEBC.8090305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45815 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab1H3P14 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:27:56 -0400
Content-Disposition: inline
In-Reply-To: <4E5CEEBC.8090305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Yes, when using your patch, otherwise (when handling this case in
> nf_nat_setup_info() we might invoke it multiple times simultaneously
> though.
> 
> > In case nf_ct_ext_add() we already return NF_ACCEPT, so I think this
> > part is OK.
> > 
> >> I also fear this is not
> >> going to be the only problem caused by breaking the "unconfirmed means
> >> non-shared nfct" assumption.
> > 
> > Agreed. Perhaps we can solve the module dependeny issue of the "unshare"
> > approach.  In fact, if invalid state for the clones would be acceptable
> > then the dependency should go away; AFAICS nf_conntrack_untracked is the
> > only nf-related symbol required by br_netfilter.o not in netfilter/core.c.
> 
> I don't think the clones should have invalid state, even untracked is
> very questionable since all packets should have NAT applied to them in
> the same way, connmarks might be used etc.

Right, but this is probably only going to be fixable in a "try to do the
best without crashing", because even without userspace queueing
there are cases where this is not deterministic:

-m physdev --physdev-out eth1 -j SNAT ...
-m physdev --physdev-out eth2 -j SNAT ...

... will match whatever bridge port the packet will be sent out on
first.

Also, before 87557c18ac36241b596984589a0889c5c4bf916c
forward ran after pass_frame_up() in which case post_routing is
not involved.

I am afraid we might first need to find out what should happen in
the "delivered locally and forwarded" case before we can figure
out what a sane fix might look like.

> We probably need to restore the above mentioned assumption somehow. One
> way would be to serialize reinjection of packets belonging to
> unconfirmed conntracks in nf_reinject or the queueing modules. Conntrack
> related stuff doesn't really belong there, but it seems like the easiest
> and safest fix to me.

Only serializing reinject may not be enough, since some packets might not be
queued (e.g. when queueing only in forward, or only when dealing with
a particular bridge port); in which case we'd still race.
