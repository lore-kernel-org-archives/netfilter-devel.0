From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 nf-next 0/12] netfilter: don't copy init ns hooks to
 new namespaces
Date: Sun, 20 Dec 2015 22:01:54 +0100
Message-ID: <20151220210154.GG29573@breakpoint.cc>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
 <20151218114226.GB2091@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42356 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbbLTVB5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2015 16:01:57 -0500
Content-Disposition: inline
In-Reply-To: <20151218114226.GB2091@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 03, 2015 at 10:49:33AM +0100, Florian Westphal wrote:
> > My problem with this patch set is the ridiculous amount of code that needs
> > to be added to cover all the 'register the hooks for conntrack' cases.

[..]

> > IOW, it might be a much better idea to respin this patch series so
> > that it does NOT contain any of the conntrack changes (only 'don't register
> > xtables hooks + don't register bridge hooks), and then add
> > net.netfilter.nf_conntrack_disable (or whatever), plus -j CT --track.
>
> It would be good to agree on some design for this. Patrick also have
> concerns on loose conntrack enabling. That we can probably resolve
> through explicit configuration, something like:

[..]

> > That would also solve this issue, albeit not by default and it leaves
> > the question of how we should deal with defragmentation
> > (-s 10.2.3.0/24 -p tcp --dport 80 would not work reliably).
> 
> IIRC in iptables, we drop this via hotdrop, but in nftables this is an
> open issue, a user with no defrag should drop fragments in first place
> in his ruleset.

To clarify, what I meant was user doing this:

-s 10.0.0.8/24 -p tcp --dport 80 -j CT --track

Which will only do the expected thing -- feed all http traffic to
conntrack_in -- for non-fragmented packets.

So if we'd follow this route, i.e. conditional tracking via ruleset,
we'd need to figure out how to...

1. make sure fragments don't bypass such rules
2. deal with reply direction (we'd probably need some 'passive'
   input hook that doesn't create new connections and only checks for
   reply direction)
3. how to handle expecations, helpers, etc

Simplest and most backwards-compat solution for #1 would be to
register the defrag hooks once such a rule is inserted, which IMO
is the preferable solution, especially because it won't cause backwards
compat issues.

For #2, I don't have a good solution yet, alternative would be
to also force adding rule in reply dir, but I hate it since we don't
require it for NAT either.

Haven't thought about #3 yet.

> In iptables, we can still register the defragmentation hooks as soon
> as we need conntrack, socket or tproxy.

Yes, we'd need some of the patches from this set to avoid registering in
all net namespaces, but, I agree -- inferring if defrag is needed seems
to be easy and correct path forward.

> > Perhaps we could attempt to propogate a *conntrack rule active* bit into
> > the xtables core and call defrag from there.  Another, simpler alternative
> > would be to stick an unconditional 'defrag' call into the raw table.
> 
> I couldn't come up so far with any scenario that would break with
> unconditional defragmentation. But unconditional stuff makes me feel a
> bit nervous as there is usually someone following up with rare
> situation that forces us to disable it.

Lets forget about unconditional defrag in raw table, it was a ba idea.

> Let me know, thanks Florian.

I'd propose to respin this patch series with all the conntrack parts removed.

I think the conntrack parts are too fragile for now, lets discuss
conditional-conntrack-via-ruleset during netdev1.1.

We've mentioned 'inverted NOTRACK' so often by now that it would be a
desaster if we close that door forever by applying a half-baked
'auto-inferring "solution"' now.

If you'd prefer to toss entire patch set and discuss the entire
'netns hooking' mess at netdev1.1 -- no problem, just let me know.

Thanks!
