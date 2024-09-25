Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D515A87C;
	Wed, 25 Sep 2024 08:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727253485; cv=none; b=r7JXS4kwVnHLB/spGp7SolTnJyM7SdR5XIHMV7h8J0RiLgSN5xqDZkCmi9vudJ8GClkvbJVZqDh4+zVLsK2qdQoOcTRdHepM546dXi7iJnYsi9o70lI5U8IlnQY59HspfqOhZFC8YGjxxM8z/rmFNPz6HE3GNKKLMNLp6/HN+oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727253485; c=relaxed/simple;
	bh=9FpXjrMVNcWjGyIMxruP7MfsInytvTEkHkKnPgGVbiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O2TqaYpQ9Sna/SotvwT9k4+oyfUhi5QLYyWnu33G4yY8hiNoIk0O+FizceBM16rl2r4/Cp4F/rxPKE18419bbZFSXkUaqfgvwGUge3w01nYSEdJLTk+AzrJ5yYc9BpQZtqT7PBEKUx680saHQknXVAOev9QvsfgDXFZ15cYhFeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=bbazCjSg; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="bbazCjSg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727253474;
	bh=C+KAZMZtbRWkoNiP+xKBl35aoEFpxuY+tUuQznd1gaU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=bbazCjSgrF6PZYzu/btFHOKJJ331st5Vly3s+14pVkC6eLzmyHBQmbKNSpzXdpq6N
	 u9h7oio7zCR0mdN9vEK//2b7CtRr8AYa1xgc6jMDM1pHi0zK5jZcFBlfdl1krTYXO+
	 LGhR7/PTlWiML8IdjK5exw2lSCUgIMTfH301fPa0=
X-QQ-mid: bizesmtp87t1727253469tin69spl
X-QQ-Originating-IP: Smz1/RT4I/8FynUZnuegihidcQsto4r32tTJgbLchfE=
Received: from fish-NBLK-WAX9X.. ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 25 Sep 2024 16:37:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9396028548212037258
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
	gouhao@uniontech.com,
	yushengjin <yushengjin@uniontech.com>
Subject: [PATCH v4] net/bridge: Optimizing read-write locks in ebtables.c
Date: Wed, 25 Sep 2024 16:37:45 +0800
Message-ID: <A872628EC4B98B9E+20240925083745.179397-1-yushengjin@uniontech.com>
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

When conducting WRK testing, the softirq of the system will be very high.
forwarding through a bridge, if the network load is too high, it may
cause abnormal load on the ebt_do_table of the kernel ebtable module, leading
to excessive soft interrupts and sometimes even directly causing CPU soft
lockup.

test prepare:
1) Test machine A creates bridge :
``` bash
brctl addbr br-a
brctl addbr br-b
brctl addif br-a enp1s0f0 enp1s0f1
brctl addif br-b enp130s0f0 enp130s0f1
ifconfig br-a up
ifconfig br-b up
```
2) Testing with another machine B:
``` bash
ulimit -n 2048
./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://4.4.4.2:80/4k.html &
./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://5.5.5.2:80/4k.html &
```
At this time, the soft interrupt of machine A will be relatively high, This is
the data running on the arm Kunpeng-920 (96 cpus) machine,When I only run
wrk tests, the softirq of the system will rapidly increase to 25%:

02:50:07 PM  CPU   %usr  %nice %sys %iowait %irq  %soft  %steal %guest  %gnice %idle
02:50:25 PM  all   0.00  0.00  0.05  0.00   0.72  23.20  0.00    0.00    0.00   76.03
02:50:26 PM  all   0.00  0.00  0.08  0.00   0.72  24.53  0.00    0.00    0.00   74.67
02:50:27 PM  all   0.01  0.00  0.13  0.00   0.75  24.89  0.00    0.00    0.00   74.23

3) machine A perform ebtables related operations.
``` bash

for i in {0..100000}
do
        ebtables -t nat -Lc
        ebtables -t nat -F
        ebtables -t nat -Lc
        ebtables -t nat -A PREROUTING -j PREROUTING_direct
done
```
If ebatlse queries, updates, and other operations are continuously executed at this time, softirq
will increase again to 50%:
02:52:23 PM  all   0.00   0.00  1.18  0.00   0.54  48.91  0.00   0.00   0.00   49.36
02:52:24 PM  all   0.00   0.00  1.19  0.00   0.43  48.23  0.00   0.00   0.00   50.15
02:52:25 PM  all   0.00   0.00  1.20  0.00   0.50  48.29  0.00   0.00   0.00   50.01

More seriously, soft lockup may occur:

Message from syslogd@localhost at Sep 25 14:52:22 ...
 kernel:watchdog: BUG: soft lockup - CPU#88 stuck for 23s! [ebtables:3896]

dmesg:

