From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/23] netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore
Date: Tue,  7 Nov 2017 01:51:58 +0100
Message-ID: <20171107005213.22618-9-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.11.0
