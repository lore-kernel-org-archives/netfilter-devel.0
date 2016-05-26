From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v2 0/6] spin_unlock_wait borkage
Date: Thu, 26 May 2016 16:19:22 +0200
Message-ID: <20160526141922.163198062@infradead.org>
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This version rewrites all spin_unlock_wait() implementations to provide the
acquire order against the spin_unlock() release we wait on, ensuring we can
fully observe the critical section we waited on.

It pulls in the smp_cond_acquire() rewrite because it introduces a lot more
users of it. All simple spin_unlock_wait implementations end up being an
smp_cond_load_acquire().

And while this still introduces smp_acquire__after_ctrl_dep() it keeps its
usage contained to a few sites.

Please consider.. carefully.
