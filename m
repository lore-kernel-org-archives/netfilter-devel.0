From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nft_counter: use cmpxchg64 instead of xchg
Date: Wed,  7 Dec 2016 01:04:01 +0100
Message-ID: <1481069041-11633-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbcLGAMo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 19:12:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 596D8E5A42
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B879DA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 01:04:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 244F5DA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 01:04:06 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xchg cannot be used on 32bit, use cmpxchg64 to reset counters.

  call to '__xchg_wrong_size' declared with attribute error: Bad argument size for xchg

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I'm going to fold this in the local rebase that I have prepared.

 net/netfilter/nft_counter.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 3d2ff23be8d6..f6a02c5071c2 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -122,6 +122,18 @@ static void nft_counter_fetch(struct nft_counter_percpu __percpu *counter,
 	}
 }
 
+static u64 __nft_counter_reset(u64 *counter)
+{
+	u64 ret, old;
+
+	do {
+		old = *counter;
+		ret = cmpxchg64(counter, old, 0);
+	} while (ret != old);
+
+	return ret;
+}
+
 static void nft_counter_reset(struct nft_counter_percpu __percpu *counter,
 			      struct nft_counter *total)
 {
@@ -137,8 +149,8 @@ static void nft_counter_reset(struct nft_counter_percpu __percpu *counter,
 		cpu_stats = per_cpu_ptr(counter, cpu);
 		do {
 			seq	= u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			packets += xchg(&cpu_stats->counter.packets, 0);
-			bytes	+= xchg(&cpu_stats->counter.bytes, 0);
+			packets	+= __nft_counter_reset(&cpu_stats->counter.packets);
+			bytes	+= __nft_counter_reset(&cpu_stats->counter.bytes);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
 
 		total->packets += packets;
-- 
2.1.4

