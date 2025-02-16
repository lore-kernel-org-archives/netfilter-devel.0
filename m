Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FC019882F
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739710768; cv=none; b=r2kLGczVp62/VPl+EVaxakvWeWv7yQwmTBkEpc4mpFZxnaBMBU3Ncm9+/ZEXlrdIyHmpPF54xpqHSVO0rz1hEo7o7ecoXS513/XRI4YNPg1Qhdog2sTwom+EMDsyMythw4WbY4pXfD3HRZp4BARgTttCdWwQg34pAjFBcQm2VP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739710768; c=relaxed/simple;
	bh=TMeLXLJlh4vvtEC9LNPsNHhQKj3Bp/vnjuUiixTFlHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKsi7UGGtVbJLnf0fOJ93c1CgnpX+5pY3Cq8iVI4qPOlEHBp+IDGwIdUmW8xUt0EocFPisG4ctBdUwekyMuaxnyBB8InQPe8PFsLvtWoJ4CZ0IdXKQuasHWXZGSyWIrzCMxoZBbwft0X66HBYcCsHF+s9SkETwGS6fHeJ/RHyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=b/ispCtI; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oGn9EdKC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="b/ispCtI";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oGn9EdKC"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739710302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v62gTOtx2PkxCwkrjm8bcqz8Ue1OuFMlemTgpqnHfGE=;
	b=b/ispCtIeqXtBtAmYRamziPjI9sScK1ONJJbw7VQJKkgP6ZPZZVsYvPEQlNllbRrDhaDzO
	2YO+OmOOWqK5XmuO7uq3HFwxk2abWw/SAJewJMEC4RP+nLduPm1ahuqDypmBXKKF2mHcAR
	M00JbydpsG+QkFqg72ZA5ToYmupDAyHv+ciZvYk4bolSfEnBixpVoGs+z3ciUKHDTS5mx0
	9K+kWxUGa7VqAB3Ao/jteDNDn/bXZsVnCp6yzxAPSgXjpR3Zdk07hIv33CDYkxII1/YrwY
	QucZX5sTmPzylV3ol6S741WbVYU+xEgCt2Joq0kjI79Gw1l2vmfONGcoB1A0eA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739710302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v62gTOtx2PkxCwkrjm8bcqz8Ue1OuFMlemTgpqnHfGE=;
	b=oGn9EdKCLV5CP2IGW7Dh4SWop3Mb59YFaM/mlZx5r3KqvH6LwL/nxRDPaj6BctMuLezcwC
	2RYXQV1U9fby/ODA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/3] netfilter: Split the xt_counters type between kernel and user.
Date: Sun, 16 Feb 2025 13:51:34 +0100
Message-ID: <20250216125135.3037967-3-bigeasy@linutronix.de>
In-Reply-To: <20250216125135.3037967-1-bigeasy@linutronix.de>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The struct xt_counter contains two u64 values as counters for bytes and
packets. This type is exposed to userland via uapi. The kernel uses the
type as such when it communicates with userland.
However the type within an entry (such as ipt_entry) is treated
differently: Within the kernel it is a two value struct if the system
has only one CPU.
With more CPUs, the first value is per-CPU pointer which points to
per-CPU memory which holds the two u64 counter. How the struct is
interpreted depends on the user.

Introduce a struct xt_counter_pad which is simply used as a place
holder, ensuring it is the same size as struct xt_counters. The kernel
function will use this type if the type might be a per-CPU pointer.
Add this padding struct to arpt_entry, ipt_entry and ip6t_entry.
Pass this type to xt_get_this_cpu_counter(), xt_percpu_counter_free()
and xt_percpu_counter_alloc(). These functions will cast it to union
xt_counter_k() and return the proper pointer to struct xt_counters_k.

