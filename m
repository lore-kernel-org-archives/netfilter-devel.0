Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FD81C28E
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Oct 2025 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760793927; cv=none; b=gEAIPqq+5AKCUU7I0th76F42AIXLKfvZebgww8XP2JqLEDhIL27hijU1NE6iVpyIt+SnnhqN8AtmwZJMdH+njfuC/avd72J1C1JJMfXj4njy2ea+SM8xMmcZDlFnlLxEE5xTwlqfZgA18G3q9bv/XzzrnTGILqAz6ALoWj73+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760793927; c=relaxed/simple;
	bh=X20uqGQ+9w8CUgGhuFcarxGeDeD+ZLsy6V3LD8JqBA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTaJDPmUejviLpsrMPtxm9/L1FdfmzCeZUrcQkDbw/91ido5Kevc8nH9Xl95c3ey9iyl/xmTX+2XLkAU/9/7wfeRQ/jvF5IH+F/2QW7ZS2Mt28Y7N4MHfFz+XZhhVXsy1y7nughJFGJ8yIiGOpN0axWnsTMMoNMtjLJVR15tsDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3FB5260329; Sat, 18 Oct 2025 15:25:12 +0200 (CEST)
Date: Sat, 18 Oct 2025 15:25:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 2/7] doc: fix/improve documentation of verdicts
Message-ID: <aPOVNvw1t8lZT88o@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-3-mail@christoph.anton.mitterer.name>
 <aO-IqRLJoEJ1RYTv@strlen.de>
 <11427578d25220212d40533ed4a77652acefcc26.camel@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11427578d25220212d40533ed4a77652acefcc26.camel@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> On Wed, 2025-10-15 at 13:42 +0200, Florian Westphal wrote:
> > Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> > > +*accept*:: Terminate the evaluation of the current base chain (and
> > > any regular
> > > +chains called from it) and accept the packet from their point of
> > > view.
> > 
> > Suggest:
> > *accept*:: Terminate the evaluation of the chain.  Evaluation
> > continues in the next base chain, if any.
> 
> What I like about it, is that it avoids the slightly awkward "current
> base chain (and any regular chains called from it)" construct...
> 
> What I'm neutral about: Strictly speaking, it does not mention whether
> evaluation of any "parent" chains is also terminated.
> You try to solve that by saying "Evaluation continues in the next base
> chain"... and it is indeed kinda reasonable that all from the current
> base chain are then stopped... but a weird system could in principle
> continue with the next base chain, and eventually go back to the
> previous.

But this should describe netfilter and not something else :-)

> (Just like originally I completely misunderstood how return works when
> goto was involved).
> 
> What I like less about it, is that is misses this additional context of
> "acceptance is only with respect to those chains".

Hm, I think "Terminates the evaluation of the chain" is pretty clear.
And "Evaluation continues in ..." is also clear, packet is allowed to
move on in the processing pipeline.

> Yes it can be deduced from the following sentence ("The packet may
> however still be dropped by either")... and meanwhile, where I
> (hopefully ;-) ) understand how it works, that seems enough, but for a
> pure beginner it's IMO better to give such context and rather reinforce
> things twice in different words.

> What would you think about:
> 1st:
>    Either:
> Terminate the evaluation of the current chain as well as any chains
> from which that was called and accept the packet with respect to the
> base chain of these.
> or:
> Terminate the evaluation of the current chain as well as any chains in
> the call stack and accept the packet with respect to the base chain of
> these.

It correct but it sounds overly complicated IMO.

> 2nd and also replacing:
> > The packet may however still be dropped by either another chain with a higher
> > priority of the same hook or any chain of a later hook.

I would be fine with that, even though I also consider it too verbose.

> Evaluation continues in the next base chain (of higher or possibly
> equal priority from the same hook or of any priority from a later
> hook), if any.


Hmm, I am not sure.  Is it really needed to mention all of this?
Packet will just move on in the pipeline, it would be weird to assume
that forward-accepted packet would e.g. bypass postrouting.

> This means the packet can still be dropped in that next base chain as
> well as any regular chain (directly or indirectly) called from it.

... or that it moes to the next base chain but that base chain ignores
jumps to user-defined chains.

Your suggestions aren't wrong of course but it seems very repetitive to
me.

