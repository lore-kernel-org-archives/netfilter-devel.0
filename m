From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: Fix logging regression
Date: Tue, 24 Jul 2007 17:54:13 +0200 (MEST)
Message-ID: <20070724155344.18487.96067.sendpatchset@localhost.localdomain>
References: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix logging regression

Loading one of the LOG target fails if a different target has already
registered itself as backend for the same family. This can affect the
ipt_LOG and ipt_ULOG modules when both are loaded.

Reported and tested by: <t.artem@mailcity.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 01e8429f5fcc78ccdf3a9bc785fd7bfec86f5eef
tree e93083bbfa6b1aefda551f318525824a3cdb5f6e
parent 8324cebeed865164db4c35a86f8608078bdb0609
author Patrick McHardy <kaber@trash.net> Tue, 24 Jul 2007 16:34:04 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 24 Jul 2007 16:34:04 +0200

 net/bridge/netfilter/ebt_log.c  |    6 ++----
 net/bridge/netfilter/ebt_ulog.c |    8 ++------
 net/ipv4/netfilter/ipt_LOG.c    |    6 ++----
 net/ipv6/netfilter/ip6t_LOG.c   |    6 ++----
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 031bfa4..984e9c6 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -196,10 +196,8 @@ static int __init ebt_log_init(void)
 	ret = ebt_register_watcher(&log);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_BRIDGE, &ebt_log_logger);
-	if (ret < 0 && ret != -EEXIST)
-		ebt_unregister_watcher(&log);
-	return ret;
+	nf_log_register(PF_BRIDGE, &ebt_log_logger);
+	return 0;
 }
 
 static void __exit ebt_log_fini(void)
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 9411db6..6fec352 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -308,12 +308,8 @@ static int __init ebt_ulog_init(void)
 	else if ((ret = ebt_register_watcher(&ulog)))
 		sock_release(ebtulognl->sk_socket);
 
-	if (nf_log_register(PF_BRIDGE, &ebt_ulog_logger) < 0) {
-		printk(KERN_WARNING "ebt_ulog: not logging via ulog "
-		       "since somebody else already registered for PF_BRIDGE\n");
-		/* we cannot make module load fail here, since otherwise
-		 * ebtables userspace would abort */
-	}
+	if (ret == 0)
+		nf_log_register(PF_BRIDGE, &ebt_ulog_logger);
 
 	return ret;
 }
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 5937ad1..127a5e8 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -479,10 +479,8 @@ static int __init ipt_log_init(void)
 	ret = xt_register_target(&ipt_log_reg);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_INET, &ipt_log_logger);
-	if (ret < 0 && ret != -EEXIST)
-		xt_unregister_target(&ipt_log_reg);
-	return ret;
+	nf_log_register(PF_INET, &ipt_log_logger);
+	return 0;
 }
 
 static void __exit ipt_log_fini(void)
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index b05327e..6ab9900 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -493,10 +493,8 @@ static int __init ip6t_log_init(void)
 	ret = xt_register_target(&ip6t_log_reg);
 	if (ret < 0)
 		return ret;
-	ret = nf_log_register(PF_INET6, &ip6t_logger);
-	if (ret < 0 && ret != -EEXIST)
-		xt_unregister_target(&ip6t_log_reg);
-	return ret;
+	nf_log_register(PF_INET6, &ip6t_logger);
+	return 0;
 }
 
 static void __exit ip6t_log_fini(void)
