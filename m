From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Wed, 07 Nov 2007 11:59:22 +0100
Message-ID: <47319A8A.3050007@plouf.fr.eu.org>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net> <47319460.8040305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <47319460.8040305@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy a =E9crit :
>=20
> I can reproduce this with forwarding between two bridges.

This matches my own observations.

> The reason is that skb->nf_bridge still contains the data
> from the first bridge and so br_netfilter thinks this is
> a bridged packet.

Am I missing something if I think that this behaviour is badly broken ?

> I don't know how this is supposed to work,
> but it seems to me that on packets going out a bridge device
> this should be reset in case it originates from a different
> bridge (actually I think it should be reset unconditionally

So do I. Otherwise a packet received on a bridge can be forwarded back=20
to the same bridge and would be wrongly considered bridged.

> but that would probably break bridged DNAT).

Why ?
