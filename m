From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v4 5/7] locking, arch: Update spin_unlock_wait()
Date: Fri, 3 Jun 2016 15:48:42 +0200
Message-ID: <20160603134842.GB3693@twins.programming.kicks-ass.net>
References: <20160602115157.249037373@infradead.org>
 <20160602115439.085385545@infradead.org>
 <20160602142440.GE30064@insomnia>
 <20160602144424.GV3193@twins.programming.kicks-ass.net>
 <20160602163425.GV3205@twins.programming.kicks-ass.net>
 <20160602175659.GB7697@arm.com>
 <20160602215119.GF3190@twins.programming.kicks-ass.net>
 <20160603124734.GK9915@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, manfred@colorfullife.com,
	dave@stgolabs.net, paulmck@linux.vnet.ibm.com, Waiman.Long@hpe.com,
	tj@kernel.org, pablo@netfilter.org, kaber@trash.net,
	davem@davemloft.net, oleg@redhat.com,
	netfilter-devel@vger.kernel.org, sasha.levin@oracle.com,
	hofrat@osadl.org, jejb@parisc-linux.org, chris@zankel.net,
	rth@twiddle.net, dhowells@redhat.com, schwidefsky@de.ibm.com,
	mpe@ellerman.id.au, ralf@linux-mips.org, linux@armlinux.org.uk,
	rkuo@codeaurora.org, vgupta@synopsys.com, james.hogan@imgtec.com,
	realmz6@gmail.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
	cmetcalf@mellanox.com
To: Will Deacon <will.deacon@arm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbcFCNtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jun 2016 09:49:07 -0400
Content-Disposition: inline
In-Reply-To: <20160603124734.GK9915@arm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 03, 2016 at 01:47:34PM +0100, Will Deacon wrote:
> > Now, the normal atomic_foo_acquire() stuff uses smp_mb() as per
> > smp_mb__after_atomic(), its just ARM64 and PPC that go all 'funny' and
> > need this extra barrier. Blergh. So lets shelf this issue for a bit.
> 
> Hmm... I certainly plan to get qspinlock up and running for arm64 in the
> near future, so I'm not keen on shelving it for very long.

Sure; so short term we could always have arm64/ppc specific versions of
these functions where the difference matters.

Alternatively we need to introduce yet another barrier like:

	smp_mb__after_acquire()

Or something like that, which is a no-op by default except for arm64 and
ppc.

But I'm thinking nobody really wants more barrier primitives :/ (says he
who just added one).

> > This unordered store however, can be delayed (store buffer) such that
> > the loads from spin_unlock_wait/spin_is_locked can pass up before it
> > (even on TSO arches).
> 
> Right, and this is surprisingly similar to the LL/SC problem imo.

Yes and no. Yes because its an unordered store, no because a competing
ll/sc cannot make it fail the store and retry as done per your and
boqun's fancy solution.


