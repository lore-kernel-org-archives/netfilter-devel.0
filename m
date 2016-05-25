From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/3] locking: Introduce smp_acquire__after_ctrl_dep
Date: Wed, 25 May 2016 11:59:45 -0700
Message-ID: <20160525185945.GH3789@linux.vnet.ibm.com>
References: <20160524142723.178148277@infradead.org>
 <20160524143649.523586684@infradead.org>
 <57451581.6000700@hpe.com>
 <20160525045329.GQ4148@linux.vnet.ibm.com>
 <5745C2CA.4040003@hpe.com>
 <20160525155747.GE3789@linux.vnet.ibm.com>
 <20160525162829.GX3193@twins.programming.kicks-ass.net>
 <CA+55aFx0mYrxvMfngTY_+=-Ty2mOwoOuW9pLcLGUFmfP=rPvGQ@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <waiman.long@hpe.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Will Deacon <will.deacon@arm.com>,
	Boqun Feng <boqun.feng@gmail.com>, Tejun Heo <tj@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Oleg Nesterov <oleg@redhat.com>,
	netfilter-devel@vger.kernel.org,
	Sasha Levin <sasha.levin@oracle.com>, hofrat@osadl.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFx0mYrxvMfngTY_+=-Ty2mOwoOuW9pLcLGUFmfP=rPvGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 25, 2016 at 09:54:55AM -0700, Linus Torvalds wrote:
> On Wed, May 25, 2016 at 9:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I would consider any architecture that allows speculative stores as
> > broken. They are values out of thin air and would make any kind of
> > concurrency extremely 'interesting'.
> 
> It's worth noting that the same is true of compilers too. You will
> find compiler people who argue that speculative stores are valid
> because the spec doesn't explicitly forbid them. Same is true of
> compiler-generated value speculation.

Thankfully, this has improved.  There was a time when compiler writers
were happy to overwrite adjacent variables and fix them up later,
believe it or not.  Not so good if the variables are shared variables,
possibly protected by different locks.  Most compiler writers now
understand that this sort of thing is not permitted, and recent
versions of the standard explicitly forbid it.

But there are still any number of optimizations that can cause trouble
for concurrent code.  Common subexpresssion elimination, for example...
Which is one reason for my heavy use of READ_ONCE() and WRITE_ONCE().

> Both are cases of "yeah, the C standard may not explicitly disallow
> it, but sanity in a threaded environment does". Sadly, I've seen
> compiler people who dismiss "sanity" as an argument, since that also
> isn't defined in the C standard. There are people who think that paper
> is the most precious resource in the universe.
> 
> I'm not actually aware of anybody doing speculative stores or value
> speculation in a compiler we care about, but if those kinds of things
> are the kinds of things where we'd just go "that compiler is shit" and
> not use it (possibly with a command line option to disable the
> particular broken optimization, like we do for the broken type-based
> aliasing and some other code generation things that just don't work in
> the kernel).
> 
> So we definitely have the option to just say "theory is just theory".
> We'll never make design decisions based on insane things being
> possible in theory, whether it be crazy architectures or crazy
> compilers.

There has been some discussion of adding "-std=kernel" to tell the
compiler to follow Linux-kernel rules, but not sure whether this is
really going anywhere.

							Thanx, Paul
