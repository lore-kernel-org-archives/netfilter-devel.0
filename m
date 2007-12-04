From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 04 Dec 2007 09:18:36 +0100
Message-ID: <47550D5C.8090004@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <4753B957.2000207@trash.net> <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56711 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXLDITC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:19:02 -0500
In-Reply-To: <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> On Dec 3, 2007 5:07 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Salatiel Filho wrote:
>
>>> # iptables -L
>>> iptables v1.3.6: can't initialize iptables table `filter': Bad file descriptor
>>> Perhaps iptables or your kernel needs to be upgraded.
>>>
>>>
>>> My machine is a ARM machine with debian 4.0.
>>> I also have already tried 1.3.8 and got the same error.
>>
>> Which kernel version (please also send .config)? Did you compile
>> iptables yourself or used a version from Debian?
>>
>>
> # uname -a
> Linux LS-GL7D6 2.6.12.6-arm2 #77 Sun Dec 2 15:43:18 BRT 2007 armv5tejl GNU/Linux
> 
> 
> Right now i am using iptables from debian, but i already try to use
> 1.3.8  compiled by myself and the error was the same.


I can't find anything responsible for this. Could you enable
debugging in net/ipv4/netfilter/ip_tables.c (uncomment the
#define DEBUG_* at the top) and post the output please?

