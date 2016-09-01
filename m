From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Thu, 1 Sep 2016 18:41:26 +0200
Message-ID: <20160901164126.GZ10153@twins.programming.kicks-ass.net>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
 <20160901153039.GN6721@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manfred Spraul <manfred@colorfullife.com>,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160901153039.GN6721@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 01, 2016 at 04:30:39PM +0100, Will Deacon wrote:
> On Thu, Sep 01, 2016 at 05:27:52PM +0200, Manfred Spraul wrote:
> > Since spin_unlock_wait() is defined as equivalent to spin_lock();
> > spin_unlock(), the memory barrier before spin_unlock_wait() is
> > also not required.

Note that ACQUIRE+RELEASE isn't a barrier.

Both are semi-permeable and things can cross in the middle, like:


	x = 1;
	LOCK
	UNLOCK
	r = y;

can (validly) get re-ordered like:

	LOCK
	r = y;
	x = 1;
	UNLOCK

So if you want things ordered, as I think you do, I think the smp_mb()
is still needed.

RELEASE + ACQUIRE otoh, that is a load-store barrier (but not
transitive).
