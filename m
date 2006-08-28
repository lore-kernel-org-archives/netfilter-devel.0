From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: ipt_LOG and friends. Question
Date: Mon, 28 Aug 2006 14:03:34 +0200
Message-ID: <20060828120334.GA8994@kriss.csbnet.se>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
	<44EDD07D.1020805@trash.net>
	<20060827150456.GA9190@kriss.csbnet.se>
	<44F2CC09.4060109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44F2CC09.4060109@trash.net>
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

2006-08-28 12:57:13+0200, Patrick McHardy <kaber@trash.net> ->
> Joakim Axelsson wrote:
> > I am currently half way writing this up. However i'm modifying it after my
> > needs primarily. I think they might meet the netfilters general taste as
> > well. I am currently fixing the following:
> > 
> > 1. Instead of calling printk() very here and there, it prints to a global
> > buffer (using a spinlock). To finally calling printk once. This works fine.
> > Its coded and tested.
> 
> That part I would like to put in mainline.
> 

Okie, i'll se if i can just make a patch for that small part. Might be hard
as i merge ipt_LOG and ip6t_LOG into xt_LOG. Well, see below.

> > 2. I have merged ipt_LOG and ip6t_LOG into xt_LOG. With common
> > dump_tcp()/udp() and some other small code. This also works good. 
> 
> If it stays compatible and results in less code, that one too.

Yes, it _should_ be the same. The code is somewhat changed but the result
should produce exactly the same. It might have introduced some bug? So
handing it in an early rc-tree of 2.6 or give me time to run the code on our
router for a few weeks. What ever you like :-)

> 
> > The first two doesn't break anything or changes anything in compability with
> > former ip(6)t_LOG.
> 
> Great :)
> 
> > However the next things will change slightly. The question is, how much can
> > i change. Using -j LOG and the ringbuffer is for debugging purpose? Or does
> > it actually exists people that parse this buffer for some need? (It surly
> > does, but can we kindly ignore them and point them to ULOG?).
> 
> People do, we can't change anything in the output format.
> 
> > 3. The prefix is missing a space between the prefix and IN=interface. Very
> > annoying to always have to use -j LOG --log-prefix "one two three ". Notice
> > the last space. Will this break anything if i just add a space in between of
> > "%sIN=%s OUT..." for the prefix?
> 
> Yes, people already add the extra space and it would at least change
> how log files look, potentially even break parsers.
> 

Hm, hard one. I guess it's not enough to only change this to revision 1 as
the parameter is the same and so on. And the code i wrote doesn't make any
difference between revision 0 and 1 during the packet dumping functions.
They are the same.

I guess the only way to solve this is to add a new flag in revision 1
(beside keeping old --log-prefix with the missing space. --log-text-prefix,
--log-text-sulfix ? I'll think of something.

> > 4. Using an ethernet interface is _very_ common. Can i if (skb->dev->type ==
> > ARPHRD_ETHER) just dump an ETHSRC and an ETHDST instead of MAC, or will
> > this break things for people? Again a matter of someone having scripts
> > parsing this debug log. I can add this as an extra flag and have LOG revison
> > 1 use it.
> 
> An extra flag would OK fine I guess.
> 

Okey, i'll add the flag --log-macparse which removes the MAC= into something
more usefull for common interface types. The code is already written (for
ETHERNET and LOOPBACK) but i skipped the flag. I'll add it into revision 1.
The thing is that MAC= is only present when we have the IN-interface defined
and OUT not. Meaning that MAC isn't even there most of the time. ANyway,
i'll add the flag.

> > 
> > --
> > The last suggestions are involving a revision 1 of LOG.
> > 
> > 5. I my self have a good need for treating the prefix as a sulfix instead.
> > Much easier to read with the packet dump better aligned up, and an ending
> > reason. Can i add this as a flag? Having userspace revision 1 honoring it
> > with --log-sulfix (it will ofcouse not be allowed to have both --log-prefix and
> > --log-sulfix).
> 
> Mhh .. why not.
> 

Already implemented :-)

> > 6. I am in the need to alter the prefix length to somewhat below 128 (so the
> > kernel space info-struct totally is 128 bytes would be good). Is it okey if
> > i add this in a revison 1? The packet dumping code doesn't depend on a
> > length. Only the target itself.
> 
> That was already requested by multiple people (including myself), so go
> ahead.
> 

Good.

> > 7. It would be very nice if we had a -m log. This is very easy todo in
> > kernel-space. Only that we have to call it -m LOG (uppercase) for userspace
> > to load the correct library and kernel module. Its just a matter of the
> > module registering both as a match and a target. Bad idea? It would be very
> > convinent. The match would just log the packet and always return true
> > (match). Compare this to the comment module that doesn't actually do any
> > match-work.
> 
> I think this is something that can wait for a infrastructure that is
> meant to do things like that.
> 

I already written it :-/. Havn't written userspace yet and not tested it.

> > 7. Currently i always use my LOGing with a limiter to not flood the
> > ringbuffer. I guess most people are. There would be very nice with a
> > --log-limit 5, meaning we will only log 5 packets per second. Also an
> > inverter for that so --log-limit ! 6 means to log everypacket hiting the
> > rule above 6 packet per second. This will go very well with LOG being a
> > match as well. As it simply selects which packets to log and always matches
> > them to continue in the firewall rules. Again this is a revison 1 thing. The
> > code for this in kernel is very simple. 
> 
> Whats wrong with using the limit match?

It fits with -m LOG (the match). You then can write: 

iptables -m match ... -m LOG --log-prefix 'monkey' --log-limit 5/s -j DROP 

Mening that we will drop every match matching the 'match' but only log a few
of them. This saves rules (and therefore CPU). I have tons of small
terminating chains just for LOGing and then DROPing the packet. Two targets.

Old iptables needs:
iptables -N logging_droping_chain
iptables -A chain -m match ... -j logging_droping_chain
iptables -A logging_droping_chain -m limit --limit 5/s -j (U)LOG --log-prefix 'monkey'
iptables -A logging_droping_chain -j DROP

Now, if you have a really large firewall, you have alot of terminating
matches likes these. Having a -m LOG (with a limiter to not flood of the
logging path) will save alot of memory and CPU-cycles oof already stressed
routers/firewalls.

The time to get -a action (or sometime similar) added isn't soon here. :-/
I'm not saying we need to get this in mainline kernel. I'll keep it as a
patch in my svn-repository if needed.

--
Joakim Axelsson
