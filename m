Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769CA19343B
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 11:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759233041; cv=none; b=YFp12yK1B3HyrszM/KxQsrAFE96B0dn643l43hbMyNI3ekOBIiwmpiF3MhO2sayPkBN8P6148SoaurcCEtiBEaKNoUedwBLpqmdpVMYlZdBiI0Wei+nMalAaaB4GnQR2bZm5ZW/7dPOyghM8N3lm0ZWOO5eAzjX8thiPF6Q3owI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759233041; c=relaxed/simple;
	bh=7sYtVaf2v7C3dRQ+nrka5wKSlGgUiS7hP6Ug8ojXAlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+msyHg51SauO2dO3E8syJGrqKKO7QfDDWUcTzTQJOHBFZ/AXjQb7JehWKmjJNSIlDvP0eQGjL/bXwu4UQJ8obCLOMJCvCDiQH7Y7nFjHrbBiHF9e4NQswNKvwImlz7STodWXrim6dg9gNkzGKG5BYhAjb6s8B3VUK5I5v4+pl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1AD7F602F8; Tue, 30 Sep 2025 13:50:36 +0200 (CEST)
Date: Tue, 30 Sep 2025 13:50:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7] doc: add overall description of the ruleset
 evaluation
Message-ID: <aNvECxpxlsYS7Noy@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
 <20250926021136.757769-5-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250926021136.757769-5-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> +OVERALL EVALUATION OF THE RULESET
> +---------------------------------
> +This is a summary of how the ruleset is evaluated.
> +
> +* Even if a packet is accepted by the ruleset (and thus by netfilter), it may
> +  still get discarded by other means, for example Linux generally ignores
> +  various ICMP types and are sysctl options lik

Minor typo, 'like'.

> +  `net.ipv{4,6}.conf.*.forwarding` or `net.ipv4.conf.*.rp_filter`.
> +* With respect to the evaluation tables don’t matter at all and are not known by
> +  netfilter.
> +  They’re merely used to structure the ruleset.

'evaluation ordering'?  Tables do matter in the sense that you can't
have any chains without them.

> +* Packets traverse the network stack and at various hooks they’re evaluated by
> +  any base chains attached to these hooks.

Maybe add the hook names here?  (preouting, input, and so on).
Or a reference to this topic.

> +* For each hook, the attached chains are evaluated in order of their priorities
> +  (with chains with lower priority values being evaluated before those with
> +  higher values and the order of chains with the same value being undefined).

It took me a sec to parse this, maybe:

... higher values.  The order of chains with identical priorities is
undefined.

(or similar).

> +* An *accept* verdict (including an implict one via the base chain’s policy,
> +  even if caused in certain cases by a *return* verdict) ends the evaluation of
> +  the current base chain and any regular chains called from that.
> +  It accepts the packet only with respect to the current base chain, which does
> +  not mean that the packet is ultimately accepted.

Maybe: 'It accepts the packet only with respect to the current base
chain.'  The rest is already made clear by your next sentence:

> +  Any other base chain (or regular chain called by such) with a higher priority
> +  of the same hook as well as any other base chain (or regular chain called by
> +  such) of any later hook may still utlimately *deny*/*reject* the packet with
					~~~~~~~ ultimately, but i'd just
					remove this word.

please avoid 'deny' and use 'drop' everywhere.  In this case,
.. may still drop the packet.

... is enough.

> +  Thus and merely from netfilter’s point of view, a packet is only accepted if
> +  none of the chains (regardless of their tables) that are attached to any of
> +  the respectively relevant hooks issues a *deny*/*reject* verdict (be it
> +  explicitly or implicitly by policy) and if there’s at least on *accept*
> +  verdict (be it explicitly or implicitly by policy).

I'm not sure if the last part is needed as there is no such thing as a
base chain without a policy, so i would simplify this to:

Thus a packet is only accepted if no chain or rule issues a drop
verdict, including chain policies.

> +  In that, the ordering of the various base chains per hook via their priorities
> +  matters (with respect to the packets utlimate fate) only in so far, if any of
> +  then would modify the packet or its meta data and that has an influence on the
> +  verdicts – if not, the ordering shouldn’t matter (except for performance).