> > > +*drop*:: Terminate ruleset evaluation and drop the packet. This
> > > occurs
> > > +instantly, no further chains of any hooks are evaluated and it is
> > > thus not
> > > +possible to again accept the packet in a higher priority or later
> > > chain, as
> > > +those are not evaluated anymore for the packet.
> > 
> > Can this be compacted a bit?  I feel this is a tad too verbose.
> > 
> > *drop*: Packet is dropped immediately.  No futher evaluation of any
> > kind.
> > 
> > I think thats enough, no?
> 
> Uhm... I made it a perhaps bit extra verbose, mostly because we have
> terms like "terminal statement/verdict", where not all of them are
> really ultimately terminal.
> 
> What about the following compromise: O;-)
> 
> *drop*: Immediately drop the packet and terminate ruleset evaluation.
> This means no further evaluation of any chains and it's thus - unlike
> with  *accept* - not possible to again change the ultimate fate of the
> packet in any later chain.

Thats fine.

> What I'd at least think would be nice to have is to re-iterate on that
> conceptual difference between accept (may be overruled) and drop (is
> ultimate).

Yes, I understand that some people see it that way.

I see netfilter as a pipeline, where packet moves along a certain path,
e.g. prerouting, forward, postrouting or prerouting -> input.

accept is just a "move along", whereas drop stops the packet dead in its
tracks.

nftables is just a "user visible" part that allows to customize
the move-along-or-not decisions.

Hence, this "overrule old decision" idea doesn't apply.

But I can see that others may have a different concept of how
this all works under the hood.

But I have no idea how to best describe this let alone make it
clear that you can't back out of a "drop" decision.

> > > +All the above applies analogously to statements that imply a
> > > verdict:
> > > +*redirect*, *dnat*, *snat* and *masquerade* internally issue
> > > eventually an
> > > +*accept* verdict.
> > 
> > You can remove 'eventually'.
> 
> > > +*reject* and *synproxy* internally issue eventually a *drop*
> > > verdict.
> > 
> > Same.
> 
> The idea of that was a slight indication that these statements do:
> <other things> + accept|drop.
> 
> Admittedly eventually isn't really perfect …

OK, never mind. I have no strong opinion here.

> 
> > > +For example, a *reject* also immediately terminates the evaluation
> > > of the
> > > +current rule, overrules any *accept* from any other chains
> > 
> > No, not really.  There is no *overrule*.  We don't keep any 'verdict
> > state'.  There is no difference between 'drop' in the first rule of
> > the
> > first ever base chain or a drop somewhere later in the pipeline,
> > aside
> > from side effects from other matching expressions.
> 
> Well first, whether you keep an internal verdict state or not... isn't
> that again some implementation detail which here not really matters for
> the user's understanding of how evaluation works?

I hope my comments above wrt. netfilter pipeline make sense and answer
this question.

> > I would suggest:
> > For example, *reject* is like *drop*, but will attempt to send a
> > error
> > reply packet back to the sender before doing so.
> 
> I mean I'm open to change, but what I think should in one form or
> another go in, is explicitly reinforcing that reject has the same
> "power" like drop, i.e. it can render any further accepts (of other
> base chains) moot.

Hmm, I feel there is a need to document the netfilter pipeline better.

Perhaps we should add a netfilter man page document and
ship that too to explain this "move on" thing that accept does behind
the scenes?

> That's what I mean with respect to "overruling" (i.e. and previous
> accept).

Yes, I understand that.

> You're proposal rather describes the side effects of *reject* which are
> however IMO not really relevant with respect to overall ruleset
> evaluation.

Yes, its not relevant, in eval terms reject and drop are the same.

> > > +overruled, while the various NAT statements may be overruled by
> > > other *drop*
> > > +verdicts respectively statements that imply this.
> > 
> > There is no overrule.  I would not mention NAT at all here.
> > *accept* documentation already says that later chains in the pipeline
> > can drop the packet (and so could the traffic scheduler, qdisc, NIC,
> > network ...)
> 
> Like above... the idea here was again to reinforce that the statements
> which internally issue an accept, have the same "weakness" as accept
> itself, i.e. they're not ultimate and any later drop/reject/similar may
> "overrule" them.

I wonder where the idea that "accept" is a kind of magic teleporter that
just fast-forwards a packet to the socket or NIC came from...

This isn't the case even in old ipchains.

> Any other ideas how include these two points? At least I personally
> rather think that the actual side effect of "but will attempt to send a
> error reply packet back to the sender" is rather not that interesting
> with respect to the overall semantics of evaluation.

Correct, it should be in the REJECT STATEMENT section only.

> I think it makes no sense to spam the list with a v3 until I've got
> your opinions on all the above points.... so I'm waiting for that and
> the make a v3. :-)

I suggest to send a smaller v3 first, with the less "controversial"
stuff.  Patch 3 seems ready to go for instance.

Then, once thats in, revisit this patch in a (rebased and smaller) v4.

There is nothing wrong with getting this merged in smaller batches
over a longer period.
