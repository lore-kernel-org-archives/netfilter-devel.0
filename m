Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8B3C282DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77AD72075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfDORBD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:01:03 -0400
Received: from mail.us.es ([193.147.175.20]:50458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfDORAr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93EEE1C4442
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 764A4DA712
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 75A3BDA711; Mon, 15 Apr 2019 19:00:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41E74DA70E;
        Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 177534265A31;
        Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/22] netfilter: nf_nat_masquerade: unify ipv4/6 notifier registration
Date:   Mon, 15 Apr 2019 19:00:23 +0200
Message-Id: <20190415170028.3470-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only reason for having two different register functions was because of
ipt_MASQUERADE and ip6t_MASQUERADE being two different modules.

Previous patch merged those into xt_MASQUERADE, so we can merge this too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_masquerade.h |   6 +-
 net/netfilter/nf_nat_masquerade.c         | 101 +++++++++++-------------------
 net/netfilter/nft_masq.c                  |  16 +----
 net/netfilter/xt_MASQUERADE.c             |  16 +----
 4 files changed, 44 insertions(+), 95 deletions(-)

diff --git a/include/net/netfilter/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
index cafe71822a53..54a14d643c34 100644
--- a/include/net/netfilter/nf_nat_masquerade.h
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -9,13 +9,11 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		       const struct nf_nat_range2 *range,
 		       const struct net_device *out);
 
-int nf_nat_masquerade_ipv4_register_notifier(void);
-void nf_nat_masquerade_ipv4_unregister_notifier(void);
+int nf_nat_masquerade_inet_register_notifiers(void);
+void nf_nat_masquerade_inet_unregister_notifiers(void);
 
 unsigned int
 nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out);
-int nf_nat_masquerade_ipv6_register_notifier(void);
-void nf_nat_masquerade_ipv6_unregister_notifier(void);
 
 #endif /*_NF_NAT_MASQUERADE_H_ */
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 10053e70f69d..8e8a65d46345 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -10,8 +10,7 @@
 #include <net/netfilter/nf_nat_masquerade.h>
 
 static DEFINE_MUTEX(masq_mutex);
-static unsigned int masq_refcnt4 __read_mostly;
-static unsigned int masq_refcnt6 __read_mostly;
+static unsigned int masq_refcnt __read_mostly;
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
@@ -136,56 +135,6 @@ static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
 
-int nf_nat_masquerade_ipv4_register_notifier(void)
-{
-	int ret = 0;
-
-	mutex_lock(&masq_mutex);
-	if (WARN_ON_ONCE(masq_refcnt4 == UINT_MAX)) {
-		ret = -EOVERFLOW;
-		goto out_unlock;
-	}
-
-	/* check if the notifier was already set */
-	if (++masq_refcnt4 > 1)
-		goto out_unlock;
-
-	/* Register for device down reports */
-	ret = register_netdevice_notifier(&masq_dev_notifier);
-	if (ret)
-		goto err_dec;
-	/* Register IP address change reports */
-	ret = register_inetaddr_notifier(&masq_inet_notifier);
-	if (ret)
-		goto err_unregister;
-
-	mutex_unlock(&masq_mutex);
-	return ret;
-
-err_unregister:
-	unregister_netdevice_notifier(&masq_dev_notifier);
-err_dec:
-	masq_refcnt4--;
-out_unlock:
-	mutex_unlock(&masq_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_register_notifier);
-
-void nf_nat_masquerade_ipv4_unregister_notifier(void)
-{
-	mutex_lock(&masq_mutex);
-	/* check if the notifier still has clients */
-	if (--masq_refcnt4 > 0)
-		goto out_unlock;
-
-	unregister_netdevice_notifier(&masq_dev_notifier);
-	unregister_inetaddr_notifier(&masq_inet_notifier);
-out_unlock:
-	mutex_unlock(&masq_mutex);
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_unregister_notifier);
-
 #if IS_ENABLED(CONFIG_IPV6)
 static atomic_t v6_worker_count __read_mostly;
 
@@ -321,44 +270,68 @@ static struct notifier_block masq_inet6_notifier = {
 	.notifier_call	= masq_inet6_event,
 };
 
-int nf_nat_masquerade_ipv6_register_notifier(void)
+static int nf_nat_masquerade_ipv6_register_notifier(void)
+{
+	return register_inet6addr_notifier(&masq_inet6_notifier);
+}
+#else
+static inline int nf_nat_masquerade_ipv6_register_notifier(void) { return 0; }
+#endif
+
+int nf_nat_masquerade_inet_register_notifiers(void)
 {
 	int ret = 0;
 
 	mutex_lock(&masq_mutex);
-	if (WARN_ON_ONCE(masq_refcnt6 == UINT_MAX)) {
+	if (WARN_ON_ONCE(masq_refcnt == UINT_MAX)) {
 		ret = -EOVERFLOW;
 		goto out_unlock;
 	}
 
-	/* check if the notifier is already set */
-	if (++masq_refcnt6 > 1)
+	/* check if the notifier was already set */
+	if (++masq_refcnt > 1)
 		goto out_unlock;
 
-	ret = register_inet6addr_notifier(&masq_inet6_notifier);
+	/* Register for device down reports */
+	ret = register_netdevice_notifier(&masq_dev_notifier);
 	if (ret)
 		goto err_dec;
+	/* Register IP address change reports */
+	ret = register_inetaddr_notifier(&masq_inet_notifier);
+	if (ret)
+		goto err_unregister;
+
+	ret = nf_nat_masquerade_ipv6_register_notifier();
+	if (ret)
+		goto err_unreg_inet;
 
 	mutex_unlock(&masq_mutex);
 	return ret;
+err_unreg_inet:
+	unregister_inetaddr_notifier(&masq_inet_notifier);
+err_unregister:
+	unregister_netdevice_notifier(&masq_dev_notifier);
 err_dec:
-	masq_refcnt6--;
+	masq_refcnt--;
 out_unlock:
 	mutex_unlock(&masq_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_register_notifier);
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_inet_register_notifiers);
 
-void nf_nat_masquerade_ipv6_unregister_notifier(void)
+void nf_nat_masquerade_inet_unregister_notifiers(void)
 {
 	mutex_lock(&masq_mutex);
-	/* check if the notifier still has clients */
-	if (--masq_refcnt6 > 0)
+	/* check if the notifiers still have clients */
+	if (--masq_refcnt > 0)
 		goto out_unlock;
 
+	unregister_netdevice_notifier(&masq_dev_notifier);
+	unregister_inetaddr_notifier(&masq_inet_notifier);
+#if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&masq_inet6_notifier);
+#endif
 out_unlock:
 	mutex_unlock(&masq_mutex);
 }
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_unregister_notifier);
-#endif
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_inet_unregister_notifiers);
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 0783a3e99bd7..86fd90085eaf 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -195,22 +195,12 @@ static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
 
 static int __init nft_masq_module_init_ipv6(void)
 {
-	int ret = nft_register_expr(&nft_masq_ipv6_type);
-
-	if (ret)
-		return ret;
-
-	ret = nf_nat_masquerade_ipv6_register_notifier();
-	if (ret < 0)
-		nft_unregister_expr(&nft_masq_ipv6_type);
-
-	return ret;
+	return nft_register_expr(&nft_masq_ipv6_type);
 }
 
 static void nft_masq_module_exit_ipv6(void)
 {
 	nft_unregister_expr(&nft_masq_ipv6_type);
-	nf_nat_masquerade_ipv6_unregister_notifier();
 }
 #else
 static inline int nft_masq_module_init_ipv6(void) { return 0; }
