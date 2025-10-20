Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393302F260E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760952510; cv=none; b=op1xCz4Kb2m54K9D8QW+vCtfUrdXlrpSNpAfXSTQlL6o0wkWoVEUI/YQUHEcIw+jMLqqE1K9bI2/1cyK69Q5nMxn2AeBSM+MP78HyO66Z2fxwsvUtSTCjxZ0c1+HqDI2/62DEZqNxxRGIJeNw8pbbGQZUFJCp6cJrgQraKZFdag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760952510; c=relaxed/simple;
	bh=ucWeiRfyw3/S8Iy1ZEnv0UtyBRMVKd+fp5rt7AIv2QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qr/W0MRZTupeI6OfLDKAOJl/ietM3s8qFnrErLEvovqo72P1T7MJqFi/LL7qANrDbkCem1GRSo18uAQAhPLo6ZPo6WNjWGqmCO/yur5NSh3ajb7lj2V84KrzgcpmCsgPRC3oLjFcG6XcHDYfbVJAOWiOwaT5mu5rMHFpzKYHJm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1106161A86; Mon, 20 Oct 2025 11:28:26 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:28:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v3 1/6] doc: fix/improve documentation of verdicts
Message-ID: <aPYAuQ89M7Z7doVJ@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
 <20251019014000.49891-1-mail@christoph.anton.mitterer.name>
 <20251019014000.49891-2-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251019014000.49891-2-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> +*drop*:: Immediately drop the packet and terminate ruleset evaluation.
> + This means no further evaluation of any chains and it’s thus – unlike with
> + *accept* – not possible to again change the ultimate fate of the packet in any
> + later chain.
> +
> +
> +Terminate ruleset evaluation and drop the packet. This occurs


Hmm, looks like something went wrong during a rebase?
Why are there 2 blank lines followed by a rephrase of the first
sentence?

> +For example, a *reject* also immediately terminates the evaluation of the
> +current rule as well as of all chains, overrules any *accept* from any other chains and can itself not be
> +overruled, while the various NAT statements may be overruled by other *drop*
> +verdict respectively statements that imply this.

I totally dislike this sorry :-(

There is no overruling, there is no 'verdict state tracking'.

Or would you say that a qdisc that dropped a packet overruled a nft accept
verdict...?

Sorry for spinning on this again and again.

Its important to me that users understand that packets traverse through netfilter hooks
one after another until a drop verdict is seen or there are no more hooks.

In a way, *accept* moves packet to the next basechain/hook, but thats
all there is to it.

All this talk about *overrule* makes it sound much more complicated than it is.
Can you re-send this patch standalone, without this pragraph?

Or perhaps just the 'For example, a *reject* also immediately *drops*
the packet'.

I did not spot anything else other than the format nit above.

