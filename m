From: Herve Eychenne <rv@wallfire.org>
Subject: Re: RAM and conntrack performance
Date: Tue, 25 Nov 2003 16:35:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031125153543.GD1082@eychenne.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031103081240.GQ1536@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 03, 2003 at 09:12:40AM +0100, Harald Welte wrote:

> On Tue, Oct 28, 2003 at 04:10:32PM +0100, Herve Eychenne wrote:

 Hi!

Thank you very much for your detailled answer, Harald.
Sorry for the delay. I'm currently writing this little document, based mainly
on your answers.

> > I think it would be good to end up with a small document which would
> > give every detail about how to choose optimal values for HASHSIZE and
> > CONNTRACK_MAX, and every other mean to get the best out of the
> > conntracking/NAT system...

> I guess there hasn't been any performance testing.  Ideally you'd have
> as many buckets as you have conntrack entries in the system.  However,
> every bucket will 

Something was lost in space... Will? ;-)

> > Here are things I've collected so far, that it would be good to have
> > in this little document. I have questions, also:
> > - CONNTRACK_MAX and HASHSIZE get default values at boot time.
> >   By default, CONNTRACK_MAX = n * 64, where n is the RAM size in MB,
> >   am I right?

> well, it's true on i386.
> See the algorithm below.

> >   What about HASHSIZE default value? How to read it at runtime?

So, it cannot be read at runtime, I suppose... It would be really nice,
though... would /proc be ok?

> >   What is the exact link between these 2 values?

> /* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
>  * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */
>  	if (hashsize) {
>  		ip_conntrack_htable_size = hashsize;
>  	} else {
> ip_conntrack_htable_size
> = (((num_physpages << PAGE_SHIFT) / 16384)
> / sizeof(struct list_head));
> if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
> ip_conntrack_htable_size = 8192;

We could put a "else" here.
BTW, why this hard limit of 8192? On really high-speed and high-loaded networks,
you may perfectly want to set to an upper value...

> if (ip_conntrack_htable_size < 16)
> ip_conntrack_htable_size = 16;
> }
> ip_conntrack_max = 8 * ip_conntrack_htable_size;

> I guess it's hard to describe the algorithm any better in written
> language.

> > - HASHSIZE should be an odd number, and even better: a prime number.
> >   What happens when you set it to an even number, or a non-prime number?

> hash distribution will be less optimal.

But reading the algorithm, hashsize is never automatically set to a
prime number... but an even one. So how do you explain
that I have 4091 (which is probably a prime number, right?) buckets on
my system by default?

> >   Why enable people to set even and non-prime numbers at all?

> because we're lazy (and it doesn't cause a malfunction)

Lazyness is the mother of all vices. ;-)

> >   Which values are the "best"? I.e., can someone give a formula with
> >   this potential parameters (if pertinent):
> >   - total RAM size
> >   - size of the memory that should be left for non-conntrack data in
> >     the kernel and userspace in general (what is a reasonnable value for
> >     a firewall doing only firewalling with very few applications
> >     running, and how to measure that at runtime?)
> >   - number of rules, connections rate, etc.

> This is not a fixed formula. If it was, we could just do it
> automatically that way.

No, because we don't know the amount of memory potentially used by
non-conntrack data.

> In the ideal case, you have a machine _just_
> doing packet filtering (i.e. almost no userspace running, at least none
> that would have a growing memory consumption like proxies, ...).  Then
> you put a decent amount of memory into that box, and use all but 64MB
> (or 128MB) for conntrack (which can easily be half a gig of ram
> considering todays memory prices).

> size_of_mem_available_for_ct = 
> ip_conntrack_max*sizeof(struct ip_conntrack) +
> hashsize*sizeof(struct list_head)

> struct ip_conntrack is about 300 bytes (depending on your compile-time
> configuration, see the printout at module load time).  struct list_head
> is 2 times the size of a pointer on the respective arch.  on i386 it's 8
> bytes total.

So on i386,
size_of_mem_available_for_ct =~
300 * ip_conntrack_max + hashsize * 8 =~
300 * ip_conntrack_max + ip_conntrack_max =~
300 * ip_conntrack_max =~
300 * RAM / 16384 =~
RAM / 55 by default
On a firewall-only machine (without proxies), this is not much, as
we could run with 
ip_conntrack_max = RAM - 128MB / 300

So, on a firewall-only machine with 512MB and 128MB "reserved" for
non-conntrack things (which is really big already for a firewall in
console mode), we could have 40 times more conntrack entries
than the default value without any problem. Interesting.

> > - CONNTRACK_MAX can be modified at run time with /proc. What does it
> >   do exactly (when shrinked, when extended)?

You don't really answer to my question: what happens when you set
conntrack_max to a smaller number than the currently stored conntrack
entries? I suppose conntrack entries are deleted? According to which
criterias?

> >   When you modify CONNTRACK_MAX, should you also modify HASHSIZE
> >   accordingly? Why? How?

> it increases the counter of maximum allowed conntrack entries.
> yes, you should also modify the hash size, since now the average number
> of conntrack entries per hash bucket is increasing
> (ip_conntrack_max/hashsize in the optimal case) and thus we need to
> iterate over more list entries per conntrack lookup.  Having a large
> hashsize is not bad at all - it will just occupy 
> hashzize*sizeof(struct list_head) bytes of non-swappable kernel memory,
> whether you have any connections or not. 

Yes, but globally, if we have 
conntrack_max = 8 * hashsize,
size_of_mem_available_for_ct =~
300 * ip_conntrack_max + hashsize * 8 =~
300 * ip_conntrack_max + ip_conntrack_max =~
300 * ip_conntrack_max

But if we take conntrack_max = hashsize,
size_of_mem_available_for_ct is still around 300 * ip_conntrack_max
(on my system, it is not 300, but exactly 292)
So I simply think that on firewall-only machines with 512Mo, we should
simply use conntrack_max = hashsize without any questioning.

Oh, BTW, what happens if hashsize > conntrack_max?
And what happens exactly when the number of active sessions exceeds
conntrack max?

> >   How to proceed to keep current conntrack entries at runtime as much
> >   as possible? (I suppose unloading ip_conntrack module and
> >   reinserting it with another hashsize value clears the table...)

> yes.  You just don't do that.  You configure your firewall, and put it
> in place.  You should know your network traffic beforehand and configure
> it correctly.

That's not always that simple. Suppose you're working for a company for which
availability and performance is critical... and suppose the growing
network traffic forces you to increase your bandwidth by about 10.
Well, in these sort of cases, you certainly want to avoid to reboot
(and loose connections) too much, believe me.
Yes, netfilter is sometimes used in these kind of companies. And
yes, I sometimes happen to do some missions for them.
And no, I can hardly give you any names. ;-)

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
