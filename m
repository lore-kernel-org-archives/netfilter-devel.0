From: Simon Lodal <simon@parknet.dk>
Subject: Re: new ABI
Date: Tue, 15 Aug 2006 14:14:24 +0200
Message-ID: <200608151414.24599.simon@parknet.dk>
References: <200608142312.41851.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200608142312.41851.max@nucleus.it>
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

On Monday 14 August 2006 23:12, Massimiliano Hofer wrote:
> Hi,
> I couldn't keep pace during the day with all the mail that has been
> written, so let me summarize what has been said.
> Please forgive (and correct) me if I forget anything.
>
> First of all several people think that the current ABI has shortcomings and
> something has to be done.

Everybody has a long wishlist and seem to agree that something fundamental 
needs to be done.
	
The question seems to be when backwards compatibility can be given up.

> Regarding my proposal for priv_data (I'm obviously biased here, but I'll
> try to be objective):
> - it offers the ability to store data out of reach to the userspace
> utilities (for whatever housekeeping any match/targets needs);
> - it can't offer persistent data to matches/targets.
>
> <biased>
> With this patch we can part with some really ugly tricks involving
> userspace structure fields and kernel pointers and it would let us have
> O(1) matches for quota, limit and any other match/target that needs cross
> match data. </biased>
>
> People may expect the second feature too, but it's just not possible with
> the current infrastructure. The same infrastructure, making extensive use
> of arrays whose size is determined before we call any module hook function,
> leaves us in the cold for a really flexible solution for other problems
> too. I've not yet read all the code involved, but, if we really need to, we
> may be able to use a compat-like interface to maintain ABI compatibility
> with a new netfilter core.
>
> What people need from any new infrastructure:
> - cleaner interface with clearer separation between kernel and user data;
> - ability to dump internal state of matches/targets (this may not be in a
> 1-to-1 relation, so it may be tricky, do we need module state dumping?);

Yes, but why should that be hard? Netfilter should already have a list of 
registered modules.

> - ability to change chains/rules/matches without reinitializing everything;
> - ability to change matches' state or configuration without reinitializing
> everything;
> - general infrastructure for common logic that is currently reinvented
> every time (negation comes to mind, but I'm sure there are other things).

Agreed.

> <biased>
> Regarding user influence over state, especially where the number of states
> doesn't match the number of matches involved, I'm not totally opposed to a
> file-like way of exposing it. I agree that /proc is in a sorry state, but
> configfs is there precisely for this purpose. Of course not everything can
> be done this way and I wouldn't like to have complex data passed and parsed
> this way.

We are going to have "interesting" data that are not 1:1 with rules. But then 
they will be 1:1 with modules, or some other "scope" that netfilter knows how 
to traverse. Each "scope" can have their own section in the iptables-save 
output. Hence the parsing complexity lies in iptables-restore.

Whether it is all going to be exposed in some filesystem or not is a different 
matter.

> We may need a new set of commands in iptables (should I call it
> iptables-ng?)

What is the version after it going to be then? No, I never liked the -ng 
suffix :)

What is wrong with iptables2? 

> just for keeping this kind of data (realms, quota groups, 
> conditions, etc.). If we had a general way to keep collections of
> configurations, I'll be glad to conform and use it.
> </biased>
>
> I think the current array oriented data structures won't allow us to add
> these features. RCU lists come to mind. It sure is a step back in
> performance (sparser access to memory and more memory fragmentation), but
> it may not be that noticeable.

Flexibility is not free, but perhaps it can be cheap, performance wise.

Let's say we make iptables more shell-like, with the ability to handle 
multiple commands in one invocation (with a final COMMIT command required)? 
Would be lovely in itself.

Then iptables would get a better chance to optimize memory allocation, since 
it is not only looking at one rule at a time.

The case where you load the entire firewall ruleset in one go could be 
optimized to a point where it is no different from today.


Another proposal: Abstract out the storage for each rule/match/target. Let the 
kernel netfilter part handle allocation. Allow it to do transparent 
reallocation to optimize for locality:

 * The current scheme where the ipt_entry* structs are extended through 
the .data/.elems fields is abandoned. Hence, all ipt_entry* structs have 
static sizes, and can be stored in plain arrays regardless of what type they 
really are.

 * ipt_entry* structs might contain data (like basic src/dst/port/iface 
matches), but they may not keep pointers to anything, not even their own 
fields. They are independent of their own memory location. The memory 
management code can therefore rearrange the tables at will (proper locking 
assumed), without having to reinitialize rules.

 * All other memory is accessed through a struct that is passed to each 
rule/match/target's API functions. It contains at least .instance_data, but 
also .module_data (.priv_data), and perhaps other scopes data, 
like .rule_data, .chain_data and .global_data (all cross-module). Note that 
each of these are bound to a specific entity.

 * Each module and instance must call special netfilter API's to allocate 
memory of the required types. The netfilter part handles free'ing through 
refcount (why not).

 * The actual .*_data pointers may change between invocations (packets fed to) 
of the same rule/match/target. This means the netfilter part is allowed to 
rearrange dynamic memory too.

 * The catch: Rules can be changed without affecting the others, we get 
priv_data, and dynamic-sized memory allocation for individual instances as 
well. Memory layout and optimization is isolated from the modules and 
userspace. It become complex, but it does not have to be just to get it 
working.

 * Bonus: Sync of memory regions with other hosts can be handled 
transparently, or at least easily. So that fx. limit rules can work across 
redundant hosts.

As you can probably guess I am blissfully unaware of a few intricate details. 
Please enlighten me.


I have no clear idea how all these individual blobs would be communicated 
between kernel and userspace. Except there are two general options:

1) The current "pass a large blob" scheme. Since it will contain many smaller 
blobs, some in-kernel parsing is required. Worse yet, the kernel must also be 
able to assemble a large blob in order to dump to userspace.

2) Build the structure piece by piece, with a simple kernel call for each 
piece. Not entirely unlike populating a directory structure...


> I think every match/target should expode:
> - init;
> - destroy;
> - change;
> - dump;
> - restore.

change() would be nice, like in qdisc.

> Depending on the API change, dump and restore may melt in a single
> function.
>
> The kernel should let any match:
> - receive user supplied initialization data (mostly a rule definition)
> state dumps (this calls for very careful planning and checking);
> - send state dumps to userspace;
> - keep private data for every match/target;
> - keep collections of configurations common to matches in a module (every
> module may keep it without netfilter core help, but if it becomes part of
> the infrastructure it may be handled through the userspace ABI).
>
>
> Am I forgetting anything?

We all are.

> Do you think any of these features are bugs?
> Am I overseeing fatal difficulties related to what I wrote?
> Please reply with your opinions. I'll wear my asbestos suite for the next
> couple of days. :)

Applause for possibly opening the can of worms :)


Regards,
Simon
