From: Dave Taht <dave.taht@gmail.com>
Subject: Re: [RFC] ecn match ported to ipv6
Date: Thu, 9 Jun 2011 06:15:44 -0600
Message-ID: <BANLkTimMEBayFC2T+Y-0vTzUEyWHEsG6JQ@mail.gmail.com>
References: <1307545312.3057.49.camel@edumazet-laptop>
	<BANLkTi=ORBH0q_arGbFUdjk=WMjbBz1KZg@mail.gmail.com>
	<4DEFB213.5030802@trash.net>
	<alpine.LNX.2.01.1106082248110.13030@frira.zrqbmnf.qr>
	<4DF081B5.2060102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39505 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab1FIMPp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:15:45 -0400
Received: by iwn34 with SMTP id 34so1240285iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 05:15:44 -0700 (PDT)
In-Reply-To: <4DF081B5.2060102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 9, 2011 at 2:17 AM, Patrick McHardy <kaber@trash.net> wrote=
:
> On 08.06.2011 22:50, Jan Engelhardt wrote:
>> On Wednesday 2011-06-08 19:32, Patrick McHardy wrote:
>>
>>> On 08.06.2011 17:47, Dave Taht wrote:
>>>> On Wed, Jun 8, 2011 at 9:01 AM, Eric Dumazet <eric.dumazet@gmail.c=
om> wrote:
>>>>
>>>>> Dave Taht mentioned in bloat list that netfilter ecn match was ip=
v4
>>>>> only.
>>>>>
>>>>> Is there any plan to make the switch from net/ipv4/netfilter/ipt_=
ecn.c
>>>>> to net/netfilter/xt_ecn.c ?
>>>>>
>>>>> I can probably do it but not before ~ten days, so if someone is
>>>>> interested, this will please Dave ;)
>>>
>>> That should be a relatively quick job, I'll give it a shot while
>>> my dinner is cooking :)
>>>
>>>> The larger question I had was this
>>>>
>>>> "iptables seems to think ecn can only be looked at in TCP streams,=
 where (for
>>>> example), ecn bits can be copied to the outer header of a udp vpn
>>>> stream, and marked
>>>>
>>>> when needed."
>>>>
>>>> ECN is an ip level standard, not just a tcp one.
>>>
>>> That probably needs a new revision and is slightly more work, lets
>>> begin by porting it to IPv6, then we can add this on top.
>>
>> Moving it to xt_ecn first seems like producing a smaller patchset
>> because you don't have to potentially duplicate the functions first.=
 :)
>
> It actually already supports matching on IP header ECN bits:
>
> [!] --ecn-ip-ect [0..3] Match ECN codepoint in IPv4 header
>

Sorry, my bad. It's even documented as existing.

So it's just a pair of convienence functions (
--ecn-ip-ece --ecn-ip-cwr )

and ipv6 iptables support for ECN that are MIA.

I'll argue that extending the blackhole-ing feature to also include ip

       --ecn-tcp-remove

might be good... although in my testing I have not found a blackhole
yet, they must still be out there.

--=20
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
