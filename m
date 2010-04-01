From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 01 Apr 2010 14:28:05 +0200
Message-ID: <4BB49155.3000902@trash.net>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org> <4BB480C6.9080604@trash.net> <alpine.LSU.2.01.1004011340120.17429@obet.zrqbmnf.qr> <4BB489E7.6050109@trash.net> <alpine.LSU.2.01.1004011410250.17429@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51270 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0DAM2I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:28:08 -0400
In-Reply-To: <alpine.LSU.2.01.1004011410250.17429@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2010-04-01 13:56, Patrick McHardy wrote:
>>>>>> just to defragment the packets in conntrack
>>>>>> immediately afterwards
>> This was supposed to read "one more *de*fragmentation pass. In
>> IPv6 we don't have to refragment, but simply output the original
>> fragments.
>>
>>> Assuming [nf-packet-flow.png] as a base, there are two
>>> spots in which conntrack/defrag happens: PREROUTING and OUTPUT.
>>> [...]
>>> We never see fragments in the ruleset
>>>
>>>  a) for netif_rx received packets, defrag will be run early
>>>     (yes, there's raw, but that's special anyway)
>>>
>>>  b) locally-generated packets are fragmented only after all of
>>>     Netfilter is done.
>> You're assuming conntrack is used.
> 
> That was what your original message was about, was it not?

Partially, but the ruleset construction point you replied to of
course only applies when conntrack is not used.

> If there is no nf_defrag loaded, there is not much left besides
> the standard IPv4 stack defrag on input, the fragmentation
> on output, and the double-fragmentation on forward.
> 
> What did I miss?

Now I seem to be missing something. Why are we suddenly talking
about IPv4 and nf_defrag?
