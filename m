Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F292F1E4B0;
	Fri, 26 Jul 2024 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722000775; cv=none; b=lM+ToYRxr1AJgm7VgDBH+KtosjBzNO2tyiQswOqzzTOFZgmOniq1a0HviQDo9IQO/XH96Om8HuWgvCKxlOg6TZVOnUbszV1UFlSvRC9Vp5/S1hw646SaVyKblwWdMmu45e3UAwc/SBVU6cCCdvk7B2SRhWnCG0L8MKqcSk+hyiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722000775; c=relaxed/simple;
	bh=ttdpt+jvQmXT0eJ7KYhCDK83FXS8fxW5pSifxEgr0HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWmF28yTDDMywWeFyDhcIVQ9t1fGAZc62FHeccRXWciFlPqLnaZLKAnTxF6WPzdBfOJFU/7ZRy/M7myToVIhyVlDSe4Mk4zl8fM5CzHB3dmQjjFaTjlk2Xgvbg/25UqE6Ib6W6v0yIWAnS9jpqKmNhnfLLby6EPf2eeM8xqk28Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sXL3w-0001aW-DT; Fri, 26 Jul 2024 15:32:48 +0200
Date: Fri, 26 Jul 2024 15:32:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, gnault@redhat.com,
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP
 bits before FIB lookup
Message-ID: <20240726133248.GA5302@breakpoint.cc>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-3-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725131729.1729103-3-idosch@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ido Schimmel <idosch@nvidia.com> wrote:
> @@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	if (priv->flags & NFTA_FIB_F_MARK)
>  		fl4.flowi4_mark = pkt->skb->mark;
>  
> -	fl4.flowi4_tos = iph->tos & DSCP_BITS;
> +	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;

If this is supposed to get centralised, wouldn't it
make more sense to not mask it, or will that happen later?

I thought plan was to ditch RT_MASK...
