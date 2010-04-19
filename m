From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xtables: inclusion of xt_TEE
Date: Mon, 19 Apr 2010 14:42:02 +0200
Message-ID: <4BCC4F9A.90709@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-2-git-send-email-jengelh@medozas.de> <4BCC4A83.3090302@trash.net> <alpine.LSU.2.01.1004191434530.9177@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56171 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0DSMmD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:42:03 -0400
In-Reply-To: <alpine.LSU.2.01.1004191434530.9177@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-04-19 14:20, Patrick McHardy wrote:
>>> +static bool
>>> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
>>> +{
>>> +	const struct iphdr *iph = ip_hdr(skb);
>>> +	struct net *net = pick_net(skb);
>>> +	struct rtable *rt;
>>> +	struct flowi fl;
>>> +
>>> +	memset(&fl, 0, sizeof(fl));
>>> +	if (!tee_tg_route_oif(&fl, net, info))
>>> +		return false;
>> Redoing the interface lookup once per packet is really highly
>> suboptimal. I'll change that to do the lookup once per new
>> rule or simply in userspace.
> 
> I thought about that too. But if you grab a reference to the dev on
> rule insertion, the rule would stop working when you down and up an
> interface, which does not match the regular iptables behavior (-i and
> -o options) at all.

Not down and up, unregister and register. But we don't need a
reference, just the ifindex. That can be updated on netdev events.