This is mostly the same as previously but a bit more obvious and
introduces the struct xt_counters_k for in-kernel usage. This can be
replaces later without breaking userland.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/netfilter/x_tables.h            | 40 +++++++++++++------
 include/uapi/linux/netfilter/x_tables.h       |  4 ++
 include/uapi/linux/netfilter_arp/arp_tables.h |  5 ++-
 include/uapi/linux/netfilter_ipv4/ip_tables.h |  5 ++-
 .../uapi/linux/netfilter_ipv6/ip6_tables.h    |  5 ++-
 net/ipv4/netfilter/arp_tables.c               | 22 +++++-----
 net/ipv4/netfilter/ip_tables.c                | 22 +++++-----
 net/ipv6/netfilter/ip6_tables.c               | 22 +++++-----
 net/netfilter/x_tables.c                      | 21 ++++++----
 9 files changed, 89 insertions(+), 57 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index b9cd82e845d08..fc52a2ba90f6b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -267,6 +267,17 @@ struct xt_table_info {
 	unsigned char entries[] __aligned(8);
 };
=20
+struct xt_counters_k {
+	/* Packet and byte counter */
+	__u64 pcnt;
+	__u64 bcnt;
+};
+
+union xt_counter_k {
+	struct xt_counters_k __percpu *pcpu;
+	struct xt_counters_k local;
+};
+
 int xt_register_target(struct xt_target *target);
 void xt_unregister_target(struct xt_target *target);
 int xt_register_targets(struct xt_target *target, unsigned int n);
@@ -428,29 +439,32 @@ static inline unsigned long ifname_compare_aligned(co=
nst char *_a,
=20
 struct xt_percpu_counter_alloc_state {
 	unsigned int off;
-	const char __percpu *mem;
+	void __percpu *mem;
 };
=20
 bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
-			     struct xt_counters *counter);
-void xt_percpu_counter_free(struct xt_counters *cnt);
+			     struct xt_counter_pad *xt_pad);
+void xt_percpu_counter_free(struct xt_counter_pad *xt_pad);
=20
-static inline struct xt_counters *
-xt_get_this_cpu_counter(struct xt_counters *cnt)
+static inline struct xt_counters_k *xt_get_this_cpu_counter(struct xt_coun=
ter_pad *xt_pad)
 {
-	if (nr_cpu_ids > 1)
-		return this_cpu_ptr((void __percpu *) (unsigned long) cnt->pcnt);
+	union xt_counter_k *xt_cnt =3D (union xt_counter_k *)xt_pad;
=20
-	return cnt;
+	if (nr_cpu_ids > 1)
+		return this_cpu_ptr(xt_cnt->pcpu);
+
+	return &xt_cnt->local;
 }
=20
-static inline struct xt_counters *
-xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
+static inline struct xt_counters_k *xt_get_per_cpu_counter(struct xt_count=
er_pad *xt_pad,
+							   unsigned int cpu)
 {
-	if (nr_cpu_ids > 1)
-		return per_cpu_ptr((void __percpu *) (unsigned long) cnt->pcnt, cpu);
+	union xt_counter_k *xt_cnt =3D (union xt_counter_k *)xt_pad;
=20
-	return cnt;
+	if (nr_cpu_ids > 1)
+		return per_cpu_ptr(xt_cnt->pcpu, cpu);
+
+	return &xt_cnt->local;
 }
=20
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *=
);
diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/n=
etfilter/x_tables.h
index 796af83a963aa..70e19a140ab1e 100644
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -111,6 +111,10 @@ struct xt_counters {
 	__u64 pcnt, bcnt;			/* Packet and byte counters */
 };
