From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 08 Nov 2010 08:02:56 +0100
Message-ID: <4CD7A0A0.5010905@trash.net>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>	 <4CD79A79.3030103@trash.net> <4CD79B12.9060502@trash.net>	 <AANLkTimdoYvCZhm-EqbVk2gBH-WR+yVXpnZyjqFbT-RF@mail.gmail.com> <1289199090.2478.326.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Changli Gao <xiaosuo@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54735 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0KHHDB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:03:01 -0500
In-Reply-To: <1289199090.2478.326.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.11.2010 07:51, Eric Dumazet wrote:
> Le lundi 08 novembre 2010 =E0 14:44 +0800, Changli Gao a =E9crit :
>> On Mon, Nov 8, 2010 at 2:39 PM, Patrick McHardy <kaber@trash.net> wr=
ote:
>>> [resend with netfilter-devel address fixed]
>>>
>>> On 08.11.2010 07:36, Patrick McHardy wrote:
>>>> On 08.11.2010 07:32, Changli Gao wrote:
>>>>> When conntrack is enabled, we can cache dst_entry into the
>>>>> corresponding conntrack to eliminate the subsequence
>>>>> ip_route_input_noref() calls for the same connection. The current
>>>>> implementation is a standalone module. If this idea is welcomed, =
I'll
>>>>> try to push it up. Thanks.
>>>>>
>>>>> Here it is: https://github.com/xiaosuo/xiaosuo/tree/master/nf_rtc=
ache/
>>>>
>>>> Please send the patch as attachment so it can be discussed.
>>>
>>>
>>
>> Here is a trivial patch to add RTCACHE NF extention.
>>
>>
>> ...
> Adding yet another level of cache seems wrong to me.
>=20
> Either we fix the first level, or we dont use it at all.
>=20
> If ip_route_input_noref() is slow, we can work on it to make it faste=
r.
>=20
> I know dst_use_noref() is the real problem an can be optimized if
> needed.

I think the main idea is to make double use of the existing conntrack
lookup. The most interesting part about this idea in my opinion is
that it should make multipath setups very easy since you don't have
to manually deal with expiring routing cache entries anymore. However
this clearly is a big change to the existing behaviour of the routing
cache and needs a lot more thought, which I will perform after having
some coffee :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
