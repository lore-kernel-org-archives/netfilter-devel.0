Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834AB1E511
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760987267; cv=none; b=fu2qZsvlp/s2mKwNU5vsydhRIUklbOd6nfTzaxyZrQApIofNsZBuyKXGMVWZT5HnImW1ImmbRVGtaY45NKyw3gxAWT0SChwY4mzMgl7LhaXtowXtVRm5y4/dY2HGXUj/tbSvfnMA/Le8O62IHnL3UfqfptK5V0jRwVbafVUVCmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760987267; c=relaxed/simple;
	bh=HSDPdxPnQ5yR1jyc9rrgaEdvqWyKptsd8J9IIEXmMEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npSuDA1+7UjTbKjB2XdpzU9zwRPgrWN5ae1qC2GqvLg/HudiNBpiRzESzgWec7L1rnErLy3CsefS3Ocor61KBuxVxxG0uVTjvsY0WvKrRfLlAlq6BXtTzKK+nPfgoiGO6yZvZfLzWhxzxPY9V/PVpZKL36NiEnHwMdz1+o8nCGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fI28wXF4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fI28wXF4"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 88E7060299;
	Mon, 20 Oct 2025 21:07:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760987261;
	bh=NDUer6OoN2rXit6U+JpBhAAd75T2yAYXxtliqocqfsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fI28wXF4bv1L07g0MmDzh8kSHUm50/OdnF8vbgwB6Xp3/UVV6SglfFS7TYWvnPF/u
	 9FobkgECOzwMsnhkFhupID5+V9erVZBmx8RN/QSEz4JPJ3CG6v4SiEqxp9uvrDw5ou
	 bX9b6jUsJ8YV7wyCJCbnMOWnZA9b1m+U5jNELW0BEAbLnVg5/nPapIQDW7h/wO+IbZ
	 O/2XLrkJncdY3CrGkYcscC4lymH1EffdIVJtP4KPA9Xm7MrOTSdPeaTgTUYfEA4AWM
	 BUlkocMgDCUNJWjdGvu2po2ZSKVzKPhkyChgdn90NP/mMtBUUPnvNyQxYJ5xn6MQwL
	 hZ6a/E7GfwGGA==
Date: Mon, 20 Oct 2025 21:07:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPaIepWRL2u1HsLb@calendula>
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
 <aPTzD7qoSIQ5AXB-@strlen.de>
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
 <aPZGOudKuDa5HMmS@strlen.de>
 <a641ebd1-c2de-478d-bbba-68eaed580fd9@suse.de>
 <aPaA8itLIaGqDoyM@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aPaA8itLIaGqDoyM@calendula>

On Mon, Oct 20, 2025 at 08:35:34PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 20, 2025 at 05:23:47PM +0200, Fernando Fernandez Mancera wrote:
> > 
> > 
> > On 10/20/25 4:24 PM, Florian Westphal wrote:
> > > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > > > On 10/19/25 4:17 PM, Florian Westphal wrote:
> > > > > > In addition I noticed that when a kernel splat happens the ruleset that
> > > > > > triggered it isn't saved anywhere, it would be nice to save them so we have
> > > > > > a reproducer right away.
> > > > > 
> > > > > I had such code but removed it for this version.
> > > > > 
> > > > > I can send a followup patch to re-add it but I think that it is better
> > > > > for kernel fuzzing to extend knft acordingly, as nft is restricted by
> > > > > the input grammar wrt. the nonsense that it can create.
> > > > > 
> > > > 
> > > > That is fine for me, I still have pending to try knft which I might do
> > > > this week if I have time. If we do not want to save which ruleset
> > > > generated the kernel splat I would drop netlink-rw mode completely..
> > > 
> > > Hmmm.... I'm not sure on this.  It would be a bit of a silly limitation.
> > > Its not like -rw adds a huge chunk of code.
> > > 
> > > The store code wasn't too bad, back then I added some scripting for
> > > allow to e.g. call nft flush ruleset periodically and that was more code
> > > than strictly needed for pure nft (-ro mode) fuzzing.
> > > 
> > > > Yes, it seems we found the same issue. I do not have a solution on the
> > > > control plane although I was about to send this patch for data plane.
> > > > 
> > > > diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> > > > index 6557a4018c09..ddc4943d082c 100644
> > > > --- a/net/netfilter/nf_tables_core.c
> > > > +++ b/net/netfilter/nf_tables_core.c
> > > > @@ -251,10 +251,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
> > > >    {
> > > >           const struct nft_chain *chain = priv, *basechain = chain;
> > > >           const struct net *net = nft_net(pkt);
> > > > +       unsigned int stackptr = 0, jumps = 0;
> > > >           const struct nft_expr *expr, *last;
> > > >           const struct nft_rule_dp *rule;
> > > >           struct nft_regs regs;
> > > > -       unsigned int stackptr = 0;
> > > >           struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
> > > >           bool genbit = READ_ONCE(net->nft.gencursor);
> > > >           struct nft_rule_blob *blob;
> > > > @@ -314,6 +314,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
> > > > 
> > > >           switch (regs.verdict.code) {
> > > >           case NFT_JUMP:
> > > > +               jumps++;
> > > > +               if (WARN_ON_ONCE(jumps > 256))
> > > > +                       return NF_DROP;
> > > >                   if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
> > > >                           return NF_DROP;
> > > >                   jumpstack[stackptr].rule = nft_rule_next(rule);
> > > > 
> > > > Currently with enough jumps chained together and traffic generated, CPU
> > > > can get stuck on nft_do_chain() triggering a kernel splat. If there is a
> > > > solution on data plane it would be much better than this of course.
> > > 
> > > There is this patch:
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250728040315.1014454-1-brady.1345@gmail.com/
> > > 
> > > I planned to push it upstream in this merge window.
> > 
> > This looks quite good. I tested it and seems to solve the problem, great!
> 
> This patch emits a WARN_ON_ONCE.
> 
> Can this be controlled from control plane instead?

Oh well, you refer to the patch that checks this from control plane.

I remember an issue with abort path, has this been addressed?
