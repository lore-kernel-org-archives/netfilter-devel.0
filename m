From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next v2 04/10] netfilter: xt_LOG: add net namespace support for xt_LOG
Date: Mon, 25 Mar 2013 17:50:42 +0800
Message-ID: <1364205048-32632-4-git-send-email-gaofeng@cn.fujitsu.com>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: pablo@netfilter.org, Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3CYJuJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:50:09 -0400
In-Reply-To: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add pernet_operations for xt_LOG, in pernet_ops,
we call nf_log_set/unset to set/unset nf_loggers
of per net.

Because the syslog ns has not been implemented,
we don't want the container DDOS the host's syslog.
so only enable ebt_log in init_net and wait for
syslog ns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/xt_LOG.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index fa40096..d396600 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -474,7 +474,13 @@ ipt_log_packet(u_int8_t pf,
 	       const struct nf_loginfo *loginfo,
 	       const char *prefix)
 {
-	struct sbuff *m = sb_open();
+	struct sbuff *m;
+	struct net *net = dev_net(in ? in : out);
+
+	if (!net_eq(net, &init_net))
+		return;
+
+	m = sb_open();
 
 	if (!loginfo)
 		loginfo = &default_loginfo;
@@ -798,7 +804,13 @@ ip6t_log_packet(u_int8_t pf,
 		const struct nf_loginfo *loginfo,
 		const char *prefix)
 {
-	struct sbuff *m = sb_open();
+	struct sbuff *m;
+	struct net *net = dev_net(in ? in : out);
+
+	if (!net_eq(net, &init_net))
+		return;
+
+	m = sb_open();
 
 	if (!loginfo)
 		loginfo = &default_loginfo;
@@ -893,6 +905,28 @@ static struct nf_logger ip6t_log_logger __read_mostly = {
 };
 #endif
 
+static int __net_init log_net_init(struct net *net)
+{
+	nf_log_set(net, NFPROTO_IPV4, &ipt_log_logger);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	nf_log_set(net, NFPROTO_IPV6, &ip6t_log_logger);
+#endif
+	return 0;
+}
+
+static void __net_exit log_net_exit(struct net *net)
+{
+	nf_log_unset(net, &ipt_log_logger);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	nf_log_unset(net, &ip6t_log_logger);
+#endif
+}
+
+static struct pernet_operations log_net_ops = {
+	.init = log_net_init,
+	.exit = log_net_exit,
+};
+
 static int __init log_tg_init(void)
 {
 	int ret;
@@ -905,11 +939,12 @@ static int __init log_tg_init(void)
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	nf_log_register(NFPROTO_IPV6, &ip6t_log_logger);
 #endif
-	return 0;
+	return register_pernet_subsys(&log_net_ops);
 }
 
 static void __exit log_tg_exit(void)
 {
+	unregister_pernet_subsys(&log_net_ops);
 	nf_log_unregister(&ipt_log_logger);
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	nf_log_unregister(&ip6t_log_logger);
-- 
1.7.11.7

