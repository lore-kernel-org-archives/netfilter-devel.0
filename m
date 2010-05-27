From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 17:35:37 -0300
Message-ID: <AANLkTilYHBmR0XX2BY6NCZBdCpCUd0fi0oYDccJazqJj@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop>
	<alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
	<alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr>
	<1274905649.2542.1.camel@edumazet-laptop>
	<AANLkTil_CCT7f8-Ih6v55tSf96gRtnRqs_lSuF07AyR4@mail.gmail.com>
	<AANLkTinZzwWjDm003Emipfkit4ML4zsytR1i1w-aD700@mail.gmail.com>
	<1274957271.2523.12.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47075 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab0E0Ufj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 16:35:39 -0400
Received: by fxm10 with SMTP id 10so210819fxm.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2010 13:35:38 -0700 (PDT)
In-Reply-To: <1274957271.2523.12.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi Mr. Dumazet

2010/5/27 Eric Dumazet <eric.dumazet@gmail.com>:
> Somebody setting up 48 squid instances must care about performance, or
> something is wrong...

  True, I do care, very much! :)

  We're actually using the cache machine on a 300Mbps as kind of
proof-of-concept: If it works well, we'll put on a 800Mbps network in
june.

> I would expect maybe 10.000 new connections per second for such a
> setup ?

  Yep, something like this.

> I personnally would use RPS (Remote Packet Steering) to distribute the
> load on all available cpus, and one squid per available cpu too.
>
> TPROXY selection would then use a match on selected CPU
>
> echo ff >/sys/class/net/eth0/queues/rx-0/rps_cpus
>
> -A extrachain -m cpu 0 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3127
> -A extrachain -m cpu 1 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3128
> -A extrachain -m cpu 2 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3129
> -A extrachain -m cpu 3 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3130
> -A extrachain -m cpu 4 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3131
> -A extrachain -m cpu 5 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3132
> -A extrachain -m cpu 6 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3133
> -A extrachain -m cpu 7 -j TPROXY --tproxy-mark 0x01/0xff --on-port 3134

  That's a very good tip.

  Although the squid people told me that kernels > 2.6.32 don't play
nice with TPROXY.

  I personally haven't tested them yet, I plan to do so this weekend.
I'm currently using 2.6.29.6 on the production machine.

  But if some of the newer kernel work, I'll definitely use this, thanks.

  Cheers,

Felipe Damasio
