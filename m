From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Sun, 23 Jun 2002 11:15:32 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <008201c21a96$88eb6520$0489cb8a@etbx180>
References: <027b01c21893$72bbe1d0$0289cb8a@etbx180> <20020622185150.D31606@sunbeam.de.gnumonks.org>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



I know this debate is not new... I just didn't expect such a (90% see
below) perf drop, and unavailablity risk. That's why I'm only reporting
it, hoping secretly that experienced hackers will consider it seriously.
;o)

Note: I don't want to play with words, but if you prefer, consider
     'load generator' as 'malicious DoS user', and 'perf issue' as
      'DoS vulnerability' as Don Cohen cleverly suggested :-/
     (for me it's the same problem, except that DoS is ponctual while
      perf is what we may expect in normal situation)

> >
> > I'm doing some tcp benches on a netfilter enabled box and noticed
> > huge and surprising perf decrease when loading iptable_nat module.
>
> Sounds as expected.

loading a module, doesn't mean using it (lsmod reports it as 'unused'
in my tests). So, does it really 'sounds as expected', when you see
your cpu load hitting 100%, and most packets dropped just after having
done 'iptables -t nat -L' on a system with 1%CPU load handling 'only'
10kpps and forwarding about 1000 new TCP connections/s?

>
> > - ip_conntrack is of course also loading the system, but with huge memory
> > and a large bucket size, the problem can be solved. The big issue with
> > ip_conntrack are the state timeouts: it simply kill the system and drops
> > all the traffic with the default ones, because the ip_conntrack table
> > becomes quickly full, and it seems that there is no way to recover from
> > that  situation... Keeping unused entries (time_close) even 1 minute in
> > the cache is really not suitable for configurations handling (relatively)
> > large number of connections/s.
>
> what is a 'relatively' large number of connections? I've seen a couple
> of netfilter firewalls dealing with 200000+ tracked connections.

200K concurrent established connections, maybe... but surely not NEW
connections/second.
See previous results: with only ip_conntrack loaded (no nat), I hardly
reached 500 (new) conn/s.

>
> > o The cumulative effect should be reconsidered.
>
> could you please try to explain what you mean?

There are 3 aspects:
- table exhaustion (can be fixed with large memory) as long as the
  hash is correctly distributed (few collisions)
- concurrent timers (1 per conntrack tuple??)
- I can't explain the last one, but when the table is exhausted
  conntrack drops new packets, right? What I noticed is that at that
  moment, the cpu load suddenly hit 100%, and the machine did not
  recover, unless I killed the load generator

>
> > o Are there ways/plans to tune the timeouts dynamically? and what are
> >   the valid/invalid ranges of timeouts?
>
> No, see the mailinglist archives for th reason why.

If you refer to your mail of 18 January 2001, I think that this timeout
should also be reviewed ;o)... Waiting for somebody having the time and
being able of doing a redesign was quite idealistic, while a quick patch
for configurable timeouts per rule (ie: http timeouts different from smtp
ones, as suggested by Denis Ducamp) would have been more realistic.

>
> > o looking at the code, it seems that one timer is started by tuple...
> >   wouldn't it be more efficient to have a unique periodic callback
> >   scanning the whole or part of the table for aged entries?
>
> I think somebody (Martin Josefsson?) is currently looking into optimizing
>
> > - The annoying point is iptable_nat: normally the number of entries in
> > the nat table is much lower than the number of entries in the conntrack
> > table. So even if the hash function itself could be less efficient than
> > the ip_conntrack one (because it takes less arguments: src+dst+proto),
> > the load of nat, should be much lower than the load of conntrack.
> > o So... why is it the opposite??
>
> ? What 'nat table' are  you talking about?  Do you understand how NAT
> works and how it interacts with connection tracking?

Actually, that's also what i would like to know ;o)
bysource or byisproto hash tables, pointing to ip_nat_hash tuples
pointing to ip_conntrack entry. But i don't understand where the
extra processing comes from when there are no (nat) rules defined.
Just to recall my test: I generated an amount of new connections
per second passing through a forwarding machine without any iptables
module and measured the cpu load/responsiveness and other things...
Then while the machine was sustaining this amount of new conn/s, i did
'insmod ip_conntrack [size]', saw the cpu load increasing, and finally
just did 'iptables -t nat -L' to load the nat module without any rule,
and saw again the cpu load increasing. With 500conn/s, the cpu load went
from 10% -> ~50/70% -> 100% (machine unavailable).

>
> > o Are there ways to tune the nat performances?
>
> no. NAT (and esp. NAT performance) is not a very strong point of netfilter.
> Everybody agrees that NAT is evil and it should be avoided in all
circumstances.
> Rusty didn't want to become NAT/masquerading maintainer in the first place,
> but rather concentrate on packet filtering.

wow! what is the alternative for 'Everybody' using REDIRECT?

>
> The NAT subsystem has a number of shortcomings, some of which have been
> fixed, other still remain.
>
> > - Another (old) question: why are conntrack or nat active when there are
> > no rules configured (using them or not)? If not fixed it should be at
> > least documented...
>
> This is standard behaviour.  Does your network driver unload if you
> 'ifconfig down' an interface?  Does a TC qdisc module unload if you
> delete all instances of the queue?

ok, but does your interface sends irq when it is down? I don't care
about having an 'unused' module in memory as long as it is doing
nothing and not (over)loading the system.

>
> conntrack is _not_ related/intermangled with iptables at all.  Conntrack
> does not know if anybody is using conntrack state in the system.
>
> > Somebody doing "iptables -t nat -L" takes the risk
> > of killing its system if it's already under load...
>
> ?  Please explain why. I see no reason for this.

We agree, i also don't see any reason for it.
see above: a 'clean' machine without iptables modules or rule which
is handling 500conn/s hit 100%cpu and becomes unavailable if you do
'iptables -t nat -L'.

>
> > In the same spirit,
> > iptables -F should unload all unused modules (the ip_tables modules
> > doesn't hurt). Just one quick fix: replace the 'iptables' executable by
> > one 'iptables' script calling the exe (located somewhere else) and
> > doing an rmmod at the end...
>
> no. this is considered a feature. The current [and past] behaviour is wanted
> like this by design.

that's a... choice.

> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/

_______________________________________________________________________
-jmhe-               He who expects nothing shall never be disappointed
