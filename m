From: Unit Zero <onyx@zero.fdns.net>
Subject: Re: A question about reinjecting packets
Date: Thu, 12 Feb 2004 10:51:52 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0402121032040.759@zero.fdns.net>
References: <20040211155807.GA3146@lain.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040211155807.GA3146@lain.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I actually have been wondering about reinjecting packets for some time... 
I've written some test code but had limited success in actually getting 
the packets out onto the wire. My issue is this: I want to steal outbound 
packets before they hit the net and use add_timer() to schedule a callback 
which sends the packet out after a certain delay. (To implement 
rate-limiting that dosen't drop packets, but delays them when they exceed 
a certain throughput.)

I assume that I should be hooking into LOCAL_OUTPUT, and returning 
NF_STOLEN (??) for packets that I snatch. But I have the same problem as 
Paul... what kernel routine do I use in the timer function to send the 
packet onto the network?

I think I've gotten some code which I hacked from the ipt_ROUTE target to 
steal packets from netfilter and send them directly using ip_direct_send()
from the ipt_ROUTE code, but they seem to re-enter netfilter and go 
through the chains again, which causes an infinite loop when they get to
the ip_direct_send() in the rule with my target again. So, basically, how 
do I inject a packet AFTER the netfilter processing?

- V. M. Condino

On Wed, 11 Feb 2004, Paul Tipper wrote:

> I've tried using ip6_xmit() (for which I constructed a struct flowi).
> When I couldn't get that work I prodded about some more and tried to use
> the NF_HOOK macro to send it out on PF_INET6, NF_IP6_POST_ROUTING, however
> the packet never seems to make it out onto the network and just vanishes
> without a trace, which leads me to believe I've not converted it properly
> and some nice peice of code further down the line is dropping it for
> safety reasons.
