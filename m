From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH,RFC] Route match v2
Date: Mon, 07 Jul 2008 19:33:15 +0200
Message-ID: <4872535B.9050200@trash.net>
References: <20080704184331.GA24793@linuxace.com> <48720560.5090202@trash.net> <20080707170545.GA31948@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33662 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYGGRdT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:33:19 -0400
In-Reply-To: <20080707170545.GA31948@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Mon, Jul 07, 2008 at 02:00:32PM +0200, Patrick McHardy wrote:
>>> +static bool
>>> +route_mt6(const struct sk_buff *skb, const struct net_device *in,
>>> +           const struct net_device *out, const struct xt_match *match,
>>> +           const void *matchinfo, int offset, unsigned int protoff,
>>> +           bool *hotdrop)
>>> +{
>>> +	const struct xt_route_info *info = matchinfo;
>>> +	const struct ipv6hdr *iph = ipv6_hdr(skb);
>>> +	struct fib6_node *fn;
>>> +	struct flowi fl = {0};
>>> +
>>> +	switch (info->mode) {
>>> +	case XT_ROUTE_SRC_EXISTS:
>>> +		fl.nl_u.ip6_u.daddr = iph->saddr;
>>> +		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
>> This is always using the main table, which is inconsistent
>> with the IPv4 support. It also shouldn't call IPv6 functions
>> directly to avoid incorrect module dependencies.
> 
> What are the alternatives?  If we need to support IPv6 in the match, then
> we need to call the functions directly, no?  Is there a helper function
> I'm missing?

There are the ->route functions is nf_afinfo, but I'm not sure
if they will work for you. You may have too add some new ones.

