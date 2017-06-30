From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 14/26] hexagon: Remove spin_unlock_wait() arch-specific definitions
Date: Thu, 29 Jun 2017 17:01:22 -0700
Message-ID: <1498780894-8253-14-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20170629235918.GA6445@linux.vnet.ibm.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org, mingo@redhat.com,
        dave@stgolabs.net, manfred@colorfullife.com, tj@kernel.org,
        arnd@arndb.de, linux-arch@vger.kernel.org, will.deacon@arm.com,
        peterz@infradead.org, stern@rowland.harvard.edu,
        parri.andrea@gmail.com, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Kuo <rkuo@codeaurora.org>,
        <linux-hexagon@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752317AbdF3ABq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 20:01:46 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5TNx70U112920
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 20:01:45 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bd1dtu316-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 20:01:45 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 29 Jun 2017 20:01:43 -0400
In-Reply-To: <20170629235918.GA6445@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no agreed-upon definition of spin_unlock_wait()'s semantics,
and it appears that all callers could do just as well with a lock/unlock
pair.  This commit therefore removes the underlying arch-specific
arch_spin_unlock_wait().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: <linux-hexagon@vger.kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/hexagon/include/asm/spinlock.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/hexagon/include/asm/spinlock.h b/arch/hexagon/include/asm/spinlock.h
index a1c55788c5d6..53a8d5885887 100644
--- a/arch/hexagon/include/asm/spinlock.h
+++ b/arch/hexagon/include/asm/spinlock.h
@@ -179,11 +179,6 @@ static inline unsigned int arch_spin_trylock(arch_spinlock_t *lock)
  */
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
-static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
-{
-	smp_cond_load_acquire(&lock->lock, !VAL);
-}
-
 #define arch_spin_is_locked(x) ((x)->lock != 0)
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
-- 
2.5.2

