From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Wed, 23 Aug 2006 23:13:21 +0200
Message-ID: <200608232313.22379.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
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

On Tuesday 22 August 2006 10:46 am, Jozsef Kadlecsik wrote:

> I think this is the surface for the users i.e how to express the rules in
> the userspace. I strongly believe Harald has got absolutely right that
> what we need is a plugin architecture and library which makes possible to
> write interfaces using a commandline style or XML, or to write a

XML could already be used. It would be easier to parse for other programs (a 
GUI viewer/generator), but little else.
He was proposing a richer language, too. I'm not sure a complete boolean 
expression would be easier to manage for a GUI, althought it would be easier 
to write for sysadmins.

> What at least equally important is the kernel-userspace communication. In
> what form should the data be passed? Using what kind of kernel-userspace
> communication method?
>
> For the former I believe the (extended) attribute subsytem stolen from
> nfnetlink is probably the most flexible and still the simplest solution.
> Of course it must be morphed and extended a little bit, for example by
> adding "bunch/array of foo type" types to pass huge number of same type of
> data more efficiently, or to gracefully handle unknown attribute types
> (intended for another match/target or new unknown attribute for a given
> match/target). Let's forget about passing binary blobs with magical
> pointers/offsets back and forth!

> > + init, destory, dump/restore, change, match/target is needed as
> > implemented functions (or Nulls) for the match / targets.
>
> For the kernel space, yes. In userspace we need a little bit more: option
> (argument) list with allowed types and hooks for the parsers
> (cmdline/XML/whatever), even probably embedded help.

I agree.

> > + Use RCU-list in kernel. Because its more editable.
>
> I won't give up the hope to integrate nf-hipac once. In other words, the
> RCU-list must be one possible way to list the rules and other methods
> must be supported as well. Let us not fall in the trap to hardcode this
> part of the system.

The least radical proposals call for a separation between kernel metadata 
(potentially fixed size) and match structures (variable, but known, size 
parameters and custom data).
The more radical (with respect to the necessary data structures) call for 
complete expression evaluation. This would require trees instead of lists or 
arrays.
Whatever we do, we certainly can keep the metadata distinct from the match 
data and make it inaccessible to modules (not to mention userspace).

For example we could have:
struct match_instance {
   struct match_id id;
   struct match *match_type;
   void *match_parameters;
   void *instance_data;
   ... /* counters, spinlocks for editing single matches, etc. */
};

The real structure could be kept in a separate tree. During modifications we 
could create a complete version of the new tree with pointers to 
match_instances and then swap it with the old one atomically.
We could use some simple management system in order to know when a 
match_instance is no longer needed.
For example we could embed it in a structure that keeps a reference counter or 
a list and adjust them when as needed. Match modules won't need to know what 
and how we do it and we may start with a linear data structure (similar to 
the one we use today) and switch to a tree without people noticing.

Te current way to express rules is similar to Horn clauses (logic programmers 
please forgive me, I know, we have negations, targets that don't terminate, 
lateral effects and we lack recursive rules).
Other people propose boolean expressions.

I think most people is more confortable with boolean expressions, althought 
it's more complex to parse and manage. How much do people desires it?

> > + Allow customs jump modules, beside match and target modules.
>
> That's cool but sanity (and rule-integrity) must of course be preserved.

We want to ensure termination (well I certainly want to avoid a loop in the 
rules). If we had boolean expressions and non-recursive expression chains 
(that we could use as pre-build sub-expressions in other rules) we could be 
extemely expressive without gotos.

> > + Allow grouping of rules in some way. Really large firewall needs this.
>
> Sub-tables can probably help. It seems to me non-trivial how not to loose
> efficiency, though. Multiple toplevel tables (i.e active/passive,
> active/backup) should also be considered.

Is this the same thing I'm calling expression chains? We could have an 
expression table with user defined chains that system chains can use.
I don't think it would be inefficient. Just jump to a chain and see what it 
returns. If we want to optimize it we could cache results so that people can 
use sub-chains several times (in different combinations) withou worrying 
about it.

> + All parts must be designed to take into account rule- and
>   (match/target) state-replication between firewalls in active-active
>   setups.

What level of runtime synchronization do you need? We have to allow some delay 
between 2 firewalls.
If we implement generic module data tables (with event notification to 
userspace), this wouldn't be a kernel problem anymore.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
