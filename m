Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50812C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F6C861A2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCYRZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhCYRZo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 13:25:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F1DC06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 10:25:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPTjq-0004qj-NT; Thu, 25 Mar 2021 18:25:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/8] netfilter: nf_log_netdev: merge with nf_log_syslog
Date:   Thu, 25 Mar 2021 18:25:08 +0100
Message-Id: <20210325172512.17729-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210325172512.17729-1-fw@strlen.de>
References: <20210325172512.17729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Provide netdev family support from the nf_log_syslog module.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig         |  4 --
 net/netfilter/Makefile        |  3 --
 net/netfilter/nf_log_netdev.c | 78 -----------------------------------
 net/netfilter/nf_log_syslog.c | 36 ++++++++++++++++
 4 files changed, 36 insertions(+), 85 deletions(-)
 delete mode 100644 net/netfilter/nf_log_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d5c047190eb9..6aef981a8446 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -74,10 +74,6 @@ config NF_CONNTRACK
 config NF_LOG_COMMON
 	tristate
 
-config NF_LOG_NETDEV
-	tristate "Netdev packet logging"
-	select NF_LOG_COMMON
-
 config NF_LOG_SYSLOG
 	tristate "Syslog packet logging"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 59642d9ab7a5..429be36fe4c7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -52,9 +52,6 @@ nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
 obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 
-# packet logging for netdev family
-obj-$(CONFIG_NF_LOG_NETDEV) += nf_log_netdev.o
-
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
diff --git a/net/netfilter/nf_log_netdev.c b/net/netfilter/nf_log_netdev.c
deleted file mode 100644
index 968dafa684c9..000000000000
--- a/net/netfilter/nf_log_netdev.c
+++ /dev/null
@@ -1,78 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/route.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_log.h>
-
-static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
-				 unsigned int hooknum,
-				 const struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 const struct nf_loginfo *loginfo,
-				 const char *prefix)
-{
-	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
-			loginfo, prefix);
-}
-
-static struct nf_logger nf_netdev_logger __read_mostly = {
-	.name		= "nf_log_netdev",
-	.type		= NF_LOG_TYPE_LOG,
-	.logfn		= nf_log_netdev_packet,
-	.me		= THIS_MODULE,
-};
-
-static int __net_init nf_log_netdev_net_init(struct net *net)
-{
-	return nf_log_set(net, NFPROTO_NETDEV, &nf_netdev_logger);
-}
-
-static void __net_exit nf_log_netdev_net_exit(struct net *net)
-{
-	nf_log_unset(net, &nf_netdev_logger);
-}
-
-static struct pernet_operations nf_log_netdev_net_ops = {
-	.init = nf_log_netdev_net_init,
-	.exit = nf_log_netdev_net_exit,
-};
-
-static int __init nf_log_netdev_init(void)
-{
-	int ret;
-
-	/* Request to load the real packet loggers. */
-	nf_logger_request_module(NFPROTO_IPV4, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_IPV6, NF_LOG_TYPE_LOG);
-	nf_logger_request_module(NFPROTO_ARP, NF_LOG_TYPE_LOG);
-
-	ret = register_pernet_subsys(&nf_log_netdev_net_ops);
-	if (ret < 0)
-		return ret;
-
-	nf_log_register(NFPROTO_NETDEV, &nf_netdev_logger);
-	return 0;
-}
-
-static void __exit nf_log_netdev_exit(void)
-{
-	unregister_pernet_subsys(&nf_log_netdev_net_ops);
-	nf_log_unregister(&nf_netdev_logger);
-}
-
-module_init(nf_log_netdev_init);
-module_exit(nf_log_netdev_exit);
-
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_DESCRIPTION("Netfilter netdev packet logging");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 9ba71bc2ef84..617e0071c0c4 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -768,6 +768,25 @@ static struct nf_logger nf_ip6_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
+				 unsigned int hooknum,
+				 const struct sk_buff *skb,
+				 const struct net_device *in,
+				 const struct net_device *out,
+				 const struct nf_loginfo *loginfo,
+				 const char *prefix)
+{
+	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
+			loginfo, prefix);
+}
+
+static struct nf_logger nf_netdev_logger __read_mostly = {
+	.name		= "nf_log_netdev",
+	.type		= NF_LOG_TYPE_LOG,
+	.logfn		= nf_log_netdev_packet,
+	.me		= THIS_MODULE,
+};
+
 static int __net_init nf_log_syslog_net_init(struct net *net)
 {
 	int ret = nf_log_set(net, NFPROTO_IPV4, &nf_ip_logger);
@@ -782,7 +801,13 @@ static int __net_init nf_log_syslog_net_init(struct net *net)
 	ret = nf_log_set(net, NFPROTO_IPV6, &nf_ip6_logger);
 	if (ret)
 		goto err2;
+
+	ret = nf_log_set(net, NFPROTO_NETDEV, &nf_netdev_logger);
+	if (ret)
+		goto err3;
 	return 0;
+err3:
+	nf_log_unset(net, &nf_ip6_logger);
 err2:
 	nf_log_unset(net, &nf_arp_logger);
 err1:
@@ -794,6 +819,8 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 {
 	nf_log_unset(net, &nf_ip_logger);
 	nf_log_unset(net, &nf_arp_logger);
+	nf_log_unset(net, &nf_ip6_logger);
+	nf_log_unset(net, &nf_netdev_logger);
 }
 
 static struct pernet_operations nf_log_syslog_net_ops = {
@@ -821,7 +848,13 @@ static int __init nf_log_syslog_init(void)
 	if (ret < 0)
 		goto err3;
 
+	ret = nf_log_register(NFPROTO_NETDEV, &nf_netdev_logger);
+	if (ret < 0)
+		goto err4;
+
 	return 0;
+err4:
+	nf_log_unregister(&nf_ip6_logger);
 err3:
 	nf_log_unregister(&nf_arp_logger);
 err2:
@@ -838,6 +871,7 @@ static void __exit nf_log_syslog_exit(void)
 	nf_log_unregister(&nf_ip_logger);
 	nf_log_unregister(&nf_arp_logger);
 	nf_log_unregister(&nf_ip6_logger);
+	nf_log_unregister(&nf_netdev_logger);
 }
 
 module_init(nf_log_syslog_init);
@@ -849,6 +883,8 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("nf_log_arp");
 MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS("nf_log_ipv6");
+MODULE_ALIAS("nf_log_netdev");
 MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
 MODULE_ALIAS_NF_LOGGER(3, 0);
+MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
-- 
2.26.3

