From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nft_counter: move counter reset into separated function
Date: Tue,  6 Dec 2016 14:45:47 +0100
Message-ID: <1481031947-8805-2-git-send-email-pablo@netfilter.org>
References: <1481031947-8805-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752142AbcLFNqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 08:46:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D74596ECA
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2040A7E92
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8356A7E95
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:52 +0100 (CET)
In-Reply-To: <1481031947-8805-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the reset path from nft_counter_fetch() to
nft_counter_reset(), this patch aims to solve gcc compilation warning:

   net/netfilter/nft_counter.c: In function 'nft_counter_fetch':
>> net/netfilter/nft_counter.c:128:18: warning: 'packets' may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
      total->packets += packets;
                     ^~
>> net/netfilter/nft_counter.c:129:16: warning: 'bytes' may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
      total->bytes += bytes;
                   ^~

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_counter.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 90e42140ee7b..3d2ff23be8d6 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -101,7 +101,7 @@ static void nft_counter_obj_destroy(struct nft_object *obj)
 }
 
 static void nft_counter_fetch(struct nft_counter_percpu __percpu *counter,
-			      struct nft_counter *total, bool reset)
+			      struct nft_counter *total)
 {
 	struct nft_counter_percpu *cpu_stats;
 	u64 bytes, packets;
@@ -110,19 +110,35 @@ static void nft_counter_fetch(struct nft_counter_percpu __percpu *counter,
 
 	memset(total, 0, sizeof(*total));
 	for_each_possible_cpu(cpu) {
-		if (reset)
-			bytes = packets = 0;
+		cpu_stats = per_cpu_ptr(counter, cpu);
+		do {
+			seq	= u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			bytes	= cpu_stats->counter.bytes;
+			packets	= cpu_stats->counter.packets;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
+
+		total->packets += packets;
+		total->bytes += bytes;
+	}
+}
+
+static void nft_counter_reset(struct nft_counter_percpu __percpu *counter,
+			      struct nft_counter *total)
+{
+	struct nft_counter_percpu *cpu_stats;
+	u64 bytes, packets;
+	unsigned int seq;
+	int cpu;
+
+	memset(total, 0, sizeof(*total));
+	for_each_possible_cpu(cpu) {
+		bytes = packets = 0;
 
 		cpu_stats = per_cpu_ptr(counter, cpu);
 		do {
 			seq	= u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			if (reset) {
-				packets += xchg(&cpu_stats->counter.packets, 0);
-				bytes	+= xchg(&cpu_stats->counter.bytes, 0);
-			} else {
-				bytes	= cpu_stats->counter.bytes;
-				packets	= cpu_stats->counter.packets;
-			}
+			packets += xchg(&cpu_stats->counter.packets, 0);
+			bytes	+= xchg(&cpu_stats->counter.bytes, 0);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
 
 		total->packets += packets;
@@ -136,7 +152,10 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 {
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total, reset);
+	if (reset)
+		nft_counter_reset(priv->counter, &total);
+	else
+		nft_counter_fetch(priv->counter, &total);
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
 			 NFTA_COUNTER_PAD) ||
@@ -215,7 +234,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src)
 	struct nft_counter_percpu *this_cpu;
 	struct nft_counter total;
 
-	nft_counter_fetch(priv->counter, &total, false);
+	nft_counter_fetch(priv->counter, &total);
 
 	cpu_stats = __netdev_alloc_pcpu_stats(struct nft_counter_percpu,
 					      GFP_ATOMIC);
-- 
2.1.4

