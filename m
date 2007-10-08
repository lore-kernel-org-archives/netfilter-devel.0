From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Mon, 08 Oct 2007 18:27:01 +0200
Message-ID: <470A5A55.7010704@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de> <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr> <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr> <4709B97F.2000106@trash.net> <Pine.LNX.4.64.0710081753390.10239@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbXJHQ3e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:29:34 -0400
In-Reply-To: <Pine.LNX.4.64.0710081753390.10239@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 8 2007 07:00, Patrick McHardy wrote:
> 
>>A few minor comments:
>>
>>
>>>+#define tcpoptstrip_set_bit(bmap, idx) \
>>>+	(bmap[(idx) >> 5] |= 1UL << (idx & 31))
>>>+#define tcpoptstrip_test_bit(bmap, idx) \
>>>+	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) != 0)
>>
>>Why UL? You're using 32 bit variables for the bitmap ..
> 
> 
> Blame linux/bitmap.h. It uses 1UL, but at the same time, limits itself
> to uint32_t-based operations.


It uses purely unsigned long, just as the bitops do.

>>>+	nexthdr = ipv6h->nexthdr;
>>>+	tcphoff = ipv6_skip_exthdr(*pskb, sizeof(*ipv6h), &nexthdr);
>>
>>This needs #ifdef CONFIG_IPV6
> 
> 
> xt_TCPMSS also uses ipv6_skip_exthdr, but has no such protection.
> xt_hashlimit uses ipv6_find_hdr, would not that need CONFIG_IPV6 protection
> too?


Both use CONFIG_IP6_NF_IPTABLES, which is a superset of CONFIG_IPV6.
Will try if TCPOPTSTRIP actually needs that too.
