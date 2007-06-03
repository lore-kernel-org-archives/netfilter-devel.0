From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables gateway match
Date: Sun, 03 Jun 2007 19:10:29 +0200
Message-ID: <4662F605.9040700@trash.net>
References: <46604D8B.7030507@ufomechanic.net> <46604EB0.9080302@trash.net>
	<46607546.4050100@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46607546.4050100@ufomechanic.net>
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

Amin Azez wrote:
> Patrick McHardy wrote:
> 
>> I'm wondering whether we really need a new match for this. It should
>> be possible to do the same using routing realms and the realm match.
>>   
> 
> It's possible that it could be managed using realms, but THAT would be a
> hack, and one very hard for rule generating systems to use, especially
> if realms were already in use.


I don't consider that this a hack. Its even more useful since you
can do masked matches. I also don't see the problem for generated
rules, in fact I used them for exactly this (and other) purpose
in a rule generating system.

> The match as used here is purely for ip<->ip routing compatability, easy
> auto generation of SNATing rules when the next hop router doesn't have a
> reverse route.
> 
> It's also useful for collecting per-gateway statistics (esp. with load
> balancing) and debugging complex routing.
> 
> It will also be useful to most people who won't or can't bend realms to
> their will.
> 
> I don't know if realms will help in the load balancing routing case anyway.


Yes, you can use one realm per nexthop.
