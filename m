Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3DE22423A
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780962980; cv=none; b=TEZh8xg1/bNL1ORnOtwkxlb6/9yM/gwmEbnS9Wzb2Yk4ApOCGux7sUdoWu8tgZC5UwZ5BPCC+zLfLozdleISAY2fOlGE3llhBZIeXmTY//tLBtlpHGtlkNxyhbzQhf6jQ8N5ScrsGf/dLAxWuo3I+aWhg2vPPHvqN2ZZ2hYb7tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780962980; c=relaxed/simple;
	bh=SpaAKuEssMkF3PS0YbFFnpafncMWc9/g0xD4YwxJ/4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fj6iUqmQTE5xP3Z7cQuI/oum6+c1M3irmfGnkjBheGA687+AbePkE5CX1nPhwHEqS3C9OwSkSNpx/vrJNs7AsYdg66Mn+LwtWYNFW3mVG/UlJbUUWBkWtiH0b2MU7i1XjhrgF8iLqv+DnO/8WhveQEJeCAQzWmNpsy5mu2qtKv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eY1BtUdK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eY1BtUdK"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D1BA56017D;
	Tue,  9 Jun 2026 01:56:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780962975;
	bh=vIfblX+mw0DK+qu7jCYYxt/Sj/wgcOWhvumOJVkfVbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eY1BtUdKxZLYq13P1u+2ElBuwoZ7J9WOB5zx7xOepdUTDbsjS1hrVZ2gcNLjwK/b+
	 J3XHE8pw+UnOmv6xADtCWAJqUJMS0GBSfp0LvyMupszGP0nACNKz1FmtwBakjNI/x+
	 +kTutkva4RBmlyodIurxWSm/j6oqbGmednZnWIz9wO4kk/3AkYj/X2V8dG6luG7sKk
	 IWDQ0IpUaNVqaQFmLc4h2mIfSUiAD+unq4S/SXWu9n8YFYtXMo0ax6Fca6eg4vHo0Z
	 n6l+1AIflBSx26BAarq74uVKW0UEOXndSCEbWf99JEbBwgFr9hlBRTqvWlLoehfEsP
	 HS2HG9+AntBgw==
Date: Tue, 9 Jun 2026 01:56:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	lorenzo@kernel.org, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, bird@lzu.edu.cn, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: nf_flow_table: separate tunnel route
 state from direct xmit
Message-ID: <aidWndIYXO9hXFq-@chamomile>
References: <cover.1780580352.git.chzhengyang2023@lzu.edu.cn>
 <3947a39286d335b6136bbee26f8bf44b23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3947a39286d335b6136bbee26f8bf44b23471c69.1780580352.git.chzhengyang2023@lzu.edu.cn>

Hi,

