From: Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/3] spin_unlock_wait and assorted borkage
Date: Tue, 24 May 2016 16:27:23 +0200
Message-ID: <20160524142723.178148277@infradead.org>
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As per recent discussions spin_unlock_wait() has an unintuitive 'feature'.

  lkml.kernel.org/r/20160520053926.GC31084@linux-uzut.site

These patches pull the existing solution into generic code; annotate all
spin_unlock_wait() users and fix nf_conntrack more.

The alternative -- putting smp_acquire__after_ctrl_dep() into
spin_unlock_wait() can be done later if desired, now that al users are audited
and corrected.

Please (very) carefully consider.
