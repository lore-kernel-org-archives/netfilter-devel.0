From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Tue, 5 Sep 2006 00:26:20 +0200
Message-ID: <200609050026.21018.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<200608232313.22379.max@nucleus.it>
	<Pine.LNX.4.58.0608241122500.8098@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.58.0608241122500.8098@blackhole.kfki.hu>
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

On Thursday 24 August 2006 12:15 pm, Jozsef Kadlecsik wrote:

> I think the current system is pushed to its limits and it is time for
> radical changes. Non-radical change proposals can of course explore the
> current problems and point to directions toward the proper solutions, so
> such efforts are not wasted.

I've been thinking of a few things we can do in an incremental way, but the 
reality is that the most important features require a drastically different 
interaction with userspace and one of the primary goals is to reduce the 
number of user space visible changes. This does not apply to development 
versions of course. There are lots of small incremental steps we can do 
in "developer mode".

> > > > + Allow grouping of rules in some way. Really large firewall needs
> > > > this.
> > >
> > > Sub-tables can probably help. It seems to me non-trivial how not to
> > > loose efficiency, though. Multiple toplevel tables (i.e active/passive,
> > > active/backup) should also be considered.
> >
> > Is this the same thing I'm calling expression chains? We could have an
> > expression table with user defined chains that system chains can use.
> > I don't think it would be inefficient. Just jump to a chain and see what
> > it returns. If we want to optimize it we could cache results so that
> > people can use sub-chains several times (in different combinations)
> > withou worrying about it.
>
> Could you show an example?

iptables -t macro -N trustedclient
iptables -t macro -A trustedclient ... -j TRUE
...
iptables -t macro -A trustedclient ... -j FALSE

iptables -t macro -N trustedserver
...


iptables -I FORWARD --macro trustedclient --macro trustedserver -j ACCEPT


Of course, the real usefulness comes when you use multiple combinations.
Another user could be to have a single macro in FORWARD and in nat 
POSTROUTING. This poses the problem of what matches to allow in macro chains. 
The maximum common set? Ignore non applicable ones? Separate macros for every 
context?

We could cache the result of a macro the first time we run into it (for a 
single packet) and avoid traversing the chain when we reuse it.

I have lots of firewalls where I use a script to generate combinations of 
rules. This feature would simplify all of them.

> Sub-tables as I name are complete tables of the given type (filter,
> mangle, etc):
>
> # Define new, empty filter type of table foo:
> -t filter --new-table foo
> # Fill it up with rules, define default policies, etc
> -t foo -A ...
> ...
>
> # Then you could chain filter type of tables one after another
> # using the default as an always existing one:
> -t filter --prepend-table foo
> -t filter --append-table bar
> # Now we'd have foo, default, bar as filter tables to be evaluated

Similar goal, different style.
Why not just:
-t filter --evaluate-table foo

This way you could mix it with other rules and allow for more flexible mixing 
of more than 2 sub-tables.
Would you forbid {prepend|append|evalute}-table in sub-tables in order to 
avoid infinite recursion or would you check for cyclicity at load time or run 
time?

> > What level of runtime synchronization do you need? We have to allow some
> > delay between 2 firewalls.
>
> It depends on the active-active setup and the modules in question. If the
> TCP/UDP/etc. streams can pass any of the firewalls then strong
> syncronization is required. If the streams always pass the same firewall
> in both directions (except after failover), then loose syncronization
> can be enough. recent/set modules probably always require strong sync.

This is feasible only with ip_conntrack_tcp_be_liberal. I don't think you will 
ever keep a completerly up to date mirror state down to the last sequence 
number unless you use some special and really fast means of communication.
Synchronous remote communication in the middle of packet processing is out of 
the question.
Do you have a something specific in your mind?
If you settle for loose synchronization we can certainly have a way to send 
kernel generated change events to userspace and then you could send them to 
the other members of the cluster.

> > If we implement generic module data tables (with event notification to
> > userspace), this wouldn't be a kernel problem anymore.
>
> Yes, we just need such an infrastructure to back the module writers.

This is one of the few things we could add without breaking backward 
compatibility.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
