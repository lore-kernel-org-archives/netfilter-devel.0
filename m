From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/64]: arp_tables: remove obsolete standard_check function
Date: Tue, 18 Dec 2007 00:46:45 +0100 (MET)
Message-ID: <20071217234645.23601.23429.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38952 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbXLQXqr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:47 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: remove obsolete standard_check function

The size check is already performed by xt_check_target, no need
to do it again.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 66239de91b46299cad80509607b1793dd6131925
tree 33383232c04cbdfab157a244bfdc96f66b1a2ae3
parent 04ec98b3abcf42330ae733de42af96e97128f083
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:05 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:54 +0100

 net/ipv4/netfilter/arp_tables.c |   28 +++-------------------------
 1 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d5cae7e..8b1842b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -435,23 +435,6 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int standard_check(const struct arpt_entry_target *t,
-				 unsigned int max_offset)
-{
-	/* Check standard info. */
-	if (t->u.target_size
-	    != ARPT_ALIGN(sizeof(struct arpt_standard_target))) {
-		duprintf("arpt_standard_check: target size %u != %Zu\n",
-			 t->u.target_size,
-			 ARPT_ALIGN(sizeof(struct arpt_standard_target)));
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct arpt_target arpt_standard_target;
-
 static inline int check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 			      unsigned int *i)
 {
@@ -486,14 +469,9 @@ static inline int check_entry(struct arpt_entry *e, const char *name, unsigned i
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target == &arpt_standard_target) {
-		if (!standard_check(t, size)) {
-			ret = -EINVAL;
-			goto err;
-		}
-	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      e->comefrom)) {
+	if (t->u.kernel.target->checkentry
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
