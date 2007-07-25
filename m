From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: Fix logging regression
Date: Wed, 25 Jul 2007 17:00:15 +0200
Message-ID: <46A7657F.20906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080501080600000202040304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080501080600000202040304
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch fixes a regression in 2.6.22, breaking loading of
ipt_LOG/ipt_ULOG under certain circumstances.

Please apply, thanks.


--------------080501080600000202040304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix logging regression

Loading one of the LOG target fails if a different target has already
registered itself as backend for the same family. This can affect the
ipt_LOG and ipt_ULOG modules when both are loaded.

Reported and tested by: <t.artem@mailcity.com>
Upstream-commit: 7e2acc7e

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2ffb1c81aa78b9a7c0b59e08d257e82773d8a2ff
tree 50cc002f5a3e3cba68f38a6bab09e94e28431e88
parent f44bba1a92e01bbab6ca9817b86ddf9e1744a616
author Patrick McHardy <kaber@trash.net> Wed, 25 Jul 2007 16:58:34 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 25 Jul 2007 16:58:34 +0200

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
index a42c5cd..361be2b 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -477,10 +477,8 @@ static int __init ipt_log_init(void)
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
index 5bb9cd3..a7a2517 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -490,10 +490,8 @@ static int __init ip6t_log_init(void)
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

--------------080501080600000202040304--
