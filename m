Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E330352C3F;
	Mon, 19 Oct 2026 05:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792386032; cv=none; b=fvWQHOJsD6nlGxAyD2h/xvVhoYyu9Pupl9VJmsCzNON5kpCPAUHDq1GXD8KHy70bvNflDP1pTZ87VbGBzACykqXe4EnknHIrrO4/s1W1gt629La9vF8sjoQJ0U5BNyx1qEX1fy+EgVDePl3EddHlhmxKuEkArcXiKdfKjZBQnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792386032; c=relaxed/simple;
	bh=UCAofxHz9gM2uN+iPHtZRsYil1UV579TaxZvZLXFW3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XR4jtnXyCKH5Oa2U6eFTk8ZdO5duBAeVdKZgE0bp1xgcUScR/3eztVyoIM6Amcj6kvAH8vU7awB5HMU4bTBKIbpCAZjdTqak6xAEfaeKR9HzyEqS868R3N7TFE1UtEdGdT+NAh+xcmaYGiSfZTxCUufuELpbaGYGEwVaCyEnhLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8761460272; Mon, 19 Oct 2026 07:00:18 +0200 (CEST)
Date: Mon, 19 Oct 2026 07:00:18 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 07/15] netfilter: nf_tables: switch chain_types
 array to rcu
Message-ID: <atWj4u3dSPq9IcIR@strlen.de>
References: <20261018005638.1776148-8-pablo@netfilter.org>
 <179237288492.3135.4070411587398264435@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288492.3135.4070411587398264435@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> Low priority / nit picks for your consideration:
> 
> - [Low] Commit "netfilter: nf_tables: switch chain_types array to rcu"
>   fixes a module-memory use-after-free but has no Fixes: tag and no Cc:…
> 
> --
> 
> netfilter: nf_tables: switch chain_types array to rcu
> 
> This converts the global chain_type array in nf_tables_api.c to RCU and
> takes the module reference on the chain type owner inside the RCU read
> section. That closes a window where a transaction could dereference an
> nft_chain_type freed by a concurrent rmmod of nft_chain_nat, and
> nft_chain_nat_exit() now calls synchronize_rcu() after unregistering.
> 
> > Reported-by: Vega <vega@nebusec.ai>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [Severity: Low]
> Should this patch carry a Fixes: tag?

No need.  This is an LLM report, not a real bug ever encountered.

Would need busyloop doing rmmod on nft modules with nft transactions happening
in parallel, this is not a realistic enough scenario to entertain a
Fixes tag IMO.

> Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")

Looks correct, but I don't think this is worth placing in -stable.
Even if AI says the patch is fine and correct, we've had enough cases of
AI missing things (resp. humans missing bogosity in AI generated patches)
that we should make "AI is fine with it" the new "it compiles, ship it".

> Without it, stable trees that carry f102d66b335a may not pick up this fix.
> Other patches in the same series do have Fixes: tags, for example
> "netfilter: conntrack: fix unlikely UaF in gc worker" (also an LLM finding
> from the same reporter) and "netfilter: nft_compat: restrict raw table
> targets/matches".

Its a tradeoff.  This is fix is neither obviously simple, nor the bug
severe or frequent enough.  The raw table thing e.g. allows deliberate
kernel crash for unpriv netns, but this one needs full rmmod capability.
