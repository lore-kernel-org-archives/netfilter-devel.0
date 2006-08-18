From: "Simon Lodal" <simonl@parknet.dk>
Subject: Re: new ABI
Date: Fri, 18 Aug 2006 15:06:03 +0200 (CEST)
Message-ID: <1086.83.88.199.217.1155906363.squirrel@mail.parknet.dk>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: max@nucleus.it, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <gozem@gozem.se>
In-Reply-To: <20060816121653.GA31235@kriss.csbnet.se>
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


> Also keep in mind that we can allow several targets. I previously in
> another mail talked about actions. Its not needed i think, but might
> make it easier to distringuisch between jumps, ending targets and just
> changing and logging targets. It should be perfect legal already today
> to say:
>
> iptables -m match -j other_chain -j LOG -j other_chain2 -j DROP -j TTL

LOG + DROP in one rule would be a huge improvement. Even though it would
just reintroduce an ipchains feature.

> Now, the last TTL will never be executed, but thats a user config
> choise. The sematics of the above can't be missunderstood.
>
>
> For kernel-space:
> -------------------
> I think the above is good. Perhaps we don't need restore as it can be
> done with dump. Only that dump must dump both initial state/config and
> current state.
> - init()
> - destroy()
> - dump() / restore()
> - change()
> - match() / target()
>
> Much importat is the change() that for exampel recent match can use to
> remove or add IPs in any recent list. There are several other matches
> that can use this. Quota for example. Add or remove bytes in the pot.
> Far more complex matches like ipset can use this as well.

That could provide the basis for some of the dynamic userspace features
that people are often pointed to on this list, even though they do not yet
exist.

> Also a good way of "finding your way" to either group of rules is
> needed. Today i have a router with 4096 IPs (students computers)
> behind. The IPs all need its own chain of rules. I won't go into why,
> but trust me, it's needed and the only flexible way that i have found.
> I have created a sort of binary tree of rules trying to make the access
> of each customer as painless as possible. This area needs work as well
> i think. I've seen many people asking if this exists. Simple solution
> might be to allow custom(?) modules that implemet different forms of
> jumping. To which group or chain do you want to jump to? Well: iptables
> -m match -J ipmapjump (notice the big -J)  The recent "goto" jump also
> fits here.

I would like to do it in a generic way: Introduce a "match index" variable
that can be set by matches and used by targets. A "--dports 1000:1023"
match has 24 possible matches, so it would set the index to between 0 and
23. Same can be done for IP, sets; all other matches that have a finite
set of possible matches and can enumerate them.
Now, it should be relatively simple to create a generic jump target that
uses the match index to jump to a specific subchain (donøt know exactly
how the list of subchains wouyld be defined, should not be that
difficult). Other interesting targets might be NAT that could NAT from/to
a base address plus match index.

> Summary:
> + Use XML to express firewall rules. Because its easy and backward
> compability will be easily ported. It fits both human written and
> scripted rules. The tool is already there in tons of places.
>
> + init, destory, dump/restore, change, match/target is needed as
> implemented functions (or Nulls) for the match / targets.
>
> + Use RCU-list in kernel. Because its more editable.
>
> + Have smart ways of allocate memory in kernel (slabs).
>
> + Allow sveral targets for one rule.
>
> + Perhaps seperate ending targets form non ending and jumps.
>
> + Allow customs jump modules, beside match and target modules.
>
> + Allow grouping of rules in some way. Really large firewall needs
> this.
>
> + We rather have one too many hooks/void *, unused rather than one too
> few for futhure use. It won't waste that much memory.
>
> + Design all this into pkttables rather than focus on IP/IPv6.


I agree with all your points, perhaps except the XML part ... I am one of
those non-converts. But you may be right anyway. It would be nice to have
an standard way to define a ruleset, as descriptive data rather than
commands.

Regards,
Simon
