Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D0324B3F
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760970303; cv=none; b=TwGPtr7TMtaeFLn8iKdg4gn2URBU5a5Q5by2brketim/4vXGIexcYit7Tno6KkznEHesiH9HKh2OLUrEWESLkNYHxx/oaZ9nGR4c0kvbkoSg02jH3BOLkZ5FJcKP09hrAj60qZ9+mLfQ3O8ZLScOe+Li6aqL/xPPVGvaEHKTiJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760970303; c=relaxed/simple;
	bh=XCgbTjraLw7FnbL8oEA7qVEq22UZ/uJayFT3G+6lyQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzevLM3FSTvOQG1NRf4gx/M2ecDhpAR12mfgQcEbOlxW0I1wY1npxBAgpIm/U7IMIK9RaCarcqhEupglV27rgU3DfjSfq2ISpYpqrNquidf/+/AHu2oam/jHBLGCWh/mcpGKvwXCPJrqNTxN5qHelfhwHp4naVQOUi68x/xWSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 03E24618FC; Mon, 20 Oct 2025 16:24:58 +0200 (CEST)
Date: Mon, 20 Oct 2025 16:24:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPZGOudKuDa5HMmS@strlen.de>
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
 <aPTzD7qoSIQ5AXB-@strlen.de>
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/19/25 4:17 PM, Florian Westphal wrote:
> >> In addition I noticed that when a kernel splat happens the ruleset that
> >> triggered it isn't saved anywhere, it would be nice to save them so we have
> >> a reproducer right away.
> > 
> > I had such code but removed it for this version.
> > 
> > I can send a followup patch to re-add it but I think that it is better
> > for kernel fuzzing to extend knft acordingly, as nft is restricted by
> > the input grammar wrt. the nonsense that it can create.
> > 
> 
> That is fine for me, I still have pending to try knft which I might do 
> this week if I have time. If we do not want to save which ruleset 
> generated the kernel splat I would drop netlink-rw mode completely..

Hmmm.... I'm not sure on this.  It would be a bit of a silly limitation.
Its not like -rw adds a huge chunk of code.

The store code wasn't too bad, back then I added some scripting for
allow to e.g. call nft flush ruleset periodically and that was more code
than strictly needed for pure nft (-ro mode) fuzzing.

> Yes, it seems we found the same issue. I do not have a solution on the 
> control plane although I was about to send this patch for data plane.
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 6557a4018c09..ddc4943d082c 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -251,10 +251,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
>   {
>          const struct nft_chain *chain = priv, *basechain = chain;
>          const struct net *net = nft_net(pkt);
> +       unsigned int stackptr = 0, jumps = 0;
>          const struct nft_expr *expr, *last;
>          const struct nft_rule_dp *rule;
>          struct nft_regs regs;
> -       unsigned int stackptr = 0;
>          struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
>          bool genbit = READ_ONCE(net->nft.gencursor);
>          struct nft_rule_blob *blob;
> @@ -314,6 +314,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
> 
>          switch (regs.verdict.code) {
>          case NFT_JUMP:
> +               jumps++;
> +               if (WARN_ON_ONCE(jumps > 256))
> +                       return NF_DROP;
>                  if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
>                          return NF_DROP;
>                  jumpstack[stackptr].rule = nft_rule_next(rule);
> 
> Currently with enough jumps chained together and traffic generated, CPU 
> can get stuck on nft_do_chain() triggering a kernel splat. If there is a 
> solution on data plane it would be much better than this of course.

There is this patch:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250728040315.1014454-1-brady.1345@gmail.com/

I planned to push it upstream in this merge window.
