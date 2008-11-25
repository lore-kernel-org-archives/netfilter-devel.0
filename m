From: =?gb2312?B?1dTA2g==?= <zhao.lei129@pku.edu.cn>
Subject: Re: Re: NF_STOLEN
Date: Tue, 25 Nov 2008 11:23:33 +0800
Message-ID: <23c0b023d0f5.23d0f523c0b0@pku.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sunrise.PKU.EDU.CN ([162.105.129.21]:49877 "HELO
	sunrise.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753298AbYKYDTR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 22:19:17 -0500
Content-Language: zh-CN
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Thank you for your reply.

As per your advice, I call ip_rcv_finish (referenced by the argument
okfn) in my NF_IP_PRE_ROUTING hook function. But I got segmentation
fault. Could you explain in a little more detail what should I do or
what was the problem with the above method? I'm a newbie in netfilter
and linux kernel programming.

Thanks a lot.


=B4=D3: Jan Engelhardt <jengelh@medozas.de>
=D6=F7=CC=E2: Re: NF_STOLEN
>
> On Friday 2008-11-21 03:17, =D5=D4=C0=DA wrote:
>
> >Hi,
> >
> >I register a NF_IP_PRE_ROUTING hook that check the incoming
> packets. I=A1=AFm
> >trying to return NF_STOLEN on particular TCP packets and later
> pass them
> >to the TCP module of the kernel. Any advice about how this can be
> achieved?
>
> PREROUTING is invoked from here:
>
> net/ipv4/ip_input.c:
>        return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, dev,
> NULL,
>                       ip_rcv_finish);
> or here, net/ipv6/ip6_input.c:
>        return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, dev,
> NULL,
>                       ip6_rcv_finish);
> (or whichever other protocol you use)
> So you just call the appropriate functions (ip{,6}_rcv_finish).
>=20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
