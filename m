From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/23] netfilter: x_tables: don't use seqlock when fetching old counters
Date: Tue,  7 Nov 2017 01:51:59 +0100
Message-ID: <20171107005213.22618-10-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58914 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934799AbdKGAxA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:53:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2F131F4B6F
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:52:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3221DA812
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:52:58 +0100 (CET)
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

after previous commit xt_replace_table will wait until all cpus
had even seqcount (i.e., no cpu is accessing old ruleset).

Add a 'old' counter retrival version that doesn't synchronize counters.
Its not needed, the old counters are not in use anymore at this point.

This speeds up table replacement on busy systems with large tables
(and many cores).

Cc: Dan Williams <dcbw@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 22 ++++++++++++++++++++--
 net/ipv4/netfilter/ip_tables.c  | 23 +++++++++++++++++++++--
 net/ipv6/netfilter/ip6_tables.c | 22 ++++++++++++++++++++--
 3 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 9e2770fd00be..f88221aebc9d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -634,6 +634,25 @@ static void get_counters(const struct xt_table_info *t,
 	}
 }
 
+static void get_old_counters(const struct xt_table_info *t,
+			     struct xt_counters counters[])
+{
+	struct arpt_entry *iter;
+	unsigned int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		i = 0;
+		xt_entry_foreach(iter, t->entries, t->size) {
+			struct xt_counters *tmp;
+
+			tmp = xt_get_per_cpu_counter(&iter->counters, cpu);
+			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
+			++i;
+		}
+		cond_resched();
+	}
+}
+
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
@@ -910,8 +929,7 @@ static int __do_replace(struct net *net, const char *name,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	/* Get the old counters, and synchronize with replace */
-	get_counters(oldinfo, counters);
+	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 39286e543ee6..4cbe5e80f3bf 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -781,6 +781,26 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
+static void get_old_counters(const struct xt_table_info *t,
+			     struct xt_counters counters[])
+{
+	struct ipt_entry *iter;
+	unsigned int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		i = 0;
+		xt_entry_foreach(iter, t->entries, t->size) {
+			const struct xt_counters *tmp;
+
+			tmp = xt_get_per_cpu_counter(&iter->counters, cpu);
+			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
+			++i; /* macro does multi eval of i */
+		}
+
+		cond_resched();
+	}
+}
+
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
@@ -1070,8 +1090,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	/* Get the old counters, and synchronize with replace */
-	get_counters(oldinfo, counters);
+	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
 	xt_entry_foreach(iter, oldinfo->entries, oldinfo->size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 01bd3ee5ebc6..f06e25065a34 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -800,6 +800,25 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
+static void get_old_counters(const struct xt_table_info *t,
+			     struct xt_counters counters[])
+{
+	struct ip6t_entry *iter;
+	unsigned int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		i = 0;
+		xt_entry_foreach(iter, t->entries, t->size) {
+			const struct xt_counters *tmp;
+
+			tmp = xt_get_per_cpu_counter(&iter->counters, cpu);
+			ADD_COUNTER(counters[i], tmp->bcnt, tmp->pcnt);
+			++i;
+		}
+		cond_resched();
+	}
+}
+
 static struct xt_counters *alloc_counters(const struct xt_table *table)
 {
 	unsigned int countersize;
@@ -1090,8 +1109,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	/* Get the old counters, and synchronize with replace */
-	get_counters(oldinfo, counters);
+	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
 	xt_entry_foreach(iter, oldinfo->entries, oldinfo->size)
-- 
2.11.0

