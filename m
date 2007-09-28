From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 17:02:48 +0200
Message-ID: <46FD1798.2020302@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54175 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXI1PDR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:03:17 -0400
In-Reply-To: <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Since I had nothing better to do, I did a cleanup :)


Great :) My main question is what the use case of this is.


> @@ -0,0 +1,155 @@
> +/*
> + * A module for stripping a specific TCP option from TCP packets.
> + *
> + * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/tcp.h>
> +#include <net/ipv6.h>
> +#include <net/tcp.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_tcpudp.h>

tcpudp.h? Shouldn't be needed.

> +#include <linux/netfilter/xt_TCPOPTSTRIP.h>
> +
> +static void fast_csum(__sum16 *csum, const u_int8_t *optr,
> +                      const u_int8_t *nptr, const int offset)
> +{
> +	u_int8_t s[4];
> +
> +	if (offset & 1) {
> +		s[0] = s[2] = 0;
> +		s[1] = ~*optr;
> +		s[3] = *nptr;
> +	} else {
> +		s[1] = s[3] = 0;
> +		s[0] = ~*optr;
> +		s[2] = *nptr;
> +	}
> +
> +	*csum = csum_fold(csum_partial(s, 4, ~csum_unfold(*csum)));
> +}


Please use the generic checksumming helpers.

> +
> +static unsigned int
> +tcpoptstrip_mangle_packet(struct sk_buff **pskb,
> +                          const struct xt_tcpoptstrip_info *info,
> +                          unsigned int tcphoff, unsigned int minlen)
> +{
> +	const u_int8_t newopt = TCPOPT_NOP;
> +	unsigned int optl, tcplen, i, j;
> +	struct tcphdr *tcph;
> +	u_int8_t *opt;
> +
> +	if (!skb_make_writable(pskb, (*pskb)->len))
> +		return NF_DROP;
> +
> +	tcplen = (*pskb)->len - tcphoff;
> +	tcph   = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
> +
> +	if (tcplen != 4 * tcph->doff)
> +		return NF_DROP;


Seems to be copied from TCPMSS - but I don't see why you shouldn't allow
stripping options from packets with data.

> +
> +	opt = (u_int8_t *)tcph;
> +
> +	for (i = sizeof(struct tcphdr); i < 4 * tcph->doff; i += optl) {
> +		optl = optlen(opt, i);
> +
> +		if (optl + i > tcph->doff*4)
> +			break;
> +
> +		if (opt[i] == info->tcpoption) {
> +			for (j = 0; j < optl; j++)
> +				fast_csum(&tcph->check, opt + i + j,
> +				          &newopt, i + j);
> +			if (optl & 1)
> +				fast_csum(&tcph->check, &newopt,
> +				          &newopt, i + j);
> +			memset(opt+i, newopt, optl);


For TCPOPTSTRIP I would expect either real stripping or replacement
by TCPOPT_NOP. In which cases does replacement by something else
make sense?

