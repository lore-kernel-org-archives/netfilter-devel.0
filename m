Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0388726A1AF;
	Thu,  9 Apr 2026 11:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775732774; cv=none; b=rQtcVcvP5lsypyf7dnXcnTtCpXYJfz1LHem4SyOSHxfZScj0eN5OW4dLK9z0JlrNoStygcOiOlnZhUoqkEDjrwvxwDxphvFqN+pu36Y14Kd59h1MrjbjE7IEsP2ozw0qwx9hXGo86y7+36kJwHczq0Hl/Am6HbEJIkhO1H6w6Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775732774; c=relaxed/simple;
	bh=2YHFrzrI84d9lpiXpxi3bnyki3GTSvsusW4oxazVRnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZ8mxvGxHzcuqd5qHMpt1+Le4LlrRMLbosiztJgVn8o3GI8cC4dLW7nM2JRDAYtbDMLfBgUJpL4/ehEUhPcy+32YW9lq5+S1ZWhJo9nsuEw/nS1raciY7yXtPbqAmFFadqhRl+DyW9HmF3n0OQUTWc5Z2DbYE7dhf0Hplm2Cl+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q4KIBn+q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q4KIBn+q"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5B3A9600B5;
	Thu,  9 Apr 2026 13:06:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775732762;
	bh=Rqu/gVOitW7Ns+Rt9dxe6qvnEaTF9koiHqNOvlCaxxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q4KIBn+qAbOy7EGryTB0I7AkCyB37k8XY47oQU/Qi78dm6Ut9JSo8QGBvHqt5KN0h
	 Ly3cm0k+5HXYuYoIyrtRqxalS9yi8D/HNxWHBDpP8tjjqBb1CJkkz+umNPi1ZfLqkv
	 9m33Vg3S+pRFdZJH72oDKV4IlUyzvn0GVKlnnYt6O6KMQN8ImT6jKArG1vU7o/nSup
	 6m3aH/lMjciTHb0/9IbiegtfRF9Wxj0/eWIGfVfp6btpFMRePcRyAkIl2VdrrjNN+V
	 eq+XvSmzYMMetUMTKycE868w9EDWIxhWyVCxiqUds9+EzDfi21hUPXjmSsYUq/mAMZ
	 YYvMIxbqo7xfw==
Date: Thu, 9 Apr 2026 13:05:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] netfilter: nft_fwd_netdev: use recursion counter in
 neigh egress path
Message-ID: <adeIF7ZsJsZsgwQy@chamomile>
References: <20260409104911.722698-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260409104911.722698-2-bestswngs@gmail.com>

On Thu, Apr 09, 2026 at 06:49:12PM +0800, Weiming Shi wrote:
> nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
> forwarding rule targets the same device or two devices forward to each
> other, neigh_xmit() triggers dev_queue_xmit() which re-enters
> nf_hook_egress(), causing infinite recursion and stack overflow.
> 
> Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
> to the shared header nf_dup_netdev.h as a static inline, so that
> nft_fwd_netdev can use the recursion counter directly without exported
> function call overhead. Guard neigh_xmit() with the same recursion
> limit already used in nf_do_netdev_egress().
> 
> Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")

I would just restrict this "feature", I don't see a point in allowing
this from egress?

> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
>  net/netfilter/nf_dup_netdev.c         | 16 ----------------
>  net/netfilter/nft_fwd_netdev.c        |  7 +++++++
>  3 files changed, 20 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> index b175d271aec9..609bcf422a9b 100644
> --- a/include/net/netfilter/nf_dup_netdev.h
> +++ b/include/net/netfilter/nf_dup_netdev.h
> @@ -3,10 +3,23 @@
>  #define _NF_DUP_NETDEV_H_
>  
>  #include <net/netfilter/nf_tables.h>
> +#include <linux/netdevice.h>
> +#include <linux/sched.h>
>  
>  void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>  void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
>  
> +#define NF_RECURSION_LIMIT	2
> +
> +static inline u8 *nf_get_nf_dup_skb_recursion(void)
> +{
> +#ifndef CONFIG_PREEMPT_RT
> +	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> +#else
> +	return &current->net_xmit.nf_dup_skb_recursion;
> +#endif
> +}
> +
>  struct nft_offload_ctx;
>  struct nft_flow_rule;
>  
> diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> index fab8b9011098..a958a1b0c5be 100644
> --- a/net/netfilter/nf_dup_netdev.c
> +++ b/net/netfilter/nf_dup_netdev.c
> @@ -13,22 +13,6 @@
>  #include <net/netfilter/nf_tables_offload.h>
>  #include <net/netfilter/nf_dup_netdev.h>
>  
> -#define NF_RECURSION_LIMIT	2
> -
> -#ifndef CONFIG_PREEMPT_RT
> -static u8 *nf_get_nf_dup_skb_recursion(void)
> -{
> -	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> -}
> -#else
> -
> -static u8 *nf_get_nf_dup_skb_recursion(void)
> -{
> -	return &current->net_xmit.nf_dup_skb_recursion;
> -}
> -
> -#endif
> -
>  static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
>  				enum nf_dev_hooks hook)
>  {
> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index 152a9fb4d23a..492bb599a499 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
>  		goto out;
>  	}
>  
> +	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
> +		verdict = NF_DROP;
> +		goto out;
> +	}
> +
>  	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
>  	if (dev == NULL)
>  		return;
>  
>  	skb->dev = dev;
>  	skb_clear_tstamp(skb);
> +	(*nf_get_nf_dup_skb_recursion())++;
>  	neigh_xmit(neigh_table, dev, addr, skb);
> +	(*nf_get_nf_dup_skb_recursion())--;
>  out:
>  	regs->verdict.code = verdict;
>  }
> -- 
> 2.43.0
> 
> 
