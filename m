From: Patrick McHardy <kaber@trash.net>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 22:18:25 +0200
Message-ID: <4835D511.7030503@trash.net>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net> <20080522201419.GA28832@internet24.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYEVUUH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 16:20:07 -0400
In-Reply-To: <20080522201419.GA28832@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
>> Thats one of the things I also want to add (halfway finished yet).
>> Jumps are regular verdicts in my new design and verdicts can be
>> gathered though lookups in sets, hashes etc. So you could do:
>>
>> unnamed ... -j { 192.168.0.1:chain_1, 192.168.0.2:chain_2, ...}
>>     
>
> Great news, that's more or less what I'm looking to do.
>
> Would those plans also include some way to incrementally
> manipulate these verdict sets, maybe like:
>
> unnamed ... -j dstset:targets
>
> settool --name targets --add 192.168.0.10:chain_10
>
> ?

Not implemented yet, but I'm probably going to add this as an option
(since it may affect the choice of data structure). For jumps its
tricky though because loop detection has to be performed.

>   
>> It would be great to have this in shape by next year, but I won't
>> promise anything. Should be doable though.
>>     
>
> Looking forward to be an avid beta tester then ;-)
>   

Great :)


