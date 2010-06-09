From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: queue: rwlock to spinlock conversion
Date: Wed, 09 Jun 2010 16:02:21 +0200
Message-ID: <4C0F9EED.2020007@trash.net>
References: <1276002860.2486.22.camel@edumazet-laptop>	 <4C0F9BCD.2040605@trash.net> <1276092053.2442.142.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34962 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab0FIOCT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:02:19 -0400
In-Reply-To: <1276092053.2442.142.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le mercredi 09 juin 2010 =C3=A0 15:49 +0200, Patrick McHardy a =C3=A9=
crit :
>  =20
>> Eric Dumazet wrote:
>>    =20
>>> Converts queue_lock rwlock to a spinlock.
>>>
>>> (readlocked part can be changed by reads of integer values)
>>>
>>> One atomic operation instead of four per ipq_enqueue_packet() call.
>>>      =20
>> Looks fine to me, applied, thanks Eric.
>>
>> Just wondering since ip_queue is actually obsoleted, do you intend t=
o
>> change ip6_queue and nfnetlink_queue in a similar fashion?
>>
>>    =20
>
> Indeed, I started these yesterday but had to pause them, probably bef=
ore
> tomorrow, if no urgent stuff raise before ;)
>  =20

Cool, thanks.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
