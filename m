From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] bridge: netfilter: don't call iptables on vlan packets
 if sysctl is off
Date: Fri, 02 Mar 2012 22:11:11 +0100
Message-ID: <4F51376F.3050704@pandora.be>
References: <1330638154-1142-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
	Jesse Gross <jesse@nicira.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:37545 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2CBVLR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:11:17 -0500
In-Reply-To: <1330638154-1142-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 1/03/2012 22:42, Florian Westphal schreef:
> When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> arriving should not be sent to ip(6)tables by bridge netfilter.
>
> However, it turns out that we currently always send VLAN packets to
> netfilter, if ..
> a), CONFIG_VLAN_8021Q is enabled ; or
> b), CONFIG_VLAN_8021Q is not set but rx vlan offload is enabled
>     on the bridge port.
>
> This is because bridge netfilter treats skb with
> skb->protocol == ETH_P_IP{V6} as "non-vlan packet".

> -	else if (skb->protocol == htons(ETH_P_IPV6) || IS_VLAN_IPV6(skb) ||
> -		 IS_PPPOE_IPV6(skb))
> +	else if (IS_IPV6(skb) || IS_PPPOE_IPV6(skb))

> -	if (skb->protocol != htons(ETH_P_ARP)) {
> -		if (!IS_VLAN_ARP(skb))
> -			return NF_ACCEPT;
> -		nf_bridge_pull_encap_header(skb);
> -	}
> +	if (!IS_ARP(skb))
> +		return NF_ACCEPT;
> +	nf_bridge_pull_encap_header(skb);

> -	if (skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb) ||
> -	    IS_PPPOE_IP(skb))
> +	if (IS_IP(skb) || IS_PPPOE_IP(skb))

I think the above is quite unclear to read. I would prefer something 
like this:
if (IS_IP(skb) || IS_VLAN_IP(skb) || IS_PPPOE_IP(skb))
The compiler should easily remove any redundant checks that this would 
produce. The same idea goes for the IS_ARP and IS_IPV6 macros you define...
Apart from that the patch looks fine to me.

cheers,

Bart