=20
+struct xt_counter_pad {
+	__u8 pad[16];
+};
+
 /* The argument to IPT_SO_ADD_COUNTERS. */
 struct xt_counters_info {
 	/* Which table. */
diff --git a/include/uapi/linux/netfilter_arp/arp_tables.h b/include/uapi/l=
inux/netfilter_arp/arp_tables.h
index a6ac2463f787a..4ca949a955412 100644
--- a/include/uapi/linux/netfilter_arp/arp_tables.h
+++ b/include/uapi/linux/netfilter_arp/arp_tables.h
@@ -106,7 +106,10 @@ struct arpt_entry
 	unsigned int comefrom;
=20
 	/* Packet and byte counters. */
-	struct xt_counters counters;
+	union {
+		struct xt_counters counters;
+		struct xt_counter_pad counter_pad;
+	};
=20
 	/* The matches (if any), then the target. */
 	unsigned char elems[];
diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/l=
inux/netfilter_ipv4/ip_tables.h
index 1485df28b2391..a4874078ec058 100644
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -118,7 +118,10 @@ struct ipt_entry {
 	unsigned int comefrom;
=20
 	/* Packet and byte counters. */
-	struct xt_counters counters;
+	union {
+		struct xt_counters counters;
+		struct xt_counter_pad counter_pad;
+	};
=20
 	/* The matches (if any), then the target. */
 	unsigned char elems[];
diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/uapi/=
linux/netfilter_ipv6/ip6_tables.h
index 766e8e0bcc683..8634257e1cd59 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
@@ -122,7 +122,10 @@ struct ip6t_entry {
 	unsigned int comefrom;
=20
 	/* Packet and byte counters. */
-	struct xt_counters counters;
+	union {
+		struct xt_counters counters;
+		struct xt_counter_pad counter_pad;
+	};
=20
 	/* The matches (if any), then the target. */
 	unsigned char elems[0];
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 0628e68910f7f..ce3d73155ca9b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -221,14 +221,14 @@ unsigned int arpt_do_table(void *priv,
 	arp =3D arp_hdr(skb);
 	do {
 		const struct xt_entry_target *t;
-		struct xt_counters *counter;
+		struct xt_counters_k *counter;
=20
 		if (!arp_packet_match(arp, skb->dev, indev, outdev, &e->arp)) {
 			e =3D arpt_next_entry(e);
 			continue;
 		}
=20
-		counter =3D xt_get_this_cpu_counter(&e->counters);
+		counter =3D xt_get_this_cpu_counter(&e->counter_pad);
 		ADD_COUNTER(*counter, arp_hdr_len(skb->dev), 1);
=20
 		t =3D arpt_get_target_c(e);
@@ -412,7 +412,7 @@ find_check_entry(struct arpt_entry *e, struct net *net,=
 const char *name,
 	struct xt_target *target;
 	int ret;
=20
-	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counter_pad))
 		return -ENOMEM;
=20
 	t =3D arpt_get_target(e);
@@ -431,7 +431,7 @@ find_check_entry(struct arpt_entry *e, struct net *net,=
 const char *name,
 err:
 	module_put(t->u.kernel.target->me);
 out:
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
=20
 	return ret;
 }
@@ -512,7 +512,7 @@ static void cleanup_entry(struct arpt_entry *e, struct =
net *net)
 	if (par.target->destroy !=3D NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
 }
=20
 /* Checks and translates the user-supplied table segment (held in
@@ -611,11 +611,11 @@ static void get_counters(const struct xt_table_info *=
t,
=20
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			struct xt_counters *tmp;
+			struct xt_counters_k *tmp;
 			u64 bcnt, pcnt;
 			unsigned int start;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			do {
 				start =3D read_seqcount_begin(s);
 				bcnt =3D tmp->bcnt;
@@ -638,9 +638,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
 	for_each_possible_cpu(cpu) {
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			struct xt_counters *tmp;
+			struct xt_counters_k *tmp;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
 			++i;
 		}
@@ -1035,9 +1035,9 @@ static int do_add_counters(struct net *net, sockptr_t=
 arg, unsigned int len)
=20
 	addend =3D xt_write_recseq_begin();
 	xt_entry_foreach(iter,  private->entries, private->size) {
-		struct xt_counters *tmp;
+		struct xt_counters_k *tmp;
=20
-		tmp =3D xt_get_this_cpu_counter(&iter->counters);
+		tmp =3D xt_get_this_cpu_counter(&iter->counter_pad);
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 20e8b46af8876..95f917f5bceef 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -278,7 +278,7 @@ ipt_do_table(void *priv,
 	do {
 		const struct xt_entry_target *t;
 		const struct xt_entry_match *ematch;
-		struct xt_counters *counter;
+		struct xt_counters_k *counter;
=20
 		WARN_ON(!e);
 		if (!ip_packet_match(ip, indev, outdev,
@@ -295,7 +295,7 @@ ipt_do_table(void *priv,
 				goto no_match;
 		}
=20
-		counter =3D xt_get_this_cpu_counter(&e->counters);
+		counter =3D xt_get_this_cpu_counter(&e->counter_pad);
 		ADD_COUNTER(*counter, skb->len, 1);
=20
 		t =3D ipt_get_target_c(e);
@@ -525,7 +525,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, =
const char *name,
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
=20
-	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counter_pad))
 		return -ENOMEM;
=20
 	j =3D 0;
@@ -565,7 +565,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, =
const char *name,
 		cleanup_match(ematch, net);
 	}
=20
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
=20
 	return ret;
 }
@@ -653,7 +653,7 @@ cleanup_entry(struct ipt_entry *e, struct net *net)
 	if (par.target->destroy !=3D NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
 }
=20
 /* Checks and translates the user-supplied table segment (held in
@@ -750,11 +750,11 @@ get_counters(const struct xt_table_info *t,
=20
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			struct xt_counters *tmp;
+			struct xt_counters_k *tmp;
 			u64 bcnt, pcnt;
 			unsigned int start;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			do {
 				start =3D read_seqcount_begin(s);
 				bcnt =3D tmp->bcnt;
@@ -777,9 +777,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
 	for_each_possible_cpu(cpu) {
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			const struct xt_counters *tmp;
+			const struct xt_counters_k *tmp;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
 			++i; /* macro does multi eval of i */
 		}
@@ -1187,9 +1187,9 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	i =3D 0;
 	addend =3D xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
-		struct xt_counters *tmp;
+		struct xt_counters_k *tmp;
=20
-		tmp =3D xt_get_this_cpu_counter(&iter->counters);
+		tmp =3D xt_get_this_cpu_counter(&iter->counter_pad);
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index c12d489a09840..f4877b1b2463e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -300,7 +300,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	do {
 		const struct xt_entry_target *t;
 		const struct xt_entry_match *ematch;
-		struct xt_counters *counter;
+		struct xt_counters_k *counter;
=20
 		WARN_ON(!e);
 		acpar.thoff =3D 0;
@@ -318,7 +318,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 				goto no_match;
 		}
=20
-		counter =3D xt_get_this_cpu_counter(&e->counters);
+		counter =3D xt_get_this_cpu_counter(&e->counter_pad);
 		ADD_COUNTER(*counter, skb->len, 1);
=20
 		t =3D ip6t_get_target_c(e);
@@ -544,7 +544,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net,=
 const char *name,
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
=20
-	if (!xt_percpu_counter_alloc(alloc_state, &e->counters))
+	if (!xt_percpu_counter_alloc(alloc_state, &e->counter_pad))
 		return -ENOMEM;
=20
 	j =3D 0;
@@ -583,7 +583,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net,=
 const char *name,
 		cleanup_match(ematch, net);
 	}
=20
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
=20
 	return ret;
 }
@@ -670,7 +670,7 @@ static void cleanup_entry(struct ip6t_entry *e, struct =
net *net)
 	if (par.target->destroy !=3D NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(&e->counters);
+	xt_percpu_counter_free(&e->counter_pad);
 }
=20
 /* Checks and translates the user-supplied table segment (held in
@@ -767,11 +767,11 @@ get_counters(const struct xt_table_info *t,
=20
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			struct xt_counters *tmp;
+			struct xt_counters_k *tmp;
 			u64 bcnt, pcnt;
 			unsigned int start;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			do {
 				start =3D read_seqcount_begin(s);
 				bcnt =3D tmp->bcnt;
@@ -794,9 +794,9 @@ static void get_old_counters(const struct xt_table_info=
 *t,
 	for_each_possible_cpu(cpu) {
 		i =3D 0;
 		xt_entry_foreach(iter, t->entries, t->size) {
-			const struct xt_counters *tmp;
+			const struct xt_counters_k *tmp;
=20
-			tmp =3D xt_get_per_cpu_counter(&iter->counters, cpu);
+			tmp =3D xt_get_per_cpu_counter(&iter->counter_pad, cpu);
 			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
 			++i;
 		}
@@ -1203,9 +1203,9 @@ do_add_counters(struct net *net, sockptr_t arg, unsig=
ned int len)
 	i =3D 0;
 	addend =3D xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
-		struct xt_counters *tmp;
+		struct xt_counters_k *tmp;
=20
-		tmp =3D xt_get_this_cpu_counter(&iter->counters);
+		tmp =3D xt_get_this_cpu_counter(&iter->counter_pad);
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ee38272cca562..e3f48539f81d6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1908,9 +1908,13 @@ EXPORT_SYMBOL_GPL(xt_proto_fini);
  * returns false on error.
  */
 bool xt_percpu_counter_alloc(struct xt_percpu_counter_alloc_state *state,
-			     struct xt_counters *counter)
+			     struct xt_counter_pad *xt_pad)
 {
-	BUILD_BUG_ON(XT_PCPU_BLOCK_SIZE < (sizeof(*counter) * 2));
+	union xt_counter_k *xt_cnt =3D (union xt_counter_k *)xt_pad;
+
+	BUILD_BUG_ON(XT_PCPU_BLOCK_SIZE < (sizeof(struct xt_counters_k) * 2));
+	BUILD_BUG_ON(sizeof(struct xt_counters_k) !=3D sizeof(struct xt_counters)=
);
+	BUILD_BUG_ON(sizeof(struct xt_counters_k) !=3D sizeof(struct xt_counter_p=
ad));
=20
 	if (nr_cpu_ids <=3D 1)
 		return true;
@@ -1921,9 +1925,9 @@ bool xt_percpu_counter_alloc(struct xt_percpu_counter=
_alloc_state *state,
 		if (!state->mem)
 			return false;
 	}
-	counter->pcnt =3D (__force unsigned long)(state->mem + state->off);
-	state->off +=3D sizeof(*counter);
-	if (state->off > (XT_PCPU_BLOCK_SIZE - sizeof(*counter))) {
+	xt_cnt->pcpu =3D state->mem + state->off;
+	state->off +=3D sizeof(struct xt_counters_k);
+	if (state->off > (XT_PCPU_BLOCK_SIZE - sizeof(struct xt_counters_k))) {
 		state->mem =3D NULL;
 		state->off =3D 0;
 	}
@@ -1931,12 +1935,13 @@ bool xt_percpu_counter_alloc(struct xt_percpu_count=
er_alloc_state *state,
 }
 EXPORT_SYMBOL_GPL(xt_percpu_counter_alloc);
=20
-void xt_percpu_counter_free(struct xt_counters *counters)
+void xt_percpu_counter_free(struct xt_counter_pad *xt_pad)
 {
-	unsigned long pcnt =3D counters->pcnt;
+	union xt_counter_k *xt_cnt =3D (union xt_counter_k *)xt_pad;
+	unsigned long pcnt =3D (unsigned long)xt_cnt->pcpu;
=20
 	if (nr_cpu_ids > 1 && (pcnt & (XT_PCPU_BLOCK_SIZE - 1)) =3D=3D 0)
-		free_percpu((void __percpu *)pcnt);
+		free_percpu(xt_cnt->pcpu);
 }
 EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
=20
--=20
2.47.2

