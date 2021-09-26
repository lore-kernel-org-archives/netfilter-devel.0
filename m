Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFF9C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Sep 2021 19:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE1860F6D
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Sep 2021 19:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhIZT7V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Sep 2021 15:59:21 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:43132 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhIZT7V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Sep 2021 15:59:21 -0400
Received: from ubuntu20.redfish-solutions.com (ubuntu20.redfish-solutions.com [192.168.4.33])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.16.1/8.16.1) with ESMTPSA id 18QJvY5w535332
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 26 Sep 2021 13:57:34 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on IPv6
Date:   Sun, 26 Sep 2021 13:57:34 -0600
Message-Id: <20210926195734.702772-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 192.168.4.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

Not all modules compile equally well when CONFIG_IPv6 is disabled.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 extensions/xt_ECHO.c   | 19 ++++++++++++++-----
 extensions/xt_TARPIT.c |  2 ++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/extensions/xt_ECHO.c b/extensions/xt_ECHO.c
index a0b718561db53ab468f86e17a05b5d991771d983..3c419f36f5169212af01cf62afa0b93456401767 100644
--- a/extensions/xt_ECHO.c
+++ b/extensions/xt_ECHO.c
@@ -22,7 +22,11 @@
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include "compat_xtables.h"
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#	define WITH_IPV6 1
+#endif
 
+#ifdef WITH_IPV6
 static unsigned int
 echo_tg6(struct sk_buff *oldskb, const struct xt_action_param *par)
 {
@@ -124,6 +128,7 @@ echo_tg6(struct sk_buff *oldskb, const struct xt_action_param *par)
 	kfree_skb(newskb);
 	return NF_DROP;
 }
+#endif
 
 static unsigned int
 echo_tg4(struct sk_buff *oldskb, const struct xt_action_param *par)
@@ -219,21 +224,23 @@ static struct xt_target echo_tg_reg[] __read_mostly = {
 	{
 		.name       = "ECHO",
 		.revision   = 0,
-		.family     = NFPROTO_IPV6,
+		.family     = NFPROTO_IPV4,
 		.proto      = IPPROTO_UDP,
 		.table      = "filter",
-		.target     = echo_tg6,
+		.target     = echo_tg4,
 		.me         = THIS_MODULE,
 	},
+#ifdef WITH_IPV6
 	{
 		.name       = "ECHO",
 		.revision   = 0,
-		.family     = NFPROTO_IPV4,
+		.family     = NFPROTO_IPV6,
 		.proto      = IPPROTO_UDP,
 		.table      = "filter",
-		.target     = echo_tg4,
+		.target     = echo_tg6,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init echo_tg_init(void)
@@ -251,5 +258,7 @@ module_exit(echo_tg_exit);
 MODULE_AUTHOR("Jan Engelhardt ");
 MODULE_DESCRIPTION("Xtables: ECHO diagnosis target");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip6t_ECHO");
 MODULE_ALIAS("ipt_ECHO");
+#ifdef WITH_IPV6
+MODULE_ALIAS("ip6t_ECHO");
+#endif
diff --git a/extensions/xt_TARPIT.c b/extensions/xt_TARPIT.c
index 0b70dd9c8d16fe9193125b66f0773af8b00a6e81..9a7ae5cc840683d96a98ba298626b81fee355ac1 100644
--- a/extensions/xt_TARPIT.c
+++ b/extensions/xt_TARPIT.c
@@ -532,4 +532,6 @@ MODULE_DESCRIPTION("Xtables: \"TARPIT\", capture and hold TCP connections");
 MODULE_AUTHOR("Jan Engelhardt ");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TARPIT");
+#ifdef WITH_IPV6
 MODULE_ALIAS("ip6t_TARPIT");
+#endif
-- 
2.25.1

