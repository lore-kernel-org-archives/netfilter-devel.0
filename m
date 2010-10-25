From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 20:19:31 -0700
Message-ID: <AANLkTimqOaBx4hr4RiuBQW-JePcf4QScMP56p20eTtF5@mail.gmail.com>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
	<20101024182508.GM15247@Chamillionaire.breakpoint.cc>
	<1287947511.2658.1678.camel@edumazet-laptop>
	<alpine.LNX.2.01.1010242222380.18070@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58143 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0JYDTd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 23:19:33 -0400
Received: by wyf28 with SMTP id 28so2875309wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 20:19:32 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010242222380.18070@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> To be read as: one OV is reachable by 13 input values; 5 OVs are each
> reachable by 12 input values (IV) (i.e. a group of 60 IV lead to only=
 5
> OV), etc.

I don't quite follow what you are doing here.

> You can surely agree with me that this looks very much like at least
> one queue will be at a disadvantage (getting less packets).
>
> And indeed, with total_queues=3D4 I get a packet distribution of
>
> =C2=A024.41404 25.58534 25.00025 25.00037
>
> percent. With more queues, I suspect the variance will go up.

This suggests the hash function is bad.

The only difference between
  HASH32 % N
and
  (HASH32 * N) >> 32
is that modulus has a tendency to use the lower bits of the HASH32,
while multiplication has a tendency to use the higher bits of the
HASH32.
Non-prime values of N will be worse than prime values (excluding two),
and power-of-two values of N will be worst.

If the HASH32 is being calculated as SRC_IP^DST_IP, and then we're
using a power-of-two value of N, then we're basically using the top
two (for N=3D4)
bits of SRC_IP^DST_IP, which has a bad distribution for obvious
reasons - namely, ips aren't randomly distributed, especially so for
their top two bits.
Remember entire /8's haven't been allocated, the entire top /3 is
multicast or reserved.  And certain /8's (like 10.*) are much more
likely than others (0.*).

It certainly seems that the hash function should be fixed.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
