Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC52157A6C;
	Mon, 23 Sep 2024 09:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727082951; cv=none; b=A8XJ2y+H2I48DnZnhijecVYNlfSPPPQMGxDoiFhEpeaPLqrfWJP/lGqKTGLO0ZM90zLYCLLpe+SANjyq6uTY7qeN22tuf8t5ai7FYOfo8NUmAuBE9SaGNlnCrWYMKlo9q/SpB/7NfGwend+A1L0VnhXHf78k3Yku9ov3D9DWdSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727082951; c=relaxed/simple;
	bh=YPHqx2hoK6eSjQbTNcPeskb7nIZQxjFuAWwO/tUA+oA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLy39Y+24y1w/D2RdUDERCvGr3UE4nuoOMygW9orK6RZ/2n3i17hDAouJwZXFXwfXhSGWbhL+TAf5FgLzkBckAGyJ3f87dpmyf0vVd3uBQvw0+SdCBjHGnLESHbrkj4fFJtX4swqcQZOXaG5oNDfLlDHpSqtlx2s6Q8fUoueQJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=M9J0blzQ; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="M9J0blzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727082943;
	bh=2Fz465nGyVXXGwXiXosjhwFDgGEtYoK5p8R5cjtgS0E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=M9J0blzQyUKro+svHhutttAaEunnP4HxXZKqROKCJd0K1LP60WR5CKKG/eH5aUiED
	 H+WvdwVl8fQcxb18q2Uq/5mDn4CCCLBKIpupB1bxnqa2T/r8mdUNtvrz6xQaF6ndXn
	 /ijCGcbSUIbqN28J7NmCuAPxhwV/s7zWsugDh9jw=
X-QQ-mid: bizesmtpsz3t1727082939tpsb4mi
X-QQ-Originating-IP: SGK2YqAUhj5xYLt4DQwc1KncxARzA20r3RDca32GyEw=
Received: from fish-NBLK-WAX9X.. ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 23 Sep 2024 17:15:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11822925006816321753
From: yushengjin <yushengjin@uniontech.com>
To: pablo@netfilter.org
Cc: kadlec@netfilter.org,
	roopa@nvidia.com,
	razor@blackwall.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yushengjin <yushengjin@uniontech.com>
Subject: [PATCH] net/bridge: Optimizing read-write locks in ebtables.c
Date: Mon, 23 Sep 2024 17:15:35 +0800
Message-ID: <EC5AC714C75A855E+20240923091535.77865-1-yushengjin@uniontech.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0

When conducting WRK testing, the CPU usage rate of the testing machine was
100%. forwarding through a bridge, if the network load is too high, it may
cause abnormal load on the ebt_do_table of the kernel ebtable module, leading
to excessive soft interrupts and sometimes even directly causing CPU soft
deadlocks.

After analysis, it was found that the code of ebtables had not been optimized
for a long time, and the read-write locks inside still existed. However, other
arp/ip/ip6 tables had already been optimized a lot, and performance bottlenecks
in read-write locks had been discovered a long time ago.

Ref link: https://lore.kernel.org/lkml/20090428092411.5331c4a1@nehalam/

So I referred to arp/ip/ip6 modification methods to optimize the read-write
lock in ebtables.c.

test method:
1) Test machine creates bridge :
``` bash
brctl addbr br-a
brctl addbr br-b
brctl addif br-a enp1s0f0 enp1s0f1
brctl addif br-b enp130s0f0 enp130s0f1
ifconfig br-a up
ifconfig br-b up
```
2) Testing with another machine:
``` bash
ulimit -n 2048
./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://4.4.4.2:80/4k.html &
./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://5.5.5.2:80/4k.html &
```

