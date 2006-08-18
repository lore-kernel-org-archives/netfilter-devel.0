From: "Simon Lodal" <simonl@parknet.dk>
Subject: Re: new ABI
Date: Fri, 18 Aug 2006 16:14:35 +0200 (CEST)
Message-ID: <1108.83.88.199.217.1155910475.squirrel@mail.parknet.dk>
References: <200608142312.41851.max@nucleus.it>
	<200608151414.24599.simon@parknet.dk>
	<200608160057.05431.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <max@nucleus.it>
In-Reply-To: <200608160057.05431.max@nucleus.it>
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

>> Everybody has a long wishlist and seem to agree that something
>> fundamental needs to be done.
>>
>> The question seems to be when backwards compatibility can be given up.
>
> Everyone agrees that we have reached the maximum expressiveness with
> the  current system.

You mean we have created the ideal system?!

Or that we have created a mess that is no longer extendable?

> Nobody says that we couldn't keep a way to convert old rules in the new
>  system.
> The real question thus becomes: is it worh to restart from (almost)
> scratch?

Sometimes you can have something entirely different in mind and still make
incremental changes.
The iptables syntax/interface as seen by user is far from stellar but
perhaps good enough for it's purposes. I do not see any urgent need to
change it's syntax.
But the API's suck. Good ideas get nowhere because the API's can not
support it. Is that really controversial? My point is they need to change,
and it will be incomatible, too bad, but is has to done some day.

>> > What people need from any new infrastructure:
>> > - cleaner interface with clearer separation between kernel and user
>> > data; - ability to dump internal state of matches/targets (this may
>> > not be in a 1-to-1 relation, so it may be tricky, do we need module
>> > state dumping?);
>>
>> Yes, but why should that be hard? Netfilter should already have a list
>> of registered modules.
>
> Yes, but iptables has no way to manipulate per-module data (eg:
> collection of  names and flags for condition, but there are plenty
> other examples). I don't think it would be difficult, even without a
> total redesign. I was  testing the ground for ideas and real needs.

I agree.

>> We are going to have "interesting" data that are not 1:1 with rules.
>> But then they will be 1:1 with modules, or some other "scope" that
>> netfilter
>
> Make it n:1. I don't think n:n is desirable.

It is not n:n. It is just more 1:1's.


>> knows how to traverse. Each "scope" can have their own section in the
>> iptables-save output. Hence the parsing complexity lies in
>> iptables-restore.
>>
>> Whether it is all going to be exposed in some filesystem or not is a
>> different matter.
>
> I like file interfaces, but not everything readily becomes a file. It
> all  depends on what people really want to do with this class of data.
>
>> What is the version after it going to be then? No, I never liked the
>> -ng suffix :)
>>
>> What is wrong with iptables2?
>
> OK. We had ipfwadm and ipchains. So we're really more like iptables4.
> :)

That might do.


