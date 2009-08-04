From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 019/103] netfilter: xtables: check for unconditionality of policies
Date: Tue,  4 Aug 2009 09:25:03 +0200
Message-ID: <1249370787-17583-20-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbZHDH0y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:54 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   12 +++++++-----
 net/ipv4/netfilter/ip_tables.c  |   11 +++++++----
 net/ipv6/netfilter/ip6_tables.c |   12 +++++++-----
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d91f083..064082d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -8,7 +8,7 @@
  * Copyright (C) 2002 David S. Miller (davem@redhat.com)
  *
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
@@ -563,13 +563,15 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 			continue;
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
-		if ((unsigned char *)e - base == underflows[h])
+		if ((unsigned char *)e - base == underflows[h]) {
+			if (!unconditional(&e->arp)) {
+				pr_err("Underflows must be unconditional\n");
+				return -EINVAL;
+			}
 			newinfo->underflow[h] = underflows[h];
+		}
 	}
 
-	/* FIXME: underflows must be unconditional, standard verdicts
-	   < 0 (not ARPT_RETURN). --RR */
-
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6e7b7e8..6e546d5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -8,6 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/cache.h>
 #include <linux/capability.h>
 #include <linux/skbuff.h>
@@ -738,13 +739,15 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 			continue;
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
-		if ((unsigned char *)e - base == underflows[h])
+		if ((unsigned char *)e - base == underflows[h]) {
+			if (!unconditional(&e->ip)) {
+				pr_err("Underflows must be unconditional\n");
+				return -EINVAL;
+			}
 			newinfo->underflow[h] = underflows[h];
+		}
 	}
 
-	/* FIXME: underflows must be unconditional, standard verdicts
-	   < 0 (not IPT_RETURN). --RR */
-
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 8e4921a..b0599b9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -8,7 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/capability.h>
 #include <linux/in.h>
 #include <linux/skbuff.h>
@@ -771,13 +771,15 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 			continue;
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
-		if ((unsigned char *)e - base == underflows[h])
+		if ((unsigned char *)e - base == underflows[h]) {
+			if (!unconditional(&e->ipv6)) {
+				pr_err("Underflows must be unconditional\n");
+				return -EINVAL;
+			}
 			newinfo->underflow[h] = underflows[h];
+		}
 	}
 
-	/* FIXME: underflows must be unconditional, standard verdicts
-	   < 0 (not IP6T_RETURN). --RR */
-
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
-- 
1.6.3.3

