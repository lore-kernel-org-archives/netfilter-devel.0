From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH v2 2/3] netfilter: log: protect nf_log_register against double registering
Date: Fri, 24 Oct 2014 10:59:50 -0200
Message-ID: <dad1a3c1e30a676f3d17244ec74acef4dd0c9ca9.1414155204.git.mleitner@redhat.com>
References: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437AbaJXM76 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:59:58 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9OCxwl1013144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 08:59:58 -0400
Received: from localhost.localdomain.com (vpn1-6-197.gru2.redhat.com [10.97.6.197])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9OCxt4G024829
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 08:59:56 -0400
In-Reply-To: <12a99ae77aa9969692d847d8d2929deb13485e72.1414155204.git.mleitner@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, despite the comment right before the function,
nf_log_register allows registering two loggers on with the same type and
end up overwriting the previous register.

Not a real issue today as current tree doesn't have two loggers for the
same type but it's better to get this protected.

Also make sure that all of its callers do error checking.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---

Notes:
    v1->v2:
     - make use of pr_fmt
     - added err1 error handling flow
     - based on nft_log_dereference()

 net/ipv4/netfilter/nf_log_arp.c  | 12 +++++++++++-
 net/ipv4/netfilter/nf_log_ipv4.c | 12 +++++++++++-
 net/ipv6/netfilter/nf_log_ipv6.c | 12 +++++++++++-
 net/netfilter/nf_log.c           | 11 ++++++++++-
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_log_arp.c b/net/ipv4/netfilter/nf_log_arp.c
index ccfc78db12ee8acae68faf451f2cf6bc5597f2c1..0c8799a0c9e46df1bd414251c4d5661da024fae1 100644
--- a/net/ipv4/netfilter/nf_log_arp.c
+++ b/net/ipv4/netfilter/nf_log_arp.c
@@ -10,6 +10,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -130,8 +131,17 @@ static int __init nf_log_arp_init(void)
 	if (ret < 0)
 		return ret;
 
-	nf_log_register(NFPROTO_ARP, &nf_arp_logger);
+	ret = nf_log_register(NFPROTO_ARP, &nf_arp_logger);
+	if (ret < 0) {
+		pr_err("failed to register logger\n");
+		goto err1;
+	}
+
 	return 0;
+
+err1:
+	unregister_pernet_subsys(&nf_log_arp_net_ops);
+	return ret;
 }
 
 static void __exit nf_log_arp_exit(void)
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 078bdca1b607a167e05e7cf1bdfedccdd5aca92a..75101980eeee197a4f8413bbd7d29f4fd9e4bb74 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -366,8 +367,17 @@ static int __init nf_log_ipv4_init(void)
 	if (ret < 0)
 		return ret;
 
-	nf_log_register(NFPROTO_IPV4, &nf_ip_logger);
+	ret = nf_log_register(NFPROTO_IPV4, &nf_ip_logger);
+	if (ret < 0) {
+		pr_err("failed to register logger\n");
+		goto err1;
+	}
+
 	return 0;
+
+err1:
+	unregister_pernet_subsys(&nf_log_ipv4_net_ops);
+	return ret;
 }
 
 static void __exit nf_log_ipv4_exit(void)
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index 7b17a0be93e7eccb2a26cd3294713d0f1112158d..7fc34d1681a195ff071406811771b8327337db22 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -398,8 +399,17 @@ static int __init nf_log_ipv6_init(void)
 	if (ret < 0)
 		return ret;
 
-	nf_log_register(NFPROTO_IPV6, &nf_ip6_logger);
+	ret = nf_log_register(NFPROTO_IPV6, &nf_ip6_logger);
+	if (ret < 0) {
+		pr_err("failed to register logger\n");
+		goto err1;
+	}
+
 	return 0;
+
+err1:
+	unregister_pernet_subsys(&nf_log_ipv6_net_ops);
+	return ret;
 }
 
 static void __exit nf_log_ipv6_exit(void)
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index f1409d95f810c689ec70755eb8a85125d291ad47..e7c7439f48db590eba8f7f2eac61fafd9e571389 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -82,10 +82,19 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {
+		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+			if (nft_log_dereference(loggers[i][logger->type])) {
+				mutex_unlock(&nf_log_mutex);
+				return -EEXIST;
+			}
+		}
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 			rcu_assign_pointer(loggers[i][logger->type], logger);
 	} else {
-		/* register at end of list to honor first register win */
+		if (nft_log_dereference(loggers[pf][logger->type])) {
+			mutex_unlock(&nf_log_mutex);
+			return -EEXIST;
+		}
 		rcu_assign_pointer(loggers[pf][logger->type], logger);
 	}
 
-- 
1.9.3

