Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01B31C5D7B;
	Fri, 23 May 2025 07:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747985729; cv=none; b=gUnz9l4Rr8hxV0saUDzNkuHT74IqrzMti+1wJ3Qs9hReo79rKGVhxGUinlItACLNFjmpl/E1iZEGsDE7sv/gc1kxObDmDAnZUzpUs/dJLRU6NG4IFJ0mysIS1KHu1fA1BuMAeEbWCfWMs3MgXOVY1F1TfnXy9wEKryNydpLn10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747985729; c=relaxed/simple;
	bh=0XVPY2niVjWpDBO6CEqhrrLx5v8QhRqfDoKXreKcaf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjYkeGX7Hgg1MAH2ASae08I7Z3rb3xVM2ME78Ce806Ez7CjflYQNSMbXl6DQrAZ+p3MwQYRGBAQGOPY76hg18M7MftK5v5w4QuO+cInOHUImcE24YoEGnpI8JfS0qyeXIktskU0BpTJ2zEEY6qxgdzbZLojdO1dAGeV3w0TtQlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLcjKhUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLcjKhUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93A2C4CEE9;
	Fri, 23 May 2025 07:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747985728;
	bh=0XVPY2niVjWpDBO6CEqhrrLx5v8QhRqfDoKXreKcaf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLcjKhUmk10FVcL4jfd42aKFpEbYcfBj5hUuwmDljQE0i3npkMAdRUjd4iflG4cFN
	 +ftJDukW1HblVABI/25DZe+ZlYehPfgVjJ4fnkrJjW1QldJ1brCL3IRAW9e9Zke8JI
	 PlgCcSEsAAeweBl3NGZoPxjoxVw3313EhlbFDJJIS4wjoru7X5XbIGotKIdDT94XBP
	 fwlAn7Gsv08Lo4OMzQJbwhVBzi9c5Z9tzPEtwpPspMYX9HUJtAJ/eeW1SBiGHAlw9t
	 e9wXCkxEvnRhLKzEl8rIz6N/ZL4WTDXrzSoMD5lLEEd1R/3fLL8eUT+51nsKwyLGV+
	 zJ/EubuQIUa+w==
Date: Fri, 23 May 2025 08:35:24 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent
 l3mdev handling
Message-ID: <20250523073524.GR365796@horms.kernel.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
 <20250522165238.378456-7-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522165238.378456-7-pablo@netfilter.org>

On Thu, May 22, 2025 at 06:52:18PM +0200, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> fib has two modes:
> 1. Obtain output device according to source or destination address
> 2. Obtain the type of the address, e.g. local, unicast, multicast.
> 
> 'fib daddr type' should return 'local' if the address is configured
> in this netns or unicast otherwise.
> 
> 'fib daddr . iif type' should return 'local' if the address is configured
> on the input interface or unicast otherwise, i.e. more restrictive.
> 
> However, if the interface is part of a VRF, then 'fib daddr type'
> returns unicast even if the address is configured on the incoming
> interface.
> 
> This is broken for both ipv4 and ipv6.
> 
> In the ipv4 case, inet_dev_addr_type must only be used if the
> 'iif' or 'oif' (strict mode) was requested.
> 
> Else inet_addr_type_dev_table() needs to be used and the correct
> dev argument must be passed as well so the correct fib (vrf) table
> is used.
> 
> In the ipv6 case, the bug is similar, without strict mode, dev is NULL
> so .flowi6_l3mdev will be set to 0.
> 
> Add a new 'nft_fib_l3mdev_master_ifindex_rcu()' helper and use that
> to init the .l3mdev structure member.
> 
> For ipv6, use it from nft_fib6_flowi_init() which gets called from
> both the 'type' and the 'route' mode eval functions.
> 
> This provides consistent behaviour for all modes for both ipv4 and ipv6:
> If strict matching is requested, the input respectively output device
> of the netfilter hooks is used.
> 
> Otherwise, use skb->dev to obtain the l3mdev ifindex.
> 
> Without this, most type checks in updated nft_fib.sh selftest fail:
> 
>   FAIL: did not find veth0 . 10.9.9.1 . local in fibtype4
>   FAIL: did not find veth0 . dead:1::1 . local in fibtype6
>   FAIL: did not find veth0 . dead:9::1 . local in fibtype6
>   FAIL: did not find tvrf . 10.0.1.1 . local in fibtype4
>   FAIL: did not find tvrf . 10.9.9.1 . local in fibtype4
>   FAIL: did not find tvrf . dead:1::1 . local in fibtype6
>   FAIL: did not find tvrf . dead:9::1 . local in fibtype6
>   FAIL: fib expression address types match (iif in vrf)
> 
> (fib errounously returns 'unicast' for all of them, even
>  though all of these addresses are local to the vrf).
> 
> Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nft_fib.h   | 16 ++++++++++++++++
>  net/ipv4/netfilter/nft_fib_ipv4.c | 11 +++++++++--
>  net/ipv6/netfilter/nft_fib_ipv6.c |  4 +---
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
> index 6e202ed5e63f..2eea102c6609 100644
> --- a/include/net/netfilter/nft_fib.h
> +++ b/include/net/netfilter/nft_fib.h
> @@ -2,6 +2,7 @@
>  #ifndef _NFT_FIB_H_
>  #define _NFT_FIB_H_
>  
> +#include <net/l3mdev.h>
>  #include <net/netfilter/nf_tables.h>
>  
>  struct nft_fib {
> @@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
>  	return nft_fib_is_loopback(pkt->skb, indev);
>  }
>  
> +/**
> + * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device

Hi Pablo,

I don't mean to hold up progress of this pull request. But it would be nice
if at some point the above could be changed to
nft_fib_l3mdev_master_ifindex_rcu so it matches the name of the function
below that it documents.

Flagged by ./scripts/kernel-doc -none

> + * @pkt: pktinfo container passed to nft_fib_eval function
> + * @iif: input interface, can be NULL
> + *
> + * Return: interface index or 0.
> + */
> +static inline int nft_fib_l3mdev_master_ifindex_rcu(const struct nft_pktinfo *pkt,

> +						    const struct net_device *iif)
> +{
> +	const struct net_device *dev = iif ? iif : pkt->skb->dev;
> +
> +	return l3mdev_master_ifindex_rcu(dev);
> +}
> +
>  int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
>  int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  		 const struct nlattr * const tb[]);

...