>> Flexibility is not free, but perhaps it can be cheap, performance
>> wise.
>>
>> Let's say we make iptables more shell-like, with the ability to handle
>> multiple commands in one invocation (with a final COMMIT command
>> required)? Would be lovely in itself.
>>
>> Then iptables would get a better chance to optimize memory allocation,
>> since it is not only looking at one rule at a time.
>>
>> The case where you load the entire firewall ruleset in one go could be
>> optimized to a point where it is no different from today.
>
> This if we assume we know the sizes of everything. I think
> matches/targets  need to have a chance to influence their own data (now
> they can't).
Correct, and it is a major annoyance.


> We'll have:
> - general data structures (fixed);
> - match/target descriptor (passed by userspace and of known size); -
> match/target runtime data (potentially anything from a single byte to a
>  dynamic structure).
>
> Currently matches/targets are fed the descriptor. I'd like them to be
> fed a  descriptor and their runtime data. We can suppose the latter
> won't be needed  by every match, so it won't impact performance.
> We still got a fixed size data structure that we can
> move/compact/rewrite and  a descriptor that we can potentially move (we
> could move it if people weren't  abusing it for lack of runtime data)
> but with variable sized.
> The first one can become a simple allocation in list node array (with
> some  mechanism for growing and shrinking). The descriptors are a
> little more  tricky and we would need stricter specifications in order
> to do proper  repacking.

Sounds reasonable.

> Before we continue work on a non-problem: do we have data about kernel
> memory  fragmentation and performance issues?

I would love to know that too!


>>  * ipt_entry* structs might contain data (like basic
>>  src/dst/port/iface
>> matches), but they may not keep pointers to anything, not even their
>> own fields. They are independent of their own memory location. The
>> memory management code can therefore rearrange the tables at will
>> (proper locking assumed), without having to reinitialize rules.
>
> Good. I just don't know if this is overdesigned.

Perhaps yes. It is irrelevant unless there really is a fregmentation issue.


>>  * All other memory is accessed through a struct that is passed to
>>  each
>> rule/match/target's API functions. It contains at least
>> .instance_data, but also .module_data (.priv_data), and perhaps other
>> scopes data,
>> like .rule_data, .chain_data and .global_data (all cross-module). Note
>> that each of these are bound to a specific entity.
>
> I agree.
>
>>  * Each module and instance must call special netfilter API's to
>>  allocate
>> memory of the required types. The netfilter part handles free'ing
>> through refcount (why not).
>
> If we don't have cross-module data (does anyone need it?) each module
> could do  it's housekeeping. It's difficult to know how to optimize
> other people's  data.

The idea is just to make it less error prone to write match/target
modules; the less free()'s you need to call the less memory leaks we get.
Since you can only have one .instance_data pointer, the old one should be
deallocated if you allocate another. Why not let netfilter do that. You
would just tell netfilter how much memory you need, and it will just
deliver that. And guarantee against accidental memory leaks in individual
modules.

>>  * The actual .*_data pointers may change between invocations (packets
>>  fed
>> to) of the same rule/match/target. This means the netfilter part is
>> allowed to rearrange dynamic memory too.
>
> What if people want to keep pointers and other complex data structures?
> The  instance data should be opaque to the core code. The risk is that
> people, not  trusting this structure, will use it just to keep a
> pointer to the real data.

If someone really wants to break the rules they can.

Here, the only rule is: No pointers. Use local offsets instead if you
really need to "point".

>>  * Bonus: Sync of memory regions with other hosts can be handled
>> transparently, or at least easily. So that fx. limit rules can work
>> across redundant hosts.
>
> Malus: a whole memory management system just for a subsystem of the
> kernel.  Too much semantics risks to limit what people want to do. Of
> course anarchy  has drawbacks too. I'd seek a middle ground where we
> handle the common case  and leave people free to implement exotic new
> things.

The most important goal is to pass a number of pointers (descriptors) to
the modules, each being shared in different ways (and having dynamic size,
preferably). It might work if any module could (re)allocate those shared
memory areas independently, but would be much simpler if netfilter
allocation wrappers handles synchronization between them.
We already have a memory management subsystem; we try to manage how things
are located. Unfortunately it is very dumb which is the reason for many
problems we have.
I am no fan of a new complex memory management subsystem in-kernel. It is
only a suggestion for a solution to the fragmentation issue, if it really
exists.

>> I have no clear idea how all these individual blobs would be
>> communicated between kernel and userspace. Except there are two
>> general options:
>>
>> 1) The current "pass a large blob" scheme. Since it will contain many
>> smaller blobs, some in-kernel parsing is required. Worse yet, the
>> kernel must also be able to assemble a large blob in order to dump to
>> userspace.
>
> Either way we'll need some form of rule and match id.
> I don't know what level of transactionality is desired. Currently
> iptables-restore is atomic and so are single changes with iptables. How
> much  is needed with the new system? At least rule level atomicity is
> certainly  desired, so we'll need to create duplicate data (just the
> core structure with  pointers to the real descriptors) during
> modifications.

I agree with that desire. But it totally rules out a filesystem
representation, I guess. Not that I really want an iptablesfs.
I guess some hierarchical locking would be necessary.



Regards,
Simon
