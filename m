From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Wed, 16 Mar 2011 14:54:54 +0100
Message-ID: <4D80C12E.4010107@trash.net>
References: <1300214971-20345-1-git-send-email-fw@strlen.de> <1300214971-20345-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64459 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1CPNzA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:55:00 -0400
In-Reply-To: <1300214971-20345-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.03.2011 19:49, Florian Westphal wrote:
> +static bool match_type6(struct net *net, const struct net_device *dev,
> +				const struct in6_addr *addr, u16 mask)
> +{
> +	int addr_type = ipv6_addr_type(addr);
> +
> +	if ((mask & XT_ADDRTYPE_MULTICAST) &&
> +	    !(addr_type & IPV6_ADDR_MULTICAST))
> +		return false;
> +	if ((mask & XT_ADDRTYPE_UNICAST) && !(addr_type & IPV6_ADDR_UNICAST))
> +		return false;
> +	if ((mask & XT_ADDRTYPE_UNSPEC) && addr_type != IPV6_ADDR_ANY)
> +		return false;
> +
> +	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
> +	     XT_ADDRTYPE_UNREACHABLE) & mask) {
> +		struct rt6_info *rt;
> +		u32 type;
> +		int ifindex = dev ? dev->ifindex : 0;
> +
> +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);

Florian, I just noticed that this will pull in the IPv6 module just
by loading the xt_addrtype module. Can we convert this to use
nf_ip6_afinfo->route() instead?

> +
> +		type = xt_addrtype_rt6_to_type(rt);
> +
> +		dst_release(&rt->dst);
> +		return !!(mask & type);
> +	}
> +	return true;
> +}
