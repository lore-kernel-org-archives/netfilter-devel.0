From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Wed, 16 Aug 2006 00:57:04 +0200
Message-ID: <200608160057.05431.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<200608151414.24599.simon@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200608151414.24599.simon@parknet.dk>
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

On Tuesday 15 August 2006 2:14 pm, Simon Lodal wrote:

> Everybody has a long wishlist and seem to agree that something fundamental
> needs to be done.
>
> The question seems to be when backwards compatibility can be given up.

Everyone agrees that we have reached the maximum expressiveness with the 
current system.
Nobody says that we couldn't keep a way to convert old rules in the new 
system.
The real question thus becomes: is it worh to restart from (almost) scratch?

> > What people need from any new infrastructure:
> > - cleaner interface with clearer separation between kernel and user data;
> > - ability to dump internal state of matches/targets (this may not be in a
> > 1-to-1 relation, so it may be tricky, do we need module state dumping?);
>
> Yes, but why should that be hard? Netfilter should already have a list of
> registered modules.

Yes, but iptables has no way to manipulate per-module data (eg: collection of 
names and flags for condition, but there are plenty other examples).
I don't think it would be difficult, even without a total redesign. I was 
testing the ground for ideas and real needs.

> We are going to have "interesting" data that are not 1:1 with rules. But
> then they will be 1:1 with modules, or some other "scope" that netfilter

Make it n:1. I don't think n:n is desirable.

> knows how to traverse. Each "scope" can have their own section in the
> iptables-save output. Hence the parsing complexity lies in
> iptables-restore.
>
> Whether it is all going to be exposed in some filesystem or not is a
> different matter.

I like file interfaces, but not everything readily becomes a file. It all 
depends on what people really want to do with this class of data.

> What is the version after it going to be then? No, I never liked the -ng
> suffix :)
>
> What is wrong with iptables2?

OK. We had ipfwadm and ipchains. So we're really more like iptables4. :)

> Flexibility is not free, but perhaps it can be cheap, performance wise.
>
> Let's say we make iptables more shell-like, with the ability to handle
> multiple commands in one invocation (with a final COMMIT command required)?
> Would be lovely in itself.
>
> Then iptables would get a better chance to optimize memory allocation,
> since it is not only looking at one rule at a time.
>
> The case where you load the entire firewall ruleset in one go could be
> optimized to a point where it is no different from today.

This if we assume we know the sizes of everything. I think matches/targets 
need to have a chance to influence their own data (now they can't).
We'll have:
- general data structures (fixed);
- match/target descriptor (passed by userspace and of known size);
- match/target runtime data (potentially anything from a single byte to a 
dynamic structure).

Currently matches/targets are fed the descriptor. I'd like them to be fed a 
descriptor and their runtime data. We can suppose the latter won't be needed 
by every match, so it won't impact performance.
We still got a fixed size data structure that we can move/compact/rewrite and 
a descriptor that we can potentially move (we could move it if people weren't 
abusing it for lack of runtime data) but with variable sized.
The first one can become a simple allocation in list node array (with some 
mechanism for growing and shrinking). The descriptors are a little more 
tricky and we would need stricter specifications in order to do proper 
repacking.
Before we continue work on a non-problem: do we have data about kernel memory 
fragmentation and performance issues?


>  * ipt_entry* structs might contain data (like basic src/dst/port/iface
> matches), but they may not keep pointers to anything, not even their own
> fields. They are independent of their own memory location. The memory
> management code can therefore rearrange the tables at will (proper locking
> assumed), without having to reinitialize rules.

Good. I just don't know if this is overdesigned.

>  * All other memory is accessed through a struct that is passed to each
> rule/match/target's API functions. It contains at least .instance_data, but
> also .module_data (.priv_data), and perhaps other scopes data,
> like .rule_data, .chain_data and .global_data (all cross-module). Note that
> each of these are bound to a specific entity.

I agree.

>  * Each module and instance must call special netfilter API's to allocate
> memory of the required types. The netfilter part handles free'ing through
> refcount (why not).

If we don't have cross-module data (does anyone need it?) each module could do 
it's housekeeping. It's difficult to know how to optimize other people's 
data.

>  * The actual .*_data pointers may change between invocations (packets fed
> to) of the same rule/match/target. This means the netfilter part is allowed
> to rearrange dynamic memory too.

What if people want to keep pointers and other complex data structures? The 
instance data should be opaque to the core code. The risk is that people, not 
trusting this structure, will use it just to keep a pointer to the real data.

>  * Bonus: Sync of memory regions with other hosts can be handled
> transparently, or at least easily. So that fx. limit rules can work across
> redundant hosts.

Malus: a whole memory management system just for a subsystem of the kernel. 
Too much semantics risks to limit what people want to do. Of course anarchy 
has drawbacks too. I'd seek a middle ground where we handle the common case 
and leave people free to implement exotic new things.

> I have no clear idea how all these individual blobs would be communicated
> between kernel and userspace. Except there are two general options:
>
> 1) The current "pass a large blob" scheme. Since it will contain many
> smaller blobs, some in-kernel parsing is required. Worse yet, the kernel
> must also be able to assemble a large blob in order to dump to userspace.

Either way we'll need some form of rule and match id.
I don't know what level of transactionality is desired. Currently 
iptables-restore is atomic and so are single changes with iptables. How much 
is needed with the new system? At least rule level atomicity is certainly 
desired, so we'll need to create duplicate data (just the core structure with 
pointers to the real descriptors) during modifications.

> > I think every match/target should expode:
> > - init;
> > - destroy;
> > - change;
> > - dump;
> > - restore.
>
> change() would be nice, like in qdisc.

Does it really make sense? How many matches would have a different behaviour 
while changing instead of a full create-activate_new-destroy?

> Applause for possibly opening the can of worms :)

:)

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
