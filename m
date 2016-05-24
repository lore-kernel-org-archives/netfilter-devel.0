From: Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 2/3] locking: Annotate spin_unlock_wait() users
Date: Tue, 24 May 2016 16:27:25 +0200
Message-ID: <20160524143649.608476390@infradead.org>
References: <20160524142723.178148277@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=peterz-locking-fix-spin_unlock_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

spin_unlock_wait() has an unintuitive 'feature' in that it doesn't
fully serialize against the spin_unlock() we've waited on.

In particular, spin_unlock_wait() only provides a control dependency,
which is a LOAD->STORE order. This means subsequent loads can creep up
and observe state prior to the waited-for unlock. This means we don't
necessarily observe the full critical section.

We must employ smp_acquire__after_ctrl_dep() to upgrade the
LOAD->STORE to LOAD->{LOAD,STORE} aka. load-AQUIRE and thereby ensure
we observe the full critical section we've waited on.

Many spin_unlock_wait() users were unaware of this issue and need
help.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/ata/libata-eh.c   |    4 +++-
 kernel/exit.c             |   14 ++++++++++++--
 kernel/sched/completion.c |    7 +++++++
 kernel/task_work.c        |    2 +-
 4 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -703,8 +703,10 @@ void ata_scsi_cmd_error_handler(struct S
 
 		/* initialize eh_tries */
 		ap->eh_tries = ATA_EH_MAX_TRIES;
-	} else
+	} else {
 		spin_unlock_wait(ap->lock);
+		smp_acquire__after_ctrl_dep();
+	}
 
 }
 EXPORT_SYMBOL(ata_scsi_cmd_error_handler);
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -776,11 +776,16 @@ void do_exit(long code)
 
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
-	 * tsk->flags are checked in the futex code to protect against
-	 * an exiting task cleaning up the robust pi futexes.
+	 * Ensure that all new tsk->pi_lock acquisitions must observe
+	 * PF_EXITING. Serializes against futex.c:attach_to_pi_owner().
 	 */
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
+	/*
+	 * Ensure that we must observe the pi_state in exit_mm() ->
+	 * mm_release() -> exit_pi_state_list().
+	 */
+	smp_acquire__after_ctrl_dep();
 
 	if (unlikely(in_atomic())) {
 		pr_info("note: %s[%d] exited with preempt_count %d\n",
@@ -897,6 +902,11 @@ void do_exit(long code)
 	 */
 	smp_mb();
 	raw_spin_unlock_wait(&tsk->pi_lock);
+	/*
+	 * Since there are no following loads the LOAD->LOAD order
+	 * provided by smp_acquire__after_ctrl_dep() is not
+	 * strictly required.
+	 */
 
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -312,6 +312,13 @@ bool completion_done(struct completion *
 	 */
 	smp_rmb();
 	spin_unlock_wait(&x->wait.lock);
+	/*
+	 * Even though we've observed 'done', this doesn't mean we can observe
+	 * all stores prior to complete(), as the only RELEASE barrier on that
+	 * path is provided by the spin_unlock().
+	 */
+	smp_acquire__after_ctrl_dep();
+
 	return true;
 }
 EXPORT_SYMBOL(completion_done);
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -108,7 +108,7 @@ void task_work_run(void)
 		 * fail, but it can play with *work and other entries.
 		 */
 		raw_spin_unlock_wait(&task->pi_lock);
-		smp_mb();
+		smp_acquire__after_ctrl_dep();
 
 		do {
 			next = work->next;
