Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95722676F8
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737827; cv=none; b=kEVnekx8MPJbgqT4OoQ5eJneFyl5JwQL2Q8XY331y/XSxqj52pHPbniOVMaT+UTwqMQQIz61UBvV+RtuQ885dI1ck5gFMx0ohLikFrWb+7qV+O4gJDY2Cgp3EKPT58EoilFSUEFtp1qt9KlDS81JjxPReH3weBSVIKESfE0qG9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737827; c=relaxed/simple;
	bh=WWLmYcAHE1AUmUi/EccgtAtEWMXkSl+icgR+nrUKkv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsaCT0ROBYpF4zWUzgLpjO/J7yZTmIXcVzA/IOIMm7ft3b6N0S2rGSttFnuLMwu98ZWNAgu8DGjZi6Yfm2W/467I38gqBQbcvw8mBK9enDHefs0HFksF+pNv9ZzQns9fMgdhBxtyElei4vqV5sFRmtr+LSVgwpbLjnlPEUfjwE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DB1A66005E; Tue, 20 May 2025 12:43:43 +0200 (CEST)
Date: Tue, 20 May 2025 12:42:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 0/6] revisiting nf_tables ruleset validation
Message-ID: <aCxcqjjNeuQKxErP@strlen.de>
References: <20250514214216.828862-1-pablo@netfilter.org>
 <aCWDoXLJCYIy14oF@strlen.de>
 <aCtJ6TVRSpLTGMX2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCtJ6TVRSpLTGMX2@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 15, 2025 at 08:03:13AM +0200, Florian Westphal wrote:
> > >   netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path
> > 
> > Do this via nf.git?
> 
> nf-next.git should be fine, this late in the development cycle.

Right, agreed.

> > >   netfilter: nf_tables: honor validation state in preparation phase
> > >   netfilter: nf_tables: add infrastructure for chain validation on updates
> > >   netfilter: nf_tables: add new binding infrastructure
> > >   netfilter: nf_tables: use new binding infrastructure
> > >   netfilter: nf_tables: add support for validating incremental ruleset updates
> > > 
> > >  include/net/netfilter/nf_tables.h |  52 +-
> > >  net/netfilter/nf_tables_api.c     | 800 ++++++++++++++++++++++++++++--
> > >  net/netfilter/nft_immediate.c     |  25 +-
> > >  3 files changed, 844 insertions(+), 33 deletions(-)
> > 
> > This is a lot of new code but no explanation as to why is given.
> 
> These are the results of a test program I made, which is incrementally
> adding elements to an already populated verdict map with 100k elements.
> 
> The ruleset validation shows in the perf callgraph, for each new
> element that is added:
> 
>     55.06%  nft-buffer       [kernel.kallsyms]           [k] nft_chain_validate
>      7.68%  nft-buffer       [kernel.kallsyms]           [k] nf_tables_commit
>      7.19%  nft-buffer       [kernel.kallsyms]           [k] nft_table_validate
>      5.34%  nft-buffer       [kernel.kallsyms]           [k] nft_rhash_walk
>      2.82%  swapper          [kernel.kallsyms]           [k] mwait_idle_with_hints.constprop.0
>      1.26%  nft-buffer       [kernel.kallsyms]           [k] __rhashtable_walk_find_next
>      1.09%  nft-buffer       [kernel.kallsyms]           [k] nft_setelem_validate
>      0.94%  nft-buffer       [kernel.kallsyms]           [k] rhashtable_walk_next
>      0.54%  nft-buffer       libnftables.so.1.1.0        [.] nft_parse
> 
> This is a test adding 100 new elements including jump to chain in a
> existing 100k verdict map.
> 
> With this approach, there is no need to fully validate the chain
> graph.
> 
> > Does this fix bugs with the existing scheme?
> 
> The two initial patches are targetted at fixing minor issues. The
> remaining patches are new code, they are passing tests/shell with
> CONFIG_KASAN and CONFIG_KMEMLEAK. I will post v2 but I would like to
> run more fuzz test on the error path.
> 
> > Or is this an optimization? If so, how big is the speedup?
> 
> Optimization. After this series, validation does not show up near the
> top 10; this is the first symbol in the perf call graph:
> 
>      0.03%  nft-buffer       [nf_tables]               [k] __nft_chain_validate
> 
> and it is far from the top 10.
> 
> I can include this information in v2 so they can sit in the mailing
> list for a while, there is a few bugs in v1 that I have addressed.
> Phil has spotted one in them.
> 
> Moreover, I can move the bindings hashtable to make it per-net to
> control the maximum number of jump/goto per family. This is a lot
> larger than Shaun's update, you have to tell me your preference on
> this.

I think Shauns approach is better due to backporting reasons.

Once the new code is stable enough you can move the jump limitation
check there.

Makes sense?

> Old binding code can possibly go away, but that requires closer look
> too.

Yes, lets keep it for now until there is confidence that the split
approach catches all issues.

I suggest to do this by adding a WARN_ON_ONCE() in the old path once
you think the new code should have prevented cycles in 100% of cases,
then remove it after e.g. 6-12 months or so.
