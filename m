Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76A0C6377D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA2861355
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 08:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhGVIIS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 04:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhGVIIS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 04:08:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C2CC061575
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2021 01:48:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m6UNw-0000yG-0f; Thu, 22 Jul 2021 10:48:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: ipt_CLUSTERIP: only add arp mangle hook when required
Date:   Thu, 22 Jul 2021 10:48:32 +0200
Message-Id: <20210722084834.27027-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722084834.27027-1-fw@strlen.de>
References: <20210722084834.27027-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not register the arp mangling hooks from pernet init path.

As-is, load of the module is enough for these hooks to become active
in each net namespace.

Use checkentry instead so hook is only added if a CLUSTERIP rule is used.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 51 ++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 8f7ca67475b7..11bcf599358d 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -71,6 +71,16 @@ struct clusterip_net {
 	/* mutex protects the config->pde*/
 	struct mutex mutex;
 #endif
+	unsigned int hook_users;
+};
+
+static unsigned int clusterip_arp_mangle(void *priv, struct sk_buff *skb, const struct nf_hook_state *state);
+
+static const struct nf_hook_ops cip_arp_ops = {
+	.hook = clusterip_arp_mangle,
+	.pf = NFPROTO_ARP,
+	.hooknum = NF_ARP_OUT,
+	.priority = -1
 };
 
 static unsigned int clusterip_net_id __read_mostly;
@@ -458,6 +468,7 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
+	struct clusterip_net *cn = clusterip_pernet(par->net);
 	const struct ipt_entry *e = par->entryinfo;
 	struct clusterip_config *config;
 	int ret, i;
@@ -467,6 +478,9 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		return -EOPNOTSUPP;
 	}
 
+	if (cn->hook_users == UINT_MAX)
+		return -EOVERFLOW;
+
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
@@ -517,6 +531,19 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 		return ret;
 	}
 
+	if (cn->hook_users == 0) {
+		ret = nf_register_net_hook(par->net, &cip_arp_ops);
+
+		if (ret < 0) {
+			clusterip_config_entry_put(cipinfo->config);
+			clusterip_config_put(cipinfo->config);
+			nf_ct_netns_put(par->net, par->family);
+			return ret;
+		}
+	}
+
+	cn->hook_users++;
+
 	if (!par->net->xt.clusterip_deprecated_warning) {
 		pr_info("ipt_CLUSTERIP is deprecated and it will removed soon, "
 			"use xt_cluster instead\n");
@@ -531,6 +558,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
+	struct clusterip_net *cn = clusterip_pernet(par->net);
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
@@ -539,6 +567,10 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 	clusterip_config_put(cipinfo->config);
 
 	nf_ct_netns_put(par->net, par->family);
+	cn->hook_users--;
+
+	if (cn->hook_users == 0)
+		nf_unregister_net_hook(par->net, &cip_arp_ops);
 }
 
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -602,9 +634,8 @@ static void arp_print(struct arp_payload *payload)
 #endif
 
 static unsigned int
-arp_mangle(void *priv,
-	   struct sk_buff *skb,
-	   const struct nf_hook_state *state)
+clusterip_arp_mangle(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
 {
 	struct arphdr *arp = arp_hdr(skb);
 	struct arp_payload *payload;
@@ -654,13 +685,6 @@ arp_mangle(void *priv,
 	return NF_ACCEPT;
 }
 
-static const struct nf_hook_ops cip_arp_ops = {
-	.hook = arp_mangle,
-	.pf = NFPROTO_ARP,
-	.hooknum = NF_ARP_OUT,
-	.priority = -1
-};
-
 /***********************************************************************
  * PROC DIR HANDLING
  ***********************************************************************/
@@ -817,20 +841,14 @@ static const struct proc_ops clusterip_proc_ops = {
 static int clusterip_net_init(struct net *net)
 {
 	struct clusterip_net *cn = clusterip_pernet(net);
-	int ret;
 
 	INIT_LIST_HEAD(&cn->configs);
 
 	spin_lock_init(&cn->lock);
 
-	ret = nf_register_net_hook(net, &cip_arp_ops);
-	if (ret < 0)
-		return ret;
-
 #ifdef CONFIG_PROC_FS
 	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
-		nf_unregister_net_hook(net, &cip_arp_ops);
 		pr_err("Unable to proc dir entry\n");
 		return -ENOMEM;
 	}
@@ -850,7 +868,6 @@ static void clusterip_net_exit(struct net *net)
 	cn->procdir = NULL;
 	mutex_unlock(&cn->mutex);
 #endif
-	nf_unregister_net_hook(net, &cip_arp_ops);
 }
 
 static struct pernet_operations clusterip_net_ops = {
-- 
2.31.1

