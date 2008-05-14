From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFLOG - missing packets?
Date: Wed, 14 May 2008 19:53:47 +0200
Message-ID: <482B272B.3040906@trash.net>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com> <20080511161837.GJ11778@ice-age> <200805121224.12073.anton.vazir@gmail.com> <482B2626.8080902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Anton <anton.vazir@gmail.com>, Eric Leblond <eric@inl.fr>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48032 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYENRxt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 13:53:49 -0400
In-Reply-To: <482B2626.8080902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Anton wrote:
>> Just some extra results,
>>
>> seems DB drivers does such a difference, since while logging 
>> to LOGEMU (only) target - I've go result which looks true. 
>> But - If I enable DB logger - results in DB and LOGEMU - 
>> are the same. Looks like DB transfers makes ULOG to not 
>> accept packets from kernelspace
> 
> The problem is netlink that cannot back off. Netlink is the underlying
> communication subsystem that we use to communicate kernel with usepace
> space. Since Netlink is unreliable, some log messages can vanish under
> heavy load. I guess that database insertions consumes lots of CPU
> resouces. Thus, doing online database logging in a scalable manner turns
> really hard. Instead, if you need scalability, I'd suggest to use logemu
> or whatever plain text logging facility and then convert it to a
> database *offline* if you really need advanced queries.


Yeah, but what we can do is check whether the message
was successfully transmitted in the kernel and drop
the packet in case it wasn't. That should catch 99.9%
of all error cases since a slow databse effectively
only causes the process to read less often from the
netlink socket.

I still have a very old and unfinished patch for this
somewhere ...

