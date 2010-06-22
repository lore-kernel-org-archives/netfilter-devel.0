From: Patrick McHardy <kaber@trash.net>
Subject: Re: Accessing packet marking functions
Date: Tue, 22 Jun 2010 08:16:35 +0200
Message-ID: <4C205543.9080902@trash.net>
References: <1276965739.1476.35.camel@andybev>	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>	 <1277032613.1476.93.camel@andybev>	 <alpine.LSU.2.01.1006201351490.23203@obet.zrqbmnf.qr> <1277037072.1476.107.camel@andybev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40856 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab0FVGQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:16:36 -0400
In-Reply-To: <1277037072.1476.107.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andrew Beverley wrote:
>>>>> Can somebody point me in the right direction for the correct way of
>>>>> setting and accessing the mark value of a packet? The TOS feature in
>>>>> Squid uses setsockopt(). Is there an equivalent for mark? Should I be
>>>>> using libnetfilter_queue?
>>>>>           
>>>> setsockopt(fd, SOL_SOCKET, SO_MARK, ...)
>>>>         
>>> I am getting the error "Operation not permitted" when trying to do this.
>>> Is this because the packet is not in a state where it can be marked, or
>>> am I doing something stupid? My code is:
>>>
>>> int nfmark = 255;
>>> setsockopt(fd, SOL_SOCKET, SO_MARK, (int *) &nfmark, sizeof(int));
>>>       
>
>   
>> 1. Do away with the pointless casts.
>> 2. Needs root privileges.
>>     
>
> Thanks, that works now when running as root (with pointless casts
> removed).
>
> The problem is that Squid normally runs as a non-privileged user (I had
> to remove the root checks from the code to get it to run as root). Is
> there any way to mark packets when not root? Or is the only way to make
> this work to run a small part of Squid as root?


enter_suid()/leave_suid().
