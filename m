From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: do not omit re-route check on NF_QUEUE
 verdict
Date: Thu, 20 Jan 2011 08:53:47 +0100
Message-ID: <4D37EA0B.1080706@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-7-git-send-email-fw@strlen.de> <4D35AE71.6010301@trash.net> <20110119231435.GA956@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62735 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1ATHxt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:53:49 -0500
In-Reply-To: <20110119231435.GA956@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.01.2011 00:14, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>> On 16.01.2011 14:19, Florian Westphal wrote:
>>> ret != NF_QUEUE only works in the "--queue-num 0" case; for
>>> queues > 0 the test should be '(ret & NF_VERDICT_MASK) != NF_QUEUE'.
>>>
>>> However, NF_QUEUE no longer DROPs the skb unconditionally if queueing
>>> fails (due to NF_VERDICT_FLAG_QUEUE_BYPASS verdict flag), so the
>>> re-route test should also be performed if this flag is set in the
>>> verdict.
>>>
>>> The full test would then look something like
>>>
>>> && ((ret & NF_VERDICT_MASK) == NF_QUEUE && (ret & NF_VERDICT_FLAG_QUEUE_BYPASS))
>>>
>>> This is rather ugly, so just remove the NF_QUEUE test altogether.
>>>
>>> The only effect is that we might perform an unnecessary route lookup
>>> in the NF_QUEUE case.
>>
>> Alternatively we could have nf_queue.c perform the rerouting when
>> a packet is marked for queue bypass, just as it already does when
>> reinjecting a packet. mangle just needs to check for NF_ACCEPT,
>> since that is the only verdict we can return from the table that
>> doesn't cause the packet to be dropped or queued.
> 
> Hrm.  I was looking into this, but the current logic appears to be subtly
> broken, or at least it is inconsistent.
> 
> Here is what I did:
> 
> ip addr add 192.168.7.20/24 dev eth0
> ip addr add 192.168.8.20/24 dev eth1
> ip route add default via 192.168.7.1
> ip route add default via 192.168.8.1 table 2
> ip rule fwmark 2 lookup 2
> 
> iptables -t mangle -A OUTPUT -d 10.1.1.1 -j MARK --set-mark 2
> 
> When I run 'ping -c 1 10.1.1.1' i see the icmp packet on eth1.
> 
> But, when I add
> iptables -t mangle -A OUTPUT -d 10.1.1.1 -j NFQUEUE
> 
> I see the packet leaving via eth0 (i am running the nfqueue test program
> from libnetfilter_queue on id 0).
> 
> When I change the rule to -j NFQUEUE --queue-id 1, it leaves via eth1
> %-)
> 
> Here is what I think is happening:
> 
> In the --queue-id 0 case, ipt_mangle_out() skips rerouting, because
> it tests for ret != NF_QUEUE.
> 
> But nf_queue does not re-route either:
> __nf_queue calls afinfo->saveroute(), and, because the test program
> does not modify the nfmark any further, afinfo->reroute does not do
> anything.
> 
> In the --queue-id 1 case, ipt_mangle_out() does re-routing because
> the return value is (1 << 16|NF_QUEUE) and the nfmark is different
> than it was before OUTPUT was called.
> 
> My think it would be best to just remove the 'ret != NF_QUEUE' test
> in ipt_mangle_out so we always re-route when the nfmark was modified.
> 
> Thoughts?

Indeed, that seems inconsistent and I agree with your explanation
and suggested fix. I'll apply your patch once the current batch
has been merged, thanks.
