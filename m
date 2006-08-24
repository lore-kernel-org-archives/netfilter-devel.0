From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 12:15:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608241122500.8098@blackhole.kfki.hu>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
	<200608232313.22379.max@nucleus.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200608232313.22379.max@nucleus.it>
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

On Wed, 23 Aug 2006, Massimiliano Hofer wrote:

> On Tuesday 22 August 2006 10:46 am, Jozsef Kadlecsik wrote:
>
> > I think this is the surface for the users i.e how to express the rules in
> > the userspace. I strongly believe Harald has got absolutely right that
> > what we need is a plugin architecture and library which makes possible to
> > write interfaces using a commandline style or XML, or to write a
>
> XML could already be used. It would be easier to parse for other programs (a
> GUI viewer/generator), but little else.
> He was proposing a richer language, too. I'm not sure a complete boolean
> expression would be easier to manage for a GUI, althought it would be easier
> to write for sysadmins.

That can be handled by the data structure passed to/from the kernel: when
one plugin (say the GUI) constructed the data from its input, another
plugin (cmdline/XML) can translate it back to its own format.

> > > + Use RCU-list in kernel. Because its more editable.
> >
> > I won't give up the hope to integrate nf-hipac once. In other words, the
> > RCU-list must be one possible way to list the rules and other methods
> > must be supported as well. Let us not fall in the trap to hardcode this
> > part of the system.
>
> The least radical proposals call for a separation between kernel metadata
> (potentially fixed size) and match structures (variable, but known, size
> parameters and custom data).
> The more radical (with respect to the necessary data structures) call for
> complete expression evaluation. This would require trees instead of lists or
> arrays.

I think the current system is pushed to its limits and it is time for
radical changes. Non-radical change proposals can of course explore the
current problems and point to directions toward the proper solutions, so
such efforts are not wasted.

> > > + Allow grouping of rules in some way. Really large firewall needs this.
> >
> > Sub-tables can probably help. It seems to me non-trivial how not to loose
> > efficiency, though. Multiple toplevel tables (i.e active/passive,
> > active/backup) should also be considered.
>
> Is this the same thing I'm calling expression chains? We could have an
> expression table with user defined chains that system chains can use.
> I don't think it would be inefficient. Just jump to a chain and see what it
> returns. If we want to optimize it we could cache results so that people can
> use sub-chains several times (in different combinations) withou worrying
> about it.

Could you show an example?

Sub-tables as I name are complete tables of the given type (filter,
mangle, etc):

# Define new, empty filter type of table foo:
-t filter --new-table foo
# Fill it up with rules, define default policies, etc
-t foo -A ...
...

# Then you could chain filter type of tables one after another
# using the default as an always existing one:
-t filter --prepend-table foo
-t filter --append-table bar
# Now we'd have foo, default, bar as filter tables to be evaluated

Or we could swap the default filter table with another one
(internally at restore or by user input when a table is pre-constructed
in case of emergency, etc.)

But what I propose as sub-table is definitely not scalable.

> > + All parts must be designed to take into account rule- and
> >   (match/target) state-replication between firewalls in active-active
> >   setups.
>
> What level of runtime synchronization do you need? We have to allow some delay
> between 2 firewalls.

It depends on the active-active setup and the modules in question. If the
TCP/UDP/etc. streams can pass any of the firewalls then strong
syncronization is required. If the streams always pass the same firewall
in both directions (except after failover), then loose syncronization
can be enough. recent/set modules probably always require strong sync.

> If we implement generic module data tables (with event notification to
> userspace), this wouldn't be a kernel problem anymore.

Yes, we just need such an infrastructure to back the module writers.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
