Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3572CCC0
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759418520; cv=none; b=kNIqJsbXJq+Huf66YbUijAGGUBZc6KmFwKYHuKYQeSYRaD5XxjdJ9/eamr65e/ECELrSBkF//yDJtQv3LkmIsSXrQ14e2EmF4RYI1ghsddKtKnuh6e9ZagfbMjo3onib42iFmbWCic/8H8uZ4g/2JXCg667KBoN4KTMtAzPP+6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759418520; c=relaxed/simple;
	bh=qlYnQM/0pENuukpx+w/pIt7VLEJ594+Bzwbz9zHfbMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIpyJ2wFpWnJAabIxcZbQvfqeWmj+kuB+xyifPah2bSCwpc4uWV2cSEN02KtM8/PlcCLSW3fxzV1Yr4m+VLQWoWfOSYl6AoH+vO7ZxeImX6WuYo54EwEmWMXMxnMxCRaFaeeCs3/46X914xDWlX5/CKl3JYcM0P7CPxBQ1KN9ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5FEF860298; Thu,  2 Oct 2025 17:21:55 +0200 (CEST)
Date: Thu, 2 Oct 2025 17:21:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/7] doc: fix/improve documentation of verdicts
Message-ID: <aN6YkhJxliaNw2u2@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
 <20250926021136.757769-3-mail@christoph.anton.mitterer.name>
 <aNu1-kwUzXGXyNLJ@strlen.de>
 <38e6a25fd2d311e2f33b1881542a9ce7b8a8473d.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38e6a25fd2d311e2f33b1881542a9ce7b8a8473d.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> What would you think about changing it roughly as follows (at this
> place, as well as perhaps in my new summary chapter about how
> evaluation works):
> - remove the rejects from next to the drops
> - add a paragraph which describes that there are verdict-like
>   statements, which a) do some extra stuff and b) cause one of the true
>   verdicts (drop/accept)
> - along with that add a list which explains which such statement causes
>   which verdict
> 
> What's IMO important from the user PoV is that for example at a
> sentence like:
> >*accept* and *drop*/*reject* are absolute verdicts, which immediately
> > terminate the evaluation of the current rule, i.e. even any later
> > statements of the current rule won’t get executed

Why not shorten it to "accept/drop/reject immediately terminate ..."

> The user doesn't want to have to read through the whole manpage to
> eventually realise that reject behaves effectively like drop here.
> And even if you refer to the REJECT section and mention it there, it
> makes things IMO more difficult to understand.

Ok.

> But back to verdict/verdict-like statements:
> Are jump/goto/return/etc. then true verdicts? I wouldn't guess so, yet
> they already are explained in the verdict section.

Yes, this is because of netfilter verdicts vs. nftables verdicts.

accept/drop are both, continue, goto, return the latter.

This is because netfilter core has no idea what a ruleset is;
nftables "plugs" into the netfilter core.

The nf_tables base hooks interpret the user policy and then
issue either NF_ACCEPT, NF_DROP, NF_QUEUE or NF_STOLEN.

(the "core" verdicts).  But I agree that this is an implementation
detail that is irrelevant to the man page and that continue, goto, etc.
should be called verdicts too.

> I'm not sure how much we win, by differentiating between these two, and
> even if we do so, how shall we call things like reject? "verdict like
> statements"? "statements that imply a verdict"?

What about "terminal statements"?
This is already used in the man page in several places.

> > 'reject' is also not the only statement that ends rule/basechain
> > evaluation,
> > other examples are redirect/dnat/snat/masquerade which will
> > internally
> > issue an accept verdict.  Or synproxy, which will drop internally to
> > consume the incoming packet.
> 
> Is there a complete list of all these which are verdict-like and what
> verdict they actually imply?

No.

net/bridge/netfilter/nft_reject_bridge.c:       regs->verdict.code = NF_DROP;
net/ipv4/netfilter/nft_reject_ipv4.c:   regs->verdict.code = NF_DROP;
net/ipv6/netfilter/nft_reject_ipv6.c:   regs->verdict.code = NF_DROP;
net/netfilter/nft_reject_inet.c:        regs->verdict.code = NF_DROP;
net/netfilter/nft_reject_netdev.c:      regs->verdict.code = NF_DROP;

These are "obvious", reject is a fancier drop.

net/netfilter/nft_compat.c:             regs->verdict.code = NF_ACCEPT;
net/netfilter/nft_compat.c:             regs->verdict.code = NF_DROP;

irrelevant for nftables

net/netfilter/nft_connlimit.c:          regs->verdict.code = NF_DROP;

Error handling only

net/netfilter/nft_ct.c:                 regs->verdict.code = NF_DROP;
net/netfilter/nft_ct.c:         regs->verdict.code = NF_DROP;
net/netfilter/nft_exthdr.c:     regs->verdict.code = NF_DROP;
net/netfilter/nft_fib_inet.c:   regs->verdict.code = NF_DROP;

Same, only errors

net/netfilter/nft_fwd_netdev.c: regs->verdict.code = NF_STOLEN;

Terminal (packet is redirected)

net/netfilter/nft_synproxy.c:                   regs->verdict.code = NF_DROP;
net/netfilter/nft_synproxy.c:                   regs->verdict.code = NF_STOLEN;
net/netfilter/nft_synproxy.c:           regs->verdict.code = NF_DROP;
net/netfilter/nft_synproxy.c:           regs->verdict.code = NF_STOLEN;

Also terminal, 3whs packets are dropped resp. stolen
for further processing.

> > Maybe the 'REJECT STATEMENT' section can be extended a little, but I
> > think its ok as-is.
> 
> Same solution as I'd propose above?!

Ok.

> > Maybe we should mention that 'return' is the implicit thing at the
> > end
> > of a user-created non-base chain?
> > 
> > Or do you think thats self-evident?
> 
> I do mention it in my summary chapter.
> 
> In the section on the verdicts you're referring to it follows
> implicitly from the description of the *jump* statement, but at least
> there I'd also think it's perhaps good to explicitly mention it in
> parentheses.

That seems fine.

> Whether we also mentioned it in the return description, I don't mind.
> We can, so to say as extra information, but it's IMO not strictly
> necessary. Because if someone looks up the book for the return
> statement he most likely wants to know what happens we issuing it - not
> which other things (he wasn't looking up) also behave in some cases
> like the statement he was looking up.

Ok.

> > > + In a regular chain that was called via *goto* or in a base chain,
> > > the *return*
> > > + verdict is equivalent to the base chain’s policy.
> > 
> > No, its not.
> > I think this warrants an example.
> > 
> > chain two { ... }
> > chain one {
> >  ...
> >  goto two
> >  ip saddr ..   # never matched
> > }
> > 
> > chain in {
> >  hook input type filter ...
> >  jump one
> >  ip saddr .. # evaluated for all packets not dropped/accepted yet
> > }
> > 
> > -> base chain calls 'one' and remembers this location
> > -> 'one' calls 'two', but doesn't place it on chain stack.
> > -> at the end of 'two' / on 'return', we resume after 'jump one', not
> >    after 'goto'.
> > 
> > The sentence wrt. base chain policy is valid in case 'chain in' would
> > contain 'goto one', as it doesn't remember the origin location,
> > end-of-one / return is equal to explicit 'return' from the base
> > chain.
> 
> Uff... okay... that makes things quite a bit harder to describe.

Yes, I think an example would be prudent, it is probably simpler
to unstand rather than describing the mechanism.

> So effectively that means, return (explicit or implicit) it not really
> equivalent to the policy, as claimed for at least base-chains in the
> current manpage:
> > return
> > Return from the current chain and continue evaluation at the next
> > rule in the last chain. If issued in a base chain, it isequivalent to
> > the base chain policy.
> But rather *if* there's nowhere to return to (like when it's called
> from a base-chain) *then* the policy is applied, right!?

Yes.

> > Maybe it should say that it will instead resume after the last jump
> > (if
> > there was any?, or not at all (base chain policy executes?)

Yes, you can also look into man iptables, --jump and --goto work the
same way in nftables.

> As far as I understand it now:
>   base --jump--> regularA --goto--> regularB
> then at the end of regularB or if return is called in it, while I don't
> return to regularA, I actually will return to the jump position in
> base, right?

Yes, rules in "regularB" are evaluated as if they would reside in
regularA, it resumes in the base chain.

> Similar in:
>   base --jump--> regularA --jump--> regularB --goto--> regularC
> I will not return to regularB, but will return to the jump position of
> regularA and then to that of base, right?

Yes.

> Very open for opinions, but I do think with that semantics it actually
> might be best to describe things with a call stack an give some
> examples.

Yes, I think examples are best here.
