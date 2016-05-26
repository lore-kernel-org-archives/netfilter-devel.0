From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v2 2/6] locking: Introduce cmpwait()
Date: Thu, 26 May 2016 16:19:24 +0200
Message-ID: <20160526142354.150759303@infradead.org>
References: <20160526141922.163198062@infradead.org>
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
Content-Disposition: inline; filename=peterz-locking-cmp_and_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Provide the cmpwait() primitive, which will 'spin' wait for a variable
to change and use it to implement smp_cond_load_acquire().

This primitive can be implemented with hardware assist on some
platforms (ARM64, x86).

Suggested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/compiler.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -305,6 +305,23 @@ static __always_inline void __write_once
 })
 
 /**
+ * cmpwait - compare and wait for a variable to change
+ * @ptr: pointer to the variable to wait on
+ * @val: the value it should change from
+ *
+ * A simple constuct that waits for a variable to change from a known
+ * value; some architectures can do this in hardware.
+ */
+#ifndef cmpwait
+#define cmpwait(ptr, val) do {					\
+	typeof (ptr) __ptr = (ptr);				\
+	typeof (val) __val = (val);				\
+	while (READ_ONCE(*__ptr) == __val)			\
+		cpu_relax();					\
+} while (0)
+#endif
+
+/**
  * smp_cond_load_acquire() - (Spin) wait for cond with ACQUIRE ordering
  * @ptr: pointer to the variable to wait on
  * @cond: boolean expression to wait for
@@ -327,7 +344,7 @@ static __always_inline void __write_once
 		VAL = READ_ONCE(*__PTR);			\
 		if (cond_expr)					\
 			break;					\
-		cpu_relax();					\
+		cmpwait(__PTR, VAL);				\
 	}							\
 	smp_rmb(); /* ctrl + rmb := acquire */			\
 	VAL;							\
