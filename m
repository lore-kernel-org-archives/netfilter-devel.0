From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack
Date: Wed, 25 Feb 2004 21:47:26 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402251247.VAA25777@toshiba.co.jp>
References: <200312240144.KAA15346@toshiba.co.jp>
	<20040224092137.GU13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
        jozef@sunbeam.gnumonks.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20040224092137.GU13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald, thank you for replying.

Sory about long message and poor english.

> > In previous version, the l3 part in tuple is represented by "union" of IPv4
> > and IPv6 address.
> > 
> > And in this version, size of the l3 part in tuple varies with layer 3
> > protocol.  Then it's more complex than the previous version, but can
> > save memory spaces where many IPv4 connections are created.
> 
> Yes, this is definitely something we need.  Although I still don't like
> the idea of having to explicitly allocate three pieces of memory
> (2*tuple, 1*nf_conntrack) per new connection.  This will hurt connection
> setup rate very badly, I expect :(

No.

When L3 protocol modules are registered, my implementation of
"dynamic version" calculate the size of 2 tuple + nf_conntrack, and
create caches. So

	$ cat /proc/slabinfo |grep nf_conntrack

prints	"nf_conntrack:ipv4" and "nf_conntrack:ipv6".

1 chunk includes static part of nf_conntrack and 2 tuples.
But memory spaces for helper, nat are statically allocated.
Because I wanted to see the impact of dynamic allocating memory space
for tuple, at first.

> What I initially had in mind (but don't know if it can be implemented in
> any reasonable way) was:
> 
> - have a static part of struct np_conntrack without tuples
> - this static part contains a bitmask
> - this bitmask determines which 'extension structures' are present at
>   the end
> - possible 'extension structures' might be:
> 	- ipv4 orig/reply tuple
> 	- ipv6 orig/reply tuple
> 	- ipv4 l3 protocol (and helper) data
> 	- ipv6 l3 protocol (and helper) data

Your idea about extension structure (L3/helper/nat union) is acceptable.

But I think tuple of IPv{4,6} should be represented by one structure
-- "struct nf_conntrack_tuple".

Your idea seems that ip_conntrack_tuple and ip6_conntrack_tuple are defined
individually. Please see nf_conntrack_proto_tcp.c in my implementation.
All functions can handle both tuples for IPv{4,6} . But if ip_conntrack_tuple
and ip6_conntrack_tuple are defined individually, we have to define
2 version of each functions which do same thing and have just different
type of argument "tuple".

	ex) ip_tcp_print_conntrack(ip_conntrack_tuple *tuple);
	    ip6_tcp_print_conntrack(ip6_conntrack_tuple *tuple);

This does't mean "Layer 3 independent".

BTW, unfortunately, I can't spend time for this work this 2 months.
Recently I changed my code to fairly compare 2 implementations, and roughly
evaluated. As I expected, the performance of "dynamic version" is more worse
than "static version".

So I concluded it is desirable to be statically defined the structure of tuple.

> I know it sounds very tricky.  We always guarantee the ordering of such
> extension structures.  The nf_conntrack core would maintain a list of
> slab caches for every reasonable combination of extensions structures.  
> The extension structures are always allocated in one chunk gogether with
> the static nf_conntrack 'header'.
> 
> Extension structures would always be accessed via pre-defined macros
> (which just add an offset depending on the bitmask)

It is efficient to keep the pointer to extension structure when allocating
nf_conntrack instead of calculating offset every access to it.

> Even thinking further, this would enable us to put more parts than just
> the tuple into those extensions (let's say the nat or helper union).
> This in turn means that we can make conntrack structures for the normal
> case (ipv4 only, no helper, no nat) even smaller.  
> 
> I'm not sure if it's worth performance-wise.  The benefits of such a
> solution would be:
> 
> 1) still one chunk of memory for any conntrack
> 	- one allocation at connection setup time
> 	- conntrack+tuple still physically close in memory instead of
> 	  having to dereference every tuple 
> 2) potentially smaller conntracks even in the current 'normal' case
>    (one of our long-term wishes)
> 
> As disadvantage I can see
> 1) difficult implementation with lots of macros/offset calculation
> 2) we'd have to determine which slab we came from at destroy() time
>    [maybe save cachep in nf_contrack?]
> 3) slightly higher computational cost when we want to access extension
>    structures (like tuples), since relative offset has to be calculated
>    at runtime.
> 
> What do you think?  

I think processing speed is more important for connection tracking than
saving memory space. But you got a point that unused memory space should
not be allocated.

my opinions are

1. It is desirable to be statically defined the structure of tuple.
   Because
	- tuple should be represented by one structure -- nf_conntrack_tuple
	  to get tcp/udp/icmp part in tuple independent of Layer 3 protocol.

	- I can't agree with dynamic structure of tuple due to performance
	  issue and difficulty of handling.

2. Your idea about extension structure (L3/helper/nat union) is acceptable.
   I expect that this impact to performance is small.But I worry about
   slowdown in the case of "nat helper union". When allocating conntrack,
   it is difficult to figure out whether conntrack will be processed or not
   by nat helper module. So I expect that it is needed to reallocate and copy
   conntrack before nat helper module processes it.

   On the other hand, there is no problem about "nat union" (= ip_nat_info).
   Because if nat module is loaded, all conntrack certainly have "null-binding"
   or "binding" which specified by user. So conntrack core module always
   need to allocate memory space for "nat union" in this case.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
