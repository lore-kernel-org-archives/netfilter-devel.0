From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 1/2] netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore
Date: Thu, 12 Oct 2017 01:13:50 +0200
Message-ID: <20171011231351.8517-2-fw@strlen.de>
References: <20171011231351.8517-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>, Dan Williams <dcbw@redhat.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43444 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751694AbdJKXNg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 19:13:36 -0400
In-Reply-To: <20171011231351.8517-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_replace_table relies on table replacement counter retrieval (which
uses xt_recseq to synchronize pcpu counters).

This is fine, however with large rule set get_counters() can take
a very long time -- it needs to synchronize all counters because
it has to assume concurrent modifications can occur.

Make xt_replace_table synchronize by itself by waiting until all cpus
had an even seqcount.

This allows a followup patch to copy the counters of the old ruleset
without any synchonization after xt_replace_table has completed.

Cc: Dan Williams <dcbw@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v4: add smb_wmb to make sure ->private is visible
 before checking xt_recseq
 v3: also continue if seq has changed in any way

 net/netfilter/x_tables.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index c83a3b5e1c6c..a164e5123d59 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1153,6 +1153,7 @@ xt_replace_table(struct xt_table *table,
 	      int *error)
 {
 	struct xt_table_info *private;
+	unsigned int cpu;
 	int ret;
 
 	ret = xt_jumpstack_alloc(newinfo);
@@ -1182,14 +1183,28 @@ xt_replace_table(struct xt_table *table,
 	smp_wmb();
 	table->private = newinfo;
 
+	/* make sure all cpus see new ->private value */
+	smp_wmb();
+
 	/*
 	 * Even though table entries have now been swapped, other CPU's
-	 * may still be using the old entries. This is okay, because
-	 * resynchronization happens because of the locking done
-	 * during the get_counters() routine.
+	 * may still be using the old entries...
 	 */
 	local_bh_enable();
 
+	/* ... so wait for even xt_recseq on all cpus */
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
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
 		audit_log(current->audit_context, GFP_KERNEL,
-- 
2.13.6

