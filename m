Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DAD2FFFB0
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2025 11:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760528558; cv=none; b=ZAbNgYQeO5oplFGCSZLfkYUluG5p8ESvZsUORVOnKdv20ZlBzdxujysQj4aIIqd7KmHQr8IlrTtIF/WDYbcrDXL6rOM3UUNX2pHYe2VXjpBfO3Bv/+FBjag41L70P3Do6gY5sDeuCy/AnSoPetCl4ZBY9XLyRv/JOCSLX2oPYR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760528558; c=relaxed/simple;
	bh=e9UQCxBK2eX9Z/iZOL8vD0TgwXUSvSAwsveM4NpojNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMzXR8ghbf4iTyHTAk6WR4Q/+nBbUqZVdVHHlvZNItCDeMRK+aQYfSswgz/SHsgJiAGJbBzj5e7uoM1OfQPOrQXCV0C/xwP1do6mGUWJ+yg+zH8iougUX6ww5fKHCP0yypQSvrcf7J4pd0qlNR4vyNAfi/DRtKr2Qos48Ewk9k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 870E360156; Wed, 15 Oct 2025 13:42:33 +0200 (CEST)
Date: Wed, 15 Oct 2025 13:42:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 2/7] doc: fix/improve documentation of verdicts
Message-ID: <aO-IqRLJoEJ1RYTv@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-3-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011002928.262644-3-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> +*accept*:: Terminate the evaluation of the current base chain (and any regular
> +chains called from it) and accept the packet from their point of view.

Suggest:
*accept*:: Terminate the evaluation of the chain.  Evaluation
continues in the next base chain, if any.

> +The packet may however still be dropped by either another chain with a higher
> +priority of the same hook or any chain of a later hook.

... This means the packet can still be dropped ...

> +For example, an *accept* in a chain of the *forward* hook still allows one to
> +*drop* (or *reject*, etc.) the packet in another *forward* hook base chain (and
> +any regular chains called from it) that has a higher priority number as well as
> +later in a chain of the *postrouting* hook.

Thanks, that example is good to have.

> +*drop*:: Terminate ruleset evaluation and drop the packet. This occurs
> +instantly, no further chains of any hooks are evaluated and it is thus not
> +possible to again accept the packet in a higher priority or later chain, as
> +those are not evaluated anymore for the packet.

Can this be compacted a bit?  I feel this is a tad too verbose.

*drop*: Packet is dropped immediately.  No futher evaluation of any kind.

I think thats enough, no?

> +*jump* 'CHAIN':: Store the current position in the call stack of chains and
> + continue evaluation at the first rule of 'CHAIN'.
> + When the end of 'CHAIN' is reached, an implicit *return* verdict is issued.
> + When an absolute verdict is issued (respectively implied by a verdict-like
> + statement) in 'CHAIN', evaluation terminates as described above.
> +*goto* 'CHAIN':: Equal to *jump* except that the current position is not stored
> + in the call stack of chains.
> +*return*:: End evaluation of the current chain, pop the most recently added
> + position from the call stack of chains and continue evaluation after that
> + position.
> + When there’s no position to pop (which is the case when the current chain is
> + either the base chain or a regular chain that was reached solely via *goto*
> + verdicts) end evaluation of the current base chain (and any regular chains
> + called from it) using the base chain’s policy as implicit verdict.
> +*continue*:: Continue ruleset evaluation with the next rule. This
> + is the default behaviour in case a rule issues no verdict.
>  *queue*:: Terminate ruleset evaluation and queue the packet to userspace.
>  Userspace must provide a drop or accept verdict.  In case of accept, processing
>  resumes with the next base chain hook, not the rule following the queue verdict.

> +All the above applies analogously to statements that imply a verdict:
> +*redirect*, *dnat*, *snat* and *masquerade* internally issue eventually an
> +*accept* verdict.

You can remove 'eventually'.

> +*reject* and *synproxy* internally issue eventually a *drop* verdict.

Same.

> +These statements thus behave like their implied verdicts, but with side effects.
>
> +For example, a *reject* also immediately terminates the evaluation of the
> +current rule, overrules any *accept* from any other chains

No, not really.  There is no *overrule*.  We don't keep any 'verdict
state'.  There is no difference between 'drop' in the first rule of the
first ever base chain or a drop somewhere later in the pipeline, aside
from side effects from other matching expressions.

I would suggest:
For example, *reject* is like *drop*, but will attempt to send a error
reply packet back to the sender before doing so.

> +overruled, while the various NAT statements may be overruled by other *drop*
> +verdicts respectively statements that imply this.

There is no overrule.  I would not mention NAT at all here.
*accept* documentation already says that later chains in the pipeline
can drop the packet (and so could the traffic scheduler, qdisc, NIC,
network ...)
