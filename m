From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/5] netfilter: x_tables: add and use xt_check_entry_target
Date: Tue, 22 Mar 2016 18:02:51 +0100
Message-ID: <1458666173-24318-4-git-send-email-fw@strlen.de>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38138 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261AbcCVRCq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:02:46 -0400
In-Reply-To: <1458666173-24318-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have targets and standard targets -- the latter carries a verdict, so we
must check the standard size as well here -- later functions access t->verdict
which otherwise can point after the blob end.

Spotted with UBSAN.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  3 +++
 net/ipv4/netfilter/arp_tables.c    | 11 +----------
 net/ipv4/netfilter/ip_tables.c     | 12 +-----------
 net/ipv6/netfilter/ip6_tables.c    | 12 +-----------
 net/netfilter/x_tables.c           | 22 ++++++++++++++++++++++
 5 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 80a305b..9e7153e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -413,6 +413,9 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
 
+int xt_check_entry_target(const void *base, unsigned int target_offset,
+			  unsigned int next_offset);
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 51d4fe5..59a9610 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -476,19 +476,10 @@ next:
 
 static inline int check_entry(const struct arpt_entry *e)
 {
-	const struct xt_entry_target *t;
-
 	if (!arp_checkentry(&e->arp))
 		return -EINVAL;
 
-	if (e->target_offset + sizeof(struct xt_entry_target) > e->next_offset)
-		return -EINVAL;
-
-	t = arpt_get_target_c(e);
-	if (e->target_offset + t->u.target_size > e->next_offset)
-		return -EINVAL;
-
-	return 0;
+	return xt_check_entry_target(e, e->target_offset, e->next_offset);
 }
 
 static inline int check_target(struct arpt_entry *e, const char *name)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fb7694e..1acc6ee 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -571,20 +571,10 @@ static void cleanup_match(struct xt_entry_match *m, struct net *net)
 static int
 check_entry(const struct ipt_entry *e)
 {
-	const struct xt_entry_target *t;
-
 	if (!ip_checkentry(&e->ip))
 		return -EINVAL;
 
-	if (e->target_offset + sizeof(struct xt_entry_target) >
-	    e->next_offset)
-		return -EINVAL;
-
-	t = ipt_get_target_c(e);
-	if (e->target_offset + t->u.target_size > e->next_offset)
-		return -EINVAL;
-
-	return 0;
+	return xt_check_entry_target(e, e->target_offset, e->next_offset);
 }
 
 static int
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b248528f..29e2113 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -583,20 +583,10 @@ static void cleanup_match(struct xt_entry_match *m, struct net *net)
 static int
 check_entry(const struct ip6t_entry *e)
 {
-	const struct xt_entry_target *t;
-
 	if (!ip6_checkentry(&e->ipv6))
 		return -EINVAL;
 
-	if (e->target_offset + sizeof(struct xt_entry_target) >
-	    e->next_offset)
-		return -EINVAL;
-
-	t = ip6t_get_target_c(e);
-	if (e->target_offset + t->u.target_size > e->next_offset)
-		return -EINVAL;
-
-	return 0;
+	return xt_check_entry_target(e, e->target_offset, e->next_offset);
 }
 
 static int check_match(struct xt_entry_match *m, struct xt_mtchk_param *par)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 582c9cf..c10f9b3 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -541,6 +541,28 @@ int xt_compat_match_to_user(const struct xt_entry_match *m,
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
+/* check that arp/ip/ip6t_entry target_offset is sane */
+int xt_check_entry_target(const void *base, unsigned int target_offset,
+			  unsigned int next_offset)
+{
+	const struct xt_entry_target *t;
+	const char *e = base;
+
+	if (target_offset + sizeof(struct xt_entry_target) > next_offset)
+		return -EINVAL;
+
+	t = (void *) (e + target_offset);
+	if (target_offset + t->u.target_size > next_offset)
+		return -EINVAL;
+
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
+	    target_offset + sizeof(struct xt_standard_target) > next_offset)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(xt_check_entry_target);
+
 int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
-- 
2.4.10

