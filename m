From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH,RFC] Route match v2
Date: Mon, 07 Jul 2008 14:00:32 +0200
Message-ID: <48720560.5090202@trash.net>
References: <20080704184331.GA24793@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58250 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYGGMAe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:00:34 -0400
In-Reply-To: <20080704184331.GA24793@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> Attached is a new "route" match, which matches against entries
> in the kernel routing table.
> 
> Changes since v1:
>   * IPv6 support in kernel
>   * Invert support for ALL options
>   * Various cleanup in userspace code (C99 initializers & unified v4/v6 parse)
> 
> I've tested the IPv6 support as best I can, but I'd appreciate someone who
> actually has production v6 nets giving it a run through.


> +static bool
> +route_mt6(const struct sk_buff *skb, const struct net_device *in,
> +           const struct net_device *out, const struct xt_match *match,
> +           const void *matchinfo, int offset, unsigned int protoff,
> +           bool *hotdrop)
> +{
> +	const struct xt_route_info *info = matchinfo;
> +	const struct ipv6hdr *iph = ipv6_hdr(skb);
> +	struct fib6_node *fn;
> +	struct flowi fl = {0};
> +
> +	switch (info->mode) {
> +	case XT_ROUTE_SRC_EXISTS:
> +		fl.nl_u.ip6_u.daddr = iph->saddr;
> +		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);

This is always using the main table, which is inconsistent
with the IPv4 support. It also shouldn't call IPv6 functions
directly to avoid incorrect module dependencies.

