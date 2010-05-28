From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Fri, 28 May 2010 08:10:58 +0800
Message-ID: <AANLkTik7t3wcGkjXcIwj6PvBsx9Y6Fuyqf0OT3Vc07Py@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop> <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr> <1274905649.2542.1.camel@edumazet-laptop>
	<AANLkTil_CCT7f8-Ih6v55tSf96gRtnRqs_lSuF07AyR4@mail.gmail.com>
	<AANLkTinZzwWjDm003Emipfkit4ML4zsytR1i1w-aD700@mail.gmail.com>
	<1274957271.2523.12.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37390 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0E1ALT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 20:11:19 -0400
Received: by pvg11 with SMTP id 11so138517pvg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 17:11:18 -0700 (PDT)
In-Reply-To: <1274957271.2523.12.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2010/5/27 Eric Dumazet <eric.dumazet@gmail.com>:
> Le jeudi 27 mai 2010 =C3=A0 12:35 +0200, Maciej =C5=BBenczykowski a =C3=
=A9crit :
>> You could split it into a tree if you really really cared...
>>
>> ---
>>
>> But, if you put the 48 rules in a chain which only deals with incomi=
ng
>> new connections then it only triggers on the initial syn and
>> connection tracking deals with the rest (at least if you use the
>> mangle table to mark, and nat table to REDIRECT -- don't know about
>> TPROXY).
>
> Somebody setting up 48 squid instances must care about performance, o=
r
> something is wrong...
>
> I would expect maybe 10.000 new connections per second for such a
> setup ?
>
> I personnally would use RPS (Remote Packet Steering) to distribute th=
e
> load on all available cpus, and one squid per available cpu too.
>
> TPROXY selection would then use a match on selected CPU
>
> echo ff >/sys/class/net/eth0/queues/rx-0/rps_cpus
>
> -A extrachain -m cpu 0 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
27
> -A extrachain -m cpu 1 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
28
> -A extrachain -m cpu 2 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
29
> -A extrachain -m cpu 3 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
30
> -A extrachain -m cpu 4 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
31
> -A extrachain -m cpu 5 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
32
> -A extrachain -m cpu 6 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
33
> -A extrachain -m cpu 7 -j TPROXY --tproxy-mark 0x01/0xff --on-port 31=
34
>
>

It is much like my old idea about REDIRECT/DNAT. Anyway, an iptables
match cpu seems useful.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
