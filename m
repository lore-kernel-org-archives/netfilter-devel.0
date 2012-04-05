From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH -next] netfilter: bridge: optionally set indev to vlan
Date: Thu, 05 Apr 2012 19:20:36 +0200
Message-ID: <4F7DD464.4020405@pandora.be>
References: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:39113 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab2DERUm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:20:42 -0400
In-Reply-To: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 4/04/2012 21:57, Florian Westphal schreef:
> if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
> netfilter removes the vlan header temporarily and then feeds the packet
> to ip(6)tables.
>
> When the new "bridge-nf-pass-vlan-input-device" sysctl is on
> (default off), then bridge netfilter will also change the in/out
> interface to the vlan interface; if such an interface exists.
>
> This is needed to make iptables REDIRECT target work with
> "vlan-on-top-of-bridge" setups. Also, 'iptables -i' can then be used
> to match the vlan device name.
>
> Also update Documentation with current brnf default settings.
>
>   proc/sys/net/sctp/* Variables:
>
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index dec4f38..1d69feb 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -53,6 +53,7 @@ static int brnf_call_iptables __read_mostly = 1;
>   static int brnf_call_ip6tables __read_mostly = 1;
>   static int brnf_call_arptables __read_mostly = 1;
>   static int brnf_filter_vlan_tagged __read_mostly = 0;
> +static int brnf_pass_vlan_indev __read_mostly = 0;
>   static int brnf_filter_pppoe_tagged __read_mostly = 0;
>   #else
>   #define brnf_call_iptables 1
> @@ -503,6 +504,19 @@ bridged_dnat:
>   	return 0;
>   }

You should also provide a macro in case the proc file system isn't 
enabled: currently it won't compile with your patch.

>   /* Some common code for IPv4/IPv6 */
>   static struct net_device *setup_pre_routing(struct sk_buff *skb)
>   {
> @@ -515,7 +529,7 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
>
>   	nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING;
>   	nf_bridge->physindev = skb->dev;
> -	skb->dev = bridge_parent(skb->dev);
> +	skb->dev = brnf_get_logical_dev(skb, skb->dev);
>   	if (skb->protocol == htons(ETH_P_8021Q))
>   		nf_bridge->mask |= BRNF_8021Q;
>   	else if (skb->protocol == htons(ETH_P_PPP_SES))
> @@ -737,7 +751,7 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
>   				     int (*okfn)(struct sk_buff *))
>   {
>   	struct nf_bridge_info *nf_bridge;
> -	struct net_device *parent;
> +	struct net_device *parent, *indev;
>   	u_int8_t pf;
>
>   	if (!skb->nf_bridge)
> @@ -748,10 +762,6 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
>   	if (!nf_bridge_unshare(skb))
>   		return NF_DROP;
>
> -	parent = bridge_parent(out);
> -	if (!parent)
> -		return NF_DROP;
> -
>   	if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
>   		pf = PF_INET;
>   	else if (IS_IPV6(skb) || IS_VLAN_IPV6(skb) || IS_PPPOE_IPV6(skb))
> @@ -759,6 +769,10 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
>   	else
>   		return NF_ACCEPT;
>
> +	parent = brnf_get_logical_dev(skb, out);
> +	if (!parent)
> +		return NF_DROP;
> +
>   	nf_bridge_pull_encap_header(skb);
>
>   	nf_bridge = skb->nf_bridge;
> @@ -778,7 +792,9 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
>   	else
>   		skb->protocol = htons(ETH_P_IPV6);
>
> -	NF_HOOK(pf, NF_INET_FORWARD, skb, bridge_parent(in), parent,
> +	indev = brnf_get_logical_dev(skb, in);
> +
> +	NF_HOOK(pf, NF_INET_FORWARD, skb, indev, parent,
>   		br_nf_forward_finish);
>
>   	return NF_STOLEN;
> @@ -850,7 +866,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
>   				       int (*okfn)(struct sk_buff *))
>   {
>   	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> -	struct net_device *realoutdev = bridge_parent(skb->dev);
> +	struct net_device *realoutdev = brnf_get_logical_dev(skb, out);
I think it's best to keep the bridge_parent as output device in the 
FOWARD and POSTROUTING chain: only change the input device. Do you have 
a reason for changing the output device?

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