Signed-off-by: yushengjin <yushengjin@uniontech.com>
---
 include/linux/netfilter_bridge/ebtables.h |  47 +++++++-
 net/bridge/netfilter/ebtables.c           | 132 ++++++++++++++++------
 2 files changed, 145 insertions(+), 34 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index fd533552a062..dd52dea20fb8 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -93,7 +93,6 @@ struct ebt_table {
 	char name[EBT_TABLE_MAXNAMELEN];
 	struct ebt_replace_kernel *table;
 	unsigned int valid_hooks;
-	rwlock_t lock;
 	/* the data used by the kernel */
 	struct ebt_table_info *private;
 	struct nf_hook_ops *ops;
@@ -124,4 +123,50 @@ static inline bool ebt_invalid_target(int target)
 
 int ebt_register_template(const struct ebt_table *t, int(*table_init)(struct net *net));
 void ebt_unregister_template(const struct ebt_table *t);
+
+/**
+ * ebt_recseq - recursive seqcount for netfilter use
+ *
+ * Packet processing changes the seqcount only if no recursion happened
+ * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
+ * because we use the normal seqcount convention :
+ * Low order bit set to 1 if a writer is active.
+ */
+DECLARE_PER_CPU(seqcount_t, ebt_recseq);
+
+/**
+ * ebt_write_recseq_begin - start of a write section
+ *
+ * Begin packet processing : all readers must wait the end
+ * 1) Must be called with preemption disabled
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
+ * Returns :
+ *  1 if no recursion on this cpu
+ *  0 if recursion detected
+ */
+static inline unsigned int ebt_write_recseq_begin(void)
+{
+	unsigned int addend;
+
+	addend = (__this_cpu_read(ebt_recseq.sequence) + 1) & 1;
+
+	__this_cpu_add(ebt_recseq.sequence, addend);
+	smp_mb();
+
+	return addend;
+}
+
+/**
+ * ebt_write_recseq_end - end of a write section
+ * @addend: return value from previous ebt_write_recseq_begin()
+ *
+ * End packet processing : all readers can proceed
+ * 1) Must be called with preemption disabled
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
+ */
+static inline void ebt_write_recseq_end(unsigned int addend)
+{
+	smp_wmb();
+	__this_cpu_add(ebt_recseq.sequence, addend);
+}
 #endif
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3e67d4aff419..9da5733a26ea 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -40,6 +40,9 @@
 #define COUNTER_BASE(c, n, cpu) ((struct ebt_counter *)(((char *)c) + \
 				 COUNTER_OFFSET(n) * cpu))
 
+DEFINE_PER_CPU(seqcount_t, ebt_recseq);
+EXPORT_PER_CPU_SYMBOL_GPL(ebt_recseq);
+
 struct ebt_pernet {
 	struct list_head tables;
 };
@@ -204,11 +207,14 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	const char *base;
 	const struct ebt_table_info *private;
 	struct xt_action_param acpar;
+	unsigned int addend;
 
 	acpar.state   = state;
 	acpar.hotdrop = false;
 
-	read_lock_bh(&table->lock);
+	local_bh_disable();
+	addend = ebt_write_recseq_begin();
+
 	private = table->private;
 	cb_base = COUNTER_BASE(private->counters, private->nentries,
 	   smp_processor_id());
@@ -229,10 +235,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
 			goto letscontinue;
-		if (acpar.hotdrop) {
-			read_unlock_bh(&table->lock);
-			return NF_DROP;
-		}
+		if (acpar.hotdrop)
+			goto drop_out;
 
 		ADD_COUNTER(*(counter_base + i), skb->len, 1);
 
@@ -251,13 +255,13 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 			verdict = t->u.target->target(skb, &acpar);
 		}
 		if (verdict == EBT_ACCEPT) {
-			read_unlock_bh(&table->lock);
+			ebt_write_recseq_end(addend);
+			local_bh_enable();
 			return NF_ACCEPT;
 		}
