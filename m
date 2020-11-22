Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CBAC5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 19:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795E92076E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 19:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="xbeWgRzY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgKVTSP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 14:18:15 -0500
Received: from z5.mailgun.us ([104.130.96.5]:60827 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgKVTSO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 14:18:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606072693; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=6H3fKt564w+x9fnm1xA40fsKK8+AoU4PNKCn8ve5Lbo=; b=xbeWgRzYD/OH7SR0m4sr+iOOxzpTLDjFg91yZSJX3NYRWXw0eW+tHWBrMP13/Q3kUEMJ6qm9
 rJMyqUS/O+/wbcKBg8mOalTKQsIRTN9ozG9H3RiKDLDV6gFEQQBFfqydkAi2O/HMSRcvi0n6
 mu8lc2+dRx5LpIZZL8UteFyV/Pc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fbab970a5a29b56a1c20642 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 22 Nov 2020 19:18:08
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30E6BC43460; Sun, 22 Nov 2020 19:18:08 +0000 (UTC)
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99608C433C6;
        Sun, 22 Nov 2020 19:18:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99608C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     will@kernel.org, pablo@netfilter.org, stranche@codeaurora.org,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de, fw@strlen.de,
        peterz@infradead.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf] netfilter: x_tables: Switch synchronization to RCU
Date:   Sun, 22 Nov 2020 12:17:16 -0700
Message-Id: <1606072636-23555-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running concurrent iptables rules replacement with data, the per CPU
sequence count is checked after the assignment of the new information.
The sequence count is used to synchronize with the packet path without the
use of any explicit locking. If there are any packets in the packet path using
the table information, the sequence count is incremented to an odd value and
is incremented to an even after the packet process completion.

The new table value assignment is followed by a write memory barrier so every
CPU should see the latest value. If the packet path has started with the old
table information, the sequence counter will be odd and the iptables
replacement will wait till the sequence count is even prior to freeing the
old table info.

However, this assumes that the new table information assignment and the memory
barrier is actually executed prior to the counter check in the replacement
thread. If CPU decides to execute the assignment later as there is no user of
the table information prior to the sequence check, the packet path in another
CPU may use the old table information. The replacement thread would then free
the table information under it leading to a use after free in the packet
processing context-

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000008e
pc : ip6t_do_table+0x5d0/0x89c
lr : ip6t_do_table+0x5b8/0x89c
ip6t_do_table+0x5d0/0x89c
ip6table_filter_hook+0x24/0x30
nf_hook_slow+0x84/0x120
ip6_input+0x74/0xe0
ip6_rcv_finish+0x7c/0x128
ipv6_rcv+0xac/0xe4
__netif_receive_skb+0x84/0x17c
process_backlog+0x15c/0x1b8
napi_poll+0x88/0x284
net_rx_action+0xbc/0x23c
__do_softirq+0x20c/0x48c

This could be fixed by forcing instruction order after the new table
information assignment or by switching to RCU for the synchronization.

Fixes: 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
Reported-by: Sean Tranchetti <stranche@codeaurora.org>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/linux/netfilter/x_tables.h |  5 +++-
 net/ipv4/netfilter/arp_tables.c    |  8 +++----
 net/ipv4/netfilter/ip_tables.c     |  8 +++----
 net/ipv6/netfilter/ip6_tables.c    |  8 +++----
 net/netfilter/x_tables.c           | 48 ++++++++++++--------------------------
 5 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5deb099..8ebb641 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -227,7 +227,7 @@ struct xt_table {
 	unsigned int valid_hooks;
 
 	/* Man behind the curtain... */
-	struct xt_table_info *private;
+	struct xt_table_info __rcu *private;
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -448,6 +448,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table);
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d1e04d2..6891a40 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu     = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
@@ -649,7 +649,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -673,7 +673,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -1330,7 +1330,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f15bc21..01a9753 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -258,7 +258,7 @@ ipt_do_table(struct sk_buff *skb,
 	WARN_ON(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
@@ -791,7 +791,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -815,7 +815,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ipt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -1543,7 +1543,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2e2119b..8a7bb06 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -280,7 +280,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
-	private = READ_ONCE(table->private); /* Address dependency. */
+	private = rcu_access_pointer(table->private);
 	cpu        = smp_processor_id();
 	table_base = private->entries;
 	jumpstack  = (struct ip6t_entry **)private->jumpstack[cpu];
@@ -807,7 +807,7 @@ static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -831,7 +831,7 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	const struct ip6t_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	int ret = 0;
 	const void *loc_cpu_entry;
 
@@ -1552,7 +1552,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = xt_table_get_private_protected(table);
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe..416a617 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1349,6 +1349,14 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
+struct xt_table_info
+*xt_table_get_private_protected(const struct xt_table *table)
+{
+	return rcu_dereference_protected(table->private,
+					 mutex_is_locked(&xt[table->af].mutex));
+}
+EXPORT_SYMBOL(xt_table_get_private_protected);
+
 struct xt_table_info *
 xt_replace_table(struct xt_table *table,
 	      unsigned int num_counters,
@@ -1356,7 +1364,6 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
-	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1366,8 +1373,7 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	local_bh_disable();
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
@@ -1379,34 +1385,9 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	newinfo->initial_entries = private->initial_entries;
-	/*
-	 * Ensure contents of newinfo are visible before assigning to
-	 * private.
-	 */
-	smp_wmb();
-	table->private = newinfo;
-
-	/* make sure all cpus see new ->private value */
-	smp_wmb();
 
-	/*
-	 * Even though table entries have now been swapped, other CPU's
-	 * may still be using the old entries...
-	 */
-	local_bh_enable();
-
-	/* ... so wait for even xt_recseq on all cpus */
-	for_each_possible_cpu(cpu) {
-		seqcount_t *s = &per_cpu(xt_recseq, cpu);
-		u32 seq = raw_read_seqcount(s);
-
-		if (seq & 1) {
-			do {
-				cond_resched();
-				cpu_relax();
-			} while (seq == raw_read_seqcount(s));
-		}
-	}
+	rcu_assign_pointer(table->private, newinfo);
+	synchronize_rcu();
 
 	audit_log_nfcfg(table->name, table->af, private->number,
 			!private->number ? AUDIT_XT_OP_REGISTER :
@@ -1442,12 +1423,12 @@ struct xt_table *xt_register_table(struct net *net,
 	}
 
 	/* Simplifies replace_table code. */
-	table->private = bootstrap;
+	rcu_assign_pointer(table->private, bootstrap);
 
 	if (!xt_replace_table(table, 0, newinfo, &ret))
 		goto unlock;
 
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 	pr_debug("table->private->number = %u\n", private->number);
 
 	/* save number of initial entries */
@@ -1470,7 +1451,8 @@ void *xt_unregister_table(struct xt_table *table)
 	struct xt_table_info *private;
 
 	mutex_lock(&xt[table->af].mutex);
-	private = table->private;
+	private = xt_table_get_private_protected(table);
+	RCU_INIT_POINTER(table->private, NULL);
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
 	audit_log_nfcfg(table->name, table->af, private->number,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

