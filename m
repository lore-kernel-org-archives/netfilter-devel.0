Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6796E1E9B3D;
	Fri,  4 Jul 2025 20:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751659352; cv=none; b=KM7OTkjeNDZqwbxUbZix/LTAipOHnXL3NmofAiwMolFQoI6Nrm6WsO76N5slOuoaJlFgB3CzlSjqUwE1N97R6IqpeVgB1L6baAqfg9gpjDOdv93gNf90NevSTXLGz3Ngpi5/kcrmFkTLyYAwmVPcWxUpLPRaP+juXxs3LYoJbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751659352; c=relaxed/simple;
	bh=K6S3vKi4AxrKb0KI1YtJIYhd+BJaIWZMMADIbY6RX0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyBSUC30+ceqXDeauH0wx1Y8OSCZxEV35+wuAxMv9Q5ndG24/f2OGap2huNsc9rOFp+covd9P8V7XbTUNGGdc1NXL7/8YwxxPn0gC3GIM/ovwKvXvnvqdg7H5GemFPEhwAXQv3Zx/kBRKnoHzhdILgMQgArjm/grhty4CEy/GVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A8EDC61260; Fri,  4 Jul 2025 22:02:27 +0200 (CEST)
Date: Fri, 4 Jul 2025 22:02:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v13 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aGgzUe9X_0hXN2Ok@strlen.de>
References: <20250704191135.1815969-1-ericwouds@gmail.com>
 <20250704191135.1815969-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704191135.1815969-4-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets in the bridge filter chain.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_chain_filter.c | 52 +++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
> index 19a553550c76..8445ddfb9cea 100644
> --- a/net/netfilter/nft_chain_filter.c
> +++ b/net/netfilter/nft_chain_filter.c
> @@ -232,11 +232,55 @@ nft_do_chain_bridge(void *priv,
>  		    struct sk_buff *skb,
>  		    const struct nf_hook_state *state)
>  {
> +	__be16 outer_proto, proto = 0;
>  	struct nft_pktinfo pkt;
> +	int ret, offset = 0;
>  
>  	nft_set_pktinfo(&pkt, skb, state);
>  
>  	switch (eth_hdr(skb)->h_proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;
> +
> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
> +			break;
> +		offset = PPPOE_SES_HLEN;
> +		outer_proto = skb->protocol;
> +		ph = (struct ppp_hdr *)(skb->data);
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			proto = htons(ETH_P_IP);
> +			break;
> +		case htons(PPP_IPV6):
> +			proto = htons(ETH_P_IPV6);
> +			break;
> +		}

What if ph->proto is neither ipv4 nor ipv6?  I don't think
we should clobber skb->protocol or set a new network header in that
case.

> +      ret = nft_do_chain(&pkt, priv);
> +
> +      if (offset) {
> +               skb_reset_network_header(skb);

if ret == NF_STOLEN, skb has already been free'd or is queued
elsewhere and must not be modified anymore.

I would restrict this to ret == NF_ACCEPT.
