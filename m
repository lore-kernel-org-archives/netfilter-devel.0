Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52323189BA1
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 08:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724141215; cv=none; b=FC0jol7mXXtENbAG6tmcubsiPiRZA64Xbnvyp1lOS9/FrpsNDPhZ630nhIY2pTIYxY2NkEW9E4DZA0CCgJ0YzozrpNZ9+5OcdJziDSPQv5j7K/0S54SJqyIjmOpBEP8VRBPtihB+0b1UPGDTAc7ZVVNNQYxGJgwEx21/Q+bB2ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724141215; c=relaxed/simple;
	bh=JfZCHVUZbw1maMAZ8pFkGswzEaAYCqQnXct/s5hyLus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dH21vJ8MY5sMTTei6ZXl4JhRpbJ9XLQXQuG1UUwgtLnLkgnZNKE09Bm8j1DDMALsoS+78Ob9HXIiVf1qX1yskRjFggZ4VGXyVK92V0WBs6ggeqh/VUt+UoB7VQYg1kaV8IAsQH63qJdmU4HjqYGl0lyydivkXL3lWbXopPx+1v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=t9cFruYQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=X2z/Y7l3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="t9cFruYQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="X2z/Y7l3"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PbMWvQSLcSLHXIRxE1qdsPYLvZEzG8YggChMjFyayr0=;
	b=t9cFruYQ4EqOVUxyisUwsXzKY6rjJsYyvu61IaOrV51UZYxfRM03Qr4JVdIUfsP4DP10BQ
	3EM4GSrcdm/A4Ba1lZbz4CnnS4wiCxjNFXhnjQRMwrOZdVlpv3fg7MJrsET/0VysZyNkpR
	uCxlH5RACV9H45qp+sQyOeYokvHgGPqI3AbKq9/POFQy7D/kHRTSibNpar7/d/JmKWH3ui
	HNHOKmsq7SuZBnYx5DyObwm5WEKmsHblCpOgmi3Zxyy7kIjC9cEPtjUXHb4H5Fesktlp6A
	I9mYAPXtsOqIsL1y0hU/KcEwIKOLlLRjeXVSoXnewO5iqdWOKlW2vMqCL+bMcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724141211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PbMWvQSLcSLHXIRxE1qdsPYLvZEzG8YggChMjFyayr0=;
	b=X2z/Y7l36btncNxStHaGBJr1Wx0VZHcZKzfsPpptLA50FI0Kq1x1tHRLkw17wsTzGJC9z2
	L0Xk4vp2ZdgVXJCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/3] netfilter: nft_counter: Use u64_stats_t for statistic.
Date: Tue, 20 Aug 2024 09:54:32 +0200
Message-ID: <20240820080644.2642759-4-bigeasy@linutronix.de>
In-Reply-To: <20240820080644.2642759-1-bigeasy@linutronix.de>
References: <20240820080644.2642759-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

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
---
 net/netfilter/nft_counter.c | 90 +++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index eab0dc66bee6b..cc73253294963 100644
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
=20
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
=20
-static DEFINE_PER_CPU(seqcount_t, nft_counter_seq);
+static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
=20
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *pri=
v,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
=20
 	local_bh_disable();
 	this_cpu =3D this_cpu_ptr(priv->counter);
-	myseq =3D this_cpu_ptr(&nft_counter_seq);
+	nft_sync =3D this_cpu_ptr(&nft_counter_sync);
=20
-	write_seqcount_begin(myseq);
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->bytes, pkt->skb->len);
+	u64_stats_inc(&this_cpu->packets);
+	u64_stats_update_end(nft_sync);
=20
-	this_cpu->bytes +=3D pkt->skb->len;
-	this_cpu->packets++;
-
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
=20
@@ -66,17 +70,16 @@ static int nft_counter_do_init(const struct nlattr * co=
nst tb[],
 	if (cpu_stats =3D=3D NULL)
 		return -ENOMEM;
=20
-	preempt_disable();
-	this_cpu =3D this_cpu_ptr(cpu_stats);
+	this_cpu =3D raw_cpu_ptr(cpu_stats);
 	if (tb[NFTA_COUNTER_PACKETS]) {
-	        this_cpu->packets =3D
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+		u64_stats_set(&this_cpu->packets,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS])));
 	}
 	if (tb[NFTA_COUNTER_BYTES]) {
-		this_cpu->bytes =3D
-			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+		u64_stats_set(&this_cpu->bytes,
+			      be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES])));
 	}
-	preempt_enable();
+
 	priv->counter =3D cpu_stats;
 	return 0;
 }
