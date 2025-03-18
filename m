Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8986C1DED62;
	Tue, 18 Mar 2025 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742340228; cv=none; b=g6SL6Zd5qwMzctwcEQb6aU/om7vlHHoo30cz/17RM60pEXCvW21Y82+nPWVd4cpqt3bQ6VFvJw0++TNSWQ7npqcGopV3WUpSvjO2IwtxS+5hkTYypFkNeBe+NDJE18S1+LlOVJl8xmgF0wWWWghxcpPJJlEBYFpUATk71er7cps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742340228; c=relaxed/simple;
	bh=L9G4cm5suUsEr6dfWAfkpgsY6UwZGyLwjWcniuegWpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAPulCC0YdnW2HEIMN2GUe1Ste8hdSx/pLzv9tZt4Yai7yWA4FC7m9VZ54qlMkbBc9ITafDVpWEVjfjMkGyGRNbFWjdAaiI/UzrDElETKwbREaAiKpwsJi9EyuN8Ub2UBOAJ1QdJrTc9yfqVyJqUPOESZf8jrBu1aaRfFT/SEPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qrx0keNz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FCdP+LeE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qrx0keNz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FCdP+LeE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 155256054C; Wed, 19 Mar 2025 00:23:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742340224;
	bh=dwGU1IpfSZnRD6UAttPD8hi29anzn8fQpPnbFhuosq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qrx0keNz9oFc5uR0TF+LZNWsjj6sDNrYViFl1aRa4RiHhkGkBqgGZ+2v024jSgzuw
	 vxt1QmC08RLfLsda6eB2ufuOkb5nVmFVSljaURevXwTd3kfEIDTm2A9hWN/qI+JbHI
	 pY+8SMduN+MeY0hph9NjSw684mqC70WGw8d/sGRGDKWr1FK7DsQxCwABtTQYvgsYkT
	 sljhmg6oReAvYRKQaQWiiV4XekerpKHm0JvXbcQv0vns0G7JdsXhNeOgirn6Xqi5pX
	 hAsAMGskr8UyIv+dLyeKBkdG7Mr8RSVUi3E6PGxD7Ndo13mU6mMcWOoPQ/E9JhUQJx
	 Lb9Yy57sXLSkw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 84E786054C;
	Wed, 19 Mar 2025 00:23:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742340219;
	bh=dwGU1IpfSZnRD6UAttPD8hi29anzn8fQpPnbFhuosq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FCdP+LeEqe2X5YLCkhAuOL+of8fEd6EC34qac2A/05+Bf3Iu+IGppC7ayyGIFe/0x
	 pemY5cBqXIa91iVp2f7ZyU1eE5Bq0QlgUnAgelMi9u5+aNQCk9BqVzkG+gWgqa/blM
	 R/8IXCfzP4q9mtFPUQVGSgANGlTwmH4DIMxNxEcMsgyGxQu8dmDGYAOAPq08V7rd1a
	 CQpplp/DCLvsLVXGxTVHT86P9VeXmvKWLvik4lSXQLUwYEgMVLDjtRgDNuHRXKU9jC
	 vxnkgz3NHgM0Y2udOUmUT1W+hGgcBQdKZqHZ/henqRfudI4MT7cz74mKNoyshLGTa2
	 ctj9VZAvjZscA==
Date: Wed, 19 Mar 2025 00:23:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v10 nf-next 2/3] netfilter: nf_flow_table_offload: Add
 nf_flow_encap_push() for xmit direct
Message-ID: <Z9oAeJ5KifLxllEa@calendula>
References: <20250315195910.17659-1-ericwouds@gmail.com>
 <20250315195910.17659-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250315195910.17659-3-ericwouds@gmail.com>

On Sat, Mar 15, 2025 at 08:59:09PM +0100, Eric Woudstra wrote:
> Loosely based on wenxu's patches:
> 
> "nf_flow_table_offload: offload the vlan/PPPoE encap in the flowtable".

I remember that patch.

> Fixed double vlan and pppoe packets, almost entirely rewriting the patch.
>
> After this patch, it is possible to transmit packets in the fastpath with
> outgoing encaps, without using vlan- and/or pppoe-devices.
> 
> This makes it possible to use more different kinds of network setups.
> For example, when bridge tagging is used to egress vlan tagged
> packets using the forward fastpath. Another example is passing 802.1q
> tagged packets through a bridge using the bridge fastpath.
> 
> This also makes the software fastpath process more similar to the
> hardware offloaded fastpath process, where encaps are also pushed.

I am not convinced that making the software flowtable more similar
hardware is the way the go, we already have to deal with issues with
flow teardown mechanism (races) to make it more suitable for hardware
offload.

I think the benefit for pppoe is that packets do not go to userspace
anymore, but probably pppoe driver can be modified push the header
itself?

As for vlan, this is saving an indirection?

Going in this direction means the flowtable datapath will get more
headers to be pushed in this path in the future, eg. mpls.

Is this also possibly breaking existing setups? eg. xfrm + vlan
devices, but maybe I'm wrong.

