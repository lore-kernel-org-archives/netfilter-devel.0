Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A8267B89
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747740592; cv=none; b=peHbwj3hEUfmaVvA5VQlpEMP6L+3+D9cx0Vf2GKFUFZQlp00vozv6loO2zsfMhf7W+qWxsC9i7cUWcPX4oRXtAuUsosJ/xari+kPQkI9prLtaZhkdGDOGYcSD53CcUCEd3S5CCcCYDtSPXEHx4F4GeRxhZLAlj7VC8upf+yVMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747740592; c=relaxed/simple;
	bh=KkJVNANM0stcBox7o+pMgAxGLqXaMp6husgg+Qjn4/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZVld4K4CtvyezQCu5d0F9fVtEy5DTo8DHF7tSWKdd3d9vImbH6JpvlRqOJtOPg3fMDsr8eF7TbOPOHsbfj7mRvenJ14to/+Gja+PtPbD+shfgXWtNor8nal7HuU4iWea2bX/ruPRA/IAd5hDJnKrdKb0NDS3fwiE9DSn92z8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tb8ieyGE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WEa2QRrc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tb8ieyGE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WEa2QRrc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7870A60708; Tue, 20 May 2025 13:29:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747740587;
	bh=1745alfMo3lcg65rIYOFpv72b+moJ+0HNBTCaXTK5oQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tb8ieyGEsezO5iQaF4y+gI9nlJo9RljZfLRvsbg9AveBTyMhrPd9SFVGf5xPASb5J
	 UyrhFcl/HFWMdA9C7eq+DLXSk5GQcRxs5Ps8v0kI8jhkdpsTTQdLnJSprnKXnLNwJA
	 BCmB9H+b7KNbcKH2aE/nrTmlmNkg9Hj9iftb+ork4sn5amu3IjEcAOsa0Gttpk2fBd
	 aq6E0d+tmhmr6MD57YnrCzCgolO0jyEwe+LWucUkBFAqjmtAwHtPXJaCO9uo8ORTw9
	 EYtN9ggbEbNS7Mbxb+xvlyMW7ipwfheSrcC52c4oJDupeBAQ/3ykPEltnfC3zZm6Fv
	 +jF855tTocCmA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 78F93606F1;
	Tue, 20 May 2025 13:29:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747740586;
	bh=1745alfMo3lcg65rIYOFpv72b+moJ+0HNBTCaXTK5oQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WEa2QRrc/pukgF1EV5399ja/SStPmvAPDoM2Theb9QSjDYNJ1BQXtMf8VxR3z89OU
	 BDUHXxV+EGCgpLSlftDrwuDr45PWLNkXgmv918MqEHd6pniP+PjArNVRAk/XGmRV5i
	 T1pw2iphEq2c5SOOYpR+jKoW1hcY0uAmJy6BsBBLMuAiEmvNQ6tUB+EMQF2s+ESM2Z
	 sCg9kRx5CjhtYz32kx/5XWFXg4w+hkM9JIo6PfVfC4fz04k7CfLXo6lPiAtnCOYK/B
	 AZUZ6S2nyXMqtUZxbK5H+iDs2piRrmSeib7L20Tr/UrT5NbRBSgjnRmNai7EoJOsEd
	 4DzjsA+jn56OA==
Date: Tue, 20 May 2025 13:29:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 0/6] revisiting nf_tables ruleset validation
Message-ID: <aCxnpzCo0c_W0OpB@calendula>
References: <20250514214216.828862-1-pablo@netfilter.org>
 <aCWDoXLJCYIy14oF@strlen.de>
 <aCtJ6TVRSpLTGMX2@calendula>
 <aCxcqjjNeuQKxErP@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aCxcqjjNeuQKxErP@strlen.de>

