From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Possible conntrack/kernel bug - not catching certain ICMP
 packets
Date: Tue, 26 Jul 2011 01:45:07 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107260143410.3972@frira.zrqbmnf.qr>
References: <4E202844.30602@wildgooses.com> <4E241AB0.5060603@wildgooses.com> <alpine.LNX.2.01.1107181415500.13166@frira.zrqbmnf.qr> <4E274C77.8080605@wildgooses.com> <4E27C458.5030605@trash.net> <4E27E6B1.4030606@wildgooses.com>
 <4E27EDFC.6020007@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ed W <lists@wildgooses.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60556 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1GYXpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:45:09 -0400
In-Reply-To: <4E27EDFC.6020007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-07-21 11:14, Patrick McHardy wrote:
>On 21.07.2011 10:43, Ed W wrote:
>> On 21/07/2011 07:16, Patrick McHardy wrote:
>>> It's expected behaviour since ICMP packets related to an existing
>>> connection don't refresh the connection and are not accounted.
>>> I don't have an opinion on whether they should be accounted, I
>>> guess you could argue both ways.
>> 
>> Thanks for the feedback.
>> 
>> I guess I was hoping that conntrack could be used for accurate bandwidth
>> accounting, however, it seems to ignore this type of packet, so it's
>> count is going to deviate from a simple interface byte counter?
>
>Yes, but it's going to do that anyways since there are also packets
>which can't be tracked, invalid packets, etc. Also conntrack doesn't
>account for link layer headers and only for IPv4/v6 packets.

While toying around, I found that if an skb is classified as RELATED,
skb->nfct->master always points to skb->nfct itself. Is that a bug
or something? Should it not point to the origin CT?
