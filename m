Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC6C2D8DB5
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 09:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848478; cv=none; b=R3a5qoQkA9mEmmU7p517//ZXY9ZNXgl6CUOA6RDY34oJuJayLKzTN9KAN2iecYyOrU8hxmu+GpQ65tm6QE3uQQl0KXq09uIE6UVwxu7rroE+nRlhmY0DL8zw+IkEFPDb+ueHWD3efoct7vZJOy+w+MZZvsD3wrXmKDBz/d/X0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848478; c=relaxed/simple;
	bh=sciJJXH7CWygdF2uNP6BjQil9xYCS8T6RaQ9HlxRC/Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=iqarGx0mEzgXsgvmXs0JkruDxSwnK5LH3aT2nr2inJ/zwyzfIFyrhEG+Jj3o+t0ucTn0ny1adW9QufZTj+A3RbzpsVOVz4sYVcwxEX+ZnqK28Kd/yoCVb48n5E/ZyQKe+9Qw3o4WfO5ayg7CFJ3vAPh+Ckal4AdP5XEfNzxC8uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i5gKr6+I; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5gKr6+I"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15e03c2763so445440566b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 02:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783848475; x=1784453275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rKpJnCy23PP1/oJ/tDnabaN5cQwtRszVvOHCjhsVkQ0=;
        b=i5gKr6+Ixp43xAND7dLIeKTNXZOvWHj4uJgveDH1vrY6xzVmiEJF+VCJJWJwMZ9flV
         LbwJEsNOo8mr5rCswcWDtV+sBm6zH5IRaCKQDQtD3wGgPqrmx2fii2jFU152nS5HJeNg
         rDAtla7MBNCREsXDc3ZZUWfrmJ6Kl4mg7Gnd2/hfAmDImSWPT5C5V/moQImI0la4oAbO
         lamyKQv3Cc7UJdGg7wHOMM8m+Ay2eQf/JWtx5ZgSKtSTcH2aeuCA5QDf4qMWwURZws5v
         2yyYQsN7vxwrcy27n5F1+ciK7u3FRZYOUgqlqghHzPHan+afBFkUtVTG3mWQEBNocCz/
         vWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783848475; x=1784453275;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rKpJnCy23PP1/oJ/tDnabaN5cQwtRszVvOHCjhsVkQ0=;
        b=ArVzfKhrgldKnZDHN0sPxkrnlerc3AWmiG0G7oQl0Lq9vHtUaU+nLKPil0RjHLXpjW
         y0f1m6c1tqT5DhoDR8oQ7aC2IHXrhHdsQGpbQg8eIsjgHBa+3zXi0hf8q/WRIGNWOWZM
         ewzyG8dlH8dt0mlGYCLEpLGA1DzjrB8/khiKbqqOE1Gb4AxuThrKpj1aMLbqpAAF94zw
         bt4n1yrrAZPYKus3hke//R3N3pLSCTr8ZLW7/kNtkUocrIgwgaQ3FBZodvzS6B44Ahsr
         xKSKOYzEjEfU+xBTny/C+gFBVHH9FFjT6xnyopbYsSJ7a/DeUPXyRA4KbVxLRSie/nU0
         UI4A==
X-Forwarded-Encrypted: i=1; AHgh+Rrv66ECQA73m3daIv6/4ZvlepY78wNeXIFrcnqX/sBG54gf0qn7qyfsK4WnIqhPnDbt/LJw1JGIe+gbNF8sU/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzJ2QdO2tDdhN7hptcN0lWMSiTCiLUgQLGkGu2d4fT85r1wC0l
	/LQCXSoyUZrsRYV8XLArzLgsuazOKM+mtV+5FK4XiHaRFIv53/Cw+Dl1
