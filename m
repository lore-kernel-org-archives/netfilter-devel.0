From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Thu, 08 Nov 2007 10:03:25 +0100
Message-ID: <4732D0DD.5020609@plouf.fr.eu.org>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net> <005b01c82151$4acac750$6500a8c0@ronPc> <473247F6.8090204@trash.net> <000a01c82199$92441f30$bb0b10ac@FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Ron Lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <000a01c82199$92441f30$bb0b10ac@FireEye.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Ron Lai a =E9crit :
>=20
> -ip route show
> 172.16.0.0/12 dev ether1  proto kernel  scope link  src 172.16.119.87
> default via 172.16.1.1 dev ether1  metric 1
>=20
> -brctl show
> bridge name     bridge id               STP enabled     interfaces
> ether1          8000.00d0680df494       no              pether1
[...]
>>> I am using a single bridge with one device.

But from the information you provided it seems that the bridge "ether1"=
=20
is the only active interface in you system. So IP forwarding can only=20
happen from a bridge (ether1) to a bridge (ether1), which is the=20
situation causing the IP POST_ROUTING hook to be called twice.
