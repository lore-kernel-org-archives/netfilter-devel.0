From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xtables: inclusion of xt_TEE
Date: Mon, 19 Apr 2010 14:20:19 +0200
Message-ID: <4BCC4A83.3090302@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55766 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DSMUU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:20:20 -0400
In-Reply-To: <1271373909-6959-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> xt_TEE can be used to clone and reroute a packet. This can for
> example be used to copy traffic at a router for logging purposes
> to another dedicated machine.
> 
> References: http://www.gossamer-threads.com/lists/iptables/devel/68781

Applied, thanks Jan.

> +static bool tee_tg_route_oif(struct flowi *f, struct net *net,
> +			     const struct xt_tee_tginfo *info)
> +{
> +	const struct net_device *dev;
> +
> +	if (*info->oif != '\0')
> +		return true;
> +	dev = dev_get_by_name(net, info->oif);
> +	if (dev == NULL)
> +		return false;
> +	f->oif = dev->ifindex;
> +	return true;
> +}
> +
> +static bool
> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
> +{
> +	const struct iphdr *iph = ip_hdr(skb);
> +	struct net *net = pick_net(skb);
> +	struct rtable *rt;
> +	struct flowi fl;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	if (!tee_tg_route_oif(&fl, net, info))
> +		return false;

Redoing the interface lookup once per packet is really highly
suboptimal. I'll change that to do the lookup once per new
rule or simply in userspace.

Please also send the userspace patch you're using so I can
do some testing. Thanks.
