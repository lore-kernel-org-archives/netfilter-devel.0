From: Bruno Moreira Guedes <beanweb@beanweb.com.br>
Subject: Re: Fw: Netfilter for Windows
Date: Thu, 15 Apr 2010 09:21:51 -0300
Message-ID: <s2l3fdd6ce01004150521p301a9087o5072b7b20d9e9308@mail.gmail.com>
References: <E1065721E84E443C803CD31BFE864396@kerio.local>
	 <4BC6EBFC.3020204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Samuel Feitosa <samuel@beanweb.com.br>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39365 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab0DOMVy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:21:54 -0400
Received: by gwaa18 with SMTP id a18so704240gwa.19
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 05:21:51 -0700 (PDT)
In-Reply-To: <4BC6EBFC.3020204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2010/4/15 Patrick McHardy <kaber@trash.net>:
> Ondrej Slanina wrote:
>> I just created a basic 'port' of Linux netfilter core modules on MS
>> Windows. Now, it's implemented as a single kernel module (IM driver)=
 and
>> userspace library which has the same API as libnetfilter_queue. Netw=
ork
>> filtering is now performed only on pre_input and post_output sides.
>> Kernel module now includes packet queueing, processing, not as on Li=
nux,
>> where this tasks is processed by separate modules. It will be
>> distributed under GPL. I have some questions:
>
> Cool. Finally those poor souls can use a proper firewall :)
>
>> 1, Can I use 'netfilter' and 'libnetfilter_queue' names for this? Fo=
r
>> example kernel module named netfilter.sys, userspace library named
>> libnetfilter_queue.lib, project name netfilter, netfilter for window=
s or
>> something like it?
>
> I think using the same names is fine.
>
>> 2, Should I put some notice about origin into source code files ?
>> Something like: "Based on Linux netfilter/libnetfilter_queue" =A0?
> Just keeping the original copyright and GPL headers is fine.
>
>> My implementation is now very primitive, but I want to extend it in =
the future.
>
> Please keep us posted. I guess we could also host the source on
> one of the netfilter servers in case you're interested.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>


Congratulations! Do you plan to port the userspace tools to windows usi=
ng mingw?

And what's the status? Is libnetfilter_queue working fine?

I'm very interested, because I'm currently porting some commercial
softwares to windows, including a firewall which uses
libnetfilter_queue.

And now we're talking about netfilter on Windows, let me ask: is there
any known port to NetBSD/FreeBSD?? And for MINIX??

Thank you.

--Bruno Moreira Guedes
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
