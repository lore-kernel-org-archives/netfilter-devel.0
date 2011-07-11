From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH next] netfilter: nfqueue: batch verdict support
Date: Mon, 11 Jul 2011 11:44:32 +0200
Message-ID: <4E1AC600.8050005@trash.net>
References: <1307657659-30266-1-git-send-email-fw@strlen.de> <4E1310EC.1030401@trash.net> <20110707134552.GX16021@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46133 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1GKJog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:44:36 -0400
In-Reply-To: <20110707134552.GX16021@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 07.07.2011 15:45, schrieb Florian Westphal:
> Patrick McHardy <kaber@trash.net> wrote:
>> On 10.06.2011 00:14, Florian Westphal wrote:
>>> Introduces a new nfnetlink type that applies a given
>>> verdict to all queued packets with an id <= the id in the verdict
>>> message.
>>>
>>> If a mark is provided it is applied to all matched packets.
>>>
>>> This reduces the number of verdicts that have to be sent.
>>> Applications that make use of this feature need to maintain
>>> a timeout to send a batchverdict periodically to avoid starvation.
>>
>> Thanks Florian. Do you have any throughput numbers with this patch?
> 
> I re-ran some tests via lo, with Eric Dumazets
> "netfilter: nfqueue: assert monotonic packet ids" patch applied on top of
> a 2.6.39.2 kernel.
> 
> With "one accept per packet", the rest program needs
> about two minutes to process 10000000 1024-Byte udp packets
> sent via lo (queueing via
> -t mangle -I INPUT -i lo -p udp -m udp --dport 6666 -j NFQUEUE --queue-num 0
> ; no other queueing rules active)
> 
> When sending batch accept verdicts for every tenth packet received,
> run time was reduced to about 72 seconds.
> 
> I ran this several times and the results were similar.

Thanks, that sounds pretty promising.

> Just to be sure I also tried with the Erics RCU patch applied but I
> did not see any changes (not surprising because nfnl_mutex should
> not cause contention in the "single queue" case).

I'll have another look at this patch later. As I wrote, I'm unsure
whether we want to do a full move to RCU because of ctnetlink, but
the optional RCU callbacks seem fine for now.
