From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 23:47:12 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <046a01c21c91$dd980b80$0489cb8a@etbx180>
References: <20020625151007.980D14140@lists.samba.org> <15640.41407.432907.402311@isis.cs3-inc.com>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Harald Welte" <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> But I believe that conntrack is exactly what's causing the load. If
> the machine is busy creating connections then it's clearly going to
> lose packets.  I imagine that the packets that are dropped are those
> arriving at full queues.  So fin's and rst's could very well be
> dropped if they arrive on interfaces that are receiving lots of other
> stuff while the cpu is busy building conntrack records.

agreed.

(strange thing is that ethernet irq's reported by procinfo are 
 decreasing when the machine is overloaded. It suppose that it 
 means either that irq's are not even caught by the kernel/driver, 
 which is quite worrying, or either that irq's counters refer to 
 'processessed' interrupts)

> Not true.  See my proposed bucket size limit.  I hope to find some
> formulae to post on this later.

longing to see that.

> I suspect the hash function is fine.  I propose to insert code that
> does printk whenever a bucket size exceeds some threshold and then
> invite all the readers of this list to try it and report their
> results.

I would rather go for global stats reported periodically, so that we 
have a constant measure (counters update) overhead.

> I think what happens is that it's not hash collisions but conntrack
> record creation that takes a long time, and that pretty much all
> packets are likely to be lost when the cpu is saturated with that
> activity.  In that case it's true that connections are not garbage
> collected as fast as they should be.

Since the difference between entry creation and entry lookup is only
a call to init_conntrack(), profiling will be welcome, because as far 
as the slab allocator is concerned, at constant speed, the system should
not do any costly alloc() anymore and instead dig into the slab' freelist.
A lock problem somewhere, or a lack of inlines?

same thing for nat I suppose

Harld: could you ask to your kernel specialist what is the weakpoint of
kmem_cache_alloc()? (locks, allocs, ...), and how we could possibly
improve it (batch alloc, but isn't it already the case?)

PS: Harald
> I've recently did some testing which try to avoid the null binding, but 
> as I'm not entirely sure they don't break something else I haven't been
> releasing them yet.

I would be glad to test it at the same time. I'll come back to you when 
ready for testings. But I've no SMP system.

> I've been talking about this with a couple of people here at the kernel
> summit, and it looks like the per-packet del_timer/add_timer in
> ip_ct_refresh should be a severe performance hit on SMP boxes.

Any indications that it would not be the same on non SMP boxes? 

> Changing this to 'do not update timer if update would be < HZ different
> than current timer' is a two-line patch.  

I've seen that discussion, but not the patch. (I'll come back to you)

--
-jmhe-
