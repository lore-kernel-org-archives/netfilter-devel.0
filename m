Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E2331ED4;
	Wed,  8 Jul 2026 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504378; cv=none; b=CE/A5E2tDX9YT1dQKB2mWW7YCkRptLn6hRmw9xG3ihfvxIg3AvVcy69cfQYVax9YauKFJuBPTvMkewgAofsGFMbeCh5i5bMSLASOOQWJ43V+8XB9yHr1Cbj+AFoR+Aa5/5bhSe6q5OVD8EJXoUD5NWeyGXtRBhzO9XkVb7wLYUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504378; c=relaxed/simple;
	bh=psSMGsFXzeljzNkVlffS+G6i+3apIUBeuTMpfQpDahs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZjXgauJcNMsTINtV8XZ6VznuFoFcL7roocMntiGja4m5171vPnhLEECyC6T9PZYFe+WJ9xzXSH/hgKdcHb1F99t0LqG9FWdC9gPOWNuad4lJ0bOA3nUVYxmBwkKUBZen27QecKFEw2g93vC5xaZPmXFxPxc7obGn18a0skr048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=alR3UOPs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="alR3UOPs"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A661C60195;
	Wed,  8 Jul 2026 11:52:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783504374;
	bh=hsTRFpAJV1/FkjiikxGCQ+8X0wx09ni7JTWzArJNiGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=alR3UOPshxaawQ6tu/bC1aGDEmec6k8ColGGLdh/x2BGIv0X0zu/81cLPGcWIVyHA
	 8yt2UlTt8c4GPmMI3mC9muI96uMjJdt5/RTS/m0KvcCW9BOmRxO6bLKzlKJwnSieAm
	 JoknmwM8kJ4LPWh2NgZ7BfmN+/3oaxycluDy1K69vyjNlN/Ei4GcmifkjtUqqd/ekq
	 fMzteU/ohVNJ8fRbOAK/nA8I26Vc0Bjb4V1CORI2rxyaS+0VZJJvq62KCE73P7FKVx
	 79gkT5RyCW8KLvh1CeT+cyj/NDH4jffXMan9tJzhDcjFnf8hwFkSX4QlKC+Wg2E9q8
	 vBjGq61pQVaVg==
Date: Wed, 8 Jul 2026 11:52:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v12 nf-next 7/7] netfilter: nft_flow_offload: Add
 bridgeflow to nft_flow_offload_eval()
Message-ID: <ak4d89hkh0Jvcp2W@chamomile>
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-8-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260707091045.967678-8-ericwouds@gmail.com>

Hi,

On Tue, Jul 07, 2026 at 11:10:45AM +0200, Eric Woudstra wrote:
> Edit nft_flow_offload_eval() to make it possible to handle a flowtable of
> the nft bridge family.
> 
> Use nft_flow_offload_bridge_init() to fill the flow tuples. It uses
> nft_dev_fill_bridge_path() in each direction.

I decided to add a bit more boiler plate in my proposal to detach the
inet and bridge flowtable dataplanes.

More comments below.

> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  include/net/netfilter/nf_flow_table.h |   5 +
>  net/netfilter/nf_flow_table_path.c    | 126 ++++++++++++++++++++++++++
>  net/netfilter/nft_flow_offload.c      |  20 +++-
>  3 files changed, 146 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 5c6e3b65ae85b..a109eda5250c7 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -305,6 +305,11 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
>  void flow_offload_route_init(struct flow_offload *flow,
>  			     struct nf_flow_route *route);
>  
> +int flow_offload_bridge_init(struct flow_offload *flow,
> +			     const struct nft_pktinfo *pkt,
> +			     enum ip_conntrack_dir dir,
> +			     struct nft_flowtable *ft);
> +
>  int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
>  void flow_offload_refresh(struct nf_flowtable *flow_table,
>  			  struct flow_offload *flow, bool force);
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 2b6ebb594a9ee..cdd6a822cb811 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/if_vlan.h>
>  #include <linux/init.h>
>  #include <linux/etherdevice.h>
>  #include <linux/netlink.h>
> @@ -365,3 +366,128 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>  	return -ENOENT;
>  }
>  EXPORT_SYMBOL_GPL(nft_flow_route);
> +
> +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
> +				    struct nft_flowtable *ft,
> +				    enum ip_conntrack_dir dir,
> +				    const struct net_device *src_dev,
> +				    const struct net_device *dst_dev,
> +				    unsigned char *src_ha,
> +				    unsigned char *dst_ha)
> +{
> +	struct flow_offload_tuple_rhash *th = flow->tuplehash;
> +	struct net_device_path_ctx ctx = {};
> +	struct net_device_path_stack stack;
> +	struct nft_forward_info info = {};
> +	int i, j = 0;
> +
> +	for (i = th[dir].tuple.encap_num - 1; i >= 0 ; i--) {
> +		if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
> +			return -1;
> +
> +		if (th[dir].tuple.in_vlan_ingress & BIT(i))
> +			continue;
> +
> +		info.encap[info.num_encaps].id = th[dir].tuple.encap[i].id;
> +		info.encap[info.num_encaps].proto = th[dir].tuple.encap[i].proto;
> +		info.num_encaps++;
> +
> +		if (th[dir].tuple.encap[i].proto == htons(ETH_P_PPP_SES))
> +			continue;
> +
> +		if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
> +			return -1;
> +		ctx.vlan[ctx.num_vlans].id = th[dir].tuple.encap[i].id;
> +		ctx.vlan[ctx.num_vlans].proto = th[dir].tuple.encap[i].proto;
> +		ctx.num_vlans++;
> +	}

I am not sure why this is needed, in my approach I simplified this,
but maybe I broke bridge vlan filtering. I am not sure what test
coverage you made.

> +	ctx.dev = src_dev;
> +	ether_addr_copy(ctx.daddr, dst_ha);
> +
> +	if (dev_fill_bridge_path(&ctx, &stack) < 0)
> +		return -1;
> +
> +	nft_dev_path_info(&stack, &info, dst_ha, &ft->data);
> +
> +	if (!info.indev || info.indev != dst_dev)
> +		return -1;
> +
> +	th[!dir].tuple.iifidx = info.indev->ifindex;
> +	for (i = info.num_encaps - 1; i >= 0; i--) {
> +		th[!dir].tuple.encap[j].id = info.encap[i].id;
> +		th[!dir].tuple.encap[j].proto = info.encap[i].proto;
> +		if (info.ingress_vlans & BIT(i))
> +			th[!dir].tuple.in_vlan_ingress |= BIT(j);
> +		j++;
> +	}
> +	th[!dir].tuple.encap_num = info.num_encaps;
> +
> +	th[dir].tuple.mtu = dst_dev->mtu;
> +	ether_addr_copy(th[dir].tuple.out.h_source, src_ha);
> +	ether_addr_copy(th[dir].tuple.out.h_dest, dst_ha);
> +	th[dir].tuple.out.ifidx = info.outdev->ifindex;
> +	th[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> +
> +	return 0;
> +}
> +
> +int flow_offload_bridge_init(struct flow_offload *flow,
> +			     const struct nft_pktinfo *pkt,
> +			     enum ip_conntrack_dir dir,
> +			     struct nft_flowtable *ft)
> +{
> +	const struct net_device *in_dev, *out_dev;
> +	struct ethhdr *eth = eth_hdr(pkt->skb);
> +	struct flow_offload_tuple *tuple;
> +	int err, i = 0;
> +
> +	in_dev = nft_in(pkt);
> +	if (!in_dev || !nft_flowtable_find_dev(in_dev, ft))
> +		return -1;
> +
> +	out_dev = nft_out(pkt);
> +	if (!out_dev || !nft_flowtable_find_dev(out_dev, ft))
> +		return -1;
> +
> +	tuple =  &flow->tuplehash[!dir].tuple;
> +
> +	if (skb_vlan_tag_present(pkt->skb)) {
> +		tuple->encap[i].id = skb_vlan_tag_get(pkt->skb);
> +		tuple->encap[i].proto = pkt->skb->vlan_proto;
> +		i++;
> +	}
> +
> +	switch (eth_hdr(pkt->skb)->h_proto) {
> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb_mac_header(pkt->skb)
> +					 + sizeof(struct ethhdr));
> +		tuple->encap[i].id = ntohs(vhdr->h_vlan_TCI);
> +		tuple->encap[i].proto = htons(ETH_P_8021Q);
> +		i++;
> +		break;
> +	}
> +	case htons(ETH_P_PPP_SES): {
> +		struct pppoe_hdr *phdr = (struct pppoe_hdr *)(skb_mac_header(pkt->skb)
> +					  + sizeof(struct ethhdr));
> +
> +		tuple->encap[i].id = ntohs(phdr->sid);
> +		tuple->encap[i].proto = htons(ETH_P_PPP_SES);
> +		i++;
> +		break;
> +	}
> +	}
> +	tuple->encap_num = i;

I am not sure these lines above can work. The VLAN tag might be
already gone by when the packet is observed from the bridge/forward
hook. I think populating the encap fields of the tuple by using the
observed packet is not good to go.

> +	err = nft_dev_fill_bridge_path(flow, ft, !dir, out_dev, in_dev,
> +				       eth->h_dest, eth->h_source);
> +	if (err < 0)
> +		return err;
> +
> +	err = nft_dev_fill_bridge_path(flow, ft, dir, in_dev, out_dev,
> +				       eth->h_source, eth->h_dest);
> +	if (err < 0)
> +		return err;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(flow_offload_bridge_init);
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 0be62841155b6..d0d63ef7cecd5 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -53,6 +53,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  {
>  	struct nft_flow_offload *priv = nft_expr_priv(expr);
>  	struct nf_flowtable *flowtable = &priv->flowtable->data;
> +	bool routing = flowtable->type->family != NFPROTO_BRIDGE;
>  	struct tcphdr _tcph, *tcph = NULL;
>  	struct nf_flow_route route = {};
>  	enum ip_conntrack_info ctinfo;
> @@ -109,14 +110,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  		goto out;
>  
>  	dir = CTINFO2DIR(ctinfo);
> -	if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
> -		goto err_flow_route;
> +	if (routing) {
> +		if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
> +			goto err_flow_route;
> +	}

As said, I am leaning towards adding a bit more boilerplate code to
separate the bridge and inet flowtable datapaths.

>  	flow = flow_offload_alloc(ct);
>  	if (!flow)
>  		goto err_flow_alloc;
>  
> -	flow_offload_route_init(flow, &route);
> +	if (routing)
> +		flow_offload_route_init(flow, &route);
> +	else
> +		if (flow_offload_bridge_init(flow, pkt, dir, priv->flowtable) < 0)
> +			goto err_flow_add;
> +
>  	if (tcph)
>  		flow_offload_ct_tcp(ct);
>  
> @@ -164,8 +172,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  err_flow_add:
>  	flow_offload_free(flow);
>  err_flow_alloc:
> -	dst_release(route.tuple[dir].dst);
> -	dst_release(route.tuple[!dir].dst);
> +	if (routing) {
> +		dst_release(route.tuple[dir].dst);
> +		dst_release(route.tuple[!dir].dst);
> +	}
>  err_flow_route:
>  	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
>  out:
> -- 
> 2.53.0
> 
