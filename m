From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible conntrack/kernel bug - not catching certain ICMP packets
Date: Tue, 26 Jul 2011 15:00:49 +0200
Message-ID: <4E2EBA81.2070201@trash.net>
References: <4E202844.30602@wildgooses.com> <4E241AB0.5060603@wildgooses.com> <alpine.LNX.2.01.1107181415500.13166@frira.zrqbmnf.qr> <4E274C77.8080605@wildgooses.com> <4E27C458.5030605@trash.net> <4E27E6B1.4030606@wildgooses.com> <4E27EDFC.6020007@trash.net> <alpine.LNX.2.01.1107260143410.3972@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ed W <lists@wildgooses.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48338 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1GZMmT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:42:19 -0400
In-Reply-To: <alpine.LNX.2.01.1107260143410.3972@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.07.2011 01:45, Jan Engelhardt wrote:
> 
> On Thursday 2011-07-21 11:14, Patrick McHardy wrote:
>> On 21.07.2011 10:43, Ed W wrote:
>>> On 21/07/2011 07:16, Patrick McHardy wrote:
>>>> It's expected behaviour since ICMP packets related to an existing
>>>> connection don't refresh the connection and are not accounted.
>>>> I don't have an opinion on whether they should be accounted, I
>>>> guess you could argue both ways.
>>>
>>> Thanks for the feedback.
>>>
>>> I guess I was hoping that conntrack could be used for accurate bandwidth
>>> accounting, however, it seems to ignore this type of packet, so it's
>>> count is going to deviate from a simple interface byte counter?
>>
>> Yes, but it's going to do that anyways since there are also packets
>> which can't be tracked, invalid packets, etc. Also conntrack doesn't
>> account for link layer headers and only for IPv4/v6 packets.
> 
> While toying around, I found that if an skb is classified as RELATED,
> skb->nfct->master always points to skb->nfct itself. Is that a bug
> or something? Should it not point to the origin CT?

For RELATED connections expected by a helper? That would be wrong, it
should point to the real master.
