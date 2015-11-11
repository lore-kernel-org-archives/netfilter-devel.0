From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/10] net: add __netdev_alloc_pcpu_stats() to indicate gfp flags
Date: Wed, 11 Nov 2015 18:33:42 +0100
Message-ID: <1447263223-22662-10-git-send-email-pablo@netfilter.org>
References: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

nf_tables may create percpu counters from the packet path through its
dynamic set instantiation infrastructure, so we need a way to allocate
this through GFP_ATOMIC.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David S. Miller <davem@davemloft.net>
---
 include/linux/netdevice.h | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2c00772..e9d0c8a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2068,20 +2068,23 @@ struct pcpu_sw_netstats {
 	struct u64_stats_sync   syncp;
 };
 
-#define netdev_alloc_pcpu_stats(type)				\
-({								\
-	typeof(type) __percpu *pcpu_stats = alloc_percpu(type); \
-	if (pcpu_stats)	{					\
-		int __cpu;					\
-		for_each_possible_cpu(__cpu) {			\
-			typeof(type) *stat;			\
-			stat = per_cpu_ptr(pcpu_stats, __cpu);	\
-			u64_stats_init(&stat->syncp);		\
-		}						\
-	}							\
-	pcpu_stats;						\
+#define __netdev_alloc_pcpu_stats(type, gfp)				\
+({									\
+	typeof(type) __percpu *pcpu_stats = alloc_percpu_gfp(type, gfp);\
+	if (pcpu_stats)	{						\
+		int __cpu;						\
+		for_each_possible_cpu(__cpu) {				\
+			typeof(type) *stat;				\
+			stat = per_cpu_ptr(pcpu_stats, __cpu);		\
+			u64_stats_init(&stat->syncp);			\
+		}							\
+	}								\
+	pcpu_stats;							\
 })
 
+#define netdev_alloc_pcpu_stats(type)					\
+	__netdev_alloc_pcpu_stats(type, GFP_KERNEL);
+
 #include <linux/notifier.h>
 
 /* netdevice notifier chain. Please remember to update the rtnetlink
-- 
2.1.4
