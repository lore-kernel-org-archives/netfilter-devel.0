From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 06:37:29 +0200
Message-ID: <20050821043728.GH5638@aaricia.csbnet.se>
References: <20050820172824.GE5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>
	<20050820202552.GF5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
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

2005-08-21 00:38:53+0200, Jan Engelhardt <jengelh@linux01.gwdg.de> ->
> 
> >Its a _very_ large router infront of a student network. It house sover 2000
> >computers behind it and has a traffic amount between 50Mbit and 400Mbit
> >(night and day) for each of the 2 large main interface. Now the machine has
> >and additionally 30 interfaces. Most of them virtual VLAN interfaces. Point
> >is, this is a _very large_ routing machine. The machines work can't be done
> >in 63 rules. No way. Not with all the functions i have. The large amount of
> 
> The question is: how different do all these 2000+ hosts need to be classified?
> I can't think of anything but to let everything through with possibly 
> exceptions like SMTP and HTTP (going over proxies there).
> 

Please do not debate my networks firewall setup. It is complex. OK. Please
just try to solve my little problem by eleminating the number for chains
needed. 

> >interface but with slithly different paramters such as ip-range, limiters
> >and other things.
> 
> Other things like?
> Matching by interface might eliminate the need to test ipaddr/iprange.
> Matching by ipaddr/iprange might eliminate the need to test interface.
> Discrete logic is the key ;)
> 

OK, here is the resulting file that i load for only -t raw. Its not perfect
yet. Far away from it. It already has some custom made modules by me.
ACCOUNT and SPEED are the obvious ones. Others are the -m lim.

http://www.gozem.se/~gozem/test

bogus can be more optimized. I know. Havn't come that far yet.

Some of it has been cut to keep the secret of excatly how the firewall
works. :-/ Some things are there and look empty. There are hook for other
script to add and remove rules as needed. This is specially try for *_zap
and *_harddrop chains.

> >Seen it, however im running on a 2.4.23-kernel. (It will take weeks to test
> >and patch a new 2.6-kernel not even knowing if it will crash.
> 
> You know that 2.4.31 is current, and .23 is more error prone to security flaws
> (oh, did you mention you are a DDOS target? Think again!)
> 

The router has never ever crashed in some 18 months now. Im not about to
trade that for a possible unstable kernel. Its not needed. Well, it is not
as the traffic amount pushes the CPU to 100%. However, you get the idea.
There is nothing to say that i need to upgrade the router just because a
kernels version is old. Its heavily patched. The machine it self is well
protected and drops absolutly everything on -t filter -A INPUT unless your
coming from a private management vlan.

> >A crach isn't affordable on this router.
> 
> Just have a fast recover lane. :)
> 

Not an option.

> >Need to backport it then and it still wont really solve the problem as i which
> >to reduce the flow most packets takes. In both mine existing and your solution
> >the packets we want to save will still take the jump to chain_tcpsyn and then
> >back.
> 
> A goto does not come back.
> 

Both with and without goto an extra chain per "class" of limiter (the
chain_tcpsyn, chain_tcp and so on chains in my example) are needed. Thats
what i meant.

> >In your solution back "two step", in mine back the two steps by yet
> >another match. My better solution wont jump at all, however needing another
> >(fast) match, the RETURN.
> 
> How do you know two packet comparisons are faster than a iptable stack jump?
> Given that each operation was valued "1" and that the first rule of
> "chain_tcpsyn" always matches for our hypothesis...
> 

I don't. I want to eliminated them both.

> >>>iptables -N chain_tcpsyn
> >>>iptables -A chain_tcpsyn -m limit (+1) --limit 1000/s (+1) -j RETURN (+1)
> >>>iptables -A chain_tcpsyn -m limit 1/s -j LOG --log-prefix "FW raw chain_tcpsyn"
> >>>iptables -A chain_tcpsyn -j DROP
> >> 
> >>>iptables -N chain
> >>>iptables -A chain -p tcp (+1) --syn (+1) -j chain_tcpsyn (+1)
> >>>iptables -A chain -p tcp (+1) --syn (+1) -j RETURN (+1)
> >>>iptables -A chain -p tcp -j chain_tcp
> >>>iptables -A chain -p tcp -j RETURN
> >> 
> >>ipt -A chain -p tcp (+1) --syn (+1) -g chain_tcpsyn (+1)
> >>ipt -A chain -p tcp -g chain_tcp
> >>ipt -A chain -p udp -g chain_udp
> 
> ... in your case, you would need
> 
>   -p tcp --syn -j chain_tcpsyn
>   -m limit --limit 1000/s -j RETURN
>   -p tcp --syn -j RETURN
>   == 9 operations
> 
> to exit finish the chain named "chain", while I need
> 
>   -p tcp --syn -g chain_tcpsyn
>   -m limit --limit 1000/s -j RETURN
>   == 6 operations to do so.
> 
> In fact, you do 3 jumps (one enter, two exits) while I do only 2 (one goto and
> one exit). And a goto is usually less expensive than a jump since it does not
> push a return-chain onto the netfilter stack.
> 

And my solution of:

ipt -A chain -p tcp --syn -m lim --lim-packets ! 1000/s -m log -j DROP
ipt -A chain -p tcp --syn -j RETURN

tcp, syn, lim,
tcp, syn, RETURN

will also be 6 operations for packets that passes (normal flow). And i don't
need chain_tcpsyn and so on. Saving memory. Loading my configuration on a
live router takes a few seconds due to the amount of rules.

And also, a jump might be very costly if the jump is so far away in memory
that a cache miss is triggered. This is not unlikly at all as i have so many
rules. Its very unlikly (or atleast much less unlikly) to happen with two
rules after each other. It's ok to do a jump/goto on packets that do not
meat the standard flow however. 

You can't compare each operation as equal cost either. It far more
inexpensive todo a --syn match than a limit (which handles spinlocks) and/or
a jump/goto which might trigger a cache miss.

I know of other places that -g goto can be very handy in my firewall. I will
add it where it suits later as the patching needed in kernel was just a few
lines.

> 
> 
> Jan Engelhardt
> -- 
> | Alphagate Systems, http://alphagate.hopto.org/

Thank you for your kind answers and tyring to help.

However, my original question is stuck. I want to make a -m log which can
printk me the current chain i'm in. Or if that helps you, i want a -m
chain_debug that prints the chain, for any purpose.

I also saw a way of actaully removing the above needed extra line with -j
RETURN when i was studing the ip_tables.c code. Ugly but will work. If i
modify the IPT_MATCH_ITERATE define (which will iterate over all matches for
a rule and break if any of them don't match) to handle that any of them
returns a negative value (like IPT_RETURN). I can add a match that will add
a verdict of IPT_NEXTRETURN. If the next match doesn't match not only
aborts the matching, it also alters the verdict to IPT_RETURN. Meaning:

ipt -A chain -p tcp --syn 
             -m return --return-if-next-match-fail \
             -m limit --lim-packets ! 1000/s \
             -m log --log-prefix "DROPing overlimits" \
             -j DROP
ipt -A chain -p tcp ...
ipt -A chain -p udp ...
...

Now i have ONE rule per matching class and limiter. Just what i wanted. Some
ugly hack perhaps, but i do this so often in my firewall (not just in -i
raw) that it might be just okej.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
