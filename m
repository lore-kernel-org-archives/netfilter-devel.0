Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5C62157
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709576558; cv=none; b=SSDm6gUoJ0s0dIsq33J/RZoXyi+oSQqM86KWo/11/EQY4QwoUl6lWY+g17XicuDMPWDKUo+ou1cNVfkQDtm4OGvCcXzV76dtFe9eteuFZn5/V9S7vV3y7la9U/Cz4zmbOPP8waNx06rWcZi17hQ6bsBiGGLEdqGId6Iz+AtAEBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709576558; c=relaxed/simple;
	bh=ZSo5FzDUSMWeQPVHU4Eqg6MIA6lXHoan2NVgN4lmzb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpQD7ecuABBWBGvSrBQit6crkYUH8cEGr1RZzjKxuTpPFF8yKedXUNPoBfy3UJz0lhy6QMvu6V3/+V6nawPBxZvHxSMUnAkTdwPwz6HD25wZ1Sfn8NwcIGauexn1giO6A17cwhsVV1aHq4WDbHzVCuQUOxKY3GURtC+SozP/Hb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rhCxI-0007zC-0I; Mon, 04 Mar 2024 19:22:28 +0100
Date: Mon, 4 Mar 2024 19:22:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: mark set as dead when
 deactivating anonymous set
Message-ID: <20240304182227.GB19146@breakpoint.cc>
References: <20240304175306.145996-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304175306.145996-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> While the rhashtable set gc runs asynchronously, a race allows it to
> collect elements from an anonymous set while it is being released from
> the abort path. This also seems possible from the rule error path.
> 
> Mingi Cho originally reported this issue in a different path in 6.1.x
> with a pipapo set with low timeouts which is not possible upstream since
> 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
> element timeout").
> 
> Fix this by setting on the dead flag to signal set gc to skip anonymous
> sets from prepare_error, abort and commit paths.

This seems to contradict what patch is doing, the flag gets toggled for
all set types.

> Cc: stable@vger.kernel.org
> Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
> Reported-by: Mingi Cho <mgcho.minic@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index ca54d4c23123..26d33ce3b682 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5513,6 +5513,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  			list_del_rcu(&binding->list);
>  
>  		nft_use_dec(&set->use);
> +		set->dead = 1;
>  		break;
>  	case NFT_TRANS_PREPARE:
>  		if (nft_set_is_anonymous(set)) {
> @@ -5534,6 +5535,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  	default:
>  		nf_tables_unbind_set(ctx, set, binding,
>  				     phase == NFT_TRANS_COMMIT);
> +		set->dead = 1;

Shouldn't that be restricted to nf_tables_unbind_set() anonymous-set
branch?
