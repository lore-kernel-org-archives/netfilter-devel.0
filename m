From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH,RFC] Route match v2
Date: Mon, 7 Jul 2008 10:05:45 -0700
Message-ID: <20080707170545.GA31948@linuxace.com>
References: <20080704184331.GA24793@linuxace.com> <48720560.5090202@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:34964
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753411AbYGGRFq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:05:46 -0400
Content-Disposition: inline
In-Reply-To: <48720560.5090202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 07, 2008 at 02:00:32PM +0200, Patrick McHardy wrote:
>> +static bool
>> +route_mt6(const struct sk_buff *skb, const struct net_device *in,
>> +           const struct net_device *out, const struct xt_match *match,
>> +           const void *matchinfo, int offset, unsigned int protoff,
>> +           bool *hotdrop)
>> +{
>> +	const struct xt_route_info *info = matchinfo;
>> +	const struct ipv6hdr *iph = ipv6_hdr(skb);
>> +	struct fib6_node *fn;
>> +	struct flowi fl = {0};
>> +
>> +	switch (info->mode) {
>> +	case XT_ROUTE_SRC_EXISTS:
>> +		fl.nl_u.ip6_u.daddr = iph->saddr;
>> +		fn = fib6_lookup(&dev_net(in)->ipv6.fib6_main_tbl->tb6_root, &fl.fl6_dst, NULL);
>
> This is always using the main table, which is inconsistent
> with the IPv4 support. It also shouldn't call IPv6 functions
> directly to avoid incorrect module dependencies.

What are the alternatives?  If we need to support IPv6 in the match, then
we need to call the functions directly, no?  Is there a helper function
I'm missing?

Phil
