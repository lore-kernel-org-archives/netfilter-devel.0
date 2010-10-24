From: Kfir Lavi <lavi.kfir@gmail.com>
Subject: Re: Moving modified packets between processes
Date: Sun, 24 Oct 2010 16:05:38 +0200
Message-ID: <AANLkTi=bbJkuuoGQ6rRtMcdH=pEh94xk1HWAZKBVcFq7@mail.gmail.com>
References: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com>
	<alpine.LNX.2.01.1010241325410.23809@obet.zrqbmnf.qr>
	<AANLkTi=ngV_Kr0_W6+Q=LQg-x2S58zFYAwKyUZmjV8da@mail.gmail.com>
	<alpine.LNX.2.01.1010241454300.2665@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32805 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0JXOFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:05:39 -0400
Received: by iwn34 with SMTP id 34so3214475iwn.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 07:05:38 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010241454300.2665@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 24, 2010 at 3:19 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Sunday 2010-10-24 14:34, Kfir Lavi wrote:
>
>>On Sun, Oct 24, 2010 at 1:31 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>> On Sunday 2010-10-24 10:54, Kfir Lavi wrote:
>>>
>>>>I will need to move Ethernet, ARP and IP packets.
>>>>What are my options regarding moving the packet modified with new
>>>>custom header from one process to another process?
>>>
>>> http://en.wikipedia.org/wiki/Inter-process_communication lists ways of
>>> transferring data between programs.
>>>
>>
>>Thanks,
>>There is no mention in this page about Netlink.
>
> Netlink belongs to the class of sockets.
>
>>As I'm getting packets from the kernel via netlink, I would think it's
>>a good choice to continue using netlink.
>>I'm trying now to create a small example code using libnl.
>>What is your take on using netlink?
>
> For user-to-user communications, the code would be simple enough to
> not warrant the use of libnl. Neither is a nlmsghdr structure needed.
>
> My take is that I would not normally use Netlink for user-to-user
> communications. For one, you would need to know the PID of the other
> process, which is not always feasible to determine. Compare with a named
> PF_LOCAL socket where both processes only need to know a rendezvous
> point. Even TCP socket numbers are more predictable - and controllable
> even - than a random PID. Also note that due to Netlink's use of PIDs,
> you cannot access other PID namespaces.
>

I'm not sure I have a problem with the PID's, because both processes
are in my hand, and I write the code for them.
Does this changes your answer?

I'm having a look on PF_LOCAL, to see if it suits my needs.
Regards,
Kfir