@@ -104,40 +107,41 @@ static void nft_counter_obj_destroy(const struct nft_=
ctx *ctx,
 }
=20
 static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
=20
 	local_bh_disable();
 	this_cpu =3D this_cpu_ptr(priv->counter);
-	myseq =3D this_cpu_ptr(&nft_counter_seq);
+	nft_sync =3D this_cpu_ptr(&nft_counter_sync);
+
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, -total->packets);
+	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_update_end(nft_sync);
=20
-	write_seqcount_begin(myseq);
-	this_cpu->packets -=3D total->packets;
-	this_cpu->bytes -=3D total->bytes;
-	write_seqcount_end(myseq);
 	local_bh_enable();
 }
=20
 static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
-			      struct nft_counter *total)
+			      struct nft_counter_tot *total)
 {
 	struct nft_counter *this_cpu;
-	const seqcount_t *myseq;
 	u64 bytes, packets;
 	unsigned int seq;
 	int cpu;
=20
 	memset(total, 0, sizeof(*total));
 	for_each_possible_cpu(cpu) {
-		myseq =3D per_cpu_ptr(&nft_counter_seq, cpu);
+		struct u64_stats_sync *nft_sync =3D per_cpu_ptr(&nft_counter_sync, cpu);
+
 		this_cpu =3D per_cpu_ptr(priv->counter, cpu);
 		do {
-			seq	=3D read_seqcount_begin(myseq);
-			bytes	=3D this_cpu->bytes;
-			packets	=3D this_cpu->packets;
-		} while (read_seqcount_retry(myseq, seq));
+			seq	=3D u64_stats_fetch_begin(nft_sync);
+			bytes	=3D u64_stats_read(&this_cpu->bytes);
+			packets	=3D u64_stats_read(&this_cpu->packets);
+		} while (u64_stats_fetch_retry(nft_sync, seq));
=20
 		total->bytes	+=3D bytes;
 		total->packets	+=3D packets;
@@ -148,7 +152,7 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 			       struct nft_counter_percpu_priv *priv,
 			       bool reset)
 {
-	struct nft_counter total;
+	struct nft_counter_tot total;
=20
 	nft_counter_fetch(priv, &total);
=20
@@ -237,7 +241,7 @@ static int nft_counter_clone(struct nft_expr *dst, cons=
t struct nft_expr *src, g
 	struct nft_counter_percpu_priv *priv_clone =3D nft_expr_priv(dst);
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
-	struct nft_counter total;
+	struct nft_counter_tot total;
=20
 	nft_counter_fetch(priv, &total);
=20
@@ -245,11 +249,9 @@ static int nft_counter_clone(struct nft_expr *dst, con=
st struct nft_expr *src, g
 	if (cpu_stats =3D=3D NULL)
 		return -ENOMEM;
=20
-	preempt_disable();
-	this_cpu =3D this_cpu_ptr(cpu_stats);
-	this_cpu->packets =3D total.packets;
-	this_cpu->bytes =3D total.bytes;
-	preempt_enable();
+	this_cpu =3D raw_cpu_ptr(cpu_stats);
+	u64_stats_set(&this_cpu->packets, total.packets);
+	u64_stats_set(&this_cpu->bytes, total.bytes);
=20
 	priv_clone->counter =3D cpu_stats;
 	return 0;
@@ -267,17 +269,17 @@ static void nft_counter_offload_stats(struct nft_expr=
 *expr,
 				      const struct flow_stats *stats)
 {
 	struct nft_counter_percpu_priv *priv =3D nft_expr_priv(expr);
+	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
-	seqcount_t *myseq;
=20
 	local_bh_disable();
 	this_cpu =3D this_cpu_ptr(priv->counter);
-	myseq =3D this_cpu_ptr(&nft_counter_seq);
+	nft_sync =3D this_cpu_ptr(&nft_counter_sync);
=20
-	write_seqcount_begin(myseq);
-	this_cpu->packets +=3D stats->pkts;
-	this_cpu->bytes +=3D stats->bytes;
-	write_seqcount_end(myseq);
+	u64_stats_update_begin(nft_sync);
+	u64_stats_add(&this_cpu->packets, stats->pkts);
+	u64_stats_add(&this_cpu->bytes, stats->bytes);
+	u64_stats_update_end(nft_sync);
 	local_bh_enable();
 }
=20
@@ -286,7 +288,7 @@ void nft_counter_init_seqcount(void)
 	int cpu;
=20
 	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&nft_counter_seq, cpu));
+		u64_stats_init(per_cpu_ptr(&nft_counter_sync, cpu));
 }
=20
 struct nft_expr_type nft_counter_type;
--=20
2.45.2

