From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: bridge: unshare bridge info before change
 it
Date: Wed, 19 Nov 2014 14:07:51 +0100
Message-ID: <20141119130751.GA10748@salvia>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35105 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbaKSNFy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:05:54 -0500
Content-Disposition: inline
In-Reply-To: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 19, 2014 at 11:07:32AM +0800, Gao feng wrote:
> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> index c755e49..dca7337 100644
> --- a/include/linux/netfilter_bridge.h
> +++ b/include/linux/netfilter_bridge.h
> @@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>  	return 0;
>  }
>  
> +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
> +{
> +	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
> +	if (likely(skb->nf_bridge))
> +		atomic_set(&(skb->nf_bridge->use), 1);
> +
> +	return skb->nf_bridge;
> +}
> +
> +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
> +{
> +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> +
> +	if (atomic_read(&nf_bridge->use) > 1) {
> +		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);

nf_bridge_alloc() overwrites the original skb->nf_bridge when
unsharing, so this leaks and likely breaks other things.

> +
> +		if (tmp) {
> +			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
> +			atomic_set(&tmp->use, 1);
> +		}
> +		nf_bridge_put(nf_bridge);
> +		nf_bridge = tmp;
> +	}
> +	return nf_bridge;
> +}
