From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Moving modified packets between processes
Date: Sun, 24 Oct 2010 15:19:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010241454300.2665@obet.zrqbmnf.qr>
References: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com> <alpine.LNX.2.01.1010241325410.23809@obet.zrqbmnf.qr> <AANLkTi=ngV_Kr0_W6+Q=LQg-x2S58zFYAwKyUZmjV8da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kfir Lavi <lavi.kfir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53926 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab0JXNTo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:19:44 -0400
In-Reply-To: <AANLkTi=ngV_Kr0_W6+Q=LQg-x2S58zFYAwKyUZmjV8da@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-10-24 14:34, Kfir Lavi wrote:

>On Sun, Oct 24, 2010 at 1:31 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Sunday 2010-10-24 10:54, Kfir Lavi wrote:
>>
>>>I will need to move Ethernet, ARP and IP packets.
>>>What are my options regarding moving the packet modified with new
>>>custom header from one process to another process?
>>
>> http://en.wikipedia.org/wiki/Inter-process_communication lists ways of
>> transferring data between programs.
>>
>
>Thanks,
>There is no mention in this page about Netlink.

Netlink belongs to the class of sockets.

>As I'm getting packets from the kernel via netlink, I would think it's
>a good choice to continue using netlink.
>I'm trying now to create a small example code using libnl.
>What is your take on using netlink?

For user-to-user communications, the code would be simple enough to 
not warrant the use of libnl. Neither is a nlmsghdr structure needed.

My take is that I would not normally use Netlink for user-to-user 
communications. For one, you would need to know the PID of the other 
process, which is not always feasible to determine. Compare with a named 
PF_LOCAL socket where both processes only need to know a rendezvous 
point. Even TCP socket numbers are more predictable - and controllable 
even - than a random PID. Also note that due to Netlink's use of PIDs, 
you cannot access other PID namespaces.