I'm not sure about this paragraph.  While its correct, base chains and
their priorities still have effects, e.g. if ip defragmentation has
taken place or not.  I think the previous paragraph is clear enough wrt.
packet acceptance.

> +* A *drop*/*reject* verdict (including an implict one via the base chain’s
> +  policy even if caused in certain cases by a *return* verdict) immediately ends
> +  the evaluation of the whole ruleset and ultimately drops/rejects the packet.
> +  Unlike with an *accept* verdict, no further chains of any hook and regardless
> +  of their table get evaluated and it’s therefore not possible to have an
> +  *drop*/*reject* verdict overturned.

As noted elsewhere, reject is just a more fancy drop, it should not be
mentioned here.

> +  Thus, if any base chain uses drop as it’s policy, the same base chain or any
> +  regular chain directly or indirectly called by it must accept a packet or it
> +  is ensured to be ultimately dropped by it.

Can that be reduced to something like:

Thus, base chains that use 'policy drop' must contain at least one accept rule or
must call another chain with an accept rule to avoid blocking all traffic.

> +* A *jump* verdict causes evaluation to continue at the first rule of the
> +  regular chain it calls. Called chains must be of the same table and cannot be
> +  base chains.

'must reside in same table'?

> +  If no other verdict is issued in the called chain and if all rules of that

.. chain... ?

> +  have been evaluated, evaluation will continue with the next rule after the
> +  calling rule of the calling chain.
> +  That is, reaching the end of the called chain causes a “jump back to the
> +  calling chain” respectively an implicit *return* verdict.

Yes, this is why there is sometimes a reference to the call stack / or
chain stack.

'jump' makes a 'where am I' note, 'goto' doesn't.

> +* A *goto* verdict causes evaluation to continue at the first rule of the
> +  regular chain it calls. Called chains must be of the same table and cannot be
> +  base chains.
> +  If no other verdict is issued in the called chain and if all rules of that
> +  have been evaluated, evaluation of the current base chain and the regular
> +  chains called by it end with an implicit verdict of the base chain’s policy.
> +  That is, unlike with *jump*, reaching the end of the called chain does not
> +  cause a “jump back to the calling chain”.

I think we should try to simplify this.

jump and goto are almost the same, the only difference is that goto
doesn't make a 'where am I' note, so the evaluation of the *called*
chain behaves as if those rules were part of the chain that contains the
'goto' statement.

> +* A *return* verdict’s processing depend upon in which chain it is issued.

Hmm.  Not so sure.  Its always the same:

End evaluation of this chain and go back to where you came from.

> +  In a regular chain that was called via *jump* it ends evaluation of that chain
> +  and return to the calling chain as described above.

Right.

> +  In a regular chain that was called via *goto* or in a base chain, the *return*
> +  verdict is equivalent to the base chain’s policy.

Yes, but thats because the called chain executes in the context of the
calling chain.  Since thats a base chain, the return statement causes
a chain-stack-underflow.  It has same effect as 'return' in ANY chain:

1. End evaluation of the chain.
2. Go back to where you cam from.

We have nowhere else to go back to.

So all of those are identical:
chain base {
	hook ...
	...
# no more rules, implicit return -> base chain policy
}

----

chain base {
	hook ...
	...
	return # variant of above with explicit return
}

----

chain user {
	return
}

chain base {
	hook ...
	goto user
}

----

All end up with 'no terminal statement seen and no more rules to check'.

> +* All verdicts described above (that is: *accept*, *drop*, *reject*, *jump*,
> +  *goto* and *return*) also end the evaluation of any later statements in their
> +  respective rules (or even cause an error when loadin such rules) with the
> +  exception of the `comment` statement.

Why mention the comment statement here?

Comment is special, its not a statement from the evaluation
perspective. It tells the kernel to allocate some extra space to
store the comment data, the interpreter doesn't know its there.

> +  That is, for example in `… counter accept` the `counter` statement is
> +  processed, but in `… accept counter` it is not.

I think this was already mentioned, also, nft should already be
informing the user that the rule has unreachable trailing statements.
