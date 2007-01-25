From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [patch 1/3] Fix return values for LOG and ULOG
Date: Thu, 25 Jan 2007 22:14:19 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701252213280.15753@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
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


[PATCH 1/3] Fix return values for LOG and ULOG

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, 2007-01-17

Index: linux-2.6.20-rc6/net/ipv4/netfilter/ipt_LOG.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/ipt_LOG.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/ipt_LOG.c
@@ -471,8 +471,9 @@ static struct nf_logger ipt_log_logger =
 
 static int __init ipt_log_init(void)
 {
-	if (ipt_register_target(&ipt_log_reg))
-		return -EINVAL;
+	int ret;
+	if ((ret = ipt_register_target(&ipt_log_reg)) < 0)
+		return ret;
 	if (nf_log_register(PF_INET, &ipt_log_logger) < 0) {
 		printk(KERN_WARNING "ipt_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET\n");
Index: linux-2.6.20-rc6/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv4/netfilter/ipt_ULOG.c
+++ linux-2.6.20-rc6/net/ipv4/netfilter/ipt_ULOG.c
@@ -379,7 +379,7 @@ static struct nf_logger ipt_ulog_logger 
 
 static int __init ipt_ulog_init(void)
 {
-	int i;
+	int ret, i;
 
 	DEBUGP("ipt_ULOG: init module\n");
 
@@ -400,9 +400,9 @@ static int __init ipt_ulog_init(void)
 	if (!nflognl)
 		return -ENOMEM;
 
-	if (ipt_register_target(&ipt_ulog_reg) != 0) {
+	if ((ret = ipt_register_target(&ipt_ulog_reg)) != 0) {
 		sock_release(nflognl->sk_socket);
-		return -EINVAL;
+		return ret;
 	}
 	if (nflog)
 		nf_log_register(PF_INET, &ipt_ulog_logger);
Index: linux-2.6.20-rc6/net/ipv6/netfilter/ip6t_LOG.c
===================================================================
--- linux-2.6.20-rc6.orig/net/ipv6/netfilter/ip6t_LOG.c
+++ linux-2.6.20-rc6/net/ipv6/netfilter/ip6t_LOG.c
@@ -482,8 +482,9 @@ static struct nf_logger ip6t_logger = {
 
 static int __init ip6t_log_init(void)
 {
-	if (ip6t_register_target(&ip6t_log_reg))
-		return -EINVAL;
+	int ret;
+	if ((ret = ip6t_register_target(&ip6t_log_reg)) < 0)
+		return ret;
 	if (nf_log_register(PF_INET6, &ip6t_logger) < 0) {
 		printk(KERN_WARNING "ip6t_LOG: not logging via system console "
 		       "since somebody else already registered for PF_INET6\n");
