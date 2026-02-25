Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9328682
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Feb 2026 00:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771979843; cv=none; b=NS+z2kzCcXCkgUUv1gbDUixEV5siBiN8SZIyW2cv/7YU4iwObMxU3airPGscXieM/3kUUxvXgQ+VQKvnXeU9OAFsjevHrLXgOsvTOYHio/qD50u1ebdvZK51d/grRMoZYH6oSmskjmw3OUaW7JghOGwzid3oNM/CmQXw2iQhgWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771979843; c=relaxed/simple;
	bh=WY5mUBUjCtABVhJYT3GpUUHRcrrsJ6fL+X7jSTgixn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hle6Y9pzSuHCFbhcbSKTkFuTR+URiCzgSLV8Qye0LKQ0Jo12GHn0W7LOXIc8srXz5tFqRtXBqM7YK9raKgxm6TGpuEdo+DfLHI69Rwon1HWqQIInpPZEUufY0x+zsbFAC6OvWiR22dJ0gdzAzJXhBoIo6bNNlJsMKkUz+n5B+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 746A860336; Wed, 25 Feb 2026 01:37:17 +0100 (CET)
Date: Wed, 25 Feb 2026 01:37:17 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: clone set on flush only
Message-ID: <aZ5EPaPz6ZZMQWjq@strlen.de>
References: <20260225001348.2371931-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225001348.2371931-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Restrict set clone to the flush set command in the preparation phase.
> Add NFT_ITER_UPDATE_CLONE and use it for this purpose, update the rbtree
> and pipapo backends to only clone the set when this iteration type is
> used.
> 
> As for the existing NFT_ITER_UPDATE type, update the pipapo backend to
> use the existing set clone if available, otherwise use the existing set
> representation. After this update, there is no need to clone a set that
> is being deleted, this includes bound anonymous set.

Thanks Pablo, this looks good to me. Two small nits/suggestions:

1. Add to commit message that this affects fault injection resp.
   that this requires failing GFP_KERNEL allocation to trigger
   the WARN splat.

>  struct nft_set;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 834736237b09..618f79700f75 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7906,7 +7906,7 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
>  {
>  	struct nft_set_iter iter = {
>  		.genmask	= genmask,
> -		.type		= NFT_ITER_UPDATE,
> +		.type		= NFT_ITER_UPDATE_CLONE,
>  		.fn		= nft_setelem_flush,
>  	};

2. I think it would help to add a comment to the existing
NFT_ITER_UPDATE users as to why they use UPDATE and not CLONE.

Or, alternatively, add comment here why this one needs the _CLONE
variant.

But this looks correct to me, nft_set_flush() makes clone mandatory
while others either can re-use the live copy OR are guaranteed to have
a clone, e.g. because the function is always called after a
delete/insert operation that already did the clone.
