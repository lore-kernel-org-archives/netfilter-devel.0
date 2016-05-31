From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v3 8/8] locking, tile: Provide TILE specific smp_acquire__after_ctrl_dep
Date: Tue, 31 May 2016 11:41:42 +0200
Message-ID: <20160531094844.342792251@infradead.org>
References: <20160531094134.606249808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: boqun.feng@gmail.com, Waiman.Long@hpe.com, tj@kernel.org,
	pablo@netfilter.org, kaber@trash.net, davem@davemloft.net,
	oleg@redhat.com, netfilter-devel@vger.kernel.org,
	sasha.levin@oracle.com, hofrat@osadl.org, peterz@infradead.org,
	Chris Metcalf <cmetcalf@mellanox.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	manfred@colorfullife.com, dave@stgolabs.net,
	paulmck@linux.vnet.ibm.com, will.deacon@arm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=peterz-tile-ctrl-dep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since TILE doesn't do read speculation, its control dependencies also
guarantee LOAD->LOAD order and we don't need the additional RMB
otherwise required to provide ACQUIRE semantics.

Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/tile/include/asm/barrier.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -87,6 +87,13 @@ mb_incoherent(void)
 #define __smp_mb__after_atomic()	__smp_mb()
 #endif
 
+/*
+ * The TILE architecture does not do speculative reads; this ensures
+ * that a control dependency also orders against loads and already provides
+ * a LOAD->{LOAD,STORE} order and can forgo the additional RMB.
+ */
+#define smp_acquire__after_ctrl_dep()	barrier()
+
 #include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */
