From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Mon, 5 Sep 2016 20:57:19 +0200
Message-ID: <5d88110f-cf0e-c72e-7acc-518b736e715e@colorfullife.com>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
 <20160901153039.GN6721@arm.com>
 <20160901164126.GZ10153@twins.programming.kicks-ass.net>
 <1971bcf8-0f42-c0b7-5e59-2ceaa6e024a7@colorfullife.com>
 <20160902192213.GM10153@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A7846A1626D35474759938E3"
Cc: Ingo Molnar <mingo@elte.hu>, Boqun Feng <boqun.feng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160902192213.GM10153@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------A7846A1626D35474759938E3
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Peter,

On 09/02/2016 09:22 PM, Peter Zijlstra wrote:
> On Fri, Sep 02, 2016 at 08:35:55AM +0200, Manfred Spraul wrote:
>> On 09/01/2016 06:41 PM, Peter Zijlstra wrote:
>>> On Thu, Sep 01, 2016 at 04:30:39PM +0100, Will Deacon wrote:
>>>> On Thu, Sep 01, 2016 at 05:27:52PM +0200, Manfred Spraul wrote:
>>>>> Since spin_unlock_wait() is defined as equivalent to spin_lock();
>>>>> spin_unlock(), the memory barrier before spin_unlock_wait() is
>>>>> also not required.
>>> Note that ACQUIRE+RELEASE isn't a barrier.
>>>
>>> Both are semi-permeable and things can cross in the middle, like:
>>>
>>>
>>> 	x = 1;
>>> 	LOCK
>>> 	UNLOCK
>>> 	r = y;
>>>
>>> can (validly) get re-ordered like:
>>>
>>> 	LOCK
>>> 	r = y;
>>> 	x = 1;
>>> 	UNLOCK
>>>
>>> So if you want things ordered, as I think you do, I think the smp_mb()
>>> is still needed.
>> CPU1:
>> x=1; /* without WRITE_ONCE */
>> LOCK(l);
>> UNLOCK(l);
>> <do_semop>
>> smp_store_release(x,0)
>>
>>
>> CPU2;
>> LOCK(l)
>> if (smp_load_acquire(x)==1) goto slow_path
>> <do_semop>
>> UNLOCK(l)
>>
>> Ordering is enforced because both CPUs access the same lock.
>>
>> x=1 can't be reordered past the UNLOCK(l), I don't see that further
>> guarantees are necessary.
>>
>> Correct?
> Correct, sadly implementations do not comply :/ In fact, even x86 is
> broken here.
>
> I spoke to Will earlier today and he suggests either making
> spin_unlock_wait() stronger to avoids any and all such surprises or just
> getting rid of the thing.
I've tried the trivial solution:
Replace spin_unlock_wait() with spin_lock();spin_unlock().
With sem-scalebench, I get around a factor 2 slowdown with an array with 
16 semaphores and factor 13 slowdown with an array of 256 semaphores :-(
[with LOCKDEP+DEBUG_SPINLOCK].

Anyone around with a ppc or arm? How slow is the loop of the 
spin_unlock_wait() calls?
Single CPU is sufficient.

Question 1: How large is the difference between:
#./sem-scalebench -t 10 -c 1 -p 1 -o 4 -f -d 1
#./sem-scalebench -t 10 -c 1 -p 1 -o 4 -f -d 256
https://github.com/manfred-colorfu/ipcscale

For x86, the difference is only ~30%.

Question 2:
Is it faster if the attached patch is applied? (relative to mmots)

--
     Manfred

--------------A7846A1626D35474759938E3
Content-Type: text/x-patch;
 name="0001-ipc-sem.c-Avoid-spin_unlock_wait.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-ipc-sem.c-Avoid-spin_unlock_wait.patch"

>From b063c9edbb264cfcbca6c23eee3c85f90cd77ae1 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Mon, 5 Sep 2016 20:45:38 +0200
Subject: [PATCH] ipc/sem.c: Avoid spin_unlock_wait()

experimental, not fully tested!
spin_unlock_wait() may be expensive, because it must ensure memory
ordering.
Test: Would it be faster if an explicit is_locked flag is used?
For large arrays, only 1 barrier would be required.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 5e318c5..062ece2d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -101,6 +101,7 @@ struct sem {
 	 */
 	int	sempid;
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
+	int		is_locked;	/* locked flag */
 	struct list_head pending_alter; /* pending single-sop operations */
 					/* that alter the semaphore */
 	struct list_head pending_const; /* pending single-sop operations */
@@ -282,17 +283,22 @@ static void complexmode_enter(struct sem_array *sma)
 
 	/* We need a full barrier after seting complex_mode:
 	 * The write to complex_mode must be visible
-	 * before we read the first sem->lock spinlock state.
+	 * before we read the first sem->is_locked state.
 	 */
 	smp_store_mb(sma->complex_mode, true);
 
 	for (i = 0; i < sma->sem_nsems; i++) {
 		sem = sma->sem_base + i;
-		spin_unlock_wait(&sem->lock);
+		if (sem->is_locked) {
+			spin_lock(&sem->lock);
+			spin_unlock(&sem->lock);
+		}
 	}
 	/*
-	 * spin_unlock_wait() is not a memory barriers, it is only a
-	 * control barrier. The code must pair with spin_unlock(&sem->lock),
+	 * If spin_lock(); spin_unlock() is used, then everything is
+	 * ordered. Otherwise: Reading sem->is_locked is only a control
+	 * barrier.
+	 * The code must pair with smp_store_release(&sem->is_locked),
 	 * thus just the control barrier is insufficient.
 	 *
 	 * smp_rmb() is sufficient, as writes cannot pass the control barrier.
@@ -364,17 +370,16 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		spin_lock(&sem->lock);
 
 		/*
-		 * See 51d7d5205d33
-		 * ("powerpc: Add smp_mb() to arch_spin_is_locked()"):
-		 * A full barrier is required: the write of sem->lock
-		 * must be visible before the read is executed
+		 * set is_locked. It must be ordered before
+		 * reading sma->complex_mode.
 		 */
-		smp_mb();
+		smp_store_mb(sem->is_locked, true);
 
 		if (!smp_load_acquire(&sma->complex_mode)) {
 			/* fast path successful! */
 			return sops->sem_num;
 		}
+		smp_store_release(&sem->is_locked, false);
 		spin_unlock(&sem->lock);
 	}
 
@@ -387,6 +392,8 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 		 * back to the fast path.
 		 */
 		spin_lock(&sem->lock);
+		/* no need for smp_mb, we own the global lock */
+		sem->is_locked = true;
 		ipc_unlock_object(&sma->sem_perm);
 		return sops->sem_num;
 	} else {
@@ -406,6 +413,7 @@ static inline void sem_unlock(struct sem_array *sma, int locknum)
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
+		smp_store_release(&sem->is_locked, false);
 		spin_unlock(&sem->lock);
 	}
 }
@@ -551,6 +559,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 		INIT_LIST_HEAD(&sma->sem_base[i].pending_alter);
 		INIT_LIST_HEAD(&sma->sem_base[i].pending_const);
 		spin_lock_init(&sma->sem_base[i].lock);
+		sma->sem_base[i].is_locked = false;
 	}
 
 	sma->complex_count = 0;
-- 
2.7.4


--------------A7846A1626D35474759938E3--
