From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Mon, 8 Oct 2007 17:55:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710081753390.10239@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
 <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr>
 <4709B97F.2000106@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48887 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJHPzX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:55:23 -0400
In-Reply-To: <4709B97F.2000106@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 8 2007 07:00, Patrick McHardy wrote:
>
>A few minor comments:
>
>> +#define tcpoptstrip_set_bit(bmap, idx) \
>> +	(bmap[(idx) >> 5] |= 1UL << (idx & 31))
>> +#define tcpoptstrip_test_bit(bmap, idx) \
>> +	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) != 0)
>
>Why UL? You're using 32 bit variables for the bitmap ..

Blame linux/bitmap.h. It uses 1UL, but at the same time, limits itself
to uint32_t-based operations.

>> +	nexthdr = ipv6h->nexthdr;
>> +	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
>
>This needs #ifdef CONFIG_IPV6

xt_TCPMSS also uses ipv6_skip_exthdr, but has no such protection.
xt_hashlimit uses ipv6_find_hdr, would not that need CONFIG_IPV6 protection
too?
