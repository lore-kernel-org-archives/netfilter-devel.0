From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Wed, 26 Jun 2002 16:50:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020626145011.GC8557@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020625151007.980D14140@lists.samba.org> <15640.41407.432907.402311@isis.cs3-inc.com> <046a01c21c91$dd980b80$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <046a01c21c91$dd980b80$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 25, 2002 at 11:47:12PM +0200, Jean-Michel Hemstedt wrote:
> agreed.
> 
> (strange thing is that ethernet irq's reported by procinfo are 
>  decreasing when the machine is overloaded. It suppose that it 
>  means either that irq's are not even caught by the kernel/driver, 
>  which is quite worrying, or either that irq's counters refer to 
>  'processessed' interrupts)

are you using a driver which uses the irq mitigation interface of 2.4.x
or the NAPI of 2.5.x ?

> Harld: could you ask to your kernel specialist what is the weakpoint of
> kmem_cache_alloc()? (locks, allocs, ...), and how we could possibly
> improve it (batch alloc, but isn't it already the case?)

I don't think that the slab allocator is the bottleneck. please show me
profiling data pointing this out.

> > I've been talking about this with a couple of people here at the kernel
> > summit, and it looks like the per-packet del_timer/add_timer in
> > ip_ct_refresh should be a severe performance hit on SMP boxes.
> 
> Any indications that it would not be the same on non SMP boxes? 

well, it's still a performance problem, but on UP it doesn't involve
disabling interrupts across all cpus.

> -jmhe-

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
