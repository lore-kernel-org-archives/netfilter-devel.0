From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 24/27] Merge ipt_REJECT and ip6t_REJECT into xt_REJECT
Date: Tue, 08 Jan 2008 16:59:55 +0100
Message-ID: <47839DFB.9020904@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022132210.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63409 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYAHQDz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:03:55 -0500
In-Reply-To: <Pine.LNX.4.64.0801022132210.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 84d36d4710f680edddb67ce30202818d95dbe32c
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 20:14:28 2008 +0100
> 
>     [NETFILTER]: Merge ipt_REJECT and ip6t_REJECT into xt_REJECT
>     

> +static inline void
> +reject_send_unreach6(struct sk_buff *skb_in, unsigned char code,
> +                     unsigned int hooknum)
> +{
> +	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
> +		skb_in->dev = init_net.loopback_dev;
> +
> +	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0, NULL);
> +}


This adds a runtime dependency on ipv6, which I just recently
got rid of for all other modules. Adding an ip_tables rule
should never cause ipv6 to be loaded. I'd suggest adding a
new function pointer to nf_afinfo for this. That might even
allow some further code unification.
