Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2188C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3CEF206C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDIIqM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:46:12 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51570 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfDIIqM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 04:46:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hDmOP-0008Rc-O3; Tue, 09 Apr 2019 10:46:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: nf_nat_masquerade: unify ipv4/6 notifier registration
Date:   Tue,  9 Apr 2019 10:44:08 +0200
Message-Id: <20190409084408.23730-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190409084408.23730-1-fw@strlen.de>
References: <20190409084408.23730-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only reason for having two different register functions was because of
ipt_MASQUERADE and ip6t_MASQUERADE being two different modules.

Previous patch merged those into xt_MASQUERADE, so we can merge this too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat_masquerade.h |   6 +-
 net/netfilter/nf_nat_masquerade.c         | 101 ++++++++--------------
 net/netfilter/nft_masq.c                  |  16 +---
 net/netfilter/xt_MASQUERADE.c             |  16 +---
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
2.21.0

