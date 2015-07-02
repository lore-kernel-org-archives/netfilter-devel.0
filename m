From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Thu, 02 Jul 2015 17:38:53 +0200
Message-ID: <1435851533.11970.33.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1435695660-26048-1-git-send-email-fw@strlen.de>
	 <20150702113044.GA21930@salvia> <20150702114837.GA16529@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36589 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbGBPi6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 11:38:58 -0400
Received: by widjy10 with SMTP id jy10so88418314wid.1
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jul 2015 08:38:57 -0700 (PDT)
In-Reply-To: <20150702114837.GA16529@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2015-07-02 at 13:48 +0200, Florian Westphal wrote:

> My plan:
> 
> - move tee_active percpu varible to xtables core (suggested by Eric)
> - in do_table, check if we're TEE'd or not
> 
> 1. if no, then just use the jumpstack from offset 0 onwards.
> 2. If yes, then fetch jumpstack, and use the upper half:
> 
> if (__this_cpu_read(xt_tee_active))
>  	jumpstack += private->stacksize;

Or maybe not using a conditional

jumpstack += private->stacksize * __this_cpu_read(xt_tee_active);


BTW, I do not remember why I used a conditional in
xt_write_recseq_begin(). This also adds extra setup cost, as @addend has
to be preserved in the stack.

Hmm... What about something like :

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 286098a5667f..bee1484c18d2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -287,44 +287,28 @@ DECLARE_PER_CPU(seqcount_t, xt_recseq);
  * Begin packet processing : all readers must wait the end
  * 1) Must be called with preemption disabled
  * 2) softirqs must be disabled too (or we should use this_cpu_add())
- * Returns :
- *  1 if no recursion on this cpu
- *  0 if recursion detected
  */
-static inline unsigned int xt_write_recseq_begin(void)
+static inline void xt_write_recseq_begin(void)
 {
-	unsigned int addend;
-
-	/*
-	 * Low order bit of sequence is set if we already
-	 * called xt_write_recseq_begin().
-	 */
-	addend = (__this_cpu_read(xt_recseq.sequence) + 1) & 1;
-
-	/*
-	 * This is kind of a write_seqcount_begin(), but addend is 0 or 1
-	 * We dont check addend value to avoid a test and conditional jump,
-	 * since addend is most likely 1
+	/* This is kind of a write_seqcount_begin(),
+	 * but can be nested (no lockdep support)
 	 */
-	__this_cpu_add(xt_recseq.sequence, addend);
+	__this_cpu_inc(xt_recseq.sequence);
 	smp_wmb();
-
-	return addend;
 }
 
 /**
  * xt_write_recseq_end - end of a write section
- * @addend: return value from previous xt_write_recseq_begin()
  *
  * End packet processing : all readers can proceed
  * 1) Must be called with preemption disabled
  * 2) softirqs must be disabled too (or we should use this_cpu_add())
  */
-static inline void xt_write_recseq_end(unsigned int addend)
+static inline void xt_write_recseq_end(void)
 {
-	/* this is kind of a write_seqcount_end(), but addend is 0 or 1 */
+	/* this is kind of a write_seqcount_end() */
 	smp_wmb();
-	__this_cpu_add(xt_recseq.sequence, addend);
+	__this_cpu_inc(xt_recseq.sequence);
 }
 
 /*
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 95c9b6eece25..b34ac984bd7f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -259,7 +259,6 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	const void *table_base;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
-	unsigned int addend;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -268,7 +267,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	outdev = state->out ? state->out->name : nulldevname;
 
 	local_bh_disable();
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	private = table->private;
 	/*
 	 * Ensure we load private-> members after we've fetched the base
@@ -346,7 +345,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			/* Verdict */
 			break;
 	} while (!acpar.hotdrop);
-	xt_write_recseq_end(addend);
+	xt_write_recseq_end();
 	local_bh_enable();
 
 	if (acpar.hotdrop)
@@ -1130,7 +1129,6 @@ static int do_add_counters(struct net *net, const void __user *user,
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct arpt_entry *iter;
-	unsigned int addend;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1185,7 +1183,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 
 	i = 0;
 
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	xt_entry_foreach(iter,  private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1193,7 +1191,7 @@ static int do_add_counters(struct net *net, const void __user *user,
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
+	xt_write_recseq_end();
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6c72fbb7b49e..4c575fb623aa 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -299,7 +299,6 @@ ipt_do_table(struct sk_buff *skb,
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
-	unsigned int addend;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -321,7 +320,7 @@ ipt_do_table(struct sk_buff *skb,
 
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 	local_bh_disable();
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	private = table->private;
 	cpu        = smp_processor_id();
 	/*
@@ -426,7 +425,7 @@ ipt_do_table(struct sk_buff *skb,
 	pr_debug("Exiting %s; resetting sp from %u to %u\n",
 		 __func__, *stackptr, origptr);
 	*stackptr = origptr;
- 	xt_write_recseq_end(addend);
+ 	xt_write_recseq_end();
  	local_bh_enable();
 
 #ifdef DEBUG_ALLOW_ALL
@@ -1312,7 +1311,6 @@ do_add_counters(struct net *net, const void __user *user,
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct ipt_entry *iter;
-	unsigned int addend;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1366,7 +1364,7 @@ do_add_counters(struct net *net, const void __user *user,
 	}
 
 	i = 0;
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1374,7 +1372,7 @@ do_add_counters(struct net *net, const void __user *user,
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
+	xt_write_recseq_end();
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3c35ced39b42..d0f66a11ed90 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -327,7 +327,6 @@ ip6t_do_table(struct sk_buff *skb,
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
-	unsigned int addend;
 
 	/* Initialization */
 	indev = state->in ? state->in->name : nulldevname;
@@ -347,7 +346,7 @@ ip6t_do_table(struct sk_buff *skb,
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
 	local_bh_disable();
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	private = table->private;
 	/*
 	 * Ensure we load private-> members after we've fetched the base
@@ -439,7 +438,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	*stackptr = origptr;
 
- 	xt_write_recseq_end(addend);
+ 	xt_write_recseq_end();
  	local_bh_enable();
 
 #ifdef DEBUG_ALLOW_ALL
@@ -1325,7 +1324,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	const struct xt_table_info *private;
 	int ret = 0;
 	struct ip6t_entry *iter;
-	unsigned int addend;
+
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1379,7 +1378,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 	}
 
 	i = 0;
-	addend = xt_write_recseq_begin();
+	xt_write_recseq_begin();
 	xt_entry_foreach(iter, private->entries, private->size) {
 		struct xt_counters *tmp;
 
@@ -1387,7 +1386,7 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 		ADD_COUNTER(*tmp, paddc[i].bcnt, paddc[i].pcnt);
 		++i;
 	}
-	xt_write_recseq_end(addend);
+	xt_write_recseq_end();
  unlock_up_free:
 	local_bh_enable();
 	xt_table_unlock(t);





