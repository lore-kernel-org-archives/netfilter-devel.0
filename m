From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resolving inner ICMP connections
Date: Sun, 04 Dec 2005 21:24:23 +0100
Message-ID: <43935077.3030903@trash.net>
References: <438F501A.5060804@cs.princeton.edu> <439316EB.2030401@trash.net>
	<43933E81.3080702@cs.princeton.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mark Huang <mlhuang@CS.Princeton.EDU>
In-Reply-To: <43933E81.3080702@cs.princeton.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Mark Huang wrote:
> Patrick McHardy wrote:
> 
>> That depends. What do you mean with "makes no sense"?
> 
> 
> Well, in the case of the French router, plain wrong.

The question is, how can conntrack know its "wrong"? There is
no relationship between the inner and the outer addresses that
we could rely on.

> But I can imagine a 
> few other scenarios as well. The inner IP packet could be completely 
> unrelated to any current connection, or it could be a cracker trying to 
> break some current connection on the machine by spoofing inner ICMP 
> packets. I'm just speculating and don't have any tests to back this 
> claim up, but I might try it just to see what happens.

It its completely unrelated it will be tracked as state INVALID.
Spoofed ICMP packets don't affect conntrack directly, ICMP replies
are only tracked to make filtering easier and to correctly reverse
NAT the inner packet. It doesn't affect the connection state.

>> Maybe an old version of linux? :) NAT used to do stange things to
>> locally generated ICMP packets until about a year ago.
> 
> 
> Do you mean on the French router or on my box? I don't know what's 
> running on the French router, but I'm running a 2.6.12ish kernel.

The router.

>> What are these assumptions?
> 
> Well, the worst assumption was that
> 
> conntrack->tuplehash[dir].tuple.dst.ip == skb->nh.iph->ipaddr
> 
> I.e., the conntrack associated with the packet I received on the local 
> IN hook, has the same destination IP address as the packet itself, which 
> in retrospect is probably a bad assumption. When the French router 
> returned the inverted ICMP error message, the conntract dst.ip was that 
> of the French router, not my IP address!

OK, thats weird. I don't think this can be used to confuse conntrack
itself, but I'm going to check.
