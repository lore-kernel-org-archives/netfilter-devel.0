Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B13264F5;
	Sun, 18 Oct 2026 01:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792288427; cv=none; b=EJ2Yk+OrwN68/wBbMlqBNOUQkJPCqYoM7cJhoSXxCiocQJiflDsrsmLknA36kczJiBHguHI5eOySIKuMa/6fcdBDHucPbFf+10+L00C/GWLNQE6FR4IAdWOGQWZNSgIKMeaTi0FtlwWYqVj2VGWJUp4MLlp+nemuixloX72Ugbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792288427; c=relaxed/simple;
	bh=XCIiK8hlCwzFwF0mXYvpuGixKQNN116lxwDGeZOX/SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdTbBYdsx/iWaW6OraoZTgmuVh6vWWF3xXX/EeNL+89AUvFiHctKfl08wqHzqIYgPajD8R/zQ8PhiyiaP0t4k0QXOWfq5+uVdDeQUDxrtU3yjd7PE9or2gwQggryoyll81IeBqdOFg4Gmd56AjM+ozi6tH9+inPcnKxwwJ4J2kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YYYsa08L; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YYYsa08L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792288423;
	bh=aGyrDya+Q51fnSt6cvt2rWR0GqJGNLTVYGw124H+8Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YYYsa08Lj2CA4ia7bwu45mSNDNCBikYK1uGSGe04VEMSlPLRKh+/gVzvdFK3Bc+Qz
	 4yBRZpVr701q7a1EWipe74wAan2f9Dax4UlgzXWKl67lhUG455vZ6zPBMbMMMuZxSU
	 9Nf+CtDApQ3H6lLkjp8jp7sTDAWUnjalG53q0UQmCVd8KDf6Bwp4CN8y2RmVP6jxGO
	 /L4jyk8mnD3AKd4FHY9Fl4mGulpP1eHmAikllyvf9UebXf7tCuAFyNG2l3/7uHelDq
	 jfY1jVBkPAMqbiJ3hq+fplAIey8QzX/jP4NUpyghVXbwUksPSQHiCAAuwHEqvlvzyA
	 oZy8aFoNrsxGw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9304C60057;
	Sun, 18 Oct 2026 03:53:43 +0200 (CEST)
Date: Sun, 18 Oct 2026 03:53:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	coreteam@netfilter.org, netdev@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, andrew+netdev@lunn.ch, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: Re: [PATCH nf-next 2/3] netfilter: flowtable: update upper device
 stats in the fast path
Message-ID: <atQmpPlfT_DSd9dq@chamomile>
References: <20261004171616.3544880-1-julius@bairaktaris.de>
 <20261004171616.3544880-3-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261004171616.3544880-3-julius@bairaktaris.de>

On Sun, Oct 04, 2026 at 07:16:15PM +0200, Julius Bairaktaris wrote:
> The software fast path receives and transmits on the lowest devices of
> the input and output stacks, so the bridge, VLAN, PPPoE and tunnel
> devices above them stop counting after the first packets of a
> connection.
> 
> Store the ifindexes of these devices from the forward path and update
> their counters from the fast path. Each device counts what it counts in
> the classic path: the IP packet plus the headers of the devices above it
> (PPPoE, outer IP, inner VLAN tag), plus the Ethernet header on transmit
> for Ethernet devices.
> 
> A GSO packet sent through a PPPoE device is counted once. The classic
> path segments it in front of the ppp device and counts every segment.
> 
> struct flow_offload grows from 296 to 328 bytes.
> 
> Assisted-by: Claude:claude-fable-5-1

This does not look very good...

I mentioned it is a feature that these counters are not bumped,
because packets are not passing through this devices in the bypass.

This allows users to see what packets follow classic path?

But if you insist, then explore a way to synchronize these counters
offline (ie. not from packet path) to see how it looks like.

Even though, I'm not sure lying to userspace that packets are going
through these devices via stats can be right.

> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  include/net/netfilter/nf_flow_table.h |  8 +++-
>  net/netfilter/nf_flow_table_core.c    |  3 ++
>  net/netfilter/nf_flow_table_ip.c      | 53 +++++++++++++++++++++++++++
>  net/netfilter/nf_flow_table_path.c    |  9 +++++
>  4 files changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index f2e2771f188f..1f451fcf05d0 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -106,6 +106,8 @@ enum flow_offload_xmit_type {
>  };
>  
>  #define NF_FLOW_TABLE_ENCAP_MAX		2
> +/* Devices above the flowtable device in a forward path. */
> +#define NF_FLOW_TABLE_UPPER_MAX		(NET_DEVICE_PATH_STACK_MAX - 1)
>  
>  struct flow_offload_tunnel {
>  	union {
> @@ -153,7 +155,8 @@ struct flow_offload_tuple {
>  					encap_num:2,
>  					needs_gso_segment:1,
>  					tun_num:2,
> -					in_vlan_ingress:2;
> +					in_vlan_ingress:2,
> +					num_uppers:3;
>  	u16				mtu;
>  	u32				dst_cookie;
>  	struct dst_entry		*dst_cache;
> @@ -171,6 +174,7 @@ struct flow_offload_tuple {
>  			u32		iifidx;
>  		} tc;
>  	};
> +	u32				upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
>  };
>  
>  struct flow_offload_tuple_rhash {
> @@ -228,6 +232,8 @@ struct nf_flow_route {
>  			u8			num_encaps:2,
>  						num_tuns:2,
>  						ingress_vlans:2;
> +			u32			upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
> +			u8			num_uppers;
>  		} in;
>  		struct {
>  			u32			ifindex;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 03241d4bfd5e..2c9a0d97c9fb 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -122,6 +122,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  
>  	flow_tuple->tun = route->tuple[dir].in.tun;
>  	flow_tuple->encap_num = route->tuple[dir].in.num_encaps;
> +	memcpy(flow_tuple->upper_ifidx, route->tuple[dir].in.upper_ifidx,
> +	       sizeof(flow_tuple->upper_ifidx));
> +	flow_tuple->num_uppers = route->tuple[dir].in.num_uppers;
>  	flow_tuple->needs_gso_segment = route->tuple[dir].out.needs_gso_segment;
>  	flow_tuple->tun_num = route->tuple[dir].in.num_tuns;
>  
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index c8c29a9a1684..e1a3511d5f1f 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -453,6 +453,49 @@ static void nf_flow_encap_pop(struct nf_flowtable_ctx *ctx,
>  		nf_flow_ip_tunnel_pop(ctx, skb);
>  }
>  
> +/* The fast path bypasses the devices above the flowtable device. */
> +static void nf_flow_upper_stats_add(struct net *net,
> +				    const struct flow_offload_tuple *tuple,
> +				    bool rx, unsigned int len)
> +{
> +	unsigned int n, vlan_hlen = 0;
> +	struct net_device *dev;
> +	int i;
> +
> +	for (i = 0; i < tuple->num_uppers; i++) {
> +		dev = dev_get_by_index_rcu(net, tuple->upper_ifidx[i]);
> +		if (!dev)
> +			continue;
> +
> +		n = len;
> +		if (!rx && dev->type == ARPHRD_ETHER)
> +			n += ETH_HLEN;
> +
> +		if (is_vlan_dev(dev)) {
> +			/* Q-in-Q: the outer VLAN device counts the inner tag. */
> +			n += vlan_hlen;
> +			if (rx)
> +				vlan_dev_sw_netstats_rx_add(dev, n);
> +			else
> +				vlan_dev_sw_netstats_tx_add(dev, 1, n);
> +			vlan_hlen += VLAN_HLEN;
> +		} else if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_TSTATS) {
> +			if (rx)
> +				dev_sw_netstats_rx_add(dev, n);
> +			else
> +				dev_sw_netstats_tx_add(dev, 1, n);
> +		}
> +
> +		/* The devices below also count this device's header. */
> +		if (dev->type == ARPHRD_PPP)
> +			len += PPPOE_SES_HLEN;
> +		else if (dev->type == ARPHRD_TUNNEL)
> +			len += sizeof(struct iphdr);
> +		else if (dev->type == ARPHRD_TUNNEL6)
> +			len += sizeof(struct ipv6hdr);
> +	}
> +}
> +
>  static struct flow_offload_tuple_rhash *
>  nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
>  		       struct nf_flowtable *flow_table, struct sk_buff *skb)
> @@ -512,6 +555,11 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
>  	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
>  		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
>  
> +	nf_flow_upper_stats_add(dev_net(ctx->in), &tuplehash->tuple, true,
> +				skb->len);
> +	nf_flow_upper_stats_add(dev_net(ctx->in), &flow->tuplehash[!dir].tuple,
> +				false, skb->len);
> +
>  	return 1;
>  }
>  
> @@ -1107,6 +1155,11 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
>  	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
>  		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
>  
> +	nf_flow_upper_stats_add(dev_net(ctx->in), &tuplehash->tuple, true,
> +				skb->len);
> +	nf_flow_upper_stats_add(dev_net(ctx->in), &flow->tuplehash[!dir].tuple,
> +				false, skb->len);
> +
>  	return 1;
>  }
>  
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 1e55644f2edb..ba5ac3ebe614 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -83,6 +83,8 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
>  
>  struct nft_forward_info {
>  	const struct net_device *dev;
> +	u32 upper_ifidx[NF_FLOW_TABLE_UPPER_MAX];
> +	u8 num_uppers;
>  	struct id {
>  		__u16	id;
>  		__be16	proto;
> @@ -187,6 +189,10 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
>  		}
>  	}
>  
> +	for (i = 0; info->dev && stack->path[i].dev != info->dev; i++)
> +		info->upper_ifidx[i] = stack->path[i].dev->ifindex;
> +	info->num_uppers = i;
> +
>  	if (nf_flowtable_hw_offload(&ft->data) &&
>  	    nft_is_valid_ether_device(info->dev))
>  		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> @@ -253,6 +259,9 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  
>  	route->tuple[!dir].in.num_encaps = info.num_encaps;
>  	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
> +	memcpy(route->tuple[!dir].in.upper_ifidx, info.upper_ifidx,
> +	       sizeof(info.upper_ifidx));
> +	route->tuple[!dir].in.num_uppers = info.num_uppers;
>  
>  	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
>  		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
> -- 
> 2.53.0
> 
