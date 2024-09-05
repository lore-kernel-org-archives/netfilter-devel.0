Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1A218CBF6;
	Thu,  5 Sep 2024 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578978; cv=none; b=Lq0WeQghgKmbiAls3Gcx12F5eBWrZqXZVgeVmAu37s42IMcdYNquO+f1smBvz5EgiUJtuBf7oD2NkyRP16xGWW+TI4I8fgQ3T1ko4wLv2UceAs1s1kLUmA2ysHuAJwcDqZQR7+NDQbFmDgvQ2IZokpeOQkO8AbzqasAzSKtFs00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578978; c=relaxed/simple;
	bh=qK0wZaU/rKMTrMvVWC8+quQEkeyyiArCGlsaFSgZ7g8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B3Tz3GOkKDpdGpF55GzZMOD1rE89Ng8oAfhT7h6gUl0AxbvZ4wz7csrb1swwC/VbBwbyuTI3XRnhlJijuE2W70pBsyVHF4XqefYg1fO3Nf8pobn+sukaMrAPa8tQ+sXJv5E3B+UxA5sWR31Lq+N8qYAcelvjjHTNqsoyePwZ4EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 02/16] netfilter: nft_counter: Use u64_stats_t for statistic.
Date: Fri,  6 Sep 2024 01:29:06 +0200
Message-Id: <20240905232920.5481-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The nft_counter uses two s64 counters for statistics. Those two are
protected by a seqcount to ensure that the 64bit variable is always
properly seen during updates even on 32bit architectures where the store
is performed by two writes. A side effect is that the two counter (bytes
and packet) are written and read together in the same window.

This can be replaced with u64_stats_t. write_seqcount_begin()/ end() is
replaced with u64_stats_update_begin()/ end() and behaves the same way
as with seqcount_t on 32bit architectures. Additionally there is a
preempt_disable on PREEMPT_RT to ensure that a reader does not preempt a
writer.
On 64bit architectures the macros are removed and the reads happen
without any retries. This also means that the reader can observe one
counter (bytes) from before the update and the other counter (packets)
but that is okay since there is no requirement to have both counter from
the same update window.

Convert the statistic to u64_stats_t. There is one optimisation:
nft_counter_do_init() and nft_counter_clone() allocate a new per-CPU
counter and assign a value to it. During this assignment preemption is
disabled which is not needed because the counter is not yet exposed to
the system so there can not be another writer or reader. Therefore
disabling preemption is omitted and raw_cpu_ptr() is used to obtain a
pointer to a counter for the assignment.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_counter.c | 90 +++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index eab0dc66bee6..cc7325329496 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -8,7 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/seqlock.h>
+#include <linux/u64_stats_sync.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -17,6 +17,11 @@
 #include <net/netfilter/nf_tables_offload.h>
 
 struct nft_counter {
+	u64_stats_t	bytes;
+	u64_stats_t	packets;
+};
+
+struct nft_counter_tot {
 	s64		bytes;
 	s64		packets;
 };
@@ -25,25 +30,24 @@ struct nft_counter_percpu_priv {
 	struct nft_counter __percpu *counter;
 };
 
-static DEFINE_PER_CPU(seqcount_t, nft_counter_seq);
+static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
 
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
-
-	write_seqcount_begin(myseq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
-	this_cpu->bytes += pkt->skb->len;
-	this_cpu->packets++;
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->bytes, pkt->skb->len);
+	u64_stats_inc(&this_cpu->packets);
+	u64_stats_update_end(nft_sync);
 
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
 
@@ -66,17 +70,16 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
-	preempt_disable();
-	this_cpu = this_cpu_ptr(cpu_stats);
+	this_cpu = raw_cpu_ptr(cpu_stats);
 	if (tb[NFTA_COUNTER_PACKETS]) {
-	        this_cpu->packets =
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+		u64_stats_set(&this_cpu->packets,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS])));
 	}
 	if (tb[NFTA_COUNTER_BYTES]) {
-		this_cpu->bytes =
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+		u64_stats_set(&this_cpu->bytes,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES])));
 	}
-	preempt_enable();
+
 	priv->counter = cpu_stats;
 	return 0;
 }
@@ -104,40 +107,41 @@ static void nft_counter_obj_destroy(const struct nft_ctx *ctx,
 }
 
 static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
+
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, -total->packets);
+	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_update_end(nft_sync);
 
-	write_seqcount_begin(myseq);
-	this_cpu->packets -= total->packets;
-	this_cpu->bytes -= total->bytes;
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
 
 static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
 	struct nft_counter *this_cpu;
-	const seqcount_t *myseq;
 	u64 bytes, packets;
 	unsigned int seq;
 	int cpu;
 
 	memset(total, 0, sizeof(*total));
 	for_each_possible_cpu(cpu) {
-		myseq = per_cpu_ptr(&nft_counter_seq, cpu);
+		struct u64_stats_sync *nft_sync = per_cpu_ptr(&nft_counter_sync, cpu);
+
 		this_cpu = per_cpu_ptr(priv->counter, cpu);
 		do {
-			seq	= read_seqcount_begin(myseq);
-			bytes	= this_cpu->bytes;
-			packets	= this_cpu->packets;
-		} while (read_seqcount_retry(myseq, seq));
+			seq	= u64_stats_fetch_begin(nft_sync);
+			bytes	= u64_stats_read(&this_cpu->bytes);
+			packets	= u64_stats_read(&this_cpu->packets);
+		} while (u64_stats_fetch_retry(nft_sync, seq));
 
 		total->bytes	+= bytes;
 		total->packets	+= packets;
@@ -148,7 +152,7 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 			       struct nft_counter_percpu_priv *priv,
 			       bool reset)
 {
-	struct nft_counter total;
+	struct nft_counter_tot total;
 
 	nft_counter_fetch(priv, &total);
 
@@ -237,7 +241,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, g
 	struct nft_counter_percpu_priv *priv_clone = nft_expr_priv(dst);
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
-	struct nft_counter total;
+	struct nft_counter_tot total;
 
 	nft_counter_fetch(priv, &total);
 
@@ -245,11 +249,9 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, g
 	if (cpu_stats == NULL)
 		return -ENOMEM;
 
-	preempt_disable();
-	this_cpu = this_cpu_ptr(cpu_stats);
-	this_cpu->packets = total.packets;
-	this_cpu->bytes = total.bytes;
-	preempt_enable();
+	this_cpu = raw_cpu_ptr(cpu_stats);
+	u64_stats_set(&this_cpu->packets, total.packets);
+	u64_stats_set(&this_cpu->bytes, total.bytes);
 
 	priv_clone->counter = cpu_stats;
 	return 0;
@@ -267,17 +269,17 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 				      const struct flow_stats *stats)
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
 
 	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
-	myseq = this_cpu_ptr(&nft_counter_seq);
+	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
-	write_seqcount_begin(myseq);
-	this_cpu->packets += stats->pkts;
-	this_cpu->bytes += stats->bytes;
-	write_seqcount_end(myseq);
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, stats->pkts);
+	u64_stats_add(&this_cpu->bytes, stats->bytes);
+	u64_stats_update_end(nft_sync);
 	local_bh_enable();
 }
 
@@ -286,7 +288,7 @@ void nft_counter_init_seqcount(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&nft_counter_seq, cpu));
+		u64_stats_init(per_cpu_ptr(&nft_counter_sync, cpu));
 }
 
 struct nft_expr_type nft_counter_type;
-- 
2.30.2

