From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: macvlan device blocks traffic for 30 secs
Date: Sat, 27 Feb 2010 16:22:11 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251841150.14612@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002251743590.30827@obet.zrqbmnf.qr> <4B86AB36.6090402@trash.net> <alpine.LSU.2.01.1002251817040.13151@obet.zrqbmnf.qr> <4B86B132.9090906@trash.net> <alpine.LSU.2.01.1002251832340.13151@obet.zrqbmnf.qr>
 <4B86B4FE.7020408@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55105 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966882Ab0B0PWM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:22:12 -0500
In-Reply-To: <4B86B4FE.7020408@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-25 18:35, Patrick McHardy wrote:
>>>>> No, this works fine here. It might be related to filter reprogramming
>>>>> of the NIC. Which driver are you using?
>>>> tap0 on one the host, e1000 inside the virtualbox.
>>> I have no idea about virtualbox. I guess it might be related to
>>> bridging.
>> 
>> There is no vm bridging at all, it's plain routing between tap and eth 
>> (aka "Host Only Networking" in VMware slingo).
>
>Well then you have to send me some more data, like tcpdumps, a
>description of the entire networking setup etc.

I'd have the tcpdump data ready, but since I investigated further, the 
case is already closed. The breakdown in networking is specific to 
Virtualbox; I tried both VMware bridging to a real NIC, and VMware 
bridging to a tap device, neither of which caused a disruption.
