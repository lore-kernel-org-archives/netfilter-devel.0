From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Tue, 06 Nov 2007 16:17:52 +0100
Message-ID: <473085A0.7050202@plouf.fr.eu.org>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <47307498.70104@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Patrick McHardy a =E9crit :
>=20
> The bridge netfilter code calls the IP POST_ROUTING
> hook for outgoing packets, but the packet already went through it
> during forwarding.

Indeed I noticed once that a forwarded (i.e. not bridged) IP packet goe=
s=20
through the iptables POSTROUTING chain twice (after iptables FORWARD an=
d=20
after ebtables POSTROUTING) when the input and output interfaces are=20
both bridges. But only once (after iptables FORWARD) when only the=20
output interface is a bridge. Puzzles me why.
