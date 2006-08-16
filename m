From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Wed, 16 Aug 2006 14:16:53 +0200
Message-ID: <20060816121653.GA31235@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
Content-Disposition: inline
In-Reply-To: <200608142312.41851.max@nucleus.it>
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

2006-08-14 23:12:41+0200, Massimiliano Hofer <max@nucleus.it> ->
> I think the current array oriented data structures won't allow us to add these 
> features. RCU lists come to mind. It sure is a step back in performance 
> (sparser access to memory and more memory fragmentation), but it may not be 
> that noticeable.
> I think every match/target should expode:
> - init;
> - destroy;
> - change;
> - dump;
> - restore.
> 
   match()/target()

I had some more realistic ideas that i'd like to share.

We keep the idea of rules (rather than essay, compiled or other form). To
make the new implementation as easy and as fast as possible i think using
XML to express the firewall is a good way to go. Now before you turn on all
your negatives, here's why:

- We want the old (todays) iptables to be compliant.
- We want an easy library that implements the ABI to kernel.
- We want to make the smallest possible effort writing a userspace tool.
  Leaving the more advacned for others / other projects.

XML already has good parsers. We can very easily rewrite todays iptables to
output XML. XML has no real limits on how to express things. Ofcourse can
other future userspace program use the new ABI-library directly, not using
the XML-parser. However, for those who doesn't want to learn the new library
XML is very easy. Both for humans, scripts and programs.

So we need one userspace library that talks the ABI with kernel. We also
need a library using this ABI that parses XML-files and passes them to the
ABI-library. Finally other userspace tools (that we do not need to write)
that dumps from kernel passed by the kernel->ABI->XML and pushes XML rules.

You can now easily write pre-parser later that can take firewall config on
"programing" form: Example:

if (packet.ipv4.source = 1.2.3.4 AND limit(2/s)) then 
	LOG(log-prefix, ...)
	jump(other-chain)
	DROP
end if;

The above might be much easier for a newbie to use. The best thing is that
we are pushing the "need" to write these kind of tools to others as seperate
projects. The common is XML. No need for complex parsers and trix using
getopt().

iptables is now easily ported like:
iptables <-> XML <-> ABI <-> kernel



Also keep in mind that we can allow several targets. I previously in another
mail talked about actions. Its not needed i think, but might make it easier
to distringuisch between jumps, ending targets and just changing and logging
targets. It should be perfect legal already today to say:

iptables -m match -j other_chain -j LOG -j other_chain2 -j DROP -j TTL

Now, the last TTL will never be executed, but thats a user config choise.
The sematics of the above can't be missunderstood.


For kernel-space:
-------------------
I think the above is good. Perhaps we don't need restore as it can be done
with dump. Only that dump must dump both initial state/config and current
state.
- init()
- destroy()
- dump() / restore()
- change()
- match() / target() 

Much importat is the change() that for exampel recent match can use to
remove or add IPs in any recent list. There are several other matches that
can use this. Quota for example. Add or remove bytes in the pot. Far more
complex matches like ipset can use this as well.

Also important is that easy instancse of a match/target in kernel needs its
own memory-space. Either allocated by iptables code or just a pointer-hook
where the module can allocate and hook in self. Just like priv_data, but
actually saved.

I also think RCU-list will help instead of tables/arrays. Its much more
common to add/change or remove a rule than add them all. I have a router
with some 1000 rules. Its a pain to change on of them. To save cache misses
we can preallocate memory and use. Meaning use slabs for each list element.
We can't control the code of the modules, but again, we can't today either.

Another thing that could use an add is the way of grouping rules. "These set
of rules belong to customer 1 and these to customer 2. And i'd like to only
list all rules related to customer 1". Now there is two aproches to
implement this. First one is to tag the rule with what rule or which group
it belongs to. Another way it to create sub tables. 

Also a good way of "finding your way" to either group of rules is needed.
Today i have a router with 4096 IPs (students computers) behind. The IPs all
need its own chain of rules. I won't go into why, but trust me, it's needed
and the only flexible way that i have found. I have created a sort of binary
tree of rules trying to make the access of each customer as painless as
possible. This area needs work as well i think. I've seen many people asking
if this exists. Simple solution might be to allow custom(?) modules that
implemet different forms of jumping. To which group or chain do you want to
jump to? Well: iptables -m match -J ipmapjump (notice the big -J) 
The recent "goto" jump also fits here.


Next, try to design this new iptables2/-ng so we don't need iptables3 in the
future. Rather add one too many unused hooks, void * passed parameter than
one too few.

Design this so we can have pkttables. Meaning no need for seperate tables
for iptables, ip6tables, arptables, ebtables. All in one. Its not that hard
really. Just perhaps a few more tables (nat, mangle, raw, filter, bridge
etc.) and move even the basic matching like source and dest address into
modules.

Summary:
+ Use XML to express firewall rules. Because its easy and backward
compability will be easily ported. It fits both human written and scripted
rules. The tool is already there in tons of places.

+ init, destory, dump/restore, change, match/target is needed as implemented
functions (or Nulls) for the match / targets.

+ Use RCU-list in kernel. Because its more editable.

+ Have smart ways of allocate memory in kernel (slabs).

+ Allow sveral targets for one rule.

+ Perhaps seperate ending targets form non ending and jumps.

+ Allow customs jump modules, beside match and target modules.

+ Allow grouping of rules in some way. Really large firewall needs this.

+ We rather have one too many hooks/void *, unused rather than one too few
for futhure use. It won't waste that much memory.

+ Design all this into pkttables rather than focus on IP/IPv6.

Thanks for your time reading this far :-)

--
Joakim Axelsson
