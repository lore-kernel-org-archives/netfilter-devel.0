From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] iptables gateway match
Date: Fri, 01 Jun 2007 20:36:38 +0100
Message-ID: <46607546.4050100@ufomechanic.net>
References: <46604D8B.7030507@ufomechanic.net> <46604EB0.9080302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46604EB0.9080302@trash.net>
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

Patrick McHardy wrote:
> Amin Azez wrote:
>   
>> This adds a gateway match to iptables that lets you match against the
>> routed ipv4 gateway, it's very useful for SNAT if you want to avoid
>> replicating your routing in your SNAT table.
>>
>> e.g.
>>
>> iptables -t nat -A POSTROUTING -m gateway --nexthop 172.16.1.1 -j SNAT
>> --to-address 172.16.1.5
>> iptables -t nat -A POSTROUTING -m gateway --nexthop 192.168.1.1 -j SNAT
>> --to-address 192.168.1.25
>>     
>
>
> I'm wondering whether we really need a new match for this. It should
> be possible to do the same using routing realms and the realm match.
>   
It's possible that it could be managed using realms, but THAT would be a 
hack, and one very hard for rule generating systems to use, especially 
if realms were already in use.

The match as used here is purely for ip<->ip routing compatability, easy 
auto generation of SNATing rules when the next hop router doesn't have a 
reverse route.

It's also useful for collecting per-gateway statistics (esp. with load 
balancing) and debugging complex routing.

It will also be useful to most people who won't or can't bend realms to 
their will.

I don't know if realms will help in the load balancing routing case anyway.

Sam
