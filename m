From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NF_STOLEN
Date: Fri, 21 Nov 2008 09:30:34 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811210929230.18600@fbirervta.pbzchgretzou.qr>
References: <1abcda1a9175.1a91751abcda@pku.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?6LW156OK?= <zhao.lei129@pku.edu.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52406 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYKUIah (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:30:37 -0500
In-Reply-To: <1abcda1a9175.1a91751abcda@pku.edu.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-11-21 03:17, =E8=B5=B5=E7=A3=8A wrote:

>Hi,
>
>I register a NF_IP_PRE_ROUTING hook that check the incoming packets. I=
=E2=80=99m
>trying to return NF_STOLEN on particular TCP packets and later pass th=
em
>to the TCP module of the kernel. Any advice about how this can be achi=
eved?=20

PREROUTING is invoked from here:

net/ipv4/ip_input.c:
        return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, dev, NUL=
L,=20
                       ip_rcv_finish);=20
or here, net/ipv6/ip6_input.c:
        return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, dev, NUL=
L,=20
                       ip6_rcv_finish);=20
(or whichever other protocol you use)
So you just call the appropriate functions (ip{,6}_rcv_finish).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
