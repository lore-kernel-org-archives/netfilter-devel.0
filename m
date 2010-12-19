From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/11] kernel: use EXPORT_SYMBOL_GPL
Date: Sun, 19 Dec 2010 06:18:08 +0100
Message-ID: <1292735894-17534-7-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42669 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0LSFSW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:22 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 kernel/ip_set.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index c778670..e890bf8 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -186,7 +186,7 @@ const union nf_inet_addr prefixlen_netmask_map[] = {
 	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE),
 	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF),
 };
-EXPORT_SYMBOL(prefixlen_netmask_map);
+EXPORT_SYMBOL_GPL(prefixlen_netmask_map);
 
 #undef  E
 #define E(a, b, c, d) \
@@ -327,7 +327,7 @@ const union nf_inet_addr prefixlen_hostmask_map[] = {
 	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFE),
 	E(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF),
 };
-EXPORT_SYMBOL(prefixlen_hostmask_map);
+EXPORT_SYMBOL_GPL(prefixlen_hostmask_map);
 
 /*
  * The set types are implemented in modules and registered set types
@@ -441,7 +441,7 @@ unlock:
 	ip_set_type_unlock();
 	return ret;
 }
-EXPORT_SYMBOL(ip_set_type_register);
+EXPORT_SYMBOL_GPL(ip_set_type_register);
 
 /* Unregister a set type. There's a small race with ip_set_create */
 void
@@ -462,7 +462,7 @@ unlock:
 
 	synchronize_rcu();
 }
-EXPORT_SYMBOL(ip_set_type_unregister);
+EXPORT_SYMBOL_GPL(ip_set_type_unregister);
 
 /*
  * Creating/destroying/renaming/swapping affect the existence and
@@ -524,7 +524,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	/* Convert error codes to nomatch */
 	return (ret < 0 ? 0 : ret);
 }
-EXPORT_SYMBOL(ip_set_test);
+EXPORT_SYMBOL_GPL(ip_set_test);
 
 int
 ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
@@ -546,7 +546,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 
 	return ret;
 }
-EXPORT_SYMBOL(ip_set_add);
+EXPORT_SYMBOL_GPL(ip_set_add);
 
 int
 ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
@@ -568,7 +568,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 
 	return ret;
 }
-EXPORT_SYMBOL(ip_set_del);
+EXPORT_SYMBOL_GPL(ip_set_del);
 
 /*
  * Find set by name, reference it once. The reference makes sure the
@@ -593,7 +593,7 @@ ip_set_get_byname(const char *name, struct ip_set **set)
 
 	return index;
 }
-EXPORT_SYMBOL(ip_set_get_byname);
+EXPORT_SYMBOL_GPL(ip_set_get_byname);
 
 /*
  * If the given set pointer points to a valid set, decrement
@@ -610,7 +610,7 @@ ip_set_put_byindex(ip_set_id_t index)
 		__ip_set_put(index);
 	}
 }
-EXPORT_SYMBOL(ip_set_put_byindex);
+EXPORT_SYMBOL_GPL(ip_set_put_byindex);
 
 /*
  * Get the name of a set behind a set index.
@@ -631,7 +631,7 @@ ip_set_name_byindex(ip_set_id_t index)
 	/* Referenced, so it's safe */
 	return set->name;
 }
-EXPORT_SYMBOL(ip_set_name_byindex);
+EXPORT_SYMBOL_GPL(ip_set_name_byindex);
 
 /*
  * Routines to call by external subsystems, which do not
@@ -656,7 +656,7 @@ ip_set_nfnl_get(const char *name)
 
 	return index;
 }
-EXPORT_SYMBOL(ip_set_nfnl_get);
+EXPORT_SYMBOL_GPL(ip_set_nfnl_get);
 
 /*
  * Find set by index, reference it once. The reference makes sure the
@@ -679,7 +679,7 @@ ip_set_nfnl_get_byindex(ip_set_id_t index)
 
 	return index;
 }
-EXPORT_SYMBOL(ip_set_nfnl_get_byindex);
+EXPORT_SYMBOL_GPL(ip_set_nfnl_get_byindex);
 
 /*
  * If the given set pointer points to a valid set, decrement
@@ -698,7 +698,7 @@ ip_set_nfnl_put(ip_set_id_t index)
 	}
 	nfnl_unlock();
 }
-EXPORT_SYMBOL(ip_set_nfnl_put);
+EXPORT_SYMBOL_GPL(ip_set_nfnl_put);
 
 /*
  * Communication protocol with userspace over netlink.
-- 
1.7.1

