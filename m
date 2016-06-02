From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4 0/7] spin_unlock_wait borkage and assorted bits
Date: Thu, 02 Jun 2016 13:51:57 +0200
Message-ID: <20160602115157.249037373@infradead.org>
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbcFBL5x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 07:57:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to -v3 in that it rewrites spin_unlock_wait() for all.

The new spin_unlock_wait() provides ACQUIRE semantics to match the RELEASE of
the spin_unlock() we waited for and thereby ensure we can fully observe its
critical section.

This fixes a number (pretty much all) spin_unlock_wait() users.

This series pulls in the smp_cond_acquire() rewrite because it introduces a lot
of new users of it. All simple spin_unlock_wait() implementations end up being
one.

New in this series is the removal of cmpwait() and a reorder of patches.

I'm planning on queuing these patches for 4.8.

