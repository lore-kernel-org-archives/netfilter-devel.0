From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nat: use test_and_clear_bit when deleting ct from bysource list
Date: Thu,  5 Oct 2017 16:46:45 +0200
Message-ID: <20171005144645.26616-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60050 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751366AbdJEOq1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2017 10:46:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use a single statement for this.
While at it, fixup the comment -- we don't have pernet table/ops
anymore, the function is only called from module exit path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This isn't a bug fix, nf_nat_proto_clean() is only called
 from module exit path so its not invoked concurrently.

 Nevertheless, I think its better to use single check/clear for this.
 If you disagree, just let me know and I can send a patch that only
 contains the comment change.

 net/netfilter/nf_nat_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af8345fc4fbd..6c38421e31f9 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -542,17 +542,14 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	if (nf_nat_proto_remove(ct, data))
 		return 1;
 
-	if ((ct->status & IPS_SRC_NAT_DONE) == 0)
-		return 0;
-
-	/* This netns is being destroyed, and conntrack has nat null binding.
+	/* This module is being removed and conntrack has nat null binding.
 	 * Remove it from bysource hash, as the table will be freed soon.
 	 *
 	 * Else, when the conntrack is destoyed, nf_nat_cleanup_conntrack()
 	 * will delete entry from already-freed table.
 	 */
-	clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
-	__nf_nat_cleanup_conntrack(ct);
+	if (test_and_clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status))
+		__nf_nat_cleanup_conntrack(ct);
 
 	/* don't delete conntrack.  Although that would make things a lot
 	 * simpler, we'd end up flushing all conntracks on nat rmmod.
-- 
2.13.6

