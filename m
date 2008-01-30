From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/69]: netns: put table module on netns stop
Date: Wed, 30 Jan 2008 21:17:25 +0100 (MET)
Message-ID: <20080130201722.29874.53922.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60693 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYA3UR2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:28 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: netns: put table module on netns stop

When number of entries exceeds number of initial entries, foo-tables code
will pin table module. But during table unregister on netns stop,
that additional pin was forgotten.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5925cf9534dffe7165056399a6911609bd1fb44b
tree f3085e7975b409f6ea2f5d6c56adc9abdd13aadc
parent e612deed898a9b2984bd7c2f4fef1a5a93f8160b
author Alexey Dobriyan <adobriyan@sw.ru> Tue, 29 Jan 2008 16:22:02 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:17 +0100

 net/ipv4/netfilter/arp_tables.c |    3 +++
 net/ipv4/netfilter/ip_tables.c  |    3 +++
 net/ipv6/netfilter/ip6_tables.c |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ec64b67..3608675 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1773,6 +1773,7 @@ void arpt_unregister_table(struct arpt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
 
 	private = xt_unregister_table(table);
 
@@ -1780,6 +1781,8 @@ void arpt_unregister_table(struct arpt_table *table)
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	ARPT_ENTRY_ITERATE(loc_cpu_entry, private->size,
 			   cleanup_entry, NULL);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
 	xt_free_table_info(private);
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c1b80f4..427bc9b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2095,12 +2095,15 @@ void ipt_unregister_table(struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
 
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	IPT_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, NULL);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
 	xt_free_table_info(private);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2453dfd..6fabb73 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2121,12 +2121,15 @@ void ip6t_unregister_table(struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
+	struct module *table_owner = table->me;
 
 	private = xt_unregister_table(table);
 
 	/* Decrease module usage counts and free resources */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry, private->size, cleanup_entry, NULL);
+	if (private->number > private->initial_entries)
+		module_put(table_owner);
 	xt_free_table_info(private);
 }
 
