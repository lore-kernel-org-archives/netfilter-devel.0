Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EDAC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 23:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B0C2081B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 23:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mdtgvfGe";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IzgA72dE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCHXkU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:40:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43714 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfCHXkU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 18:40:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 46FA36049C; Fri,  8 Mar 2019 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552088418;
        bh=Cb+tcMM7Yu5WQoCmS7h/f047xOpXxjiQeGuFXSVFSPs=;
        h=From:To:Cc:Subject:Date:From;
        b=mdtgvfGegf2Bl3OHxMNSEqGWArz1TFpv2OcRjE8FFvZql1ow6CxFkgOcQAxgdA2ve
         laiKk1AsSCfu6BipYsLY0IfCLWVyK7FIY3sWcizh24onxC8dy2z9darS6DgYKdGqty
         jiYCJhudpY9/Zchu6DxT42IH4Yy8MYjWGXkSQYeA=
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB48360265;
        Fri,  8 Mar 2019 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552088417;
        bh=Cb+tcMM7Yu5WQoCmS7h/f047xOpXxjiQeGuFXSVFSPs=;
        h=From:To:Cc:Subject:Date:From;
        b=IzgA72dEXam43ebfLaRs46bkncwA54W1vzvli1o0XW9qc9kwKOyMQzzRJbQkGuHhR
         F827MD3RsTtfjkt3MGgM4CtHsAdqotQCgR5jxwvS+RieZOAfZGlY58Pa9KEco98bBn
         ADRLmb7hIaeMetaUVR2RsW9/DPKhW007hjwcQX3I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB48360265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 4.19 1/2] netfilter: xt_TEE: fix wrong interface selection
Date:   Fri,  8 Mar 2019 16:38:13 -0700
Message-Id: <1552088294-18087-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit f24d2d4f9586985509320f90308723d3d0c4e47f upstream.

TEE netdevice notifier handler checks only interface name. however
each netns can have same interface name. hence other netns's interface
could be selected.

test commands:
   %ip netns add vm1
   %iptables -I INPUT -p icmp -j TEE --gateway 192.168.1.1 --oif enp2s0
   %ip link set enp2s0 netns vm1

Above rule is in the root netns. but that rule could get enp2s0
ifindex of vm1 by notifier handler.

After this patch, TEE rule is added to the per-netns list.

Fixes: 9e2f6c5d78db ("netfilter: Rework xt_TEE netdevice notifier")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c | 69 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 0d0d68c..673ad20 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -14,6 +14,8 @@
 #include <linux/skbuff.h>
 #include <linux/route.h>
 #include <linux/netfilter/x_tables.h>
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <net/route.h>
 #include <net/netfilter/ipv4/nf_dup_ipv4.h>
 #include <net/netfilter/ipv6/nf_dup_ipv6.h>
@@ -25,8 +27,15 @@ struct xt_tee_priv {
 	int			oif;
 };
 
+static unsigned int tee_net_id __read_mostly;
 static const union nf_inet_addr tee_zero_address;
 
+struct tee_net {
+	struct list_head priv_list;
+	/* lock protects the priv_list */
+	struct mutex lock;
+};
+
 static unsigned int
 tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -51,17 +60,16 @@ struct xt_tee_priv {
 }
 #endif
 
-static DEFINE_MUTEX(priv_list_mutex);
-static LIST_HEAD(priv_list);
-
 static int tee_netdev_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	struct tee_net *tn = net_generic(net, tee_net_id);
 	struct xt_tee_priv *priv;
 
-	mutex_lock(&priv_list_mutex);
-	list_for_each_entry(priv, &priv_list, list) {
+	mutex_lock(&tn->lock);
+	list_for_each_entry(priv, &tn->priv_list, list) {
 		switch (event) {
 		case NETDEV_REGISTER:
 			if (!strcmp(dev->name, priv->tginfo->oif))
@@ -79,13 +87,14 @@ static int tee_netdev_event(struct notifier_block *this, unsigned long event,
 			break;
 		}
 	}
-	mutex_unlock(&priv_list_mutex);
+	mutex_unlock(&tn->lock);
 
 	return NOTIFY_DONE;
 }
 
 static int tee_tg_check(const struct xt_tgchk_param *par)
 {
+	struct tee_net *tn = net_generic(par->net, tee_net_id);
 	struct xt_tee_tginfo *info = par->targinfo;
 	struct xt_tee_priv *priv;
 
@@ -106,9 +115,9 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		priv->oif     = -1;
 		info->priv    = priv;
 
-		mutex_lock(&priv_list_mutex);
-		list_add(&priv->list, &priv_list);
-		mutex_unlock(&priv_list_mutex);
+		mutex_lock(&tn->lock);
+		list_add(&priv->list, &tn->priv_list);
+		mutex_unlock(&tn->lock);
 	} else
 		info->priv = NULL;
 
@@ -118,12 +127,13 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 
 static void tee_tg_destroy(const struct xt_tgdtor_param *par)
 {
+	struct tee_net *tn = net_generic(par->net, tee_net_id);
 	struct xt_tee_tginfo *info = par->targinfo;
 
 	if (info->priv) {
-		mutex_lock(&priv_list_mutex);
+		mutex_lock(&tn->lock);
 		list_del(&info->priv->list);
-		mutex_unlock(&priv_list_mutex);
+		mutex_unlock(&tn->lock);
 		kfree(info->priv);
 	}
 	static_key_slow_dec(&xt_tee_enabled);
@@ -156,6 +166,21 @@ static void tee_tg_destroy(const struct xt_tgdtor_param *par)
 #endif
 };
 
+static int __net_init tee_net_init(struct net *net)
+{
+	struct tee_net *tn = net_generic(net, tee_net_id);
+
+	INIT_LIST_HEAD(&tn->priv_list);
+	mutex_init(&tn->lock);
+	return 0;
+}
+
+static struct pernet_operations tee_net_ops = {
+	.init = tee_net_init,
+	.id   = &tee_net_id,
+	.size = sizeof(struct tee_net),
+};
+
 static struct notifier_block tee_netdev_notifier = {
 	.notifier_call = tee_netdev_event,
 };
@@ -164,22 +189,32 @@ static int __init tee_tg_init(void)
 {
 	int ret;
 
-	ret = xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
-	if (ret)
+	ret = register_pernet_subsys(&tee_net_ops);
+	if (ret < 0)
 		return ret;
+
+	ret = xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	if (ret < 0)
+		goto cleanup_subsys;
+
 	ret = register_netdevice_notifier(&tee_netdev_notifier);
-	if (ret) {
-		xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
-		return ret;
-	}
+	if (ret < 0)
+		goto unregister_targets;
 
 	return 0;
+
+unregister_targets:
+	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+cleanup_subsys:
+	unregister_pernet_subsys(&tee_net_ops);
+	return ret;
 }
 
 static void __exit tee_tg_exit(void)
 {
 	unregister_netdevice_notifier(&tee_netdev_notifier);
 	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
+	unregister_pernet_subsys(&tee_net_ops);
 }
 
 module_init(tee_tg_init);
-- 
1.9.1

