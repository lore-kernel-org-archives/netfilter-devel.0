From: Pierre Rondou <prondou@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Tue, 24 May 2011 17:46:57 +0200
Message-ID: <4DDBD2F1.3020704@gmail.com>
References: <4DC1FACC.4080204@gmail.com> <1306248975.3026.47.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: behave@ietf.org, v6ops@ietf.org, netfilter-devel@vger.kernel.org,
	guy.leduc@ulg.ac.be, evyncke@cisco.com,
	Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:19906 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865Ab1EXPrB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 11:47:01 -0400
In-Reply-To: <1306248975.3026.47.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 24/05/11 16:56, Eric Dumazet a =C3=A9crit :
> Le jeudi 05 mai 2011 =C3=A0 03:18 +0200, Pierre Rondou a =C3=A9crit :
>   =20
>> Hello everybody,
>>
>> I'm currently a student at the University of Li=C3=A8ge. As part of =
my master
>> thesis, I have to develop a Linux kernel module for IVI (
>> http://datatracker.ietf.org/doc/rfc6219/ ).
>>
>> I now consider my module as finished (i.e, all functionalities are
>> implemented) and publish it.
>>
>> It is available on sourceforge:
>>
>> http://sourceforge.net/projects/nativi/
>>
>> Feel free to test it and report to me any bug, bad implementation,
>> error, ...
>>
>> If you believe that this module can be included is the Linux Kernel =
or
>> in the Xtables-addons framework, I'll be glad and will help you in t=
his
>> task.
>>
>>
>> I have tested my module inside the Xtables-addons framework (version
>> 1.32) on a debian squeeze (6.0.1) linux with a 2.6.32-5  kernel (i68=
6).
>>
>> Because of the lack of "EXPORT_SYMBOL" in the kernel, I had to
>> copy-paste several functions from the kernel into the
>> nativi_kernel_code.c file in order to use some features already
>> available in the kernel (ip_finish_output, ip6_output, icmp_send).
>>
>> Documentation is provided in the source code, if you have any questi=
on
>> don't hesitate to ask me.
>>
>>     =20
> Hi Pierre
>
> 1) Are you sure netfilter is the right place for this IVI feature ?
>     (fact that you had to copy/paste ~1300 lines of code from kernel
> might show that this would be better to use a module hooked into
> forwarding stack ?)
>   =20
I used Xtables to produce my module, fact is that I was (and still am) =
a=20
kernel nooby, Xtables seemed to a be good way to produce this code.
I'm not sure to what you're refering about, are you suggesting I should=
=20
have developed the module directly into the kernel?

> 2) How this can integrate a {conntrack enabled} firewall ?
>
>   =20

I can't ... It's a drawback of the module. The fact is that I only have=
=20
found a very little documentation about conntrack code, so I dropped th=
e=20
idea of dealing with it.
But it shouldn't be difficult to update the conntrack for a kernel pro =
I=20
guess ;-)

Regards,

Pierre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