> After applying this patch, always info->outdev = info->hw_outdev,
> so the netfilter code can be further cleaned up by removing:
>  * hw_outdev from struct nft_forward_info
>  * out.hw_ifindex from struct nf_flow_route
>  * out.hw_ifidx from struct flow_offload_tuple
> 
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 96 +++++++++++++++++++++++++++++++-
>  net/netfilter/nft_flow_offload.c |  6 +-
>  2 files changed, 96 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 8cd4cf7ae211..d0c3c459c4d2 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -306,6 +306,92 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
>  	return false;
>  }
>  
> +static int nf_flow_vlan_inner_push(struct sk_buff *skb, __be16 proto, u16 id)
> +{
> +	struct vlan_hdr *vhdr;
> +
> +	if (skb_cow_head(skb, VLAN_HLEN))
> +		return -1;
> +
> +	__skb_push(skb, VLAN_HLEN);
> +	skb_reset_network_header(skb);
> +
> +	vhdr = (struct vlan_hdr *)(skb->data);
> +	vhdr->h_vlan_TCI = htons(id);
> +	vhdr->h_vlan_encapsulated_proto = skb->protocol;
> +	skb->protocol = proto;
> +
> +	return 0;
> +}
> +
> +static int nf_flow_ppoe_push(struct sk_buff *skb, u16 id)
> +{
> +	struct ppp_hdr {
> +		struct pppoe_hdr hdr;
> +		__be16 proto;
> +	} *ph;
> +	int data_len = skb->len + 2;
> +	__be16 proto;
> +
> +	if (skb_cow_head(skb, PPPOE_SES_HLEN))
> +		return -1;
> +
> +	if (skb->protocol == htons(ETH_P_IP))
> +		proto = htons(PPP_IP);
> +	else if (skb->protocol == htons(ETH_P_IPV6))
> +		proto = htons(PPP_IPV6);
> +	else
> +		return -1;
> +
> +	__skb_push(skb, PPPOE_SES_HLEN);
> +	skb_reset_network_header(skb);
> +
> +	ph = (struct ppp_hdr *)(skb->data);
> +	ph->hdr.ver  = 1;
> +	ph->hdr.type = 1;
> +	ph->hdr.code = 0;
> +	ph->hdr.sid  = htons(id);
> +	ph->hdr.length = htons(data_len);
> +	ph->proto = proto;
> +	skb->protocol = htons(ETH_P_PPP_SES);
> +
> +	return 0;
> +}
> +
> +static int nf_flow_encap_push(struct sk_buff *skb,
> +			      struct flow_offload_tuple_rhash *tuplehash,
> +			      unsigned short *type)
> +{
> +	int i = 0, ret = 0;
> +
> +	if (!tuplehash->tuple.encap_num)
> +		return 0;
> +
> +	if (tuplehash->tuple.encap[i].proto == htons(ETH_P_8021Q) ||
> +	    tuplehash->tuple.encap[i].proto == htons(ETH_P_8021AD)) {
> +		__vlan_hwaccel_put_tag(skb, tuplehash->tuple.encap[i].proto,
> +				       tuplehash->tuple.encap[i].id);
> +		i++;
> +		if (i >= tuplehash->tuple.encap_num)
> +			return 0;
> +	}
> +
> +	switch (tuplehash->tuple.encap[i].proto) {
> +	case htons(ETH_P_8021Q):
> +		*type = ETH_P_8021Q;
> +		ret = nf_flow_vlan_inner_push(skb,
> +					      tuplehash->tuple.encap[i].proto,
> +					      tuplehash->tuple.encap[i].id);
> +		break;
> +	case htons(ETH_P_PPP_SES):
> +		*type = ETH_P_PPP_SES;
> +		ret = nf_flow_ppoe_push(skb,
> +					tuplehash->tuple.encap[i].id);
> +		break;
> +	}
> +	return ret;
> +}
> +
>  static void nf_flow_encap_pop(struct sk_buff *skb,
>  			      struct flow_offload_tuple_rhash *tuplehash)
>  {
> @@ -335,6 +421,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
>  
>  static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
>  				       const struct flow_offload_tuple_rhash *tuplehash,
> +				       struct flow_offload_tuple_rhash *other_tuplehash,
>  				       unsigned short type)
>  {
>  	struct net_device *outdev;
> @@ -343,6 +430,9 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
>  	if (!outdev)
>  		return NF_DROP;
>  
> +	if (nf_flow_encap_push(skb, other_tuplehash, &type) < 0)
> +		return NF_DROP;
> +
>  	skb->dev = outdev;
>  	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
>  			tuplehash->tuple.out.h_source, skb->len);
> @@ -462,7 +552,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  		ret = NF_STOLEN;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> -		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
> +		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
> +					 &flow->tuplehash[!dir], ETH_P_IP);
>  		if (ret == NF_DROP)
>  			flow_offload_teardown(flow);
>  		break;
> @@ -757,7 +848,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  		ret = NF_STOLEN;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> -		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
> +		ret = nf_flow_queue_xmit(state->net, skb, tuplehash,
> +					 &flow->tuplehash[!dir], ETH_P_IPV6);
>  		if (ret == NF_DROP)
>  			flow_offload_teardown(flow);
>  		break;
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 221d50223018..d320b7f5282e 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -124,13 +124,12 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  				info->indev = NULL;
>  				break;
>  			}
> -			if (!info->outdev)
> -				info->outdev = path->dev;
>  			info->encap[info->num_encaps].id = path->encap.id;
>  			info->encap[info->num_encaps].proto = path->encap.proto;
>  			info->num_encaps++;
>  			if (path->type == DEV_PATH_PPPOE)
>  				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
> +			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>  			break;
>  		case DEV_PATH_BRIDGE:
>  			if (is_zero_ether_addr(info->h_source))
> @@ -158,8 +157,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  			break;
>  		}
>  	}
> -	if (!info->outdev)
> -		info->outdev = info->indev;
> +	info->outdev = info->indev;
>  
>  	info->hw_outdev = info->indev;
>  
> -- 
> 2.47.1
> 
