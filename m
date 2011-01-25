From: Davi Baldin Tavares <davi@presentia.com.br>
Subject: iptables MARK + ip rule fwmark NOT working with load balance
Date: Tue, 25 Jan 2011 17:19:00 -0200
Message-ID: <AANLkTiknnxtm6eZOOraL50wvqpopzsapzU1HmK2K4Lse@mail.gmail.com>
References: <AANLkTinT4NGYFPSCA43b9+6RYATe+WtN1Yh7_0HGM3pp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40820 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1AYTTW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:19:22 -0500
Received: by bwz15 with SMTP id 15so453649bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2011 11:19:21 -0800 (PST)
In-Reply-To: <AANLkTinT4NGYFPSCA43b9+6RYATe+WtN1Yh7_0HGM3pp@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

I have two NICs (eth1 and eth2) on my box, each one connected over a
different ISP and both are configured in loadbalance (nexthop bla
bla).

I'm unable to use a specific interface by marking packets with
iptables MARK/CONNMARK regardless the load-balancing on the box. I
would like to set up for example all SMTP traffic (locally generated
or not) going out only by the eth2, however, I can't see this working
out.

My setup is:

# iptables -t mangle -L -n -v
Chain PREROUTING (policy ACCEPT 753K packets, 356M bytes)
=A0pkts bytes target=A0=A0=A0=A0 prot opt in=A0=A0=A0=A0 out=A0=A0=A0=A0=
 source=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 destination
=A0 810 35766 CONNMARK=A0=A0 all=A0 --=A0 eth2=A0=A0 *=A0=A0=A0=A0=A0=A0=
 0.0.0.0/0
0.0.0.0/0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state NEW CONNMARK set 0x81
=A0=A0 19=A0 2810 CONNMARK=A0=A0 all=A0 --=A0 eth3=A0=A0 *=A0=A0=A0=A0=A0=
=A0 0.0.0.0/0
0.0.0.0/0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state NEW CONNMARK set 0x82
=A07657=A0 670K CONNMARK=A0=A0 all=A0 --=A0 *=A0=A0=A0=A0=A0 *=A0=A0=A0=
=A0=A0=A0 0.0.0.0/0
0.0.0.0/0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CONNMARK restore

Chain OUTPUT (policy ACCEPT 381K packets, 185M bytes)
=A0pkts bytes target=A0=A0=A0=A0 prot opt in=A0=A0=A0=A0 out=A0=A0=A0=A0=
 source=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 destination
=A0=A0 32=A0 2099 CONNMARK=A0=A0 tcp=A0 --=A0 *=A0=A0=A0=A0=A0 *=A0=A0=A0=
=A0=A0=A0 0.0.0.0/0
0.0.0.0/0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tcp dpt:25 CONNMARK set 0x82
=A0=A0 32=A0 2099 MARK=A0=A0=A0=A0=A0=A0 tcp=A0 --=A0 *=A0=A0=A0=A0=A0 =
*=A0=A0=A0=A0=A0=A0 0.0.0.0/0
0.0.0.0/0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tcp dpt:25 MARK set 0x82

(As you can see, packages are being marked).

# ip rule list
0:=A0=A0=A0=A0=A0 from all lookup 255
3:=A0=A0=A0=A0=A0 from all fwmark 0x82 lookup link2
3:=A0=A0=A0=A0=A0 from all fwmark 0x81 lookup link1
10:=A0=A0=A0=A0 from 200.174.194.44 lookup link2
10:=A0=A0=A0=A0 from 201.26.37.40 lookup link1
32766:=A0 from all lookup main
32767:=A0 from all lookup default

# ip route list
200.174.194.40/29 dev eth3=A0 proto kernel=A0 scope link=A0 src 200.174=
=2E194.44
201.26.37.0/24 dev eth2=A0 proto kernel=A0 scope link=A0 src 201.26.37.=
40
default
=A0=A0=A0=A0=A0=A0=A0 nexthop via 200.174.194.41=A0 dev eth3 weight 1
=A0=A0=A0=A0=A0=A0=A0 nexthop via 201.26.37.1=A0 dev eth2 weight 3

At this point the mark 0x82 is related to the link on the eth3 (net
200.174.194.41). However, using this setup, the outgoing packets
almost always came from eth2 (which has a bigger weight on the
balance). I believe the balance is working (and acting on this case)
and the mark and route from a specific interface is not.

Do you happen to know something that could give me some light or
directions on order to put this working fine?

Cheers,

Davi
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
