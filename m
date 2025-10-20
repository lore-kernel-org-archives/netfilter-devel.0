Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C42D9795
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760953181; cv=none; b=IZhdv0UzfNwVwvyDwSBKAfhZruVbORYfiOYIGJmOZJUBhtO3PHqMvRqz2cu4KEOyBik0psgv3H74T4bHfTHeRLg/eUfUbZp3NwVKnckBV8iRo7QlmYjdtrQy+uU8y6VvU3A5xo2u+nqtys9wS4+M5mMz8ap+WKNG+JASuXX63fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760953181; c=relaxed/simple;
	bh=YGPuNrE3r8RSw89XhUBaAgG5yaVr+sZ7uGh9F+daJhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABfUNWbL3IeA7tQiYWuEeOATwex6bO/QOdrNSTMOpKTEokaAUPBM7kzPV/c5Dg/qgprW0kRGyGjCVaZwNmX+1YkgmaqZnpQu9bwWy6CQcmbs+zDwVMMXRMb3J0txJbtWGHan2J4HdHUAhqwlquczqrNGRMsIt9JjVZbWeh/PRlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3A8FA61A86; Mon, 20 Oct 2025 11:39:33 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:39:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2 4/7] doc: add overall description of the ruleset
 evaluation
Message-ID: <aPYDVPyq5x_2264k@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
 <20251011002928.262644-5-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011002928.262644-5-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> +  It accepts the packet only with respect to the current base chain. Any other
> +  base chain (or regular chain called by such) with a higher priority of the
> +  same hook as well as any other base chain (or regular chain called by such) of
> +  any later hook may however still ultimately *drop* (which might also be done
> +  via verdict-like statements that imply *drop*, like *reject*) the packet with
> +  an according verdict (with consequences as described below for *drop*).

...

> +  Thus and merely from netfilter’s point of view, a packet is only ultimately
> +  accepted if none of the chains (regardless of their tables) that are attached
> +  to any of the respectively relevant hooks issues a *drop* verdict (be it
> +  explicitly or implicitly by policy or via a verdict-like statement that
> +  implies *drop*, for example *reject*), which already means that there has to
> +  be at least one *accept* verdict (be it explicitly or implicitly by policy).
> +  All this applies analogously to verdict-like statements that imply *accept*,
> +  for example the NAT statements.

... I think this is too confusing and verbose.
packet ultimately passed: no drop verdict was issued.  Its all there is
to it, really.

> +* A *drop* verdict (including an implict one via the base chain’s policy)
> +  immediately ends the evaluation of the whole ruleset and ultimately drops the
> +  packet.
> +  Unlike with an *accept* verdict, no further chains of any hook and regardless
> +  of their table get evaluated and it’s therefore not possible to have an *drop*
> +  verdict overruled.

This is fine.

> +  Thus, if any base chain uses drop as its policy, the same base chain (or any
> +  regular chain directly or indirectly called by it) must accept a packet or it
> +  is ensured to be ultimately dropped by it.
> +  All this applies analogously to verdict-like statements that imply *drop*,
> +  for example *reject*.

Same.

> +* Given the semantics of *accept*/*drop* and only with respect to the utlimate
> +  decision of whether a packet is accepted or dropped, the ordering of the
> +  various base chains per hook via their priorities matters only in so far, as
> +  any of them modifies the packet or its meta data and that has an influence on
> +  the verdicts issued by the chains – other than that, the ordering shouldn’t
> +  matter (except for performance and other side effects).
> +  It also means that short-circuiting the ultimate decision is only possible via
> +  *drop* verdicts (respectively verdict-like statements that imply *drop*, for
> +  example *reject*).

Maybe rework the *accept* part to say that the packet moves on to the
next hook?  (As opposed to *drop*, which is final).

I think almost all of the overrule talk comes from this distinction (or
lack thereof).

