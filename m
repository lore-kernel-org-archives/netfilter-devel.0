From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v3 0/8] spin_unlock_wait borkage and assorted bits
Date: Tue, 31 May 2016 11:41:34 +0200
Message-ID: <20160531094134.606249808@infradead.org>
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Similar to -v2 in that it rewrites spin_unlock_wait() for all.

The new spin_unlock_wait() provides ACQUIRE semantics to match the RELEASE of
the spin_unlock() we waited for and thereby ensure we can fully observe its
critical section.

This fixes a number (pretty much all) spin_unlock_wait() users.

This series pulls in the smp_cond_acquire() rewrite because it introduces a lot
of new users of it. All simple spin_unlock_wait() implementations end up being
one.

New in this series; apart from the fixes from the last posting (s390,tile),
is that it moves smp_cond_load_acquire() and friends into asm-generic/barrier.h
such that architectures that explicitly do not do load speculation (tile)
can override smp_acquire__after_ctrl_dep().

I'm planning on queuing these patches for 4.8.