X-Gm-Gg: AfdE7cm51HIQhDvEEnpaxvAs9tpwliS685z5eXAvXOQqnFIMdoRggJfXZ40euwQocUe
	D0izTYgk7mwF7H1pFpBlh9aKRLaLZ744kYyFysT0ikhAfIeKlmPDehqaXQGt+9pFD05W0KSuAB7
	3CFBVyNmDuGg/wYYXbLQLDfhm+H5P0F2smGcfU6Pwm47TIcWuwhnRA3z90bZ+9jdxmrniGuaMgu
	xZZT8I6Do23SkpR83cKbGw7zC8OH1bf2kqEqjGxgfd8dil2tVrE/uEX1CEfbnNPEO4lttgQUp3c
	T9cSSIRFISCE4lQvTUSeVaQwsRRPr9rD8xR4Gu44Y8FEHGOnS/afgNgMaPCVgt871Ty7LHPF3nj
	+JvqIC8WXrtCAB7IWOMmZimgkGXmkmjvMtioSnLXR6ps/4w9VJTKr0pDVFPKPLSHiRh/PFGcm7j
	UxWgzYRBfJS8C2UHIhc0ijNRTAjpVrTPTKrULiiAKT1nwuHkGvduq/3t7vh1zyirWN4pB5bW+cb
	gb0dyuDWd5LwdCCkxDJsRVWIutSqDJEc3uXSgVJWnFfxLf8ekd7xhKkFTmd5JXizrqmTN6a1zxx
	0r60+NHIlujRgH+guN0cuxA=
X-Received: by 2002:a17:906:f587:b0:c12:34c3:a452 with SMTP id a640c23a62f3a-c161de339e3mr240230266b.0.1783848474856;
        Sun, 12 Jul 2026 02:27:54 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15b7561db1sm779840666b.12.2026.07.12.02.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 02:27:53 -0700 (PDT)
