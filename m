From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Mon, 25 Oct 2010 11:13:07 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010251050150.9308@obet.zrqbmnf.qr>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com> <20101024182508.GM15247@Chamillionaire.breakpoint.cc> <1287947511.2658.1678.camel@edumazet-laptop> <alpine.LNX.2.01.1010242222380.18070@obet.zrqbmnf.qr>
 <AANLkTimqOaBx4hr4RiuBQW-JePcf4QScMP56p20eTtF5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44119 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab0JYJNI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:13:08 -0400
In-Reply-To: <AANLkTimqOaBx4hr4RiuBQW-JePcf4QScMP56p20eTtF5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-10-25 05:19, Maciej =C5=BBenczykowski wrote:

>> To be read as: one OV is reachable by 13 input values; 5 OVs are eac=
h
>> reachable by 12 input values (IV) (i.e. a group of 60 IV lead to onl=
y 5
>> OV), etc.
>
>I don't quite follow what you are doing here.

See the code at the end of the mail; that will probably help some=20
people more than my description.

>> You can surely agree with me that this looks very much like at least
>> one queue will be at a disadvantage (getting less packets).
>>
>> And indeed, with total_queues=3D4 I get a packet distribution of
>>
>> =C2=A024.41404 25.58534 25.00025 25.00037
>>
>> percent. With more queues, I suspect the variance will go up.
>
>This suggests the hash function is bad.

Well, the hash function is not necessarily bad, it just is not a=20
perfect hash function for the given input domain.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
