From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/64]: arp_tables: use vmalloc_node()
Date: Tue, 18 Dec 2007 00:46:48 +0100 (MET)
Message-ID: <20071217234648.23601.54467.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38958 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbXLQXqu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:50 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: use vmalloc_node()

Use vmalloc_node() as in ip_tables.c.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5f2cccb0c367783a5207f378237c5e84c1654343
tree a85b8dfd23743d56b2bddcd396c5d32db0c6d176
parent 9cd44c2375b2d30c90e0bef6d8a61b49f986ee17
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:08 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:55 +0100

 net/ipv4/netfilter/arp_tables.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 8b1842b..fb4d779 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -804,7 +804,8 @@ static int do_replace(void __user *user, unsigned int len)
 		goto free_newinfo;
 	}
 
-	counters = vmalloc(tmp.num_counters * sizeof(struct xt_counters));
+	counters = vmalloc_node(tmp.num_counters * sizeof(struct xt_counters),
+				numa_node_id());
 	if (!counters) {
 		ret = -ENOMEM;
 		goto free_newinfo;
@@ -902,7 +903,7 @@ static int do_add_counters(void __user *user, unsigned int len)
 	if (len != sizeof(tmp) + tmp.num_counters*sizeof(struct xt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc(len);
+	paddc = vmalloc_node(len, numa_node_id());
 	if (!paddc)
 		return -ENOMEM;
 
