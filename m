From: Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH v3 1/3] netfilter: log: protect nf_log_register against double registering
Date: Wed, 29 Oct 2014 10:04:52 -0200
Message-ID: <7be00bf663b212d4984414346da216cf17d3443d.1414584011.git.mleitner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbaJ2MFG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:05:06 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9TC56OQ001628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:05:06 -0400
Received: from localhost.localdomain.com (vpn1-7-3.gru2.redhat.com [10.97.7.3])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9TC54SR026188
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2014 08:05:05 -0400
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
 net/ipv4/netfilter/nf_log_arp.c  | 12 +++++++++++-
 net/ipv4/netfilter/nf_log_ipv4.c | 12 +++++++++++-
 net/ipv6/netfilter/nf_log_ipv6.c | 12 +++++++++++-
 net/netfilter/nf_log.c           | 16 +++++++++++++---
 4 files changed, 46 insertions(+), 6 deletions(-)

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
index 5eaf047ed37facad0df59e70428c08ef8717a70d..9562e393fdf7e178b0c48bff25ace88495c2224f 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -75,6 +75,7 @@ EXPORT_SYMBOL(nf_log_unset);
 int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 {
 	int i;
+	int ret = 0;
 
 	if (pf >= ARRAY_SIZE(init_net.nf.nf_loggers))
 		return -EINVAL;
@@ -82,16 +83,25 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {
+		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
+			if (rcu_access_pointer(loggers[i][logger->type])) {
+				ret = -EEXIST;
+				goto unlock;
+			}
+		}
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 			rcu_assign_pointer(loggers[i][logger->type], logger);
 	} else {
-		/* register at end of list to honor first register win */
+		if (rcu_access_pointer(loggers[pf][logger->type])) {
+			ret = -EEXIST;
+			goto unlock;
+		}
 		rcu_assign_pointer(loggers[pf][logger->type], logger);
 	}
 
+unlock:
 	mutex_unlock(&nf_log_mutex);
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(nf_log_register);
 
-- 
1.9.3