On Fri, Jun 05, 2026 at 01:10:35AM +0800, Ren Wei wrote:
> From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> 
> When a flow tuple carries tunnel metadata and uses
> FLOW_OFFLOAD_XMIT_DIRECT, the transmit path may still need route state
> for tunnel push. However, the current tuple layout stores direct xmit
> L2 state and route state in overlapping runtime storage.
> 
> As a result, a tuple may keep tun_num set while the tunnel push path
> later reads tuple->dst_cache, even though a direct xmit tuple only has
> out.ifidx/out.h_source/out.h_dest stored in that area. This leads to
> invalid dst usage and can trigger a crash in the tunnel transmit path.
> 
> Fix this by separating tunnel route state from direct xmit runtime
> state. Store dedicated tunnel dst information for direct xmit tunnel
> flows, use it from the IPv4/IPv6 tunnel push helpers, and validate and
> release it independently from the normal neighbour/xfrm dst state.
> 
> Hardware offload rule construction still assumes that direct xmit flows
> do not carry tunnel route state, so reject that combination there for
> now to avoid undefined offload behaviour.
> 
> The issue can be reproduced with the provided namespace + flowtable +
> IPIP setup, and after this change the reproducer no longer triggers the
> observed GPF/panic.
> 
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  include/net/netfilter/nf_flow_table.h |  4 ++++
>  net/netfilter/nf_flow_table_core.c    | 19 ++++++++++++++++++-
>  net/netfilter/nf_flow_table_ip.c      | 13 +++++++++++--
>  net/netfilter/nf_flow_table_offload.c |  5 +++++
>  4 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 7b23b245a5a8..4fe220f97d75 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -155,6 +155,10 @@ struct flow_offload_tuple {
>  					tun_num:2,
>  					in_vlan_ingress:2;
>  	u16				mtu;
> +	struct {
> +		struct dst_entry	*tun_dst_cache;
> +		u32			tun_dst_cookie;

Instead of adding new tun_dst_cache and tun_dst_cookie fields, you
could move the existing dst_cache and dst_cookie out of the union.
Then, it can be used both for _NEIGH and _DIRECT modes.

Does this make sense to simplify this patch?

One more comment below.

> +	};
>  	union {
>  		struct {
>  			struct dst_entry *dst_cache;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 785d8c244a77..5048c0a1ba2e 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -84,6 +84,14 @@ static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
>  	return 0;
>  }
>  
> +static u32 flow_offload_tun_dst_cookie(struct flow_offload_tuple *flow_tuple)
> +{
> +	if (flow_tuple->tun.l3_proto == IPPROTO_IPV6)
> +		return rt6_get_cookie(dst_rt6_info(flow_tuple->tun_dst_cache));
> +
> +	return 0;
> +}
> +
>  static struct dst_entry *nft_route_dst_fetch(struct nf_flow_route *route,
>  					     enum flow_offload_tuple_dir dir)
>  {
> @@ -127,12 +135,17 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  
>  	switch (route->tuple[dir].xmit_type) {
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		if (flow_tuple->tun_num) {
> +			flow_tuple->tun_dst_cache = dst;
> +			flow_tuple->tun_dst_cookie = flow_offload_tun_dst_cookie(flow_tuple);
> +		}
>  		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
>  		       ETH_ALEN);
>  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
>  		       ETH_ALEN);
>  		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
> -		dst_release(dst);
> +		if (!flow_tuple->tun_num)
> +			dst_release(dst);
>  		break;
>  	case FLOW_OFFLOAD_XMIT_XFRM:
>  	case FLOW_OFFLOAD_XMIT_NEIGH:
> @@ -152,6 +165,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  static void nft_flow_dst_release(struct flow_offload *flow,
>  				 enum flow_offload_tuple_dir dir)
>  {
> +	if (flow->tuplehash[dir].tuple.tun_num &&
> +	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
> +		dst_release(flow->tuplehash[dir].tuple.tun_dst_cache);
> +
>  	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>  	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
>  		dst_release(flow->tuplehash[dir].tuple.dst_cache);

dst_release() becomes no-op if it is NULL, then I think this can be
simplified.

> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 9c05a50d6013..8dbec82a663a 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -299,6 +299,11 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
>  
>  static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
>  {
> +	if (tuple->tun_num &&
> +	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> +	    !dst_check(tuple->tun_dst_cache, tuple->tun_dst_cookie))
> +		return false;
> +
>  	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
>  	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
>  		return true;
> @@ -597,7 +602,9 @@ static int nf_flow_tunnel_ipip_push(struct net *net, struct sk_buff *skb,
>  				    __be32 *ip_daddr)
>  {
>  	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
> -	struct rtable *rt = dst_rtable(tuple->dst_cache);
> +	struct dst_entry *dst = tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT ?
> +				tuple->tun_dst_cache : tuple->dst_cache;
> +	struct rtable *rt = dst_rtable(dst);
>  	u8 tos = iph->tos, ttl = iph->ttl;
>  	__be16 frag_off = iph->frag_off;
>  	u32 headroom = sizeof(*iph);
> @@ -660,7 +667,9 @@ static int nf_flow_tunnel_ip6ip6_push(struct net *net, struct sk_buff *skb,
>  {
>  	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
>  	u8 hop_limit = ip6h->hop_limit, proto = IPPROTO_IPV6;
> -	struct rtable *rt = dst_rtable(tuple->dst_cache);
> +	struct dst_entry *dst = tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT ?
> +				tuple->tun_dst_cache : tuple->dst_cache;
> +	struct rtable *rt = dst_rtable(dst);
>  	__u8 dsfield = ipv6_get_dsfield(ip6h);
>  	struct flowi6 fl6 = {
>  		.daddr = tuple->tun.src_v6,
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 002ec15d988b..c739c9db68bd 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -820,6 +820,11 @@ nf_flow_offload_rule_alloc(struct net *net,
>  
>  	tuple = &flow->tuplehash[dir].tuple;
>  	other_tuple = &flow->tuplehash[!dir].tuple;
> +
> +	if (other_tuple->tun_num &&
> +	    other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
> +		goto err_flow_match;
> +
>  	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)
>  		other_dst = other_tuple->dst_cache;
>  
> -- 
> 2.43.0
> 
