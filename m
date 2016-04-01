From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 06/17] netfilter: x_tables: add compat version of xt_check_entry_offsets
Date: Fri,  1 Apr 2016 14:17:26 +0200
Message-ID: <1459513057-30652-7-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46468 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135AbcDAMRk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:17:40 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

32bit rulesets have different layout and alignment requirements, so once
more integrity checks get added to xt_check_entry_offsets it will reject
well-formed 32bit rulesets.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  3 +++
 net/ipv4/netfilter/arp_tables.c    |  3 ++-
 net/ipv4/netfilter/ip_tables.c     |  3 ++-
 net/ipv6/netfilter/ip6_tables.c    |  3 ++-
 net/netfilter/x_tables.c           | 22 ++++++++++++++++++++++
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 0de0862..08de48b 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -494,6 +494,9 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 				unsigned int *size);
 int xt_compat_target_to_user(const struct xt_entry_target *t,
 			     void __user **dstptr, unsigned int *size);
+int xt_compat_check_entry_offsets(const void *base,
+				  unsigned int target_offset,
+				  unsigned int next_offset);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _X_TABLES_H */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 24ad92a..ab8952a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1254,7 +1254,8 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	if (!arp_checkentry(&e->arp))
 		return -EINVAL;
 
-	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
+	ret = xt_compat_check_entry_offsets(e, e->target_offset,
+					    e->next_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cdf1850..7d24c87 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1513,7 +1513,8 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	if (!ip_checkentry(&e->ip))
 		return -EINVAL;
 
-	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
+	ret = xt_compat_check_entry_offsets(e,
+					    e->target_offset, e->next_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e378311..73eee7b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1525,7 +1525,8 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	if (!ip6_checkentry(&e->ipv6))
 		return -EINVAL;
 
-	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
+	ret = xt_compat_check_entry_offsets(e,
+					    e->target_offset, e->next_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index ec1b718..fa206ce 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -539,6 +539,27 @@ int xt_compat_match_to_user(const struct xt_entry_match *m,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
+
+int xt_compat_check_entry_offsets(const void *base,
+				  unsigned int target_offset,
+				  unsigned int next_offset)
+{
+	const struct compat_xt_entry_target *t;
+	const char *e = base;
+
+	if (target_offset + sizeof(*t) > next_offset)
+		return -EINVAL;
+
+	t = (void *)(e + target_offset);
+	if (t->u.target_size < sizeof(*t))
+		return -EINVAL;
+
+	if (target_offset + t->u.target_size > next_offset)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(xt_compat_check_entry_offsets);
 #endif /* CONFIG_COMPAT */
 
 /**
@@ -549,6 +570,7 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
  * @next_offset: the arp/ip/ip6_t->next_offset
  *
  * validates that target_offset and next_offset are sane.
+ * Also see xt_compat_check_entry_offsets for CONFIG_COMPAT version.
  *
  * The arp/ip/ip6t_entry structure @base must have passed following tests:
  * - it must point to a valid memory location
-- 
2.7.3

