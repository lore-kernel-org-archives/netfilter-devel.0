Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85D81B6D06
	for <netfilter-devel@vger.kernel.org>; Mon, 19 May 2025 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667450; cv=none; b=fhfLH0Cy69R3zK4Gev0rzkgC80QTD8/XWgjcj2douww7RN/LUr16RnYcV3rik/UW9NNQS5K0EffmqVQ9+ua3LQet9jK/ofZC9aKAGxf+IeoO7wDj1/eTXkwWK3kVdxB4CqT7/DxVWG3eAEpXtkpCXPBEvDZgZ1OIVbsdQx1c/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667450; c=relaxed/simple;
	bh=V56mJE8Se09tTV2nsXqLiIu+LMm5FrjzRwMt6TTmmtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KectnjgHZM1QG3gOOZ08Eniy+kmDp6OFwINnyTDvgcmp0S52pitN6VeyN71IIIQZq84XypfIpJ20cho6/OEizgVibt0H7rfqbsDhsp46M7NSWktwln23BP3m+8OR/qpIKL3/5EZwfA9Ii29lSricrg7lby/aMOgdrTYHYbEWC+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uwsSQ0Bb; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uwsSQ0Bb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uwsSQ0Bb";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uwsSQ0Bb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E3F6460284; Mon, 19 May 2025 17:10:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747667436;
	bh=HvMtMuc+HSoVyDfhrMJvhXQtEZYWSZDwsoOwUPwkHsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwsSQ0BbFNnK+4Z+kYLw+7LxyGvT0wkoFZ40vMWAj3zYQ4yPJap+R9tgSm+ZjFjYb
	 IqmPDLbDXUdCfBAsUgJjusIvhuAKh4LCP7FlN/9rCa7hMWBV4n7Rr9CwsjD4kV2HW+
	 LaoglsxnlhUg5KvuZfqLZRNm5qs6Zeen7lznlm866hB1Xkn4fdJwKq5P4w5h7786NE
	 uPVufZ5Xb8Ue+GN2uQPetiu69yIBowMVE2Q2l0MNNr8aEG/ZbL2fZIAyNeD7O8KbS3
	 joInaiuAu8lBVQCnxcLkLan8JTblXXPaIhnAMPCTDViKG8DAkCNTnFLSxkIYl0ZBKn
	 iuzft+edH80UQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 283B36027E;
	Mon, 19 May 2025 17:10:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747667436;
	bh=HvMtMuc+HSoVyDfhrMJvhXQtEZYWSZDwsoOwUPwkHsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwsSQ0BbFNnK+4Z+kYLw+7LxyGvT0wkoFZ40vMWAj3zYQ4yPJap+R9tgSm+ZjFjYb
	 IqmPDLbDXUdCfBAsUgJjusIvhuAKh4LCP7FlN/9rCa7hMWBV4n7Rr9CwsjD4kV2HW+
	 LaoglsxnlhUg5KvuZfqLZRNm5qs6Zeen7lznlm866hB1Xkn4fdJwKq5P4w5h7786NE
	 uPVufZ5Xb8Ue+GN2uQPetiu69yIBowMVE2Q2l0MNNr8aEG/ZbL2fZIAyNeD7O8KbS3
	 joInaiuAu8lBVQCnxcLkLan8JTblXXPaIhnAMPCTDViKG8DAkCNTnFLSxkIYl0ZBKn
	 iuzft+edH80UQ==
Date: Mon, 19 May 2025 17:10:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 0/6] revisiting nf_tables ruleset validation
Message-ID: <aCtJ6TVRSpLTGMX2@calendula>
References: <20250514214216.828862-1-pablo@netfilter.org>
 <aCWDoXLJCYIy14oF@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aCWDoXLJCYIy14oF@strlen.de>

Hi Florian,

On Thu, May 15, 2025 at 08:03:13AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Pablo Neira Ayuso (6):
> >   netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path
> 
> Do this via nf.git?

nf-next.git should be fine, this late in the development cycle.

> >   netfilter: nf_tables: honor validation state in preparation phase
> >   netfilter: nf_tables: add infrastructure for chain validation on updates
> >   netfilter: nf_tables: add new binding infrastructure
> >   netfilter: nf_tables: use new binding infrastructure
> >   netfilter: nf_tables: add support for validating incremental ruleset updates
> > 
> >  include/net/netfilter/nf_tables.h |  52 +-
> >  net/netfilter/nf_tables_api.c     | 800 ++++++++++++++++++++++++++++--
> >  net/netfilter/nft_immediate.c     |  25 +-
> >  3 files changed, 844 insertions(+), 33 deletions(-)
> 
> This is a lot of new code but no explanation as to why is given.

These are the results of a test program I made, which is incrementally
adding elements to an already populated verdict map with 100k elements.

The ruleset validation shows in the perf callgraph, for each new
element that is added:

    55.06%  nft-buffer       [kernel.kallsyms]           [k] nft_chain_validate
     7.68%  nft-buffer       [kernel.kallsyms]           [k] nf_tables_commit
     7.19%  nft-buffer       [kernel.kallsyms]           [k] nft_table_validate
     5.34%  nft-buffer       [kernel.kallsyms]           [k] nft_rhash_walk
     2.82%  swapper          [kernel.kallsyms]           [k] mwait_idle_with_hints.constprop.0
     1.26%  nft-buffer       [kernel.kallsyms]           [k] __rhashtable_walk_find_next
     1.09%  nft-buffer       [kernel.kallsyms]           [k] nft_setelem_validate
     0.94%  nft-buffer       [kernel.kallsyms]           [k] rhashtable_walk_next
     0.54%  nft-buffer       libnftables.so.1.1.0        [.] nft_parse

This is a test adding 100 new elements including jump to chain in a
existing 100k verdict map.

With this approach, there is no need to fully validate the chain
graph.

> Does this fix bugs with the existing scheme?

The two initial patches are targetted at fixing minor issues. The
remaining patches are new code, they are passing tests/shell with
CONFIG_KASAN and CONFIG_KMEMLEAK. I will post v2 but I would like to
run more fuzz test on the error path.

> Or is this an optimization? If so, how big is the speedup?

Optimization. After this series, validation does not show up near the
top 10; this is the first symbol in the perf call graph:

     0.03%  nft-buffer       [nf_tables]               [k] __nft_chain_validate

and it is far from the top 10.

I can include this information in v2 so they can sit in the mailing
list for a while, there is a few bugs in v1 that I have addressed.
Phil has spotted one in them.

Moreover, I can move the bindings hashtable to make it per-net to
control the maximum number of jump/goto per family. This is a lot
larger than Shaun's update, you have to tell me your preference on
this.

Old binding code can possibly go away, but that requires closer look
too.

Let me know.

Thanks.
