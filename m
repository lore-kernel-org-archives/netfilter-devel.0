From: xiaoyu Du <tingsrain@gmail.com>
Subject: Re: [patch nf-next] IPVS: ICMPv6 checksum calculation
Date: Fri, 20 Aug 2010 19:14:38 +0800
Message-ID: <AANLkTi=tVieTnz1R=9Jh45LweUwJ=mtszM1U9XAEVrK7@mail.gmail.com>
References: <20100817070036.GB742@verge.net.au>
	<Pine.LNX.4.58.1008171143500.2771@u.domain.uli>
	<20100818002149.GA18114@verge.net.au>
	<20100817.172602.193696444.davem@davemloft.net>
	<AANLkTimW6UszuFspN+S3m8WdS1dPcwTmy+m2kT4X+7MR@mail.gmail.com>
	<20100818055716.GA32429@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, ja@ssi.bg,
	linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34166 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0HTLOj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:14:39 -0400
In-Reply-To: <20100818055716.GA32429@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just replied to thank for his idea then, as he gived me some ideas
on how to manipulate
checksum. I tested the code today, but it doesn't seem to work. (I just=
 wrote a
netfilter module and hooked the code on local_out , then ping6 the
address on another PC,
It failed.). I'll find out why.

2010/8/18 Simon Horman <horms@verge.net.au>:
> On Wed, Aug 18, 2010 at 12:20:14PM +0800, xiaoyu Du wrote:
>> 2010/8/18 David Miller <davem@davemloft.net>:
>> > From: Simon Horman <horms@verge.net.au>
>> > Date: Wed, 18 Aug 2010 09:21:49 +0900
>> >
>> >> [ CCing netdev for comment ]
>> >>
>> >> On Tue, Aug 17, 2010 at 12:25:56PM +0300, Julian Anastasov wrote:
>> > =C2=A0...
>> >>> =C2=A0 =C2=A0 =C2=A0May be ip_vs_checksum_complete() is not need=
ed here?
>> >>> Also, skb->csum is not valid for every ip_summed value.
>> >>> May be we need to apply CHECKSUM_PARTIAL kind of setup for the I=
Pv6.
>> >>> Such example is net/ipv6/udp.c:udp6_ufo_send_check().
>> >>> Later dev_queue_xmit() and skb_checksum_help() should take care
>> >>> for the next steps. Something like this can be tested:
>> >>>
>> >>> =C2=A0 =C2=A0 =C2=A0icmph->icmp6_cksum =3D csum_ipv6_magic(&iph-=
>saddr,
>> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&iph->daddr,
>> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skb->len - icmp_=
offset, IPPROTO_ICMPV6,
>> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00);
>> >>> =C2=A0 =C2=A0 =C2=A0skb->csum_start =3D skb_network_header(skb) =
- skb->head +
>> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0icmp_offset;
>> >>> =C2=A0 =C2=A0 =C2=A0skb->csum_offset =3D offsetof(struct icmp6hd=
r, icmp6_cksum);
>> >>> =C2=A0 =C2=A0 =C2=A0skb->ip_summed =3D CHECKSUM_PARTIAL;
>> >>>
>> >
>> > Yes, using CHECKSUM_PARTIAL unconditionally would work.
>> >
>> Thanks, I learned this. You gave me a big cake.
>
> [ please don't top-post ]
>
> Xiaoyu, are you in a position to test the code proposed by Julian?
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
