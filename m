From: Davi Baldin Tavares <davi@presentia.com.br>
Subject: Re: iptables MARK + ip rule fwmark NOT working with load balance
Date: Tue, 25 Jan 2011 18:06:39 -0200
Message-ID: <AANLkTinJc7swvs23acqQ98B_f80JqwELx5z0zz9rPKF6@mail.gmail.com>
References: <AANLkTinT4NGYFPSCA43b9+6RYATe+WtN1Yh7_0HGM3pp@mail.gmail.com>
 <AANLkTiknnxtm6eZOOraL50wvqpopzsapzU1HmK2K4Lse@mail.gmail.com> <1295985366.2633.10.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1AYUHC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:07:02 -0500
Received: by bwz15 with SMTP id 15so496884bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2011 12:07:00 -0800 (PST)
In-Reply-To: <1295985366.2633.10.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
CentOS release 5.5 (Final)
2.6.18-194.32.1.el5 #1 SMP Wed Jan 5 17:53:09 EST 2011 i686 i686 i386 G=
NU/Linux

# ip route list table link1
200.174.194.40/29 dev eth3  proto kernel  scope link  src 200.174.194.4=
4
192.168.19.0/24 dev eth0  proto kernel  scope link  src 192.168.19.2
201.26.37.0/24 dev eth2  proto kernel  scope link  src 201.26.37.40
default via 201.26.37.1 dev eth2

# ip route list table link2
200.174.194.40/29 dev eth3  proto kernel  scope link  src 200.174.194.4=
4
192.168.19.0/24 dev eth0  proto kernel  scope link  src 192.168.19.2
201.26.37.0/24 dev eth2  proto kernel  scope link  src 201.26.37.40
default via 200.174.194.41 dev eth3

I've a script that copy the routes from main table to the link`s
table. This is a trick I have heard in order to keep route up an
running for everywhere....

Cheers,

Davi



2011/1/25 Eric Dumazet <eric.dumazet@gmail.com>:
> Le mardi 25 janvier 2011 =E0 17:19 -0200, Davi Baldin Tavares a =E9cr=
it :
>> Hello List,
>>
>> I have two NICs (eth1 and eth2) on my box, each one connected over a
>> different ISP and both are configured in loadbalance (nexthop bla
>> bla).
>>
>> I'm unable to use a specific interface by marking packets with
>> iptables MARK/CONNMARK regardless the load-balancing on the box. I
>> would like to set up for example all SMTP traffic (locally generated
>> or not) going out only by the eth2, however, I can't see this workin=
g
>> out.
>>
>> My setup is:
>>
>> # iptables -t mangle -L -n -v
>> Chain PREROUTING (policy ACCEPT 753K packets, 356M bytes)
>> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 destination
>> =A0 810 35766 CONNMARK =A0 all =A0-- =A0eth2 =A0 * =A0 =A0 =A0 0.0.0=
=2E0/0
>> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 state NEW CONNMARK set 0x81
>> =A0 =A019 =A02810 CONNMARK =A0 all =A0-- =A0eth3 =A0 * =A0 =A0 =A0 0=
=2E0.0.0/0
>> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 state NEW CONNMARK set 0x82
>> =A07657 =A0670K CONNMARK =A0 all =A0-- =A0* =A0 =A0 =A0* =A0 =A0 =A0=
 0.0.0.0/0
>> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 CONNMARK restore
>>
>> Chain OUTPUT (policy ACCEPT 381K packets, 185M bytes)
>> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 destination
>> =A0 =A032 =A02099 CONNMARK =A0 tcp =A0-- =A0* =A0 =A0 =A0* =A0 =A0 =A0=
 0.0.0.0/0
>> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 tcp dpt:25 CONNMARK set 0x82
>> =A0 =A032 =A02099 MARK =A0 =A0 =A0 tcp =A0-- =A0* =A0 =A0 =A0* =A0 =A0=
 =A0 0.0.0.0/0
>> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 tcp dpt:25 MARK set 0x82
>>
>> (As you can see, packages are being marked).
>>
>> # ip rule list
>> 0: =A0 =A0 =A0from all lookup 255
>> 3: =A0 =A0 =A0from all fwmark 0x82 lookup link2
>> 3: =A0 =A0 =A0from all fwmark 0x81 lookup link1
>
> same rule numbers 3 and 3 ??
>> 10: =A0 =A0 from 200.174.194.44 lookup link2
>> 10: =A0 =A0 from 201.26.37.40 lookup link1
>
> ditto
>
>> 32766: =A0from all lookup main
>> 32767: =A0from all lookup default
>>
>> # ip route list
>> 200.174.194.40/29 dev eth3 =A0proto kernel =A0scope link =A0src 200.=
174.194.44
>> 201.26.37.0/24 dev eth2 =A0proto kernel =A0scope link =A0src 201.26.=
37.40
>> default
>> =A0 =A0 =A0 =A0 nexthop via 200.174.194.41 =A0dev eth3 weight 1
>> =A0 =A0 =A0 =A0 nexthop via 201.26.37.1 =A0dev eth2 weight 3
>>
>> At this point the mark 0x82 is related to the link on the eth3 (net
>> 200.174.194.41). However, using this setup, the outgoing packets
>> almost always came from eth2 (which has a bigger weight on the
>> balance). I believe the balance is working (and acting on this case)
>> and the mark and route from a specific interface is not.
>>
>> Do you happen to know something that could give me some light or
>> directions on order to put this working fine?
>
> Hello
>
> What is your kernel version ?
>
> ip route list table link2
> ip route list table link1
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
