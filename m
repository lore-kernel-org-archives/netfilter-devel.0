From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 2/3] locking: Annotate spin_unlock_wait() users
Date: Tue, 24 May 2016 18:57:41 +0200
Message-ID: <20160524165741.GB15189@worktop.bitpit.net>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.608476390@infradead.org>
 <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Will Deacon <will.deacon@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <Waiman.Long@hpe.com>, Tejun Heo <tj@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Oleg Nesterov <oleg@redhat.com>,
	netfilter-devel@vger.kernel.org,
	Sasha Levin <sasha.levin@oracle.com>, hofrat@osadl.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 24, 2016 at 09:17:13AM -0700, Linus Torvalds wrote:

> This needs to be either hidden inside the basic spinlock functions,
> _or_ it needs to be a clear and unambiguous interface. Anything that
> starts talking about control dependencies is not it.
> 
> Note that this really is about naming and use, not about
> implementation. So something like "spin_sync_after_unlock_wait()" is
> acceptable, even if the actual _implementation_ were to be exactly the
> same as the "after_ctrl_dep()" crap.

OK; so I would prefer to keep the smp_acquire__after_ctrl_dep() crap for
common use in smp_cond_acquire() and such, but I'd be more than happy to
just stuff it unconditionally into spin_unlock_wait().

Most users really need it, and its restores intuitive semantics to the
primitive.

I'm assuming the explicit use then left in ipc/sem.c (as paired with the
spin_is_locked) is fine with you; that's certainly not driver code.

Todays series was really more about auditing all the spin_unlock_wait()
usage sites.
