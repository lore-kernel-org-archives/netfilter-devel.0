Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8678348866;
	Thu,  9 Apr 2026 09:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728239; cv=none; b=O1vw4gGB7YcCi9rDZikl7FiS0z310eNb8RVKYrr1nLTz1WG3qOEUXm8j33OT/VLD9v7zZk+m3iVHtn4rOTWBLU4bc6Lmk2CRD1KmwZybcLHHeyZkoFvV62jwTUKYyRagf4JYVY1erxb19a/XNkTiDSln03xgQcSlb4yas66RQTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728239; c=relaxed/simple;
	bh=i+6hlVdUZ7Xyw2twTV+z+yoWBuQrnAz2c3XD/5XMwDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGNUvq9GOYh+AkWCVil79gM1lFnQwjEJCGTDtw31pAmk6L69GyA5W99TXZjIyeCTE4A64d/wnpY0MBgxbzwgxHdE2M6DGrhVzqsdL07/71jZVLxmCuCP29DQ/omhZ2o8zUjP6eK1g343dfnEyVImZnjLXaOYugZ0cR3n2watuQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F3F3760636; Thu, 09 Apr 2026 11:50:34 +0200 (CEST)
Date: Thu, 9 Apr 2026 11:50:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nft_fwd_netdev: use recursion counter in
 neigh egress path
Message-ID: <add2ajF5YGqd4MxZ@strlen.de>
References: <20260409053629.698822-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409053629.698822-2-bestswngs@gmail.com>

Weiming Shi <bestswngs@gmail.com> wrote:
> Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  include/net/netfilter/nf_dup_netdev.h |  4 ++++
>  net/netfilter/nf_dup_netdev.c         | 18 ++++++++++++++++++
>  net/netfilter/nft_fwd_netdev.c        |  7 +++++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> index b175d271aec9..17362f76d1d1 100644
> --- a/include/net/netfilter/nf_dup_netdev.h
> +++ b/include/net/netfilter/nf_dup_netdev.h
> @@ -7,6 +7,10 @@
>  void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>  void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>  
> +bool nf_dup_netdev_has_recursed(void);
> +void nf_dup_netdev_recursion_inc(void);
> +void nf_dup_netdev_recursion_dec(void);
> +
>  struct nft_offload_ctx;
>  struct nft_flow_rule;
>  
> diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> index fab8b9011098..e2fe8bb6fe0d 100644
> --- a/net/netfilter/nf_dup_netdev.c
> +++ b/net/netfilter/nf_dup_netdev.c
> @@ -29,6 +29,24 @@ static u8 *nf_get_nf_dup_skb_recursion(void)
>  
>  #endif
>  
> +bool nf_dup_netdev_has_recursed(void)
> +{
> +	return *nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT;
> +}
> +EXPORT_SYMBOL_GPL(nf_dup_netdev_has_recursed);

I think thats a bit too heavy-handed.
nf_get_nf_dup_skb_recursion() fetches from pcpu counter or current->.

Can you move nf_get_nf_dup_skb_recursion to a shared header file
and make it inline instead of having a function call?

