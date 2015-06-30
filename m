From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: arptables: use percpu jumpstack
Date: Tue, 30 Jun 2015 22:21:00 +0200
Message-ID: <1435695660-26048-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50185 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbbF3UVH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2015 16:21:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 482cfc318559 ("netfilter: xtables: avoid percpu ruleset duplication")

Unlike ip and ip6tables, arp tables were never converted to use the percpu
jump stack.

It still uses the rule blob to store return address, which isn't safe
anymore since we now share this blob among all processors.

Because there is no TEE support for arptables, we don't need to cope
with reentrancy, so we can use loocal variable to hold stack offset.

Fixes: 482cfc318559 ("netfilter: xtables: avoid percpu ruleset duplication")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 95c9b6e..0fbe1a6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -254,9 +254,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
 	const struct arphdr *arp;
-	struct arpt_entry *e, *back;
+	struct arpt_entry *e, **jumpstack;
 	const char *indev, *outdev;
 	const void *table_base;
+	unsigned int cpu, stackidx = 0;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
 	unsigned int addend;
@@ -270,15 +271,16 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
 	private = table->private;
+	cpu     = smp_processor_id();
 	/*
 	 * Ensure we load private-> members after we've fetched the base
 	 * pointer.
 	 */
 	smp_read_barrier_depends();
 	table_base = private->entries;
+	jumpstack  = (struct arpt_entry **)private->jumpstack[cpu];
 
 	e = get_entry(table_base, private->hook_entry[hook]);
-	back = get_entry(table_base, private->underflow[hook]);
 
 	acpar.in      = state->in;
 	acpar.out     = state->out;
@@ -312,18 +314,23 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 					verdict = (unsigned int)(-v) - 1;
 					break;
 				}
-				e = back;
-				back = get_entry(table_base, back->comefrom);
+				if (stackidx == 0) {
+					e = get_entry(table_base,
+						      private->underflow[hook]);
+				} else {
+					e = jumpstack[--stackidx];
+					e = arpt_next_entry(e);
+				}
 				continue;
 			}
 			if (table_base + v
 			    != arpt_next_entry(e)) {
-				/* Save old back ptr in next entry */
-				struct arpt_entry *next = arpt_next_entry(e);
-				next->comefrom = (void *)back - table_base;
 
-				/* set back pointer to next entry */
-				back = next;
+				if (WARN_ON_ONCE(stackidx >= private->stacksize)) {
+					verdict = NF_DROP;
+					break;
+				}
+				jumpstack[stackidx++] = e;
 			}
 
 			e = get_entry(table_base, v);
-- 
2.0.5

