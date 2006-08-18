From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Sat, 19 Aug 2006 00:24:28 +0200
Message-ID: <200608190024.28883.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20060816121653.GA31235@kriss.csbnet.se>
Content-Disposition: inline
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

On Wednesday 16 August 2006 2:16 pm, Joakim Axelsson wrote:

> We keep the idea of rules (rather than essay, compiled or other form). To
> make the new implementation as easy and as fast as possible i think using
> XML to express the firewall is a good way to go. Now before you turn on all
> your negatives, here's why:
>
> - We want the old (todays) iptables to be compliant.
> - We want an easy library that implements the ABI to kernel.
> - We want to make the smallest possible effort writing a userspace tool.
>   Leaving the more advacned for others / other projects.

We want the existing ABI to continue working. Having people recompile iptables 
with a kernel change is not a short term proposition. I'd say it's kernel 3.0 
matter.
Using it between user utilities/scripts and a new version of iptables is 
certainly feasible, but it already is.

> XML already has good parsers. We can very easily rewrite todays iptables to
> output XML. XML has no real limits on how to express things. Ofcourse can
> other future userspace program use the new ABI-library directly, not using
> the XML-parser. However, for those who doesn't want to learn the new
> library XML is very easy. Both for humans, scripts and programs.

This is good for automatic manipulation. I'm not convinced it will be easier 
to digest for humans.

> So we need one userspace library that talks the ABI with kernel. We also
> need a library using this ABI that parses XML-files and passes them to the
> ABI-library. Finally other userspace tools (that we do not need to write)
> that dumps from kernel passed by the kernel->ABI->XML and pushes XML rules.

I'm all for a good library. XML might just be one of its representation 
plugins.

> if (packet.ipv4.source = 1.2.3.4 AND limit(2/s)) then
> 	LOG(log-prefix, ...)
> 	jump(other-chain)
> 	DROP
> end if;
>
> The above might be much easier for a newbie to use. The best thing is that
> we are pushing the "need" to write these kind of tools to others as
> seperate projects. The common is XML. No need for complex parsers and trix
> using getopt().

I'm not convinced that this will be much easier to parse, but I was expecting 
more a tag hell. Maybe you're right. Count me as undecided yet.

> iptables is now easily ported like:
> iptables <-> XML <-> ABI <-> kernel

The old iptables needs to continue working. We can't introduce layers between 
it and the current kernel ABI.

> Also keep in mind that we can allow several targets. I previously in
> another mail talked about actions. Its not needed i think, but might make
> it easier to distringuisch between jumps, ending targets and just changing
> and logging targets. It should be perfect legal already today to say:
>
> iptables -m match -j other_chain -j LOG -j other_chain2 -j DROP -j TTL
>
> Now, the last TTL will never be executed, but thats a user config choise.
> The sematics of the above can't be missunderstood.

I like this idea. Maybe I would use a different parameter for actions ("-a"?), 
but it's interesting.

> I think the above is good. Perhaps we don't need restore as it can be done
> with dump. Only that dump must dump both initial state/config and current
> state.
> - init()
> - destroy()
> - dump() / restore()
> - change()
> - match() / target()
>
> Much importat is the change() that for exampel recent match can use to
> remove or add IPs in any recent list. There are several other matches that
> can use this. Quota for example. Add or remove bytes in the pot. Far more
> complex matches like ipset can use this as well.

How would you represent single match changes with your XML implementation?
It sure would be expressive enought for any kind of module data.

> I also think RCU-list will help instead of tables/arrays. Its much more
> common to add/change or remove a rule than add them all. I have a router
> with some 1000 rules. Its a pain to change on of them. To save cache misses

I usually wipe everything and write from scratch. All my firewalls are 
generated (at least partially) and I don't want to risk making mismatched 
changes in the current firewall and the generating script.
I'd need several much more powerful primitives to abandon the approach.

Anyway I agree to the usefulness of RCU lists.

> Another thing that could use an add is the way of grouping rules. "These
> set of rules belong to customer 1 and these to customer 2. And i'd like to
> only list all rules related to customer 1". Now there is two aproches to
> implement this. First one is to tag the rule with what rule or which group
> it belongs to. Another way it to create sub tables.
>
> Also a good way of "finding your way" to either group of rules is needed.
> Today i have a router with 4096 IPs (students computers) behind. The IPs
> all need its own chain of rules. I won't go into why, but trust me, it's
> needed and the only flexible way that i have found. I have created a sort
> of binary tree of rules trying to make the access of each customer as
> painless as possible. This area needs work as well i think. I've seen many
> people asking if this exists. Simple solution might be to allow custom(?)
> modules that implemet different forms of jumping. To which group or chain
> do you want to jump to? Well: iptables -m match -J ipmapjump (notice the
> big -J)
> The recent "goto" jump also fits here.

You want some sort of multijump?
I had this kind of problem too. ipmapjump seems too specific. We'd really need 
a rule compiler/optimizer to handle this in an efficient way.

In your language it would be something like:

switch(packet.ipv4.source && 0xFF)
   case 1: ...
   ...
end switch;

This would be several orders of magnitude more complex than the current system 
(although magnificient).

> Next, try to design this new iptables2/-ng so we don't need iptables3 in
> the future. Rather add one too many unused hooks, void * passed parameter
> than one too few.

Of course this is an illusion. Nothing short of Turing-completeness will 
prevent iptables3. Even so someone will ask for an OO-iptables, a 
generic-iptables, etc.
We can try to keep people satisfied for the next few years and plan for the 
unplanned, but there is always something that is really unplannable and 
unforeseeable.

> Design this so we can have pkttables. Meaning no need for seperate tables
> for iptables, ip6tables, arptables, ebtables. All in one. Its not that hard
> really. Just perhaps a few more tables (nat, mangle, raw, filter, bridge
> etc.) and move even the basic matching like source and dest address into
> modules.

OK.

> Summary:
> + Use XML to express firewall rules. Because its easy and backward
> compability will be easily ported. It fits both human written and scripted
> rules. The tool is already there in tons of places.

Not convinced yet, but keep insisting. :)
Of course we'd need someone to do it. :)

> + init, destory, dump/restore, change, match/target is needed as
> implemented functions (or Nulls) for the match / targets.

OK.

> + Use RCU-list in kernel. Because its more editable.

Mostly OK, for lack of better alternatives.

> + Have smart ways of allocate memory in kernel (slabs).

OK.

> + Allow sveral targets for one rule.
> + Perhaps seperate ending targets form non ending and jumps.

OK.
I'd separate flow-changing targets from packet-altering (or some other lateral 
effect) actions.
Actions would be like current targets with a "--continue" parameter and we 
could combine it with a target to make them stop.

> + Allow customs jump modules, beside match and target modules.

What exacly are you proposing?

> + Allow grouping of rules in some way. Really large firewall needs this.

Proposal?
What about function-chains that we could use as a match?

> + We rather have one too many hooks/void *, unused rather than one too few
> for futhure use. It won't waste that much memory.

Of course.

> + Design all this into pkttables rather than focus on IP/IPv6.

OK.

> Thanks for your time reading this far :-)

:)

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