On Tue, May 20, 2025 at 12:42:50PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, May 15, 2025 at 08:03:13AM +0200, Florian Westphal wrote:
[...]
> > > >   netfilter: nf_tables: honor validation state in preparation phase
> > > >   netfilter: nf_tables: add infrastructure for chain validation on updates
> > > >   netfilter: nf_tables: add new binding infrastructure
> > > >   netfilter: nf_tables: use new binding infrastructure
> > > >   netfilter: nf_tables: add support for validating incremental ruleset updates
> > > > 
> > > >  include/net/netfilter/nf_tables.h |  52 +-
> > > >  net/netfilter/nf_tables_api.c     | 800 ++++++++++++++++++++++++++++--
> > > >  net/netfilter/nft_immediate.c     |  25 +-
> > > >  3 files changed, 844 insertions(+), 33 deletions(-)
> > > 
> > > This is a lot of new code but no explanation as to why is given.
> > 
> > These are the results of a test program I made, which is incrementally
> > adding elements to an already populated verdict map with 100k elements.
> > 
> > The ruleset validation shows in the perf callgraph, for each new
> > element that is added:
> > 
> >     55.06%  nft-buffer       [kernel.kallsyms]           [k] nft_chain_validate
> >      7.68%  nft-buffer       [kernel.kallsyms]           [k] nf_tables_commit
> >      7.19%  nft-buffer       [kernel.kallsyms]           [k] nft_table_validate
> >      5.34%  nft-buffer       [kernel.kallsyms]           [k] nft_rhash_walk
> >      2.82%  swapper          [kernel.kallsyms]           [k] mwait_idle_with_hints.constprop.0
> >      1.26%  nft-buffer       [kernel.kallsyms]           [k] __rhashtable_walk_find_next
> >      1.09%  nft-buffer       [kernel.kallsyms]           [k] nft_setelem_validate
> >      0.94%  nft-buffer       [kernel.kallsyms]           [k] rhashtable_walk_next
> >      0.54%  nft-buffer       libnftables.so.1.1.0        [.] nft_parse
> > 
> > This is a test adding 100 new elements including jump to chain in a
> > existing 100k verdict map.
> > 
> > With this approach, there is no need to fully validate the chain
> > graph.
> > 
> > > Does this fix bugs with the existing scheme?
> > 
> > The two initial patches are targetted at fixing minor issues. The
> > remaining patches are new code, they are passing tests/shell with
> > CONFIG_KASAN and CONFIG_KMEMLEAK. I will post v2 but I would like to
> > run more fuzz test on the error path.
> > 
> > > Or is this an optimization? If so, how big is the speedup?
> > 
> > Optimization. After this series, validation does not show up near the
> > top 10; this is the first symbol in the perf call graph:
> > 
> >      0.03%  nft-buffer       [nf_tables]               [k] __nft_chain_validate
> > 
> > and it is far from the top 10.
> > 
> > I can include this information in v2 so they can sit in the mailing
> > list for a while, there is a few bugs in v1 that I have addressed.
> > Phil has spotted one in them.
> > 
> > Moreover, I can move the bindings hashtable to make it per-net to
> > control the maximum number of jump/goto per family. This is a lot
> > larger than Shaun's update, you have to tell me your preference on
> > this.
> 
> I think Shauns approach is better due to backporting reasons.

Yes, it is small.

I could not find a way to extend the existing loop and validation
routines to make it incremental.

> Once the new code is stable enough you can move the jump limitation
> check there.
> 
> Makes sense?

OK.

> > Old binding code can possibly go away, but that requires closer look
> > too.
> 
> Yes, lets keep it for now until there is confidence that the split
> approach catches all issues.
> 
> I suggest to do this by adding a WARN_ON_ONCE() in the old path once
> you think the new code should have prevented cycles in 100% of cases,
> then remove it after e.g. 6-12 months or so.

This is how it works in v2:

On new table, the classic full ruleset validation from basechain is
done.

On existing tables, from the chain that has been updated (either new
rule or new jump/goto to reach it), the incremental routine backtracks
to find the basechain. If chain callstack is too deep, then it falls
back to the classic full ruleset validation from basechains. If it
detects a loop when backtracking, it also falls back to classic full
ruleset validation (it could be a loop in chains that are not
connected to basechain, this is currently allowed). Then, from the
chain that has been updated, call the existing nft_validate_chain()
using the collected basechains that can reach such updated chain. The
nft_validate_chain() function already relies on too deep callstack to
detect loops.

So the backtracking is used to find and collect the basechains that
can reach this chain.

Loop and checking if expression is accepted from this chain (eg.
masquerade from filter chain type) is done in one single pass.

Incremental is a fast path, but in case backtracking cannot collect
basechains, then it fallbacks to classic ruleset validation.

I will look into the WARN_ON_ONCE() you suggest.
