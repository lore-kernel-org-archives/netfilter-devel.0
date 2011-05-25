From: Pierre Rondou <prondou@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Wed, 25 May 2011 14:59:46 +0200
Message-ID: <4DDCFD42.3010708@gmail.com>
References: <4DC1FACC.4080204@gmail.com>	 <1306248975.3026.47.camel@edumazet-laptop>  <4DDBD2F1.3020704@gmail.com> <1306252554.3026.66.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:18612 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757254Ab1EYM7s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 08:59:48 -0400
In-Reply-To: <1306252554.3026.66.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 24/05/11 17:55, Eric Dumazet a =C3=A9crit :
>
>>>>
>>>>         =20
>>> Hi Pierre
>>>
>>> 1) Are you sure netfilter is the right place for this IVI feature ?
>>>      (fact that you had to copy/paste ~1300 lines of code from kern=
el
>>> might show that this would be better to use a module hooked into
>>> forwarding stack ?)
>>>
>>>       =20
>> I used Xtables to produce my module, fact is that I was (and still a=
m) a
>> kernel nooby, Xtables seemed to a be good way to produce this code.
>> I'm not sure to what you're refering about, are you suggesting I sho=
uld
>> have developed the module directly into the kernel?
>>
>>     =20
> We all were kernel newbie at very beginning ;)
>   =20

Sure, unfortunately there is no real book to teach new coders on what=20
they should do.

>   =20
>>> 2) How this can integrate a {conntrack enabled} firewall ?
>>>
>>>
>>>       =20
>> I can't ... It's a drawback of the module. The fact is that I only h=
ave
>> found a very little documentation about conntrack code, so I dropped=
 the
>> idea of dealing with it.
>> But it shouldn't be difficult to update the conntrack for a kernel p=
ro I
>> guess ;-)
>>     =20
> This has to be discussed before even coding ;)
>
> One packet going through this gateway has one IPv6 side and one ipv4
> side. This can be a problem to firewalling (either its ipv4, either i=
ts
> ipv6) and conntracking.
>
>
>   =20

It is a problem that's sure.
But as stated before, I didn't any suitable conntrack doc :(
My main thesis goal is to provide a working module, conntrack support=20
would be a bonus, but for now, I cannot do it on my own because of a=20
lack of conntrack knowledge.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
