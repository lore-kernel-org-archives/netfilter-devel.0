From: Pierre Rondou <prondou@gmail.com>
Subject: Re: EXPORT_SYMBOL missing in the kernel?
Date: Tue, 24 May 2011 15:48:13 +0200
Message-ID: <4DDBB71D.6080205@gmail.com>
References: <4DDBACA6.2060501@gmail.com> <1306244451.3026.42.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:59867 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932244Ab1EXNsN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:48:13 -0400
In-Reply-To: <1306244451.3026.42.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 24/05/11 15:40, Eric Dumazet a =C3=A9crit :
> Le mardi 24 mai 2011 =C3=A0 15:03 +0200, Pierre Rondou a =C3=A9crit :
>   =20
>> Hello,
>>
>> I'm a student at the University of Liege, currently developing a NAT=
64
>> (see RFC 6146) module for Netfilter.
>>
>> In order to develop this module, I had to use some in-kernel functio=
n,
>> such as icmp_send, ip6_output, ip_finish_output, ... and many more.
>>
>> But many of those functions didn't have an "EXPORT_SYMBOL" allowing =
them
>> to be reachable from outside the kernel.
>>
>> So, to be able to use them, I had to copy paste about 1500 lines of
>> kernel source code (those functions + related functions). This makes=
 the
>> module hardly updatable as all those functions are likely to be upda=
ted.
>>
>> Is there a reason why those functions are not associated with an
>> "EXPORT_SYMBOL"?
>>     =20
> We dont export all possible symbols (each export has a memory cost)
>
> We export one symbol when its needed from a module.
>
> Dont copy/paste code, but add EXPORT_SYMBOL when/if needed.
>
> icmp_send() is for sure already exported (needed in various netfilter
> modules)
>
>   =20

Ok, thanks for the info.

Though, my module doesn't need a kernel recompilations as its developed=
=20
for Xtables, I'm not likely to develop a kernel patch to apply for each=
=20
kernel my module could be connected.

Of course, the best way would be to patch the currently dev kernel=20
(2.6.39 if I take your word from previous mail) to use my module.
But I'm not a kernel developper and my previously proposed module=20
(NATIVI, which had the same problem) didn't seem to get interest from=20
kernel or Xtables developers :(
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
