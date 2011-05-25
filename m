From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Wed, 25 May 2011 15:09:43 +0200
Message-ID: <BANLkTinofP5BhXpCJB6z18yBbiN3H0N=vw@mail.gmail.com>
References: <4DC1FACC.4080204@gmail.com>
	<1306248975.3026.47.camel@edumazet-laptop>
	<4DDBD2F1.3020704@gmail.com>
	<1306252554.3026.66.camel@edumazet-laptop>
	<4DDCFD42.3010708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>, behave@ietf.org,
	v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54378 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EYNJn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:09:43 -0400
Received: by pvg12 with SMTP id 12so3385764pvg.19
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2011 06:09:43 -0700 (PDT)
In-Reply-To: <4DDCFD42.3010708@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not that I've really been following the thread.
But I think that this sort of functionality should most likely be
developed as a virtual (tun/tap/veth/sit) style tunnel-like device.

You would use ipv4/ipv6 routing in the normal kernel to direct traffic
out this virtual interface, and immediately ipv6/ipv4 traffic would
come back out of it.

This should allow all the rest of the kernel (including connection
tracking) to function normally - although of course every connection
would be registered in an unrelated way twice (once as v4, once as
v6).

I think this has nice 'black box' semantics.

On Wed, May 25, 2011 at 14:59, Pierre Rondou <prondou@gmail.com> wrote:
> Le 24/05/11 17:55, Eric Dumazet a =C3=A9crit :
>>
>>>>>
>>>>>
>>>>
>>>> Hi Pierre
>>>>
>>>> 1) Are you sure netfilter is the right place for this IVI feature =
?
>>>> =C2=A0 =C2=A0 (fact that you had to copy/paste ~1300 lines of code=
 from kernel
>>>> might show that this would be better to use a module hooked into
>>>> forwarding stack ?)
>>>>
>>>>
>>>
>>> I used Xtables to produce my module, fact is that I was (and still =
am) a
>>> kernel nooby, Xtables seemed to a be good way to produce this code.
>>> I'm not sure to what you're refering about, are you suggesting I sh=
ould
>>> have developed the module directly into the kernel?
>>>
>>>
>>
>> We all were kernel newbie at very beginning ;)
>>
>
> Sure, unfortunately there is no real book to teach new coders on what=
 they
> should do.
>
>>
>>>>
>>>> 2) How this can integrate a {conntrack enabled} firewall ?
>>>>
>>>>
>>>>
>>>
>>> I can't ... It's a drawback of the module. The fact is that I only =
have
>>> found a very little documentation about conntrack code, so I droppe=
d the
>>> idea of dealing with it.
>>> But it shouldn't be difficult to update the conntrack for a kernel =
pro I
>>> guess ;-)
>>>
>>
>> This has to be discussed before even coding ;)
>>
>> One packet going through this gateway has one IPv6 side and one ipv4
>> side. This can be a problem to firewalling (either its ipv4, either =
its
>> ipv6) and conntracking.
>>
>>
>>
>
> It is a problem that's sure.
> But as stated before, I didn't any suitable conntrack doc :(
> My main thesis goal is to provide a working module, conntrack support=
 would
> be a bonus, but for now, I cannot do it on my own because of a lack o=
f
> conntrack knowledge.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
