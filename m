From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 12:47:51 +0200
Message-ID: <1274957271.2523.12.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	 <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	 <1274905649.2542.1.camel@edumazet-laptop>
	 <AANLkTil_CCT7f8-Ih6v55tSf96gRtnRqs_lSuF07AyR4@mail.gmail.com>
	 <AANLkTinZzwWjDm003Emipfkit4ML4zsytR1i1w-aD700@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51764 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0E0Kr4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 06:47:56 -0400
Received: by fxm16 with SMTP id 16so45452fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 03:47:54 -0700 (PDT)
In-Reply-To: <AANLkTinZzwWjDm003Emipfkit4ML4zsytR1i1w-aD700@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 27 mai 2010 =C3=A0 12:35 +0200, Maciej =C5=BBenczykowski a =C3=
=A9crit :
> You could split it into a tree if you really really cared...
>=20
> ---
>=20
> But, if you put the 48 rules in a chain which only deals with incomin=
g
> new connections then it only triggers on the initial syn and
> connection tracking deals with the rest (at least if you use the
> mangle table to mark, and nat table to REDIRECT -- don't know about
> TPROXY).

Somebody setting up 48 squid instances must care about performance, or
something is wrong...

I would expect maybe 10.000 new connections per second for such a
setup ?

I personnally would use RPS (Remote Packet Steering) to distribute the
load on all available cpus, and one squid per available cpu too.

TPROXY selection would then use a match on selected CPU

echo ff >/sys/class/net/eth0/queues/rx-0/rps_cpus

-A extrachain -m cpu 0 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3127
-A extrachain -m cpu 1 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3128
-A extrachain -m cpu 2 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3129
-A extrachain -m cpu 3 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3130
-A extrachain -m cpu 4 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3131
-A extrachain -m cpu 5 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3132
-A extrachain -m cpu 6 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3133
-A extrachain -m cpu 7 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3134



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
