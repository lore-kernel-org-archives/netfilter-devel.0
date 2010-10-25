From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Mon, 25 Oct 2010 05:02:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010242222380.18070@obet.zrqbmnf.qr>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>  <20101024182508.GM15247@Chamillionaire.breakpoint.cc> <1287947511.2658.1678.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39482 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0JYDCa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 23:02:30 -0400
In-Reply-To: <1287947511.2658.1678.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-10-24 21:11, Eric Dumazet wrote:
>Le dimanche 24 octobre 2010 =C3=A0 20:25 +0200, Florian Westphal a =C3=
=A9crit :
>
>> I'd imagine that the result of ((hash * total) >> 32) is (almost)
>> always zero, especially if total is small (which it is usually).
>
>Absolutely not. total is a 32bit number, using full range.
>
>> Did you test that this change does not affect distribution average?
>
>That would be shocking actually, given we use jhash()
>
>I did same tricks in various parts of network stack in the past, and i=
ts
>fine.

I spent the afternoon raking on the impact on the distribution that=20
using multiplication here would have. Intriguing concourse.

(I looked at Jenkins3, so there is a little gap to what's in the=20
kernel.) Anyhow, the frequency of Jenkins3 output values (OV) being hit=
=20
is:

1591633245x 0
1568275918x 1
 784435879x 2
 265277962x 3
  68188245x 4
  14213782x 5
   2499352x 6
    383550x 7
     52243x 8
      6340x 9
       699x 10
        74x 11
         5x 12
         1x 13

To be read as: one OV is reachable by 13 input values; 5 OVs are each=20
reachable by 12 input values (IV) (i.e. a group of 60 IV lead to only 5=
=20
OV), etc.

With ct's input domain, i.e. ipv4saddr^ipv4daddr, a 32-bit quantity,=20
~1.59G OVs are never reachable/obtainable ("holes") no matter which IVs=
=20
are chosen. The more these 1.59G points agglomerate together, the highe=
r=20
the chance that some queue will not be used (with the multiplication=20
approach), of course.

If the 1.59G holes are uniformly distributed across the 32-bit space, a=
=20
CDF-like plot would output a straight line. Alternatively, one can=20
calculate the difference instead for visual output:

http://picpaste.de/jenkins3.png

You can surely agree with me that this looks very much like at least=20
one queue will be at a disadvantage (getting less packets).

And indeed, with total_queues=3D4 I get a packet distribution of

 24.41404 25.58534 25.00025 25.00037

percent. With more queues, I suspect the variance will go up.

=3D=3D=3D

Bottom line: modulus is resistant to hole agglomeration, and only=20
problematic with certain patterns of uniform hole distribution=20
(which in=20
turn would be a sign that the hash function is bad).

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
