From: "Katia S." <katias@iit.demokritos.gr>
Subject: Re: iptables-dev Source Example
Date: Thu, 11 Oct 2012 13:49:40 +0300 (EEST)
Message-ID: <cd80bdb60156ce8453389beb99443d30.squirrel@webmail.iit.demokritos.gr>
References: <5072D6F8.2010707@iit.demokritos.gr> <20121008152237.GA8350@1984>
    <CAHo-OoyUUHju8du-Otd6vfgv_ORz-Y_PrPB0VDKbU74jYy9hjg@mail.gmail.com>
    <2aa140973d7d5a320bd1402da1647a26.squirrel@webmail.iit.demokritos.gr>
    <alpine.LNX.2.01.1210091753520.12373@nerf07.vanv.qr>
    <11f6603b92965503cfaef2622aaf56a0.squirrel@webmail.iit.demokritos.gr>
    <5076A36D.8020505@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "Katia S." <katias@iit.demokritos.gr>,
	"Jan Engelhardt" <jengelh@inai.de>,
	Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org,
	"Pablo Neira Ayuso" <pablo@netfilter.org>
To: "Alexey Perevalov" <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zeus.iit.demokritos.gr ([143.233.226.2]:53499 "EHLO
	zeus.iit.demokritos.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2JKKto (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:49:44 -0400
In-Reply-To: <5076A36D.8020505@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Lesha! :p

Thank you very much!
I actually found the TC sources (not lib nor api, but sources) in the
iproute package (tc.c, tc_qdisc.c, tc_class.c etc) and they seem to be
somewhat straight forward.

But I'll check the lgl lib as well! Maybe it's easier than the tc sources..

Thanks again :)


> Hello Katia!
>
> There is a library lql ( http://www.coverfire.com/lql/) for working with
> linux QoS It's GPL.
> I don't know the state of this library.
>
> TC doesnt' use it, the TC's approach is directly communicate with kernel
> via netlink.
>
> On 10/09/2012 09:23 PM, Katia S. wrote:
>> Yeah, that's why I installed the development packages of both iptables
>> and
>> iptc. I'm gussing the API I need is in the iptc lib.. But still, no luck
>> finding a tutorial there either.
>>
>> And I guess the Title of this mail is kinda wrong and slighty irrelevant
>> :p
>> Sorry 'bout that..
>>
>> Do you have any suggestions regarding the iptc API and maybe any source
>> code samples (aside the ones that are already installed inside the core,
>> of course :p ) ?
>>
>>
>>> On Tuesday 2012-10-09 17:33, Katia S. wrote:
>>>
>>>> Well, I have been running "tc" commands like "tc qdisc" or "tc class"
>>>> to
>>>> get some information I need on various devices and interfaces.
>>>>
>>>> Right now I need to implement the exact same feature in a program of
>>>> mine,
>>>> but I don't want to just externally call the "tc" command and read its
>>>> output... So I was searching for an API to use it in my source code.
>>>> My
>>>> search led me to the iptc-dev and iptables-dev libraries, but those
>>>> have
>>>> no tutorial or how-tos so I'm kinda lost...
>>> tc is not part of iptables, so it is very unlikely (I say impossible)
>>> that iptables-dev will get you anything tc-related.
>>>
>>
>
>
> --
> Best regards,
> Alexey Perevalov,
>


-- 
Katia Sarsempagieva

Research Associate
Media Networks Laboratory
Institute of Networks and Telecommunications
NCSR "Demokritos"

