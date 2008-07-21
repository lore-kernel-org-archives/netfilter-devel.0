From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/08: nf_nat_core: eliminate useless find_appropriate_src for IP_NAT_RANGE_PROTO_RANDOM
Date: Mon, 21 Jul 2008 18:17:24 +0200 (MEST)
Message-ID: <20080721161724.28572.91589.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41609 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYGUQRZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:25 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_nat_core: eliminate useless find_appropriate_src for IP_NAT_RANGE_PROTO_RANDOM

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7af3d4eb70fd3a310c56c7080d7d09fc64ddd6a7
tree 4c1d98c3e69cad567b624f8fde71bf0cc6d358e1
parent 3a682fbd732d3d27bec722a923952b0938e8a404
author Changli Gao <xiaosuo@gmail.com> Mon, 21 Jul 2008 16:25:17 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 16:25:17 +0200

 net/ipv4/netfilter/nf_nat_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index d2a887f..6c6a3cb 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -240,12 +240,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	   This is only required for source (ie. NAT/masq) mappings.
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
-	if (maniptype == IP_NAT_MANIP_SRC) {
+	if (maniptype == IP_NAT_MANIP_SRC &&
+	    !(range->flags & IP_NAT_RANGE_PROTO_RANDOM)) {
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			pr_debug("get_unique_tuple: Found current src map\n");
-			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
-				if (!nf_nat_used_tuple(tuple, ct))
-					return;
+			if (!nf_nat_used_tuple(tuple, ct))
+				return;
 		}
 	}
 
