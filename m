From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 4 Dec 2007 09:58:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712040956260.22728@ask.diku.dk>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
 <4753B957.2000207@trash.net> <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>
 <47550D5C.8090004@trash.net> <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:52232 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbXLDI6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:58:19 -0500
In-Reply-To: <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tue, 4 Dec 2007, Jan Engelhardt wrote:
> On Dec 4 2007 09:18, Patrick McHardy wrote:
>> Salatiel Filho wrote:
>>> On Dec 3, 2007 5:07 AM, Patrick McHardy <kaber@trash.net> wrote:
>>>> Salatiel Filho wrote:
>>>
>>>>> # iptables -L
>>>>> iptables v1.3.6: can't initialize iptables table `filter': Bad file
>>>>> descriptor
>>>>> Perhaps iptables or your kernel needs to be upgraded.
>>>>>
>>>>> My machine is a ARM machine with debian 4.0.
>>>>> I also have already tried 1.3.8 and got the same error.
>>>>
>>>> Which kernel version (please also send .config)? Did you compile
>>>> iptables yourself or used a version from Debian?
>>>>
>
> This looks more like an userspace issue. The strace log shows that the
> netlink socket was obtained, but calls setsockopt with fd=-1.
> Just a guess, though.

My guess is that the auto loading of the module fails...

Please post the output of "lsmod"

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
