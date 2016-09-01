From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 6/7] net/netfilter/nf_conntrack_core: Remove barriers after spin_unlock_wait
Date: Thu,  1 Sep 2016 17:04:16 +0200
Message-ID: <1472742257-10515-7-git-send-email-manfred@colorfullife.com>
References: <1472742257-10515-1-git-send-email-manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, will.deacon@arm.com,
        1vier1@web.de, Davidlohr Bueso <dave@stgolabs.net>,
        Manfred Spraul <manfred@colorfullife.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34597 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933187AbcIAPF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 11:05:29 -0400
Received: by mail-wm0-f68.google.com with SMTP id v143so2428064wmv.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Sep 2016 08:04:37 -0700 (PDT)
In-Reply-To: <1472742257-10515-1-git-send-email-manfred@colorfullife.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_conntrack_all() contains an smp_rmb() after spin_unlock_wait().
This was done to allow safe backporting.

Commit 2c6100227116 ("locking/qspinlock: Fix spin_unlock_wait() some more")
(and the commits for the other archs) ensure that spin_unlock_wait()
is an ACQUIRE.
Therefore the smp_rmb() after spin_unlock_wait() can be removed.

Not for stable!

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nf_conntrack_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3847f09..c8a2d26 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -153,11 +153,6 @@ static void nf_conntrack_all_lock(void)
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_unlock_wait(&nf_conntrack_locks[i]);
 	}
-	/* spin_unlock_wait() is at least a control barrier.
-	 * Add smp_rmb() to upgrade it to an ACQUIRE, it must
-	 * pair with the spin_unlock(&nf_conntrack_locks[])
-	 */
-	smp_rmb();
 }
 
 static void nf_conntrack_all_unlock(void)
-- 
2.7.4

