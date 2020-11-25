Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B80DC56201
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 18:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54CF205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 18:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kFp8xSv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgKYS2a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:28:30 -0500
Received: from z5.mailgun.us ([104.130.96.5]:39056 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgKYS2a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 13:28:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606328909; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=oZ0UZuSBL4+q47aInHtLh85SBWYE3dCgqoW6K0hHggI=; b=kFp8xSv7Us2Rd1n4ONMLNL6bAzLau8hG4/Fcj8eJj7XfMGMq9rRJpH2vwitMYEV1pmwbCQCa
 AtC/NZm4OEKDjYpqyheG7rbgkeKDgknMHZAB/BGG3qLLjmNsPmZn+7TohS2RD1PpQnomeizT
 fmFfl4sjFKhd39r54lcba+/zpro=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fbea249d64ea0b7033b1040 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 18:28:25
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 69010C43463; Wed, 25 Nov 2020 18:28:24 +0000 (UTC)
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A694C433C6;
        Wed, 25 Nov 2020 18:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A694C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     fw@strlen.de, will@kernel.org, pablo@netfilter.org,
        stranche@codeaurora.org, netfilter-devel@vger.kernel.org,
        tglx@linutronix.de, peterz@infradead.org, lkp@intel.com
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf v2] netfilter: x_tables: Switch synchronization to RCU
Date:   Wed, 25 Nov 2020 11:27:22 -0700
Message-Id: <1606328842-22747-1-git-send-email-subashab@codeaurora.org>
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
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/linux/netfilter/x_tables.h |  5 +++-
 net/ipv4/netfilter/arp_tables.c    | 14 +++++------
 net/ipv4/netfilter/ip_tables.c     | 14 +++++------
 net/ipv6/netfilter/ip6_tables.c    | 14 +++++------
 net/netfilter/x_tables.c           | 49 ++++++++++++--------------------------
 5 files changed, 40 insertions(+), 56 deletions(-)

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
index d1e04d2..563b62b 100644
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
 
@@ -807,7 +807,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
 		struct arpt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -860,7 +860,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1017,7 +1017,7 @@ static int do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
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
index f15bc21..6e2851f 100644
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
 
@@ -964,7 +964,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
 		struct ipt_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1018,7 +1018,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1173,7 +1173,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
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
index 2e2119b..c4f532f 100644
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
 
@@ -980,7 +980,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 #ifdef CONFIG_COMPAT
 		struct xt_table_info tmp;
 
@@ -1035,7 +1035,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		struct xt_table_info *private = xt_table_get_private_protected(t);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
@@ -1189,7 +1189,7 @@ do_add_counters(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	local_bh_disable();
-	private = t->private;
+	private = xt_table_get_private_protected(t);
 	if (private->number != tmp.num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
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
index af22dbe..acce622 100644
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
@@ -1366,47 +1373,20 @@ xt_replace_table(struct xt_table *table,
 	}
 
 	/* Do the substitution. */
-	local_bh_disable();
-	private = table->private;
+	private = xt_table_get_private_protected(table);
 
 	/* Check inside lock: is the old number correct? */
 	if (num_counters != private->number) {
 		pr_debug("num_counters != table->private->number (%u/%u)\n",
 			 num_counters, private->number);
-		local_bh_enable();
 		*error = -EAGAIN;
 		return NULL;
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
@@ -1442,12 +1422,12 @@ struct xt_table *xt_register_table(struct net *net,
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
@@ -1470,7 +1450,8 @@ void *xt_unregister_table(struct xt_table *table)
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

