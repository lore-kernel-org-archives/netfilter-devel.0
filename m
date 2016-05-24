From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] locking: Annotate spin_unlock_wait() users
Date: Tue, 24 May 2016 09:17:13 -0700
Message-ID: <CA+55aFyyHbPVMx8cZbKONy5cevxsYA0qbwapboA0dD8hPSwPWg@mail.gmail.com>
References: <20160524142723.178148277@infradead.org>
	<20160524143649.608476390@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160524143649.608476390@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 24, 2016 at 7:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> spin_unlock_wait() has an unintuitive 'feature' in that it doesn't
> fully serialize against the spin_unlock() we've waited on.

NAK.

We don't start adding more of this "after_ctrl_dep" crap.

It's completely impossible to understand, and even people who have
been locking experts have gotten it wrong.

So it is *completely* unacceptable to have it in drivers.

This needs to be either hidden inside the basic spinlock functions,
_or_ it needs to be a clear and unambiguous interface. Anything that
starts talking about control dependencies is not it.

Note that this really is about naming and use, not about
implementation. So something like "spin_sync_after_unlock_wait()" is
acceptable, even if the actual _implementation_ were to be exactly the
same as the "after_ctrl_dep()" crap.

The difference is that one talks about incomprehensible implementation
details that nobody outside of the person who *implemented* the
spinlock code is supposed to understand (and seriously, I have my
doubts even the spinlock implementer understands it, judging by the
last time this happened), and the other is a much simpler semantic
guarantee.

So don't talk about "acquire". And most certainly don't talk about
"control dependencies". Not if we end up having things like *drivers*
using this like in this example libata.

                Linus
