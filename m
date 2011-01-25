From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: iptables MARK + ip rule fwmark NOT working with load balance
Date: Tue, 25 Jan 2011 20:56:06 +0100
Message-ID: <1295985366.2633.10.camel@edumazet-laptop>
References: <AANLkTinT4NGYFPSCA43b9+6RYATe+WtN1Yh7_0HGM3pp@mail.gmail.com>
	 <AANLkTiknnxtm6eZOOraL50wvqpopzsapzU1HmK2K4Lse@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Davi Baldin Tavares <davi@presentia.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1AYT4L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:56:11 -0500
Received: by wyb28 with SMTP id 28so155220wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2011 11:56:10 -0800 (PST)
In-Reply-To: <AANLkTiknnxtm6eZOOraL50wvqpopzsapzU1HmK2K4Lse@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 25 janvier 2011 =C3=A0 17:19 -0200, Davi Baldin Tavares a =C3=A9=
crit :
> Hello List,
>=20
> I have two NICs (eth1 and eth2) on my box, each one connected over a
> different ISP and both are configured in loadbalance (nexthop bla
> bla).
>=20
> I'm unable to use a specific interface by marking packets with
> iptables MARK/CONNMARK regardless the load-balancing on the box. I
> would like to set up for example all SMTP traffic (locally generated
> or not) going out only by the eth2, however, I can't see this working
> out.
>=20
> My setup is:
>=20
> # iptables -t mangle -L -n -v
> Chain PREROUTING (policy ACCEPT 753K packets, 356M bytes)
>  pkts bytes target     prot opt in     out     source               d=
estination
>   810 35766 CONNMARK   all  --  eth2   *       0.0.0.0/0
> 0.0.0.0/0           state NEW CONNMARK set 0x81
>    19  2810 CONNMARK   all  --  eth3   *       0.0.0.0/0
> 0.0.0.0/0           state NEW CONNMARK set 0x82
>  7657  670K CONNMARK   all  --  *      *       0.0.0.0/0
> 0.0.0.0/0           CONNMARK restore
>=20
> Chain OUTPUT (policy ACCEPT 381K packets, 185M bytes)
>  pkts bytes target     prot opt in     out     source               d=
estination
>    32  2099 CONNMARK   tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0           tcp dpt:25 CONNMARK set 0x82
>    32  2099 MARK       tcp  --  *      *       0.0.0.0/0
> 0.0.0.0/0           tcp dpt:25 MARK set 0x82
>=20
> (As you can see, packages are being marked).
>=20
> # ip rule list
> 0:      from all lookup 255
> 3:      from all fwmark 0x82 lookup link2
> 3:      from all fwmark 0x81 lookup link1

same rule numbers 3 and 3 ??
> 10:     from 200.174.194.44 lookup link2
> 10:     from 201.26.37.40 lookup link1

ditto

> 32766:  from all lookup main
> 32767:  from all lookup default
>=20
> # ip route list
> 200.174.194.40/29 dev eth3  proto kernel  scope link  src 200.174.194=
=2E44
> 201.26.37.0/24 dev eth2  proto kernel  scope link  src 201.26.37.40
> default
>         nexthop via 200.174.194.41  dev eth3 weight 1
>         nexthop via 201.26.37.1  dev eth2 weight 3
>=20
> At this point the mark 0x82 is related to the link on the eth3 (net
> 200.174.194.41). However, using this setup, the outgoing packets
> almost always came from eth2 (which has a bigger weight on the
> balance). I believe the balance is working (and acting on this case)
> and the mark and route from a specific interface is not.
>=20
> Do you happen to know something that could give me some light or
> directions on order to put this working fine?

Hello

What is your kernel version ?

ip route list table link2
ip route list table link1



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
