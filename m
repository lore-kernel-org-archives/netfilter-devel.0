From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] netfilter: xtables: remove unused defines
Date: Wed, 13 Oct 2010 20:03:22 +0200
Message-ID: <1286993003-3444-6-git-send-email-jengelh@medozas.de>
References: <1286993003-3444-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43239 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab0JMSDa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:03:30 -0400
In-Reply-To: <1286993003-3444-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_arp/arp_tables.h  |    4 ----
 include/linux/netfilter_ipv4/ip_tables.h  |    4 ----
 include/linux/netfilter_ipv6/ip6_tables.h |    4 ----
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index f02d574..adbf4bf 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -255,8 +255,6 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct net_device *out,
 				  struct xt_table *table);
 
-#define ARPT_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -275,8 +273,6 @@ compat_arpt_get_target(struct compat_arpt_entry *e)
 	return (void *)e + e->target_offset;
 }
 
-#define COMPAT_ARPT_ALIGN(s)	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _ARPTABLES_H */
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index d0fef0a..64a5d95 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -282,8 +282,6 @@ extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 const struct net_device *out,
 				 struct xt_table *table);
 
-#define IPT_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -304,8 +302,6 @@ compat_ipt_get_target(struct compat_ipt_entry *e)
 	return (void *)e + e->target_offset;
 }
 
-#define COMPAT_IPT_ALIGN(s) 	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index dca1118..c9784f7 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -292,8 +292,6 @@ extern int ip6t_ext_hdr(u8 nexthdr);
 extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 			 int target, unsigned short *fragoff);
 
-#define IP6T_ALIGN(s) XT_ALIGN(s)
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -313,8 +311,6 @@ compat_ip6t_get_target(struct compat_ip6t_entry *e)
 	return (void *)e + e->target_offset;
 }
 
-#define COMPAT_IP6T_ALIGN(s)	COMPAT_XT_ALIGN(s)
-
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
-- 
1.7.1

