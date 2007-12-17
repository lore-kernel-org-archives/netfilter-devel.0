From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/64]: ip6_tables: use raw_smp_processor_id() in do_add_counters()
Date: Tue, 18 Dec 2007 00:46:41 +0100 (MET)
Message-ID: <20071217234641.23601.8745.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38943 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbXLQXqn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:43 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: use raw_smp_processor_id() in do_add_counters()

Use raw_smp_processor_id() in do_add_counters() as in ip_tables.c.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d9026f418b057074d1c9b26df8197b7e5c3f222d
tree 422de5bfc8fda5e7c1dc68a82ffe691350cb2ba9
parent 1b0a8a3ff781362fdb71d2f5003b74f3c171566e
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:01 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:54 +0100

 net/ipv6/netfilter/ip6_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index fc4c62f..d910d56 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1420,7 +1420,7 @@ do_add_counters(void __user *user, unsigned int len, int compat)
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
