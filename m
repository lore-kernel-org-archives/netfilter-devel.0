From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ABI
Date: Tue, 22 Aug 2006 10:46:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
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

Hi,

[The whole thread is really inspiring, but as a late-comer I just jump in
into it the middle.]

On Wed, 16 Aug 2006, Joakim Axelsson wrote:

> Summary:
> + Use XML to express firewall rules. Because its easy and backward
> compability will be easily ported. It fits both human written and scripted
> rules. The tool is already there in tons of places.

I think this is the surface for the users i.e how to express the rules in
the userspace. I strongly believe Harald has got absolutely right that
what we need is a plugin architecture and library which makes possible to
write interfaces using a commandline style or XML, or to write a
graphical interface or whatever. (Or do you propose to implement an XML
parser in kernel space? ;-)

What at least equally important is the kernel-userspace communication. In
what form should the data be passed? Using what kind of kernel-userspace
communication method?

For the former I believe the (extended) attribute subsytem stolen from
nfnetlink is probably the most flexible and still the simplest solution.
Of course it must be morphed and extended a little bit, for example by
adding "bunch/array of foo type" types to pass huge number of same type of
data more efficiently, or to gracefully handle unknown attribute types
(intended for another match/target or new unknown attribute for a given
match/target). Let's forget about passing binary blobs with magical
pointers/offsets back and forth!

My views on how to communicate is a little bit old-fashioned as I'm
perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
but a hack. But reliable, which cannot absolutely be said about netlink.
I shudder to think about the situation when a DDoS attack could prevent or
just delay me to reconfigure a firewall. And please note even if we accept
delaying it assumes that we are willing to face reimplementing a TCP-alike
protocol over netlink to guarantee reliable message passing.

I cannot deny, a filesystem-like channel is tempting, but I think it's
simply not flexible enough.

> + init, destory, dump/restore, change, match/target is needed as implemented
> functions (or Nulls) for the match / targets.

For the kernel space, yes. In userspace we need a little bit more: option
(argument) list with allowed types and hooks for the parsers
(cmdline/XML/whatever), even probably embedded help.

For fun I propose to name the new commandline utility simply 'nf' :-).

> + Use RCU-list in kernel. Because its more editable.

I won't give up the hope to integrate nf-hipac once. In other words, the
RCU-list must be one possible way to list the rules and other methods
must be supported as well. Let us not fall in the trap to hardcode this
part of the system.

Think about expert systems built on top of iptables/nf by which one can
write policies instead of the exact rules and which translates and expands
the policies into the appropriate rules. Such systems could even choose
the most appropriate in-kernel rule listing for the given created chain or
sub-table.

> + Have smart ways of allocate memory in kernel (slabs).
>
> + Allow sveral targets for one rule.

Yes. Your example of multiple non-terminal, jump and terminal targets in
one rule proves that the semantic is still clear.

> + Perhaps seperate ending targets form non ending and jumps.

I think that it is required because thus the userspace tool can warn about
targets mistakenly listed after a terminal target.

> + Allow customs jump modules, beside match and target modules.

That's cool but sanity (and rule-integrity) must of course be preserved.

> + Allow grouping of rules in some way. Really large firewall needs this.

Sub-tables can probably help. It seems to me non-trivial how not to loose
efficiency, though. Multiple toplevel tables (i.e active/passive,
active/backup) should also be considered.

> + We rather have one too many hooks/void *, unused rather than one too few
> for futhure use. It won't waste that much memory.
>
> + Design all this into pkttables rather than focus on IP/IPv6.

Yes. And I'd add one more priciple:

+ All parts must be designed to take into account rule- and
  (match/target) state-replication between firewalls in active-active
  setups.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
