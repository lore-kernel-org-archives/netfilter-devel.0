From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: nfcache
Date: Tue, 22 Feb 2005 12:52:01 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502221232590.18441@kaber.coreworks.de>
References: <3305af12050221214270478e50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: gan hawk <ganhawk@gmail.com>
In-Reply-To: <3305af12050221214270478e50@mail.gmail.com>
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

On Mon, 21 Feb 2005, gan hawk wrote:
> I started using Netfilter/Iptables some time back. I am wondering why
> a caching system for Netfilter which Rusty and Harald envisioned was
> never developed ? If the caching system is no longer required, can
> someone please enlighten me on why. I had posted a message regarding
> this some months earlier, but I did not receive any responses :( and
> hence dropped the idea.

In many cases connection tracking is used in a way that only the first
packet of each connection needs to traverse the entire ruleset. In my
opinion cacheing is not really necessary, if we really want to improve
performance we should rethink the O(n) ruleset evaluation approach. I 
can see in your patch that you only cache positive results. This still
leaves the bigger part of the problem, packets that are not allowed
usually need to traverse the bigger part of the ruleset and conntrack
doesn't help here.

> This currently caches only packets destined for the local machine.
>
> 1) The basic idea is to store the packet information (whatever is
> present in the SKB) in a AVL tree.
>
> 2) Check incoming packet before all the hooks for cache match and if
> so, set a flag in nfcache. A match is said to be present if the values
> for all the flags in the stored nfcache of any node match the incoming
> packet's values.
>
> 3) If the packet is destined for the local machine and the cache flag
> is set, don't pass through the IP Tables rules only (the whole chain)
> (Right now it skips the whole NF_IP_LOCAL_IN hook! )
>
> 4) Check the packet that passed through the firewall after all the
> rules and add it to the cache.
>
> My plan is to have few base trees such as based on source address,
> based on destination port etc.
>
> The incoming source address is first searched on source address, then
> based on destination port and so on. If there is no rule in the
> iptables that uses any of the parameters, then a dummy rule is
> inserted in the chain, so that the packets can be cached in one of the
> trees. Right now, I add a dummy rule to check one of the known source
> address at the end, so that it will be cached in the source address
> tree.

A couple of comments:
- Any cacheing scheme should be optional
- You need to use all criteria present in the ruleset for the cache
   to avoid giving false results
- should cache all kinds of results
- stateful matches should be handled somehow
- needs to handle ruleset changes

BTW: There is an interesting paper on using Bloom filters for
caching the result of packet filters. I think the idea is quite
nice, you need very little memory and can freely tune the
probability of false results :) I'm not sure though if others
agree on the usefulness.

Regards
Patrick
