From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Tue, 27 Oct 2015 00:09:38 +0100
Message-ID: <20151026230938.GA9420@breakpoint.cc>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
 <20151026225522.GA15583@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53249 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbbJZXJk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 19:09:40 -0400
Content-Disposition: inline
In-Reply-To: <20151026225522.GA15583@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This work aims to change all major hook users to nf_register_net_hook
> > so that when a new netns is created it has no hooks at all, even when the
> > initial namespace uses conntrack, iptables and bridge netfilter.
> >
> > To keep behaviour somewhat compatible, xtable hooks are registered once a
> > iptables set/getsockopt call is made within a net namespace.
> > This also means that e.g. conntrack behaviour is not yet optimal, we
> > still create all the data structures and only skip hook registration
> > at this time.
> > Caveats:
> > - conntrack is no longer active just by loading nf_conntrack module -- at
> > least one (x)tables rule that requires conntrack has to be added, e.g.
> > conntrack match or S/DNAT target.
> 
> So far it was possible to run conntrack without iptables, eg. to
> collect statistics at per-flow level via ctnetlink. Could you find a
> way to enable the hooks also from that path?

Good point, I'll look at this tomorrow.  It should not be too hard to
add this.

> We probably should go back to the idea of having an explicit way of
> enabling conntrack from the ruleset, but that will need the /proc
> switch to keep there the existing semantics that people expect.

I'm assuming you mean something like

-t raw -p tcp ... bla ... -j CT --track ?

where this target calls the conntrack_in function directly?

I planned to add such an expression for nft bridge conntrack.

I think that if we go down this route we should also investigate
if we also need to change the way how we deal with defragmentation.
(e.g. for PF_BRIDGE and INGRESS hook points).

Maybe we could/should make it a (nf)table property?

I thought about adding a defrag expression for bridge but its error
prone, e.g. 'tcp dport 42 defrag' would have to be reordered to defrag
before l4 matching.

Thanks,
Florian
