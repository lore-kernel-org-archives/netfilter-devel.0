From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/5] netfilter: ipv6: move POSTROUTING invocation before
 fragmentation
Date: Thu, 1 Apr 2010 14:13:13 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004011410250.17429@obet.zrqbmnf.qr>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de> <1270031487-15094-2-git-send-email-jengelh@medozas.de> <4BB47A5E.6090205@linux-ipv6.org> <4BB480C6.9080604@trash.net> <alpine.LSU.2.01.1004011340120.17429@obet.zrqbmnf.qr>
 <4BB489E7.6050109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54957 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0DAMNO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:13:14 -0400
In-Reply-To: <4BB489E7.6050109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-01 13:56, Patrick McHardy wrote:
>
>>>>> just to defragment the packets in conntrack
>>>>> immediately afterwards
>
>This was supposed to read "one more *de*fragmentation pass. In
>IPv6 we don't have to refragment, but simply output the original
>fragments.
>
>> Assuming [nf-packet-flow.png] as a base, there are two
>> spots in which conntrack/defrag happens: PREROUTING and OUTPUT.
>> [...]
>> We never see fragments in the ruleset
>> 
>>  a) for netif_rx received packets, defrag will be run early
>>     (yes, there's raw, but that's special anyway)
>> 
>>  b) locally-generated packets are fragmented only after all of
>>     Netfilter is done.
>
>You're assuming conntrack is used.

That was what your original message was about, was it not?

If there is no nf_defrag loaded, there is not much left besides
the standard IPv4 stack defrag on input, the fragmentation
on output, and the double-fragmentation on forward.

What did I miss?
