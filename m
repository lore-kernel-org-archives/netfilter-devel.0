From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Sat, 29 Sep 2007 11:04:52 +0200
Message-ID: <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:32842 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbXI2JEy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:04:54 -0400
In-Reply-To: <46FD1798.2020302@trash.net> (Patrick McHardy's message of "Fri\, 28 Sep 2007 17\:02\:48 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> Jan Engelhardt wrote:
>> Since I had nothing better to do, I did a cleanup :)
>
> Great :) My main question is what the use case of this is.

Main intention for writing this module was to strip of TCP Options from
the SYN packets sent by some Hosts - for example Hosts that are
announcing that they can do window scaling, but in fact some broken
implementation/routers inbetween are preventing this. Simply stripping
of these Option allows communicating with such device, without the need
to disable window scaling kernel-wide.

The first version was only stripping the Windows scaling option, but it
may be useful for other cases - so i decided to make the stripped option
configurable.

>
>> @@ -0,0 +1,155 @@
>> +/*
>> + * A module for stripping a specific TCP option from TCP packets.
>> + *
>> + * Copyright (C) 2007 Sven Schnelle <svens@bitebene.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/ip.h>
>> +#include <linux/ipv6.h>
>> +#include <linux/tcp.h>
>> +#include <net/ipv6.h>
>> +#include <net/tcp.h>
>> +#include <linux/netfilter/x_tables.h>
>> +#include <linux/netfilter/xt_tcpudp.h>
>
> tcpudp.h? Shouldn't be needed.
>
>> +#include <linux/netfilter/xt_TCPOPTSTRIP.h>
>> +
>> +static void fast_csum(__sum16 *csum, const u_int8_t *optr,
>> +                      const u_int8_t *nptr, const int offset)
>> +{
>> +	u_int8_t s[4];
>> +
>> +	if (offset & 1) {
>> +		s[0] = s[2] = 0;
>> +		s[1] = ~*optr;
>> +		s[3] = *nptr;
>> +	} else {
>> +		s[1] = s[3] = 0;
>> +		s[0] = ~*optr;
>> +		s[2] = *nptr;
>> +	}
>> +
>> +	*csum = csum_fold(csum_partial(s, 4, ~csum_unfold(*csum)));
>> +}
>
>
> Please use the generic checksumming helpers.

something like this?:

+       if (opt[i] == tinfo->tcpoption) {
+           for(j = 0; j < optl; j++) {
+                   o = opt[i+j];
+                   n = TCPOPT_NOP;
+                   if ((i + j) % 2 == 0) {
+                       o <<= 8;
+                       n <<= 8;
+                   }
+                   nf_proto_csum_replace2(&tcph->check, *pskb,
+                                          htons(o), htons(n), 0);
+           }
+           memset(opt+i, TCPOPT_NOP, optl);
+        }

As i'm currently travelling, i can't test the code above - will do the
end of next week, and resubmit.

>> +
>> +static unsigned int
>> +tcpoptstrip_mangle_packet(struct sk_buff **pskb,
>> +                          const struct xt_tcpoptstrip_info *info,
>> +                          unsigned int tcphoff, unsigned int minlen)
>> +{
>> +	const u_int8_t newopt = TCPOPT_NOP;
>> +	unsigned int optl, tcplen, i, j;
>> +	struct tcphdr *tcph;
>> +	u_int8_t *opt;
>> +
>> +	if (!skb_make_writable(pskb, (*pskb)->len))
>> +		return NF_DROP;
>> +
>> +	tcplen = (*pskb)->len - tcphoff;
>> +	tcph   = (struct tcphdr *)(skb_network_header(*pskb) + tcphoff);
>> +
>> +	if (tcplen != 4 * tcph->doff)
>> +		return NF_DROP;
>
>
> Seems to be copied from TCPMSS - but I don't see why you shouldn't allow
> stripping options from packets with data.

Indeed, i've used xt_TCPMSS.c as some kind of template. Could be removed
of course.

>> +
>> +	opt = (u_int8_t *)tcph;
>> +
>> +	for (i = sizeof(struct tcphdr); i < 4 * tcph->doff; i += optl) {
>> +		optl = optlen(opt, i);
>> +
>> +		if (optl + i > tcph->doff*4)
>> +			break;
>> +
>> +		if (opt[i] == info->tcpoption) {
>> +			for (j = 0; j < optl; j++)
>> +				fast_csum(&tcph->check, opt + i + j,
>> +				          &newopt, i + j);
>> +			if (optl & 1)
>> +				fast_csum(&tcph->check, &newopt,
>> +				          &newopt, i + j);
>> +			memset(opt+i, newopt, optl);
>
>
> For TCPOPTSTRIP I would expect either real stripping or replacement
> by TCPOPT_NOP. In which cases does replacement by something else
> make sense?

It does replacement by TCPOPT_NOP - the newopt is a const
TCPOPT_NOP. But i've changed this with the checksum code above.
Of course we can choose another name which describes the task of this
target better - didn't care much about it the name in the first case.

I think replacing the TCP Option by nop is cheaper than moving all
remaining options.
