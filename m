From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/64]: ip6_tables: use vmalloc_node()
Date: Tue, 18 Dec 2007 00:46:26 +0100 (MET)
Message-ID: <20071217234626.23601.30663.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbXLQXq1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:27 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: use vmalloc_node()

Consistently use vmalloc_node for all counter allocations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 125dae23b2336fed2aa57e04b0afc4b185610789
tree ae3efff9f9539a13155ed54bf63d7e0f6fbbafa1
parent e3dd889d718409e2ebd6010d6db111c5ee304804
author Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:09 +0100

 net/ipv6/netfilter/ip6_tables.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 655c221..d0b5fa6 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -959,7 +959,7 @@ copy_entries_to_user(unsigned int total_size,
 	   (other than comefrom, which userspace doesn't care
 	   about). */
 	countersize = sizeof(struct xt_counters) * private->number;
-	counters = vmalloc(countersize);
+	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
 		return -ENOMEM;
@@ -1080,7 +1080,8 @@ do_replace(void __user *user, unsigned int len)
 		goto free_newinfo;
 	}
 
-	counters = vmalloc(tmp.num_counters * sizeof(struct xt_counters));
+	counters = vmalloc_node(tmp.num_counters * sizeof(struct xt_counters),
+				numa_node_id());
 	if (!counters) {
 		ret = -ENOMEM;
 		goto free_newinfo;
@@ -1186,7 +1187,7 @@ do_add_counters(void __user *user, unsigned int len)
 	if (len != sizeof(tmp) + tmp.num_counters*sizeof(struct xt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc(len);
+	paddc = vmalloc_node(len, numa_node_id());
 	if (!paddc)
 		return -ENOMEM;
 
