From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new
 namespaces
Date: Mon, 26 Oct 2015 23:55:22 +0100
Message-ID: <20151026225522.GA15583@salvia>
References: <1445597006-11264-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43531 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbbJZWsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 18:48:33 -0400
Content-Disposition: inline
In-Reply-To: <1445597006-11264-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Oct 23, 2015 at 12:43:17PM +0200, Florian Westphal wrote:
[...]
> This work aims to change all major hook users to nf_register_net_hook
> so that when a new netns is created it has no hooks at all, even when the
> initial namespace uses conntrack, iptables and bridge netfilter.
>
> To keep behaviour somewhat compatible, xtable hooks are registered once a
> iptables set/getsockopt call is made within a net namespace.
> This also means that e.g. conntrack behaviour is not yet optimal, we
> still create all the data structures and only skip hook registration
> at this time.
> 
> Caveats:
> - conntrack is no longer active just by loading nf_conntrack module -- at
> least one (x)tables rule that requires conntrack has to be added, e.g.
> conntrack match or S/DNAT target.

So far it was possible to run conntrack without iptables, eg. to
collect statistics at per-flow level via ctnetlink. Could you find a
way to enable the hooks also from that path?

If the program polls /proc, too bad for it, it shouldn't be using such
interface for that purpose.

We probably should go back to the idea of having an explicit way of
enabling conntrack from the ruleset, but that will need the /proc
switch to keep there the existing semantics that people expect.

Let me know,
Thanks.
