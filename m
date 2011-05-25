From: Pierre Rondou <prondou@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Wed, 25 May 2011 15:34:36 +0200
Message-ID: <4DDD056C.1030208@gmail.com>
References: <4DC1FACC.4080204@gmail.com>	 <1306248975.3026.47.camel@edumazet-laptop> <4DDBD2F1.3020704@gmail.com>	 <1306252554.3026.66.camel@edumazet-laptop> <4DDCFD42.3010708@gmail.com>	 <BANLkTinofP5BhXpCJB6z18yBbiN3H0N=vw@mail.gmail.com> <1306329404.2820.18.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org, guy.leduc@ulg.ac.be,
	evyncke@cisco.com, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:15139 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932596Ab1EYNei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:34:38 -0400
In-Reply-To: <1306329404.2820.18.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/05/11 15:16, Eric Dumazet a =C3=A9crit :
> Le mercredi 25 mai 2011 =C3=A0 15:09 +0200, Maciej =C5=BBenczykowski =
a =C3=A9crit :
>   =20
>> Not that I've really been following the thread.
>> But I think that this sort of functionality should most likely be
>> developed as a virtual (tun/tap/veth/sit) style tunnel-like device.
>>
>> You would use ipv4/ipv6 routing in the normal kernel to direct traff=
ic
>> out this virtual interface, and immediately ipv6/ipv4 traffic would
>> come back out of it.
>>
>> This should allow all the rest of the kernel (including connection
>> tracking) to function normally - although of course every connection
>> would be registered in an unrelated way twice (once as v4, once as
>> v6).
>>
>> I think this has nice 'black box' semantics.
>>     =20
> CERNET doc refers to  : http://linux.ivi2.org/
>
> With an implementation for linux-2.6.18 : http://linux.ivi2.org/impl/
>
> This seems enough to me, and not intrusive.
>
> Pierre, you really should discuss why a netfilter module is needed at
> all. Maybe you have a pdf or some slides somewhere (no code, but form=
al
> discussion) ?
>
>   =20

Well, as stated before, it is a master thesis work, so at the time I=20
started this work, I didn't knew anything about the kernel organization=
=20
(even though it's been years I use linux everyday).
At first I have browsed a bit in the netfilters' files, but it was=20
nearly impossible to understand what file was related to what, I had no=
=20
clue on where to install my transition code.

Then a co-worker came with Jan's ebook (Writting Netfilter Modules) and=
=20
Professors watching my thesis (Guy Leduc and Eric Vyncke, in copy)=20
agreed that is was a good way to implement my translation code.

Now, may be Maciej's way or CERNET's way to get it into the kernel is=20
better, but as it's a thesis, it has to be my own work and moreover, I=20
have to understand what I'm doing, which is the case with Jan's=20
excellent ebook.

The main drawback with "in-kernel" module is that there is almost no=20
documentation, so I had no idea on how and where put my transition=20
module or simply what to do (structures, ...).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