[ 1376.653884] watchdog: BUG: soft lockup - CPU#88 stuck for 23s! [ebtables:3896]
[ 1376.661131] CPU: 88 PID: 3896 Comm: ebtables Kdump: loaded Not tainted 4.19.90-2305.1.0.0199.82.uel20.aarch64 #1
[ 1376.661132] Hardware name: Yunke China KunTai R722/BC82AMDDA, BIOS 6.59 07/18/2023
[ 1376.661133] pstate: 20400009 (nzCv daif +PAN -UAO)
[ 1376.661137] pc : queued_write_lock_slowpath+0x70/0x128
...
[ 1376.661156] Call trace:
[ 1376.661157]  queued_write_lock_slowpath+0x70/0x128
[ 1376.661164]  copy_counters_to_user.part.2+0x110/0x140 [ebtables]
[ 1376.661166]  copy_everything_to_user+0x3c4/0x730 [ebtables]
[ 1376.661168]  do_ebt_get_ctl+0x1c0/0x270 [ebtables]
[ 1376.661172]  nf_getsockopt+0x64/0xa8
[ 1376.661175]  ip_getsockopt+0x12c/0x1b0
[ 1376.661178]  raw_getsockopt+0x88/0xb0
[ 1376.661182]  sock_common_getsockopt+0x54/0x68
[ 1376.661185]  __arm64_sys_getsockopt+0x94/0x108
[ 1376.661190]  el0_svc_handler+0x80/0x168
[ 1376.661192]  el0_svc+0x8/0x6c0

After analysis, it was found that the code of ebtables had not been optimized
for a long time, and the read-write locks inside still existed. However, other
arp/ip/ip6 tables had already been optimized a lot, and performance bottlenecks
in read-write locks had been discovered a long time ago.

So I referred to arp/ip/ip6 modification methods to optimize the read-write
lock in ebtables.c.

Ref: '7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")'

patch after:
03:17:11 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:17:12 PM  all    0.02    0.00    0.03    0.00    0.64    4.80    0.00    0.00    0.00   94.51
03:17:13 PM  all    0.00    0.00    0.03    0.00    0.60    4.68    0.00    0.00    0.00   94.69
03:17:14 PM  all    0.02    0.00    0.00    0.00    0.63    4.60    0.00    0.00    0.00   94.74

When performing ebtables query and update operations:
03:17:50 PM  all    0.97    0.00    1.16    0.00    0.59    4.37    0.00    0.00    0.00   92.92
03:17:51 PM  all    0.71    0.00    1.20    0.00    0.56    3.97    0.00    0.00    0.00   93.56
03:17:52 PM  all    1.02    0.00    1.02    0.00    0.59    4.02    0.00    0.00    0.00   93.36
03:17:53 PM  all    0.90    0.00    1.10    0.00    0.54    4.07    0.00    0.00    0.00   93.38

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: yushengjin <yushengjin@uniontech.com>
Link: https://lore.kernel.org/all/CANn89iJCBRCM3aHDy-7gxWu_+agXC9M1R=hwFuh2G9RSLu_6bg@mail.gmail.com/
---
 include/linux/netfilter_bridge/ebtables.h |   1 -
 net/bridge/netfilter/ebtables.c           | 140 ++++++++++++++++------
 2 files changed, 102 insertions(+), 39 deletions(-)

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
index 3e67d4aff419..08e430fcbe5a 100644
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
+		s = &per_cpu(xt_recseq, cpu);
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
+	/* wait for even xt_recseq on all cpus */
+	for_each_possible_cpu(cpu) {
+		seqcount_t *s = &per_cpu(xt_recseq, cpu);
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
@@ -1379,9 +1436,11 @@ static int do_update_counters(struct net *net, const char *name,
 			      struct ebt_counter __user *counters,
 			      unsigned int num_counters, unsigned int len)
 {
-	int i, ret;
-	struct ebt_counter *tmp;
+	int i, ret, cpu;
+	struct ebt_counter *tmp, *counter_base;
 	struct ebt_table *t;
+	unsigned int addend;
+	const struct ebt_table_info *private;
 
 	if (num_counters == 0)
 		return -EINVAL;
@@ -1405,14 +1464,21 @@ static int do_update_counters(struct net *net, const char *name,
 		goto unlock_mutex;
 	}
 
-	/* we want an atomic add of the counters */
-	write_lock_bh(&t->lock);
+	local_bh_disable();
+	addend = xt_write_recseq_begin();
+	private = t->private;
+	cpu = smp_processor_id();
+
+	/* we add to the counters of the current cpu */
+	for (i = 0; i < num_counters; i++) {
+		counter_base = COUNTER_BASE(private->counters,
+					private->nentries, cpu);
+		ADD_COUNTER(counter_base[i], tmp[i].bcnt, tmp[i].pcnt);
+	}
 
-	/* we add to the counters of the first cpu */
-	for (i = 0; i < num_counters; i++)
-		ADD_COUNTER(t->private->counters[i], tmp[i].bcnt, tmp[i].pcnt);
+	xt_write_recseq_end(addend);
+	local_bh_enable();
 
-	write_unlock_bh(&t->lock);
 	ret = 0;
 unlock_mutex:
 	mutex_unlock(&ebt_mutex);
@@ -1530,9 +1596,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (!counterstmp)
 		return -ENOMEM;
 
-	write_lock_bh(&t->lock);
 	get_counters(oldcounters, counterstmp, nentries);
-	write_unlock_bh(&t->lock);
 
 	if (copy_to_user(user, counterstmp,
 	    array_size(nentries, sizeof(struct ebt_counter))))
-- 
2.43.0

