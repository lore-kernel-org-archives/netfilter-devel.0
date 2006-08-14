From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 19:59:48 +0200
Message-ID: <20060814175948.GE7194@kriss.csbnet.se>
References: <20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
	<44E09E4F.3040506@trash.net>
	<20060814161337.GY7194@kriss.csbnet.se> <44E0A42D.604@trash.net>
	<20060814164048.GB7194@kriss.csbnet.se>
	<44E0A9D4.6060704@trash.net>
	<20060814171111.GD7194@kriss.csbnet.se>
	<44E0B780.7050804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44E0B780.7050804@trash.net>
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

2006-08-14 19:48:48+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > 2006-08-14 18:50:28+0200, Patrick McHardy <kaber@trash.net> ->
> > 
> >>Is that really useful without beeing able to change more than
> >>one component
> >>
> > 
> > 
> > I don't really understand your consern here?
> 
> Seems I accidentally cut out half of the sentence. I meant to ask
> if this is really useful if only one component of a rule can be
> changed at a time atomically.
> 
> 
> >>>>That is basically impossible. We can keep a compatible command-line
> >>>>interface, but the ABI can't be kept compatible. The interface itself
> >>>>it quite simple, but we also need new ruleset evaluation functions,
> >>>>new loop detection and probably a few other things.
> >>>
> >>>
> >>>This work is huge, but really needed. I don't feel I am skilled enough to
> >>>write it, only contribute with porting matches and other things. I did
> >>>however write most of the code that ipset is based on now. So I have the
> >>>"extreme amount of hook functions needed" in my back. 
> >>>
> >>>The real question is. Do we really want to force each match/target to
> >>>implement a fair amount of functions for it to work? We need to think big
> >>>from the start here, not missing some feature that will be hard to add
> >>>after. I rather see one too many needed function then one too few.
> >>
> >>Its not so much. The interface comes down to "init", "destroy", "dump",
> >>"do something". If we really want "change" it should be possible to
> >>do it in one function with "init".
> >>
> > 
> > 
> > So we are down to 4 function:
> > 1. init
> > 2. destroy
> > 3. match/target (use)
> > 4. dump (list)
> > 
> > Meaning an alter is really a "dump, destroy, init"?
> 
> No, but init and change will be pretty similar most of the time, so they
> can probably be handled by the same function.
> 
> > Perhaps we should add one or two "userdefined" functions. Something that the
> > modules can define for them self to use. For example in the quota-case this
> > can be "add more quota". It sure will make the new iptables-structure really
> > flexible. 
> > 
> > Example:
> > iptables -U1 --match-id xxxxx -m module --params
> > iptables -U1 --match-id 12345 -m quota --add-quota 4000
> > 
> > We might be able to do this in an alter if we construct the alter to be able
> > to take commands that the module can specify. Easily done if a seperate
> > struct is passed with defined data that the module can interpetrate it self.
> 
> This is not needed, netlink attributes can be nested, so module-specific
> stuff can be encapsulated in the module attributes.
> 

I don't really follow here? If you think really big. Include recent, ipset
and the old ippool-idea. Where data is added and removed into the modules
state as it works. If we want to change this state with a userspace tool we
either need:
1. /proc
2. a new userspace-tool hooking, like ipset (ippool).
3. Function added to this new iptables being capable of it. A simply init
will not do it. You can't remove one IP in a recent-pool using an
init-function. It will probably wipe them all and empty the recent-pool.

Removing the need to extra userspace programs (ipset, ippool, i know
accounting has a tool as well) or the need for /proc is a huge win in my
opinion. This also calls for two different forms of listing. The first one
is the one we have today. List the rules for your firewall. The second in is
to list the state of one match/target. Like 'cat
/proc/net/ipt_recent/xxxx' today.

Try to cover functions needed to operate ipset and/or recent from the
begining.

> > Chainging to using RCU-list instead of tables will probably break old
> > iptables badly. We can try writing a new iptables using the new API, but i
> > guess nobody will be really intressed in doing this work.
> 
> Both I and Harald are definitely interested in doing this work.
> Again, it must not break existing stuff, it will be something
> completely new (at least the core stuff, maybe not the targets
> or matches).
