Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F72D24A3
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755541435; cv=none; b=Vx37DLGGtrEpRoHBSkblyZ9pKFlvLvihE39WtlXLYhCfJXqc8kAy/04rm0b55ww3RAVgYL3tMxZnCel+oYcRnN3+O9/IyG5+ZliGhkYX6ljQ9EkzZJaJa0odfAuxS946c565ICvq/HeCx0EMZhaU1pG5+nlrXp6wlOhDyRKMDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755541435; c=relaxed/simple;
	bh=TOYbCdq4DhgShhilbtBFh1IveCAqulhKN3bFywWzVeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8n92iXAI4126zt2iDr5ggtWWzBGDXNV6gqZghSPh0DnZzDAhPib/iXquO68QhAQYBn1UDH1sb+lF/zZATxw9Caw8k7xHH7A/yVKw4YRD+7R3EpkoGXr/wBPn9WiU9jpfLmi/bdVCSdP5/odYDZl7k1ASA68uz5WH4C+IRfssug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 85E7C60F05; Mon, 18 Aug 2025 20:23:49 +0200 (CEST)
Date: Mon, 18 Aug 2025 20:23:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_set_pipapo_avx2: split lookup
 function in two parts
Message-ID: <aKNvtcCzJD8xnF3q@strlen.de>
References: <20250815143702.17272-1-fw@strlen.de>
 <20250815143702.17272-2-fw@strlen.de>
 <20250818182931.1dcaf62a@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818182931.1dcaf62a@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> > - * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
> > - * @net:	Network namespace
> > - * @set:	nftables API set representation
> > - * @key:	nftables API element representation containing key data
> > + * pipapo_get_avx2() - Lookup function for AVX2 implementation
> > + * @m:		storage containing the set elements
> > + * @data:	Key data to be matched against existing elements
> > + * @genmask:	If set, check that element is active in given genmask
> > + * @tstamp:	timestamp to check for expired elements
> 
> Nits: Storage, Timestamp (or all lowercase, for consistency with the
> other ones).

Note that there is no consistency whatsoever in the kernel.
Some use upper case, some lower, some indent on same level (like done
here), some don't.

So, I don't care anymore since it will never be right.

In case i have to mangle it anyway i will "fix" it.

> > +			e = f->mt[ret].e;
> > +			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
> 
> Here's the actual concern, even if I haven't tested this: I guess you now
> pass the timestamp to this function instead of getting it with each
> nft_set_elem_expired() call for either correctness (it should be done at
> the beginning of the insertion?) or as an optimisation (if BITS_PER_LONG < 64
> the overhead isn't necessarily trivial).

Its done because during insertion time should be frozen to avoid
elements timing out while transaction is in progress.
(this is unrelated to this patchset).

But in order to use this snippet from both control and data path
this has to be passed in so it can either be 'now' or 'time at
start of transaction'.

> But with 2/2, you need to call get_jiffies_64() as a result, from non-AVX2
> code, even for sets without a timeout (without NFT_SET_EXT_TIMEOUT
> extension).
> 
> Does that risk causing a regression on non-AVX2? If it's for correctness,
> I think we shouldn't care, but if it's done as an optimisation, perhaps
> it's not a universal one.

Its not an optimisation.  I could pass a 'is_control_plane' or
'is_packetpath' but I considered it too verbose and not needed for
correctness.