@@ -293,7 +283,7 @@ static int __init nft_masq_module_init(void)
 		return ret;
 	}
 
-	ret = nf_nat_masquerade_ipv4_register_notifier();
+	ret = nf_nat_masquerade_inet_register_notifiers();
 	if (ret < 0) {
 		nft_masq_module_exit_ipv6();
 		nft_masq_module_exit_inet();
@@ -309,7 +299,7 @@ static void __exit nft_masq_module_exit(void)
 	nft_masq_module_exit_ipv6();
 	nft_masq_module_exit_inet();
 	nft_unregister_expr(&nft_masq_ipv4_type);
-	nf_nat_masquerade_ipv4_unregister_notifier();
+	nf_nat_masquerade_inet_unregister_notifiers();
 }
 
 module_init(nft_masq_module_init);
diff --git a/net/netfilter/xt_MASQUERADE.c b/net/netfilter/xt_MASQUERADE.c
index 96d884718749..ece20d832adc 100644
--- a/net/netfilter/xt_MASQUERADE.c
+++ b/net/netfilter/xt_MASQUERADE.c
@@ -107,32 +107,20 @@ static int __init masquerade_tg_init(void)
 	if (ret)
 		return ret;
 
-	ret = nf_nat_masquerade_ipv4_register_notifier();
+	ret = nf_nat_masquerade_inet_register_notifiers();
 	if (ret) {
 		xt_unregister_targets(masquerade_tg_reg,
 				      ARRAY_SIZE(masquerade_tg_reg));
 		return ret;
 	}
 
-#if IS_ENABLED(CONFIG_IPV6)
-	ret = nf_nat_masquerade_ipv6_register_notifier();
-	if (ret) {
-		xt_unregister_targets(masquerade_tg_reg,
-				      ARRAY_SIZE(masquerade_tg_reg));
-		nf_nat_masquerade_ipv4_unregister_notifier();
-		return ret;
-	}
-#endif
 	return ret;
 }
 
 static void __exit masquerade_tg_exit(void)
 {
 	xt_unregister_targets(masquerade_tg_reg, ARRAY_SIZE(masquerade_tg_reg));
-	nf_nat_masquerade_ipv4_unregister_notifier();
-#if IS_ENABLED(CONFIG_IPV6)
-	nf_nat_masquerade_ipv6_unregister_notifier();
-#endif
+	nf_nat_masquerade_inet_unregister_notifiers();
 }
 
 module_init(masquerade_tg_init);
-- 
2.11.0

