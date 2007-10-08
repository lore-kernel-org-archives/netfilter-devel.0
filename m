From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Mon, 08 Oct 2007 07:00:47 +0200
Message-ID: <4709B97F.2000106@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de> <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr> <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51489 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXJHFDI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 01:03:08 -0400
In-Reply-To: <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Add xt_TCPOPTSTRIP, a module to replace TCP options by NOPs.

A few minor comments:

> +#define tcpoptstrip_set_bit(bmap, idx) \
> +	(bmap[(idx) >> 5] |= 1UL << (idx & 31))
> +#define tcpoptstrip_test_bit(bmap, idx) \
> +	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) != 0)


Why UL? You're using 32 bit variables for the bitmap ..


> +struct xt_tcpoptstrip_info {
> +	u_int32_t strip_bmap[8];
> +};
> +


> +config NETFILTER_XT_TARGET_TCPOPTSTRIP
> +	tristate '"TCPOPTSTRIP" target support'
> +	depends on NETFILTER_XTABLES


EXPERIMENTAL please

> +	---help---
> +	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
> +	  TCP options from TCP packets.


> +static unsigned int
> +xt_tcpoptstrip_target6(struct sk_buff **pskb, const struct net_device *in,
> +                       const struct net_device *out, unsigned int hooknum,
> +                       const struct xt_target *target, const void *targinfo)
> +{
> +	struct ipv6hdr *ipv6h = ipv6_hdr(*pskb);
> +	unsigned int tcphoff;
> +	u_int8_t nexthdr;
> +
> +	nexthdr = ipv6h->nexthdr;
> +	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);


This needs #ifdef CONFIG_IPV6

A Signed-off-by: line by Sven would also be appreciated - I guess
you can just include the original one since you modified his
patch.
