Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88E1B85FF;
	Tue, 24 Sep 2024 02:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727144693; cv=none; b=qH+uQsH9+tq4icpgMuT5KJp2dzaPLck5VAyR4+o0jZUqqO5BwQwUOSiyp9g6YmH5h8ron7vE60+JSm08oem8Wv0x926uXfwZ2YOGFlI/mL+yhv6lypOtqxOT63PM60hmPWNMA4rM+/4nPxPp1JBysBSszVC7E4JAHkFYOG4Cv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727144693; c=relaxed/simple;
	bh=ZeD2dxHt4glNwYGeQd3QpH4sDCyqQq8WnnHbXARjZvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g7jG1dmH5fWk74aSRbBaLjf5FelP5qPJbLuQStt0LdmqP7cvQ3dEfMT1bksLa1k6phmITF4jmxqYH1GTASOkN/REM9Yo6YP7U+fRhb8uh3z4m43KavEJFDTL7q856QrxEtl75KDglFvciZaRyfbPIzabBZK7RtArBHwGQKr/sdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=oZQdIJFF; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="oZQdIJFF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727144686;
	bh=/tLBDCK7pbckkG3+mplCpjgt4khIOUVDy/lEAnn6+fk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=oZQdIJFFauSUjuy8cAgzZ2BtsYyXFA9aZ5AfEuBMX4r6NGWbjMAhg9SjBUOXgJbKr
	 OJDsmjO79Iv5pVFO/c2cKM3Dk9s1/42yV3HM7YSMMe7uq8c6XuN9V4/RXAOOiN27Dp
	 km2Z2PhXXOPewtqvR6TrMiZbjglnqnO6Mp5hqPsw=
X-QQ-mid: bizesmtp88t1727144681trzskiwd
X-QQ-Originating-IP: JBqxVDiVgZHmutUkV4/9rq+sIJ1hsVnj8BqRUusNbg0=
Received: from fish-NBLK-WAX9X.. ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Sep 2024 10:24:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1965234270321233155
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
Subject: [PATCH v2] net/bridge: Optimizing read-write locks in ebtables.c
Date: Tue, 24 Sep 2024 10:24:37 +0800
Message-ID: <2860814445452DE8+20240924022437.119730-1-yushengjin@uniontech.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4a-0

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

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: yushengjin <yushengjin@uniontech.com>
Link: https://lore.kernel.org/all/CANn89iJCBRCM3aHDy-7gxWu_+agXC9M1R=hwFuh2G9RSLu_6bg@mail.gmail.com/
---
 include/linux/netfilter_bridge/ebtables.h |   1 -
 net/bridge/netfilter/ebtables.c           | 124 ++++++++++++++++------
 2 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index fd533552a062..15aad1e479d7 100644
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
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3e67d4aff419..d7db7380fcbb 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -204,11 +204,14 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	const char *base;
 	const struct ebt_table_info *private;
 	struct xt_action_param acpar;
+	unsigned int addend;
 
 	acpar.state   = state;
 	acpar.hotdrop = false;
 
-	read_lock_bh(&table->lock);
+	local_bh_disable();
+	addend = xt_write_recseq_begin();
+
 	private = table->private;
 	cb_base = COUNTER_BASE(private->counters, private->nentries,
 	   smp_processor_id());
@@ -229,10 +232,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
 			goto letscontinue;
-		if (acpar.hotdrop) {
-			read_unlock_bh(&table->lock);
-			return NF_DROP;
-		}
+		if (acpar.hotdrop)
+			goto drop_out;
 
 		ADD_COUNTER(*(counter_base + i), skb->len, 1);
 
@@ -251,13 +252,13 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 			verdict = t->u.target->target(skb, &acpar);
 		}
 		if (verdict == EBT_ACCEPT) {
-			read_unlock_bh(&table->lock);
+			xt_write_recseq_end(addend);
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
@@ -278,10 +279,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
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
@@ -290,10 +289,8 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
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
@@ -309,10 +306,15 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	if (chaininfo->policy == EBT_RETURN)
 		goto letsreturn;
 	if (chaininfo->policy == EBT_ACCEPT) {
-		read_unlock_bh(&table->lock);
+		xt_write_recseq_end(addend);
+		local_bh_enable();
 		return NF_ACCEPT;
 	}
-	read_unlock_bh(&table->lock);
+
+drop_out:
+	xt_write_recseq_end(addend);
+	local_bh_enable();
+
 	return NF_DROP;
 }
 
@@ -983,12 +985,48 @@ static int translate_table(struct net *net, const char *name,
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
@@ -1013,6 +1051,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	/* used to be able to unlock earlier */
 	struct ebt_table_info *table;
 	struct ebt_table *t;
+	unsigned int cpu;
 
 	/* the user wants counters back
 	 * the check on the size is done later, when we have the lock
@@ -1050,6 +1089,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_unlock;
 	}
 
+	local_bh_disable();
+
 	/* we have the mutex lock, so no danger in reading this pointer */
 	table = t->private;
 	/* make sure the table can only be rmmod'ed if it contains no rules */
@@ -1058,15 +1099,31 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
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
@@ -1093,6 +1150,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	return 0;
 
 free_unlock:
+	local_bh_enable();
 	mutex_unlock(&ebt_mutex);
 free_iterate:
 	EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
@@ -1235,7 +1293,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		goto free_chainstack;
 
 	table->private = newinfo;
-	rwlock_init(&table->lock);
 	mutex_lock(&ebt_mutex);
 	list_for_each_entry(t, &ebt_net->tables, list) {
 		if (strcmp(t->name, table->name) == 0) {
@@ -1382,6 +1439,7 @@ static int do_update_counters(struct net *net, const char *name,
 	int i, ret;
 	struct ebt_counter *tmp;
 	struct ebt_table *t;
+	unsigned int addend;
 
 	if (num_counters == 0)
 		return -EINVAL;
@@ -1405,14 +1463,16 @@ static int do_update_counters(struct net *net, const char *name,
 		goto unlock_mutex;
 	}
 
-	/* we want an atomic add of the counters */
-	write_lock_bh(&t->lock);
+	local_bh_disable();
+	addend = xt_write_recseq_begin();
 
 	/* we add to the counters of the first cpu */
 	for (i = 0; i < num_counters; i++)
 		ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);
 
-	write_unlock_bh(&t->lock);
+	xt_write_recseq_end(addend);
+	local_bh_enable();
+
 	ret = 0;
 unlock_mutex:
 	mutex_unlock(&ebt_mutex);
@@ -1530,9 +1590,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (!counterstmp)
 		return -ENOMEM;
 
-	write_lock_bh(&t->lock);
 	get_counters(oldcounters, counterstmp, nentries);
-	write_unlock_bh(&t->lock);
 
 	if (copy_to_user(user, counterstmp,
 	    array_size(nentries, sizeof(struct ebt_counter))))
-- 
2.43.0

