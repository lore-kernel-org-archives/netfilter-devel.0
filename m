Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7363A7E0D
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768489200; cv=none; b=EuIIO+5AMbnWqFkfKsVkyXma3amf710SPGPikHG6ldrkrVyBNU4e224wMQZf9gBrfYV0YMdNms77JVg7RbIw9H+h0uO2QHKZW/gkq5dbUe/gT3OT9U2IbnXTf1MRwlzuja6INpds2swcT4/1HR8P0U/ckZv0zTyZ6Hos2qygZ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768489200; c=relaxed/simple;
	bh=ZuvaeDlvl1qhBRLP4CYGunxRa4+WT4LzSezp0mAjDfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VclQX2Wd4CzLYms4fNGPPF4DnT0iD78IU9V8tQO0yn7EpvPEdHbuMyffvGqpZMaBgIGy/1SE3ncsYA9bfAGN4G3ZYqoXxzAyEdIwHTaAf2THG9I7MToHpOWms7HRpA3I4VrX1ZLoWErVc4CPEyeuUnW7nJGFYIUCvtDpHqEluX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B2A32602AB; Thu, 15 Jan 2026 15:59:42 +0100 (CET)
Date: Thu, 15 Jan 2026 15:59:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 1/3] netfilter: nf_tables: add
 .abort_skip_removal flag for set types
Message-ID: <aWkA2d1sSGgPFIV2@strlen.de>
References: <20260115124322.90712-1-pablo@netfilter.org>
 <20260115124322.90712-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115124322.90712-2-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The pipapo set backend is the only user of the .abort interface so far.
> To speed up pipapo abort path, removals are skipped.
> 
> The follow up patch updates the rbtree to use to build an array of
> ordered elements, then use binary search. This needs a new .abort
> interface but, unlike pipapo, it also need to undo/remove elements.
> 
> Add a flag and use it from the pipapo set backend.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h | 1 +
>  net/netfilter/nf_tables_api.c     | 2 +-
>  net/netfilter/nft_set_pipapo.c    | 2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index fab7dc73f738..21af1a2a6d3d 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -509,6 +509,7 @@ struct nft_set_ops {
>  						   const struct nft_set *set);
>  	void				(*gc_init)(const struct nft_set *set);
>  
> +	bool				abort_skip_removal;
>  	unsigned int			elemsize;
>  };
>  

This gives kdoc warning:

Warning: include/net/netfilter/nf_tables.h:513 struct member 'abort_skip_removal' not described in 'nft_set_ops'
