From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3 5/9] exit: Replace spin_unlock_wait() with lock/unlock pair
Date: Fri,  7 Jul 2017 12:28:22 -0700
Message-ID: <1499455706-9398-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20170707192704.GA6144@linux.vnet.ibm.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org, mingo@redhat.com,
        dave@stgolabs.net, manfred@colorfullife.com, tj@kernel.org,
        arnd@arndb.de, linux-arch@vger.kernel.org, will.deacon@arm.com,
        peterz@infradead.org, stern@rowland.harvard.edu,
        parri.andrea@gmail.com, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56689 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751091AbdGGT2k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 15:28:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v67JSd7W039735
        for <netfilter-devel@vger.kernel.org>; Fri, 7 Jul 2017 15:28:39 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bjcmjgj9n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jul 2017 15:28:38 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netfilter-devel@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 7 Jul 2017 15:28:33 -0400
In-Reply-To: <20170707192704.GA6144@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no agreed-upon definition of spin_unlock_wait()'s semantics, and
it appears that all callers could do just as well with a lock/unlock pair.
This commit therefore replaces the spin_unlock_wait() call in do_exit()
with spin_lock() followed immediately by spin_unlock().  This should be
safe from a performance perspective because the lock is a per-task lock,
and this is happening only at task-exit time.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrea Parri <parri.andrea@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/exit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 516acdb0e0ec..6d19c9090d43 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -832,7 +832,8 @@ void __noreturn do_exit(long code)
 	 * Ensure that we must observe the pi_state in exit_mm() ->
 	 * mm_release() -> exit_pi_state_list().
 	 */
-	raw_spin_unlock_wait(&tsk->pi_lock);
+	raw_spin_lock_irq(&tsk->pi_lock);
+	raw_spin_unlock_irq(&tsk->pi_lock);
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
-- 
2.5.2

