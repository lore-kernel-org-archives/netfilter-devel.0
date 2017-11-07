From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/23] netfilter: nat: use test_and_clear_bit when deleting ct from bysource list
Date: Tue,  7 Nov 2017 01:51:54 +0100
Message-ID: <20171107005213.22618-5-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58848 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934737AbdKGAwo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:52:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DB7D1F4B72
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:52:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2AB4DA78E
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:52:42 +0100 (CET)
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

We can use a single statement for this.
While at it, fixup the comment -- we don't have pernet table/ops
anymore, the function is only called from module exit path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.11.0

