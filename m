From: "Ondrej Slanina" <oslanina@kerio.com>
Subject: Re: Fw: Netfilter for Windows
Date: Thu, 15 Apr 2010 14:51:06 +0200
Message-ID: <5C6719D2B7C04A52A756BD3073EA51A5@kerio.local>
References: <E1065721E84E443C803CD31BFE864396@kerio.local> <4BC6EBFC.3020204@trash.net> <s2l3fdd6ce01004150521p301a9087o5072b7b20d9e9308@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Samuel Feitosa" <samuel@beanweb.com.br>
To: "Bruno Moreira Guedes" <beanweb@beanweb.com.br>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.kerio.com ([195.113.184.2]:64709 "EHLO mx1.kerio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab0DOMv0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:51:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>Congratulations! Do you plan to port the userspace tools to windows using 
>mingw?
libnetfilter_queue / nfqnl_test is able to be compiled under both mingw and 
VS2500 environment. Which other tools did you mean ? If you are talking 
about iptables - it's not simply task, before it contains lot of kernel 
modules for rules processing and linux dependent pieces like skb. It will be 
nice to port all of it :-)

>And what's the status? Is libnetfilter_queue working fine?
Yes. nfqnl_test is able to capture, drop, permit  packets. Only API used for 
obtaining information about interfaces is not implemented yet, because 
original libnetfilter_queue does not include it.
libnfnetlink includes some sort of API for work with ifaces but on Windows 
I'am not using this library...


----- Original Message ----- 
From: "Bruno Moreira Guedes" <beanweb@beanweb.com.br>
To: <netfilter-devel@vger.kernel.org>
Cc: "Samuel Feitosa" <samuel@beanweb.com.br>
Sent: Thursday, April 15, 2010 2:21 PM
Subject: Re: Fw: Netfilter for Windows


> 2010/4/15 Patrick McHardy <kaber@trash.net>:
>> Ondrej Slanina wrote:
>>> I just created a basic 'port' of Linux netfilter core modules on MS
>>> Windows. Now, it's implemented as a single kernel module (IM driver) and
>>> userspace library which has the same API as libnetfilter_queue. Network
>>> filtering is now performed only on pre_input and post_output sides.
>>> Kernel module now includes packet queueing, processing, not as on Linux,
>>> where this tasks is processed by separate modules. It will be
>>> distributed under GPL. I have some questions:
>>
>> Cool. Finally those poor souls can use a proper firewall :)
>>
>>> 1, Can I use 'netfilter' and 'libnetfilter_queue' names for this? For
>>> example kernel module named netfilter.sys, userspace library named
>>> libnetfilter_queue.lib, project name netfilter, netfilter for windows or
>>> something like it?
>>
>> I think using the same names is fine.
>>
>>> 2, Should I put some notice about origin into source code files ?
>>> Something like: "Based on Linux netfilter/libnetfilter_queue" ?
>> Just keeping the original copyright and GPL headers is fine.
>>
>>> My implementation is now very primitive, but I want to extend it in the 
>>> future.
>>
>> Please keep us posted. I guess we could also host the source on
>> one of the netfilter servers in case you're interested.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
>
> Congratulations! Do you plan to port the userspace tools to windows using 
> mingw?
>
> And what's the status? Is libnetfilter_queue working fine?
>
> I'm very interested, because I'm currently porting some commercial
> softwares to windows, including a firewall which uses
> libnetfilter_queue.
>
> And now we're talking about netfilter on Windows, let me ask: is there
> any known port to NetBSD/FreeBSD?? And for MINIX??
>
> Thank you.
>
> --Bruno Moreira Guedes
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> __________ Informace od ESET NOD32 Antivirus, verze databaze 5030 
> (20100415) __________
>
> Tuto zpravu proveril ESET NOD32 Antivirus.
>
> http://www.eset.cz
>
>
> 


__________ Informace od ESET NOD32 Antivirus, verze databaze 5030 (20100415) __________

Tuto zpravu proveril ESET NOD32 Antivirus.

http://www.eset.cz





