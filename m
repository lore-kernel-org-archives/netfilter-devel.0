From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/5] netfilter: conntrack: restart iteration on resize
Date: Sun, 21 May 2017 12:52:58 +0200
Message-ID: <20170521105259.10239-5-fw@strlen.de>
References: <20170521105259.10239-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37108 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752440AbdEUKxA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:53:00 -0400
In-Reply-To: <20170521105259.10239-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We could some conntracks when a resize occurs in parallel.

Avoid this by sampling generation seqcnt and doing a restart if needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7ecee79c78b8..c3bd9b086dcc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1623,17 +1623,25 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 				  void *data, u32 portid, int report)
 {
+	unsigned int bucket = 0, sequence;
 	struct nf_conn *ct;
-	unsigned int bucket = 0;
 
 	might_sleep();
 
-	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
-		/* Time to push up daises... */
+	for (;;) {
+		sequence = read_seqcount_begin(&nf_conntrack_generation);
 
-		nf_ct_delete(ct, portid, report);
-		nf_ct_put(ct);
-		cond_resched();
+		while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
+			/* Time to push up daises... */
+
+			nf_ct_delete(ct, portid, report);
+			nf_ct_put(ct);
+			cond_resched();
+		}
+
+		if (!read_seqcount_retry(&nf_conntrack_generation, sequence))
+			break;
+		bucket = 0;
 	}
 }
 
-- 
2.13.0

