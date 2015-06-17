From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: xtables: fix warnings on 32bit platforms
Date: Wed, 17 Jun 2015 23:58:28 +0200
Message-ID: <1434578308-31818-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39367 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297AbbFQV6l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 17:58:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 32bit archs gcc complains due to cast from void* to u64.
Add intermediate casts to long to silence these warnings.

include/linux/netfilter/x_tables.h:376:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
include/linux/netfilter/x_tables.h:384:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
include/linux/netfilter/x_tables.h:391:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
include/linux/netfilter/x_tables.h:400:22: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Fixes: 71ae0dff02d756e ("netfilter: xtables: use percpu rule counters")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 checkpatch doesn't like this due to >80 line limit, but I found line wraps
 worse than this.

 Does anyone have better idea on how to avoid gcc warnings here?

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 95693c4..a64200e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -370,7 +370,7 @@ static inline u64 xt_percpu_counter_alloc(void)
 		if (res == NULL)
 			return (u64) -ENOMEM;
 
-		return (__force u64) res;
+		return (u64) (__force unsigned long) res;
 	}
 
 	return 0;
@@ -378,14 +378,14 @@ static inline u64 xt_percpu_counter_alloc(void)
 static inline void xt_percpu_counter_free(u64 pcnt)
 {
 	if (nr_cpu_ids > 1)
-		free_percpu((void __percpu *) pcnt);
+		free_percpu((void __percpu *) (unsigned long) pcnt);
 }
 
 static inline struct xt_counters *
 xt_get_this_cpu_counter(struct xt_counters *cnt)
 {
 	if (nr_cpu_ids > 1)
-		return this_cpu_ptr((void __percpu *) cnt->pcnt);
+		return this_cpu_ptr((void __percpu *) (unsigned long) cnt->pcnt);
 
 	return cnt;
 }
@@ -394,7 +394,7 @@ static inline struct xt_counters *
 xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 {
 	if (nr_cpu_ids > 1)
-		return per_cpu_ptr((void __percpu *) cnt->pcnt, cpu);
+		return per_cpu_ptr((void __percpu *) (unsigned long) cnt->pcnt, cpu);
 
 	return cnt;
 }
-- 
2.0.5

