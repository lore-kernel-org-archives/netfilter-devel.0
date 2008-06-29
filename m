From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 2/6] ipset/iptreemap: Use min/max from kernel.h
Date: Sun, 29 Jun 2008 19:44:59 +0200
Message-ID: <1214761503-1713-3-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44950 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYF2RpQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:16 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use min/max from kernel.h instead of defining our own.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 .../net/ipv4/netfilter/ip_set_iptreemap.c          |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
index fcf882e..dfd486a 100644
--- a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
+++ b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/version.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ip.h>
 #include <linux/skbuff.h>
@@ -186,9 +187,6 @@ static struct ip_set_iptreemap_b *fullbitmap_b;
 #define LOOP_WALK_END_COUNT() \
 	}
 
-#define MIN(a, b) (a < b ? a : b)
-#define MAX(a, b) (a > b ? a : b)
-
 #define GETVALUE1(a, a1, b1, r) \
 	(a == a1 ? b1 : r)
 
@@ -377,7 +375,7 @@ addip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 		return -EINVAL;
 	}
 
-	return __addip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip);
+	return __addip_range(set, min(req->start, req->end), max(req->start, req->end), hash_ip);
 }
 
 static int
@@ -464,7 +462,7 @@ delip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 		return -EINVAL;
 	}
 
-	return __delip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip, GFP_KERNEL);
+	return __delip_range(set, min(req->start, req->end), max(req->start, req->end), hash_ip, GFP_KERNEL);
 }
 
 static int
-- 
1.5.6.1