-		if (verdict == EBT_DROP) {
-			read_unlock_bh(&table->lock);
-			return NF_DROP;
-		}
+		if (verdict == EBT_DROP)
+			goto drop_out;
+
 		if (verdict == EBT_RETURN) {
 letsreturn:
 			if (WARN(sp == 0, "RETURN on base chain")) {
@@ -278,10 +282,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 		if (verdict == EBT_CONTINUE)
 			goto letscontinue;
 
-		if (WARN(verdict < 0, "bogus standard verdict\n")) {
-			read_unlock_bh(&table->lock);
-			return NF_DROP;
-		}
+		if (WARN(verdict < 0, "bogus standard verdict\n"))
+			goto drop_out;
 
 		/* jump to a udc */
 		cs[sp].n = i + 1;
@@ -290,10 +292,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 		i = 0;
 		chaininfo = (struct ebt_entries *) (base + verdict);
 
-		if (WARN(chaininfo->distinguisher, "jump to non-chain\n")) {
-			read_unlock_bh(&table->lock);
-			return NF_DROP;
-		}
+		if (WARN(chaininfo->distinguisher, "jump to non-chain\n"))
+			goto drop_out;
 
 		nentries = chaininfo->nentries;
 		point = (struct ebt_entry *)chaininfo->data;
@@ -309,10 +309,15 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	if (chaininfo->policy == EBT_RETURN)
 		goto letsreturn;
 	if (chaininfo->policy == EBT_ACCEPT) {
-		read_unlock_bh(&table->lock);
+		ebt_write_recseq_end(addend);
+		local_bh_enable();
 		return NF_ACCEPT;
 	}
-	read_unlock_bh(&table->lock);
+
+drop_out:
+	ebt_write_recseq_end(addend);
+	local_bh_enable();
+
 	return NF_DROP;
 }
 
@@ -983,12 +988,48 @@ static int translate_table(struct net *net, const char *name,
 	return ret;
 }
 
-/* called under write_lock */
+
 static void get_counters(const struct ebt_counter *oldcounters,
 			 struct ebt_counter *counters, unsigned int nentries)
 {
 	int i, cpu;
 	struct ebt_counter *counter_base;
+	seqcount_t *s;
+
+	/* counters of cpu 0 */
+	memcpy(counters, oldcounters,
+	       sizeof(struct ebt_counter) * nentries);
+
+	/* add other counters to those of cpu 0 */
+	for_each_possible_cpu(cpu) {
+
+		if (cpu == 0)
+			continue;
+
+		s = &per_cpu(ebt_recseq, cpu);
+		counter_base = COUNTER_BASE(oldcounters, nentries, cpu);
+		for (i = 0; i < nentries; i++) {
+			u64 bcnt, pcnt;
+			unsigned int start;
+
+			do {
+				start = read_seqcount_begin(s);
+				bcnt = counter_base[i].bcnt;
+				pcnt = counter_base[i].pcnt;
+			} while (read_seqcount_retry(s, start));
+
+			ADD_COUNTER(counters[i], bcnt, pcnt);
+			cond_resched();
+		}
+	}
+}
+
+
+static void get_old_counters(const struct ebt_counter *oldcounters,
+			 struct ebt_counter *counters, unsigned int nentries)
+{
+	int i, cpu;
+	struct ebt_counter *counter_base;
 
 	/* counters of cpu 0 */
 	memcpy(counters, oldcounters,
@@ -1013,6 +1054,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	/* used to be able to unlock earlier */
 	struct ebt_table_info *table;
 	struct ebt_table *t;
+	unsigned int cpu;
 
 	/* the user wants counters back
 	 * the check on the size is done later, when we have the lock
@@ -1050,6 +1092,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_unlock;
 	}
 
+	local_bh_disable();
+
 	/* we have the mutex lock, so no danger in reading this pointer */
 	table = t->private;
 	/* make sure the table can only be rmmod'ed if it contains no rules */
@@ -1058,15 +1102,31 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_unlock;
 	} else if (table->nentries && !newinfo->nentries)
 		module_put(t->me);
-	/* we need an atomic snapshot of the counters */
-	write_lock_bh(&t->lock);
-	if (repl->num_counters)
-		get_counters(t->private->counters, counterstmp,
-		   t->private->nentries);
 
+	smp_wmb();
 	t->private = newinfo;
-	write_unlock_bh(&t->lock);
+	smp_mb();
+
+	local_bh_enable();
+
+	// wait for even ebt_recseq on all cpus
+	for_each_possible_cpu(cpu) {
+		seqcount_t *s = &per_cpu(ebt_recseq, cpu);
+		u32 seq = raw_read_seqcount(s);
+
+		if (seq & 1) {
+			do {
+				cond_resched();
+				cpu_relax();
+			} while (seq == raw_read_seqcount(s));
+		}
+	}
+
 	mutex_unlock(&ebt_mutex);
+
+	if (repl->num_counters)
+	    get_old_counters(table->counters, counterstmp, table->nentries);
+
 	/* so, a user can change the chains while having messed up her counter
 	 * allocation. Only reason why this is done is because this way the lock
 	 * is held only once, while this doesn't bring the kernel into a
@@ -1093,6 +1153,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	return 0;
 
 free_unlock:
+	local_bh_enable();
 	mutex_unlock(&ebt_mutex);
 free_iterate:
 	EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
@@ -1235,7 +1296,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		goto free_chainstack;
 
 	table->private = newinfo;
-	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
 	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, table->name) == 0) {
@@ -1382,6 +1442,7 @@ static int do_update_counters(struct net *net, const char *name,
 	int i, ret;
 	struct ebt_counter *tmp;
 	struct ebt_table *t;
+	unsigned int addend;
 
 	if (num_counters == 0)
 		return -EINVAL;
@@ -1405,14 +1466,16 @@ static int do_update_counters(struct net *net, const char *name,
 		goto unlock_mutex;
 	}
 
-	/* we want an atomic add of the counters */
-	write_lock_bh(&t->lock);
+	local_bh_disable();
+	addend = ebt_write_recseq_begin();
 
 	/* we add to the counters of the first cpu */
 	for (i = 0; i < num_counters; i++)
 		ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);
 
-	write_unlock_bh(&t->lock);
+	ebt_write_recseq_end(addend);
+	local_bh_enable();
+
 	ret = 0;
 unlock_mutex:
 	mutex_unlock(&ebt_mutex);
@@ -1530,9 +1593,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (!counterstmp)
 		return -ENOMEM;
 
-	write_lock_bh(&t->lock);
 	get_counters(oldcounters, counterstmp, nentries);
-	write_unlock_bh(&t->lock);
 
 	if (copy_to_user(user, counterstmp,
 	    array_size(nentries, sizeof(struct ebt_counter))))
@@ -2568,6 +2629,11 @@ static struct pernet_operations ebt_net_ops = {
 static int __init ebtables_init(void)
 {
 	int ret;
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+	    seqcount_init(&per_cpu(ebt_recseq, i));
+	}
 
 	ret = xt_register_target(&ebt_standard_target);
 	if (ret < 0)
-- 
2.43.0

