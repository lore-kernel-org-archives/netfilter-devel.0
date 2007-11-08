From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Thu, 08 Nov 2007 12:43:13 +0100
Message-ID: <4732F651.9090500@trash.net>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net> <005b01c82151$4acac750$6500a8c0@ronPc> <473247F6.8090204@trash.net> <000a01c82199$92441f30$bb0b10ac@FireEye.com> <4732D0DD.5020609@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ron Lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760727AbXKHLnn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 06:43:43 -0500
In-Reply-To: <4732D0DD.5020609@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Ron Lai a =E9crit :
>>
>> -ip route show
>> 172.16.0.0/12 dev ether1  proto kernel  scope link  src 172.16.119.8=
7
>> default via 172.16.1.1 dev ether1  metric 1
>>
>> -brctl show
>> bridge name     bridge id               STP enabled     interfaces
>> ether1          8000.00d0680df494       no              pether1
> [...]
>>>> I am using a single bridge with one device.
>=20
> But from the information you provided it seems that the bridge "ether=
1"=20
> is the only active interface in you system. So IP forwarding can only=
=20
> happen from a bridge (ether1) to a bridge (ether1), which is the=20
> situation causing the IP POST_ROUTING hook to be called twice.


That explains how it can happen with only a single bridge, thanks :)

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
