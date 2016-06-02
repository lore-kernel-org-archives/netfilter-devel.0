From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v4 6/7] locking: Update spin_unlock_wait users
Date: Thu, 02 Jun 2016 13:52:03 +0200
Message-ID: <20160602115439.145204300@infradead.org>
References: <20160602115157.249037373@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50828 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbcFBL5s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 07:57:48 -0400
Content-Disposition: inline; filename=peterz-locking-fix-spin_unlock_wait.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the modified semantics of spin_unlock_wait() a number of
explicit barriers can be removed. And update the comment for the
do_exit() usecase, as that was somewhat stale/obscure.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 ipc/sem.c          |    1 -
 kernel/exit.c      |    8 ++++++--
 kernel/task_work.c |    1 -
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -282,7 +282,6 @@ static void sem_wait_array(struct sem_ar
 		sem = sma->sem_base + i;
 		spin_unlock_wait(&sem->lock);
 	}
-	smp_acquire__after_ctrl_dep();
 }
 
 /*
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -776,10 +776,14 @@ void do_exit(long code)
 
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
-	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
+	 * Ensure that all new tsk->pi_lock acquisitions must observe
+	 * PF_EXITING. Serializes against futex.c:attach_to_pi_owner().
 	 */
 	smp_mb();
+	/*
+	 * Ensure that we must observe the pi_state in exit_mm() ->
+	 * mm_release() -> exit_pi_state_list().
+	 */
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic())) {
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -108,7 +108,6 @@ void task_work_run(void)
 		 * fail, but it can play with *work and other entries.
 		 */
 		raw_spin_unlock_wait(&task->pi_lock);
-		smp_mb();
 
 		do {
 			next = work->next;


