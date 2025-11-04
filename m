Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C220311;
	Tue,  4 Nov 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762271632; cv=none; b=j/HZKhCeD6hGn7ZkrR7cxyilhOsfkI0oPz3iW2d7BZ774Q5JV639ffPrjo3mdeaxXwPxDjPutJ8OHduEUSkQr2Rqz/GANi+UI4Cd9T7i71zKom0lAFU4vvEXvL8UwhlMPcLdfRL8Xn/wVZCgDxQU5voJJMcEISzq4HuRSBzkHoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762271632; c=relaxed/simple;
	bh=0V0q9rOlnk7nX1rBmck6nEO8pZJBx1Lf9aYBqkZ+DQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfxN3QuF0SPuwCoeZKnlCQe08imcPniG3qIOXqDw6kRRK38NoENNlXbgwMsmSg5Itor63rK+1xLHYLkGDvLxLCfBfNdCsunZIoU/HN9uBFr9WSeJbpUPJjN5MUXOsIUxhwG/wtmEQnqfO6wC40oicw03D1IC9flYzxeLhWaEQa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6B2A060298; Tue,  4 Nov 2025 16:53:48 +0100 (CET)
Date: Tue, 4 Nov 2025 16:53:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v16 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aQohjDYORamn7Gya@strlen.de>
References: <20251104145728.517197-1-ericwouds@gmail.com>
 <20251104145728.517197-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104145728.517197-4-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> +	switch (*proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;
> +
> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
> +			return -1;
> +		ph = (struct ppp_hdr *)(skb->data);
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			*proto = htons(ETH_P_IP);
> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
> +			return PPPOE_SES_HLEN;
> +		case htons(PPP_IPV6):
> +			*proto = htons(ETH_P_IPV6);
> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
> +			return PPPOE_SES_HLEN;
> +		}
> +		break;
> +	}
> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr;
> +
> +		if (!pskb_may_pull(skb, VLAN_HLEN))
> +			return -1;
> +		vhdr = (struct vlan_hdr *)(skb->data);
> +		*proto = vhdr->h_vlan_encapsulated_proto;
> +		skb_set_network_header(skb, VLAN_HLEN);
> +		return VLAN_HLEN;
> +	}
> +	}
> +	return 0;
> +}
> +
>  static unsigned int
>  nft_do_chain_bridge(void *priv,
>  		    struct sk_buff *skb,
>  		    const struct nf_hook_state *state)
>  {
>  	struct nft_pktinfo pkt;
> +	__be16 proto;
> +	int offset;
>  
> -	nft_set_pktinfo(&pkt, skb, state);
> +	proto = eth_hdr(skb)->h_proto;
>  
> -	switch (eth_hdr(skb)->h_proto) {
> +	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
> +	if (offset < 0)
> +		return NF_ACCEPT;


Hmm.  I'm not sure, I think this should either drop them right away
OR pass them to do_chain without any changes (i.e. retain existing
behavior and have this be same as nft_set_pktinfo_unspec()).

but please wait until resend.

I hope to finish a larger set i've been working on by tomorrow.
Then I can give this a more thorough review (and also make a summary +
suggestion wrt. the bridge match semantics wrt.  vlan + pppoe etc.

My hunch is that your approach is pretty much the way to go
but I need to complete related homework to make sure I did not
miss/forget anything.
