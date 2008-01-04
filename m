From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 15/27] xt_length match, revision 1
Date: Fri, 04 Jan 2008 16:22:49 +0100
Message-ID: <477E4F49.3000405@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022129270.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYADPZy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:25:54 -0500
In-Reply-To: <Pine.LNX.4.64.0801022129270.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ad446d5b2c0b32ead9dd86b9c10356c4617eeaf5
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:22:16 2008 +0100
>=20
>     [NETFILTER]: xt_length match, revision 1
>    =20
>     Introduce xt_length match revision 1. It adds support for layer4 =
and
>     layer5 length matching.
>    =20
> +enum {
> +	XT_LENGTH_INVERT =3D 1 << 0,
> +
> +	/* IP header plus payload */
> +	XT_LENGTH_LAYER3 =3D 1 << 3,
> +
> +	/* TCP/UDP/etc. header plus payload */
> +	XT_LENGTH_LAYER4 =3D 1 << 4,
> +
> +	/* TCP/UDP/etc. payload */
> +	XT_LENGTH_LAYER5 =3D 1 << 5,

This seems a bit odd, please don't leave holes.

> +++ b/net/netfilter/xt_length.c
> @@ -1,18 +1,32 @@
> -/* Kernel module to match packet length. */
> -/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
> +/*
> + *	xt_length - Netfilter module to match packet length
>   *
> - * This program is free software; you can redistribute it and/or mod=
ify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> + *	(C) 1999-2001 James Morris <jmorros@intercode.com.au>
> + *	Copyright =A9 CC Computer Consultants GmbH, 2007-2008
> + *	Jan Engelhardt <jengelh@computergmbh.de>
> + *
> + *	This program is free software; you can redistribute it and/or mod=
ify
> + *	it under the terms of the GNU General Public License version 2 as
> + *	published by the Free Software Foundation.
>   */
> -
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
> +#include <linux/icmp.h>
> +#include <linux/ip.h>
>  #include <linux/ipv6.h>
> +#include <linux/tcp.h>
> +#include <linux/udp.h>
>  #include <net/ip.h>
> -
> -#include <linux/netfilter/xt_length.h>
> +#include <net/ipv6.h>
>  #include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_length.h>
> +#include <linux/netfilter_ipv6/ip6_tables.h>
> +#ifndef NEXTHDR_IPV4
> +#	define NEXTHDR_IPV4 4

This should be IPPROTO_IPIP I guess.

> +#endif
> +#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLE=
S_MODULE)
> +#	define WITH_IPV6 1

Please use the CONFIG defines directly, its only one or two chunks of
code that need them.

> +static bool xtlength_layer5_tcp(unsigned int *length, const struct s=
k_buff *skb,
> +                                unsigned int offset)
> +{
> +	const struct tcphdr *tcph;
> +	struct tcphdr buf;
> +
> +	tcph =3D skb_header_pointer(skb, offset, sizeof(buf), &buf);
> +	if (tcph =3D=3D NULL)
> +		return false;
> +
> +	*length =3D skb->len - offset - 4 * tcph->doff;

This can underflow. The extra function also seems like overkill.

> +	return true;
> +}
> +
> +static inline bool
> +xtlength_layer5(unsigned int *length, const struct sk_buff *skb,
> +                unsigned int prot, unsigned int offset)
> +{
> +	switch (prot) {
> +	case IPPROTO_TCP:
> +		return xtlength_layer5_tcp(length, skb, offset);
> +	case IPPROTO_UDP:
> +	case IPPROTO_UDPLITE:
> +		*length =3D skb->len - offset - sizeof(struct udphdr);
> +		return true;
> +	case IPPROTO_ICMP:
> +		*length =3D skb->len - offset - sizeof(struct icmphdr);
> +		return true;
> +	case IPPROTO_ICMPV6:
> +		*length =3D skb->len - offset - offsetof(struct icmp6hdr, icmp6_da=
taun);
> +		return true;
> +	case IPPROTO_AH:
> +		*length =3D skb->len - offset - sizeof(struct ip_auth_hdr);
> +		return true;
> +	case IPPROTO_ESP:
> +		*length =3D skb->len - offset - sizeof(struct ip_esp_hdr);
> +		return true;
> +	}

I'm missing SCTP and DCCP. We try to consistently support at least all
protocols implemented in Linux itself. I'm also wondering what this is
actually useful for? The only useful thing I can imagine is TCP since
its useful for matching on ACKs without data, all others have fixed
sizes and can easily be implemented in userspace.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
