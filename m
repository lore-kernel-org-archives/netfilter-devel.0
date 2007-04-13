From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: {eb, ip6,
	ip}t_LOG: remove remains of LOG target overloading
Date: Fri, 13 Apr 2007 05:00:13 +0200 (MEST)
Message-ID: <20070413025928.29875.93990.sendpatchset@localhost.localdomain>
References: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: {eb,ip6,ip}t_LOG: remove remains of LOG target overloading

All LOG targets always use their internal logging function nowadays, so
remove the incorrect error message and handle real errors (!= -EEXIST)
by failing to load.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 474508878b875d838ec122f84193e48ea492f560
tree 95c52389ac63948adcb8361e20823f60461498f2
parent 794931007064900f96c05544fbed41ef194884c8
author Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:23 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 13 Apr 2007 04:43:23 +0200

 net/bridge/netfilter/ebt_log.c |   12 ++++--------
 net/ipv4/netfilter/ipt_LOG.c   |   12 ++++--------
 net/ipv6/netfilter/ip6t_LOG.c  |   12 ++++--------
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 45712ae..031bfa4 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -196,14 +196,10 @@ static int __init ebt_log_init(void)
 	ret = ebt_register_watcher(&log);
 	if (ret < 0)
 		return ret;
-	if (nf_log_register(PF_BRIDGE, &ebt_log_logger) < 0) {
-		printk(KERN_WARNING "ebt_log: not logging via system console "
-		       "since somebody else already registered for PF_INET\n");
-		/* we cannot make module load fail here, since otherwise
-		 * ebtables userspace would abort */
-	}
-
-	return 0;
+	ret = nf_log_register(PF_BRIDGE, &ebt_log_logger);
+	if (ret < 0 && ret != -EEXIST)
+		ebt_unregister_watcher(&log);
+	return ret;
 }
 
 static void __exit ebt_log_fini(void)
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 2fa3661..a42c5cd 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -477,14 +477,10 @@ static int __init ipt_log_init(void)
 	ret = xt_register_target(&ipt_log_reg);
 	if (ret < 0)
 		return ret;
-	if (nf_log_register(PF_INET, &ipt_log_logger) < 0) {
-		printk(KERN_WARNING "ipt_LOG: not logging via system console "
-		       "since somebody else already registered for PF_INET\n");
-		/* we cannot make module load fail here, since otherwise
-		 * iptables userspace would abort */
-	}
-
-	return 0;
+	ret = nf_log_register(PF_INET, &ipt_log_logger);
+	if (ret < 0 && ret != -EEXIST)
+		xt_unregister_target(&ipt_log_reg);
+	return ret;
 }
 
 static void __exit ipt_log_fini(void)
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index b465e24..5bb9cd3 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -490,14 +490,10 @@ static int __init ip6t_log_init(void)
 	ret = xt_register_target(&ip6t_log_reg);
 	if (ret < 0)
 		return ret;
-	if (nf_log_register(PF_INET6, &ip6t_logger) < 0) {
-		printk(KERN_WARNING "ip6t_LOG: not logging via system console "
-		       "since somebody else already registered for PF_INET6\n");
-		/* we cannot make module load fail here, since otherwise
-		 * ip6tables userspace would abort */
-	}
-
-	return 0;
+	ret = nf_log_register(PF_INET6, &ip6t_logger);
+	if (ret < 0 && ret != -EEXIST)
+		xt_unregister_target(&ip6t_log_reg);
+	return ret;
 }
 
 static void __exit ip6t_log_fini(void)
