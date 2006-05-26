From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] log dropped ICMP redirects
Date: Fri, 26 May 2006 16:49:15 +0200
Message-ID: <4477156B.7090703@trash.net>
References: <20060524040441.111049000@snapgear.com>	<20060524040951.092582000@snapgear.com>
	<44748922.4060207@trash.net> <447517CD.6040705@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <447517CD.6040705@snapgear.com>
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

Philip Craig wrote:
> On 05/25/2006 02:26 AM, Patrick McHardy wrote:
> 
>>There was a patch called "dropped table" once that hooked in kfree_skb.
>>I'm also not completely satisfied with the current situation .. but
>>I don't think adding excessive packet logging is the best solution,
>>often drops just occur because of failed validity checks which can
>>just as well happen outside of the netfilter code.
> 
> 
> I'm not sure what checks occur outside of netfilter code, but I assume
> they are mostly things that would be dropped by any router, not just
> a firewall?

In most cases yes.

> For connection tracking, the goal should be to never drop anything,
> and instead mark it as invalid.  My first version of this patch
> just removed this test completely, so then I could log it with an
> iptables rule before dropping it.  But I didn't think that was suitable
> for general use.

For invalid checks, it is :) But if you can already log it before it
gets dropped, why remove the check?


> For other validity checks within netfilter, this is a possible use for
> the unclean match.   This would allow you to use rules to do the
> checks, log the packet, and drop it.  And if this was done in the raw
> table, then it could cover some of the connection tracking checks too.
> What was the problem with the unclean match, did it simply check too much?

The main reason is that is was very strict, so any future enhancements
of protocols would probably be detected as invalid. This is a big
problem, think of ECN for example. But it would only cover a subset
of the possible reasons anyway.

Bottom line: I can't see a good solution for this problem right now.

>>In this case I'm actually having trouble understanding what the code
>>is supposed to do, why would we receive an ICMP redirect for a
>>unhashed connection (unhashed == first packet hasn't even left the
>>box yet)?
> 
> 
> I don't understand the reason for the code either.


I think I do now. It is meant to drop locally generated ICMP redirects
in cases where the source and NATed destination are on the same network.
The condition can't be true anymore since we started attaching conntrack
references to locally generated ICMP packets, which suggests that we
need to do this somewhere else.
