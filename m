From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 1/3] netfilter: x_tables: pass xt_counters struct instead of packet counter
Date: Mon, 21 Nov 2016 23:07:14 +0100
Message-ID: <1479766036-1307-2-git-send-email-fw@strlen.de>
References: <1479766036-1307-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40256 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754434AbcKUWHM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 17:07:12 -0500
In-Reply-To: <1479766036-1307-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On SMP we overload the packet counter (unsigned long) to contain
percpu offset.  Hide this from callers and pass xt_counters address
instead.

Preparation patch to allocate the percpu counters in page-sized batch
chunks.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <edumazet@google.com>
---
 No changes since v1.

 include/linux/netfilter/x_tables.h | 6 +-----
 net/ipv4/netfilter/arp_tables.c    | 4 ++--
 net/ipv4/netfilter/ip_tables.c     | 4 ++--
 net/ipv6/netfilter/ip6_tables.c    | 5 ++---
 net/netfilter/x_tables.c           | 9 +++++++++
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index cd4eaf8df445..6e61edeb68e3 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -430,11 +430,7 @@ static inline unsigned long xt_percpu_counter_alloc(void)
 
 	return 0;
 }
-static inline void xt_percpu_counter_free(u64 pcnt)
-{
-	if (nr_cpu_ids > 1)
-		free_percpu((void __percpu *) (unsigned long) pcnt);
-}
+void xt_percpu_counter_free(struct xt_counters *cnt);
 
 static inline struct xt_counters *
 xt_get_this_cpu_counter(struct xt_counters *cnt)
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 39004da318e2..22de2b6aaec9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -439,7 +439,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 err:
 	module_put(t->u.kernel.target->me);
 out:
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -519,7 +519,7 @@ static inline void cleanup_entry(struct arpt_entry *e)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 46815c8a60d7..acc9a0c45bdf 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -582,7 +582,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 		cleanup_match(ematch, net);
 	}
 
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -670,7 +670,7 @@ cleanup_entry(struct ipt_entry *e, struct net *net)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 6ff42b8301cc..88b56a98905b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -612,7 +612,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 		cleanup_match(ematch, net);
 	}
 
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 
 	return ret;
 }
@@ -699,8 +699,7 @@ static void cleanup_entry(struct ip6t_entry *e, struct net *net)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
-
-	xt_percpu_counter_free(e->counters.pcnt);
+	xt_percpu_counter_free(&e->counters);
 }
 
 /* Checks and translates the user-supplied table segment (held in
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ad818e52859b..0580029eb0ee 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1615,6 +1615,15 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_proto_fini);
 
+void xt_percpu_counter_free(struct xt_counters *counters)
+{
+	unsigned long pcnt = counters->pcnt;
+
+	if (nr_cpu_ids > 1)
+		free_percpu((void __percpu *)pcnt);
+}
+EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
+
 static int __net_init xt_net_init(struct net *net)
 {
 	int i;
-- 
2.7.3

