From: Patrick McHardy <kaber@trash.net>
Subject: Re: A question about reinjecting packets
Date: Thu, 12 Feb 2004 17:10:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402BA58D.1030907@trash.net>
References: <20040211155807.GA3146@lain.localnet> <Pine.LNX.4.56L0.0402121032040.759@zero.fdns.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Unit Zero <onyx@zero.fdns.net>
In-Reply-To: <Pine.LNX.4.56L0.0402121032040.759@zero.fdns.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Unit Zero wrote:
> I actually have been wondering about reinjecting packets for some time... 
> I've written some test code but had limited success in actually getting 
> the packets out onto the wire. My issue is this: I want to steal outbound 
> packets before they hit the net and use add_timer() to schedule a callback 
> which sends the packet out after a certain delay. (To implement 
> rate-limiting that dosen't drop packets, but delays them when they exceed 
> a certain throughput.)

This is not possible. If you rate-limit packets you have to drop them
at some point if the input rate constantly exceeds the service rate.
Besides, there is not much use in sending packets that have long been
retransmitted.

> 
> I assume that I should be hooking into LOCAL_OUTPUT, and returning 
> NF_STOLEN (??) for packets that I snatch. But I have the same problem as 
> Paul... what kernel routine do I use in the timer function to send the 
> packet onto the network?

Why don't you build into the qos subsystem ? It has all the
infrastructure you need.

Regards,
Patrick

> 
> I think I've gotten some code which I hacked from the ipt_ROUTE target to 
> steal packets from netfilter and send them directly using ip_direct_send()
> from the ipt_ROUTE code, but they seem to re-enter netfilter and go 
> through the chains again, which causes an infinite loop when they get to
> the ip_direct_send() in the rule with my target again. So, basically, how 
> do I inject a packet AFTER the netfilter processing?
> 
> - V. M. Condino
> 
> On Wed, 11 Feb 2004, Paul Tipper wrote:
> 
> 
>>I've tried using ip6_xmit() (for which I constructed a struct flowi).
>>When I couldn't get that work I prodded about some more and tried to use
>>the NF_HOOK macro to send it out on PF_INET6, NF_IP6_POST_ROUTING, however
>>the packet never seems to make it out onto the network and just vanishes
>>without a trace, which leads me to believe I've not converted it properly
>>and some nice peice of code further down the line is dropping it for
>>safety reasons.
