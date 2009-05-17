From: =?UTF-8?Q?Jan_Rathousk=C3=BD?= <jan.rathousky@gmail.com>
Subject: Re: port based routing for local generated connections
Date: Sun, 17 May 2009 10:15:03 +0200
Message-ID: <a14f8c120905170115s44e7f834t2113f30f97b3555e@mail.gmail.com>
References: <a14f8c120905161628i6b129e87m17f6db647115315c@mail.gmail.com>
	 <alpine.LSU.2.00.0905170920130.20778@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38220 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZEQIPE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 04:15:04 -0400
Received: by fxm2 with SMTP id 2so2688410fxm.37
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2009 01:15:04 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905170920130.20778@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/5/17 Jan Engelhardt <jengelh@medozas.de>:
>It also applies to local traffic. The packet will be re-evaluated by
>routing if it changed its mark in the OUTPUT chain.

It doesn't work.

debian:/home/houska# iptables -A OUTPUT -t mangle -p tcp --dport 60353
-j MARK --set-mark 100
debian:/home/houska# iptables -A OUTPUT -t mangle -p tcp --dport 60354
-j MARK --set-mark 100
debian:/home/houska# ip route add default via 10.6.6.6 dev ppp0 table c=
dma
debian:/home/houska# ip rule add from all fwmark 100 table cdma
debian:/home/houska#
debian:/home/houska# iptables -L -t mangle
Chain PREROUTING (policy ACCEPT)
target =C2=A0 =C2=A0 prot opt source =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 destination

=2E..

Chain OUTPUT (policy ACCEPT)
target =C2=A0 =C2=A0 prot opt source =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 destination
MARK =C2=A0 =C2=A0 =C2=A0 tcp =C2=A0-- =C2=A0anywhere =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 anywhere =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0tcp
dpt:60353 MARK xset 0x64/0xffffffff
MARK =C2=A0 =C2=A0 =C2=A0 tcp =C2=A0-- =C2=A0anywhere =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 anywhere =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0tcp
dpt:60354 MARK xset 0x64/0xffffffff

Chain POSTROUTING (policy ACCEPT)
target =C2=A0 =C2=A0 prot opt source =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 destination
debian:/home/houska#
debian:/home/houska# ip route ls table cdma
default via 10.6.6.6 dev ppp0
debian:/home/houska#
debian:/home/houska# ip route ls
10.160.3.42 dev ppp0 =C2=A0proto kernel =C2=A0scope link =C2=A0src 10.1=
62.62.199
debian:/home/houska#
debian:/home/houska# ip rule ls
0: =C2=A0 =C2=A0 =C2=A0from all lookup local
32765: =C2=A0from all fwmark 0x64 lookup cdma
32766: =C2=A0from all lookup main
32767: =C2=A0from all lookup default
debian:/home/houska#
debian:/home/houska# tcptraceroute ip.add.re.ss 60353
connect: Network is unreachable
debian:/home/houska# tcptraceroute ip.add.re.ss 60354
connect: Network is unreachable
debian:/home/houska#

:(
Same problem is with OpenVPN. What am I doing wrong?

Thanks
Jan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
