From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/7] netfilter: connlimit: improve packet-to-closed-connection logic
Date: Fri,  7 Mar 2014 14:37:10 +0100
Message-ID: <1394199435-14395-3-git-send-email-fw@strlen.de>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45171 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbaCGNlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:41:22 -0500
In-Reply-To: <1394199435-14395-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of freeing the entry from our list and then adding
it back again in the 'packet to closing connection' case just keep the
matching entry around.  Also drop the found_ct != NULL test as
nf_ct_tuplehash_to_ctrack is just container_of().

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_connlimit.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 6988818..d4c6db1 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -112,29 +112,22 @@ static int count_hlist(struct net *net,
 	hlist_for_each_entry_safe(conn, n, head, node) {
 		found    = nf_conntrack_find_get(net, NF_CT_DEFAULT_ZONE,
 						 &conn->tuple);
-		found_ct = NULL;
+		if (found == NULL) {
+			hlist_del(&conn->node);
+			kfree(conn);
+			continue;
+		}
 
-		if (found != NULL)
-			found_ct = nf_ct_tuplehash_to_ctrack(found);
+		found_ct = nf_ct_tuplehash_to_ctrack(found);
 
-		if (found_ct != NULL &&
-		    nf_ct_tuple_equal(&conn->tuple, tuple) &&
-		    !already_closed(found_ct))
+		if (nf_ct_tuple_equal(&conn->tuple, tuple)) {
 			/*
 			 * Just to be sure we have it only once in the list.
 			 * We should not see tuples twice unless someone hooks
 			 * this into a table without "-p tcp --syn".
 			 */
 			addit = false;
-
-		if (found == NULL) {
-			/* this one is gone */
-			hlist_del(&conn->node);
-			kfree(conn);
-			continue;
-		}
-
-		if (already_closed(found_ct)) {
+		} else if (already_closed(found_ct)) {
 			/*
 			 * we do not care about connections which are
 			 * closed already -> ditch it
-- 
1.8.1.5