Message-ID: <9b423fa5-88cb-4197-9849-91e40901dd5b@gmail.com>
Date: Sun, 12 Jul 2026 11:27:50 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Woudstra <ericwouds@gmail.com>
Subject: Re: [PATCH nf-next,v2 3/3] netfilter: flowtable: initial bridge
 support
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: razor@blackwall.org, fw@strlen.de
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-4-pablo@netfilter.org>
Content-Language: en-US
In-Reply-To: <20260710100729.1383580-4-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
> This patch adds bridge flowtable support, this allows to define a
> shortcut between two bridge ports. This is complementary to the
> existing inet family flowtable support.
> 
> Set up does not require userspace updates, an example ruleset to
> enable the flowtable in the bridge family is provided here below:
> 
>  table bridge x {
>         flowtable y {
>                 hook ingress priority 0
>                 devices = { veth0, veth1 }
>         }
>         chain forward {
>                 type filter hook forward priority 0
>                 ip protocol tcp flow add @y counter
>                 counter
>         }
>  }
> 
> I decided to add an explicit nft_flow_offload_bridge_eval() instead of
> recycling the existing inet function by adding branches to skip the
> routing part which is obviously not needed in the bridge path. I
> consider this mostly boiler plate for feature extensibility and better
> maintability is better to keep it separated. Similarly, the bridge hook
> that represents the flowtable bridge datapath is implemented in a
> separated function.
> 
> Although connection tracking in the bridge does not support the tracking
> of IP flows encapsulated in PPPoE and VLAN tracking yet, there are
> scenarios that involved PPPoE and VLAN that can be supported already,
> such as those where packets flows through the bridge with no tagging,
> eg. a VLAN device is used as a bridge port which decapsulates the
> packets at the ingress path.
> 
> Tested with:
> - Plain forwarding between bridge ports with no VLAN tagging.
> - VLAN device used in bridged ports, as long as packets that are
>   untagged when circulating within the bridge.
> 
> This initial bridge flowtable support does support VLAN tagged packets
> circulating within the bridge yet, because nf_conntrack_bridge still
> does not support PPPoE/VLAN natively.
> 
> Hardware offload is disabled until there is a driver in the tree
> supporting this.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: remove bridge vlan support, currently not exercised.
> 
>  include/net/netfilter/nf_flow_table.h |   7 ++
>  net/netfilter/nf_flow_table_inet.c    |  12 +++
>  net/netfilter/nf_flow_table_ip.c      | 134 ++++++++++++++++++++++++++
>  net/netfilter/nf_flow_table_path.c    |  65 +++++++++++++
>  net/netfilter/nft_flow_offload.c      |  88 ++++++++++++++++-
>  5 files changed, 305 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 7b23b245a5a8..d65914198ec9 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -247,6 +247,8 @@ struct nft_pktinfo;
>  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>  		   struct nf_flow_route *route, enum ip_conntrack_dir dir,
>  		   struct nft_flowtable *ft);
> +int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
> +		    enum ip_conntrack_dir dir, struct nft_flowtable *ft);
>  
>  static inline int
>  nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
> @@ -341,6 +343,8 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  				     const struct nf_hook_state *state);
>  unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  				       const struct nf_hook_state *state);
> +unsigned int nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
> +					 const struct nf_hook_state *state);
>  
>  #if (IS_BUILTIN(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
>      (IS_MODULE(CONFIG_NF_FLOW_TABLE) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
> @@ -374,6 +378,9 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
>  int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
>  			    enum flow_offload_tuple_dir dir,
>  			    struct nf_flow_rule *flow_rule);
> +int nf_flow_rule_bridge(struct net *net, struct flow_offload *flow,
> +			enum flow_offload_tuple_dir dir,
> +			struct nf_flow_rule *flow_rule);
>  
>  int nf_flow_table_offload_init(void);
>  void nf_flow_table_offload_exit(void);
> diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
> index b0f199171932..44790a0d3012 100644
> --- a/net/netfilter/nf_flow_table_inet.c
> +++ b/net/netfilter/nf_flow_table_inet.c
> @@ -65,6 +65,15 @@ static int nf_flow_rule_route_inet(struct net *net,
>  	return err;
>  }
>  
> +static struct nf_flowtable_type flowtable_bridge = {
> +	.family		= NFPROTO_BRIDGE,
> +	.init		= nf_flow_table_init,
> +	.setup		= nf_flow_table_offload_setup,
> +	.free		= nf_flow_table_free,
> +	.hook		= nf_flow_offload_bridge_hook,
> +	.owner		= THIS_MODULE,
> +};
> +
>  static struct nf_flowtable_type flowtable_inet = {
>  	.family		= NFPROTO_INET,
>  	.init		= nf_flow_table_init,
> @@ -97,6 +106,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
>  
>  static int __init nf_flow_inet_module_init(void)
>  {
> +	nft_register_flowtable_type(&flowtable_bridge);
>  	nft_register_flowtable_type(&flowtable_ipv4);
>  	nft_register_flowtable_type(&flowtable_ipv6);
>  	nft_register_flowtable_type(&flowtable_inet);
> @@ -109,6 +119,7 @@ static void __exit nf_flow_inet_module_exit(void)
>  	nft_unregister_flowtable_type(&flowtable_inet);
>  	nft_unregister_flowtable_type(&flowtable_ipv6);
>  	nft_unregister_flowtable_type(&flowtable_ipv4);
> +	nft_unregister_flowtable_type(&flowtable_bridge);
>  }
>  
>  module_init(nf_flow_inet_module_init);
> @@ -118,5 +129,6 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>  MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
>  MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
> +MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
>  MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
>  MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 29e93ac1e2e4..17ae49f62aa5 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -1196,3 +1196,137 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	return nf_flow_queue_xmit(state->net, skb, &xmit);
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
> +
> +static int nf_flow_bridge_xmit(struct net *net,
> +			       struct nf_flowtable *flow_table,
> +			       struct flow_offload *flow,
> +			       enum flow_offload_tuple_dir dir,
> +			       struct sk_buff *skb)
> +{
> +	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> +	struct nf_flow_xmit xmit = {};
> +
> +	xmit.outdev = dev_get_by_index_rcu(net, this_tuple->out.ifidx);
> +	if (!xmit.outdev) {
> +		flow_offload_teardown(flow);
> +		return NF_DROP;
> +	}
> +
> +	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
> +		nf_ct_acct_update(flow->ct, dir, skb->len);
> +
> +	xmit.dest = this_tuple->out.h_dest;
> +	xmit.source = this_tuple->out.h_source;
> +	xmit.tuple = other_tuple;
> +	xmit.needs_gso_segment = this_tuple->needs_gso_segment;
> +
> +	return nf_flow_queue_xmit(net, skb, &xmit);
> +}
> +
> +static unsigned int
> +nf_flow_offload_ip_bridge(void *priv, struct sk_buff *skb,
> +			  const struct nf_hook_state *state)
> +{
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct nf_flowtable *flow_table = priv;
> +	enum flow_offload_tuple_dir dir;
> +	struct nf_flowtable_ctx ctx = {
> +		.in	= state->in,
> +	};
> +	struct flow_offload *flow;
> +	unsigned int thoff;
> +	struct iphdr *iph;
> +
> +	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
> +	if (!tuplehash)
> +		return NF_ACCEPT;
> +
> +	dir = tuplehash->tuple.dir;
> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +
> +	iph = (struct iphdr *)(skb_network_header(skb) + ctx.offset);
> +	thoff = (iph->ihl * 4) + ctx.offset;
> +	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
> +		return NF_ACCEPT;
> +
> +	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
> +		return NF_DROP;
> +
> +	flow_offload_refresh(flow_table, flow, false);
> +	nf_flow_encap_pop(&ctx, skb, tuplehash);
> +	skb_clear_tstamp(skb);
> +
> +	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
> +}
> +
> +static unsigned int
> +nf_flow_offload_ipv6_bridge(void *priv, struct sk_buff *skb,
> +			    const struct nf_hook_state *state)
> +{
> +	struct flow_offload_tuple_rhash *tuplehash;
> +	struct nf_flowtable *flow_table = priv;
> +	enum flow_offload_tuple_dir dir;
> +	struct nf_flowtable_ctx ctx = {
> +		.in	= state->in,
> +	};
> +	struct flow_offload *flow;
> +	struct ipv6hdr *ip6h;
> +	unsigned int thoff;
> +
> +	tuplehash = nf_flow_offload_ipv6_lookup(&ctx, flow_table, skb);
> +	if (!tuplehash)
> +		return NF_ACCEPT;
> +
> +	dir = tuplehash->tuple.dir;
> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
> +
> +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx.offset);
> +	thoff = sizeof(*ip6h) + ctx.offset;
> +	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
> +		return NF_ACCEPT;
> +
> +	if (skb_ensure_writable(skb, thoff + ctx.hdrsize))
> +		return NF_DROP;
> +
> +	flow_offload_refresh(flow_table, flow, false);
> +	nf_flow_encap_pop(&ctx, skb, tuplehash);
> +	skb_clear_tstamp(skb);
> +
> +	return nf_flow_bridge_xmit(state->net, flow_table, flow, dir, skb);
> +}
> +
> +unsigned int
> +nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
> +			    const struct nf_hook_state *state)
> +{
> +	struct vlan_ethhdr *veth;
> +	__be16 proto;
> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_8021Q):
> +		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
> +			return NF_ACCEPT;
> +
> +		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
> +		proto = veth->h_vlan_encapsulated_proto;
> +		break;
> +	case htons(ETH_P_PPP_SES):
> +		if (!nf_flow_pppoe_proto(skb, &proto))
> +			return NF_ACCEPT;
> +		break;
> +	default:
> +		proto = skb->protocol;
> +		break;
> +	}
> +
> +	switch (proto) {
> +	case htons(ETH_P_IP):
> +		return nf_flow_offload_ip_bridge(priv, skb, state);
> +	case htons(ETH_P_IPV6):
> +		return nf_flow_offload_ipv6_bridge(priv, skb, state);
> +	}
> +
> +	return NF_ACCEPT;
> +}
> +EXPORT_SYMBOL_GPL(nf_flow_offload_bridge_hook);
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 5455149e5d9a..a3aa9a9ce673 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -8,6 +8,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <linux/if_vlan.h>
>  #include <net/ip.h>
>  #include <net/inet_dscp.h>
>  #include <net/netfilter/nf_tables.h>
> @@ -360,3 +361,67 @@ int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,
>  	return -ENOENT;
>  }
>  EXPORT_SYMBOL_GPL(nft_flow_route);
> +
> +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
> +				    struct nft_flowtable *ft,
> +				    enum ip_conntrack_dir dir,
> +				    const struct net_device *dev,
> +				    unsigned char *src_ha,
> +				    unsigned char *dst_ha)
> +{
> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;

Add:

struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;

See below.

> +	struct net_device_path_stack stack;
> +	struct nft_forward_info info = {};
> +	struct net_device_path_ctx ctx;
> +	int i, j = 0;
> +
> +	nft_dev_fill_forward_path_init(&ctx, dev, dst_ha);
> +

Here you could add the following to handle the encaps on this_tuple.

for (i = this_tuple->encap_num - 1; i >= 0 ; i--) {
	if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
		return -1;

	if (this_tuple->in_vlan_ingress & BIT(i))
		continue;

	info.encap[info.num_encaps].id = this_tuple->encap[i].id;
	info.encap[info.num_encaps].proto = this_tuple->encap[i].proto;
	info.num_encaps++;

	if (this_tuple->encap[i].proto == htons(ETH_P_PPP_SES))
		continue;

	if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
		return -1;
	ctx.vlan[ctx.num_vlans].id = this_tuple->encap[i].id;
	ctx.vlan[ctx.num_vlans].proto = this_tuple->encap[i].proto;
	ctx.num_vlans++;
}

> +	if (dev_fill_forward_path(&ctx, &stack) < 0 ||
> +	    nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
> +		return -1;
> +
> +	if (!nft_flowtable_find_dev(info.indev, ft))
> +		return -1;
> +

After replacing dev_fill_forward_path() with dev_fill_bridge_path(),
from here...

> +	this_tuple->iifidx = info.indev->ifindex;
> +	for (i = info.num_encaps - 1; i >= 0; i--) {
> +		this_tuple->encap[j].id = info.encap[i].id;
> +		this_tuple->encap[j].proto = info.encap[i].proto;
> +		j++;
> +	}
> +	this_tuple->encap_num = info.num_encaps;

Until here, this_tuple needs to be the other_tuple.
dev_fill_forward_path() does not traverse the bridge.
See other comment in other patch. Also, need to copy
the in_vlan_ingress bit.

So it becomes:

other_tuple->iifidx = info.indev->ifindex;
for (i = info.num_encaps - 1; i >= 0; i--) {
	other_tuple->encap[j].id = info.encap[i].id;
	other_tuple->encap[j].proto = info.encap[i].proto;
	if (info.ingress_vlans & BIT(i))
		other_tuple->in_vlan_ingress |= BIT(j);
	j++;
}
other_tuple->encap_num = info.num_encaps;

> +
> +	ether_addr_copy(this_tuple->out.h_source, src_ha);
> +	ether_addr_copy(this_tuple->out.h_dest, dst_ha);
> +	this_tuple->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
> +
> +	return 0;
> +}
> +
> +int nft_flow_bridge(struct flow_offload *flow, const struct nft_pktinfo *pkt,
> +		    enum ip_conntrack_dir dir, struct nft_flowtable *ft)
> +{
> +	struct flow_offload_tuple *other_tuple = &flow->tuplehash[!dir].tuple;
> +	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
> +	const struct net_device *outdev = nft_out(pkt);
> +	const struct net_device *indev = nft_in(pkt);
> +	struct ethhdr *eth = eth_hdr(pkt->skb);
> +	int err;
> +

Here I use the skb to fill other_tuple->encaps. I understand you want to
do this differently.
Then I call nft_dev_fill_bridge_path() with !dir first, then dir.

> +	err = nft_dev_fill_bridge_path(flow, ft, dir, indev,
> +				       eth->h_source, eth->h_dest);
> +	if (err < 0)
> +		return err;
> +
> +	err = nft_dev_fill_bridge_path(flow, ft, !dir, outdev,
> +				       eth->h_dest, eth->h_source);
> +	if (err < 0)
> +		return err;
> +
> +	this_tuple->out.ifidx = other_tuple->iifidx;
> +	other_tuple->out.ifidx = this_tuple->iifidx;

This could move to nft_dev_fill_bridge_path() (only 1 line) as both
tuples are also known there.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nft_flow_bridge);
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 32b4281038dd..d1f145a401d1 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -135,6 +135,64 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	regs->verdict.code = NFT_BREAK;
>  }
>  
> +static void nft_flow_offload_bridge_eval(const struct nft_expr *expr,
> +					 struct nft_regs *regs,
> +					 const struct nft_pktinfo *pkt)
> +{
> +	struct nft_flow_offload *priv = nft_expr_priv(expr);
> +	struct nf_flowtable *flowtable = &priv->flowtable->data;
> +	struct tcphdr _tcph, *tcph = NULL;
> +	enum ip_conntrack_info ctinfo;
> +	struct flow_offload *flow;
> +	enum ip_conntrack_dir dir;
> +	struct nf_conn *ct;
> +	int ret;
> +
> +	/* Is this an IP packet? If not, skip. */
> +	if (!pkt->flags)
> +		goto out;
> +
> +	ct = nf_ct_get(pkt->skb, &ctinfo);
> +	if (!ct || !nf_ct_is_confirmed(ct))
> +		goto out;
> +
> +	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> +	case IPPROTO_TCP:
> +		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> +					  sizeof(_tcph), &_tcph);
> +		if (unlikely(!tcph || tcph->fin || tcph->rst ||
> +			     !nf_conntrack_tcp_established(ct)))
> +			goto out;
> +		break;
> +	case IPPROTO_UDP:
> +		break;
> +	}
> +
> +	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
> +		goto out;
> +
> +	flow = flow_offload_alloc(ct);
> +	if (!flow)
> +		goto err_flow_forward;
> +
> +	dir = CTINFO2DIR(ctinfo);
> +	if (nft_flow_bridge(flow, pkt, dir, priv->flowtable) < 0)
> +		goto err_flow_add;
> +
> +	ret = flow_offload_add(flowtable, flow);
> +	if (ret < 0)
> +		goto err_flow_add;
> +
> +	return;
> +
> +err_flow_add:
> +	flow_offload_free(flow);
> +err_flow_forward:
> +	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
> +out:
> +	regs->verdict.code = NFT_BREAK;
> +}
> +
>  static int nft_flow_offload_validate(const struct nft_ctx *ctx,
>  				     const struct nft_expr *expr)
>  {
> @@ -142,7 +200,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
>  
>  	if (ctx->family != NFPROTO_IPV4 &&
>  	    ctx->family != NFPROTO_IPV6 &&
> -	    ctx->family != NFPROTO_INET)
> +	    ctx->family != NFPROTO_INET &&
> +	    ctx->family != NFPROTO_BRIDGE)
>  		return -EOPNOTSUPP;
>  
>  	return nft_chain_validate_hooks(ctx->chain, hook_mask);
> @@ -235,6 +294,27 @@ static struct nft_expr_type nft_flow_offload_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +static const struct nft_expr_ops nft_flow_offload_bridge_ops = {
> +	.type		= &nft_flow_offload_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_flow_offload)),
> +	.eval		= nft_flow_offload_bridge_eval,
> +	.init		= nft_flow_offload_init,
> +	.activate	= nft_flow_offload_activate,
> +	.deactivate	= nft_flow_offload_deactivate,
> +	.destroy	= nft_flow_offload_destroy,
> +	.validate	= nft_flow_offload_validate,
> +	.dump		= nft_flow_offload_dump,
> +};
> +
> +static struct nft_expr_type nft_flow_offload_bridge_type __read_mostly = {
> +	.name		= "flow_offload",
> +	.family		= NFPROTO_BRIDGE,
> +	.ops		= &nft_flow_offload_bridge_ops,
> +	.policy		= nft_flow_offload_policy,
> +	.maxattr	= NFTA_FLOW_MAX,
> +	.owner		= THIS_MODULE,
> +};
> +
>  static int flow_offload_netdev_event(struct notifier_block *this,
>  				     unsigned long event, void *ptr)
>  {
> @@ -264,8 +344,14 @@ static int __init nft_flow_offload_module_init(void)
>  	if (err < 0)
>  		goto register_expr;
>  
> +	err = nft_register_expr(&nft_flow_offload_bridge_type);
> +	if (err < 0)
> +		goto register_bridge_expr;
> +
>  	return 0;
>  
> +register_bridge_expr:
> +	nft_unregister_expr(&nft_flow_offload_type);
>  register_expr:
>  	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
>  err:

