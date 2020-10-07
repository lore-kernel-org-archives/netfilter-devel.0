Return-Path: <SRS0=fUKQ=DO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62479C4741F
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 23:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FFA52083B
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Oct 2020 23:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgJGXO7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Oct 2020 19:14:59 -0400
Received: from correo.us.es ([193.147.175.20]:45476 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgJGXO6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 19:14:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B14DBE4B8C
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1D32DA704
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 973C9DA730; Thu,  8 Oct 2020 01:14:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D8DBDA722
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 08 Oct 2020 01:14:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 58DCC42EF42A
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 01:14:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/4] netfilter: add inet ingress support
Date:   Thu,  8 Oct 2020 01:14:47 +0200
Message-Id: <20201007231448.27346-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201007231448.27346-1-pablo@netfilter.org>
References: <20201007231448.27346-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the NF_INET_INGRESS pseudohook for the NFPROTO_INET
family. This is a mapping this new hook to the existing NFPROTO_NETDEV
and NF_NETDEV_INGRESS hook. The hook does not guarantee that packets are
inet only, users must filter out non-ip traffic explicitly.

This infrastructure makes it easier to support this new hook in nf_tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter.h |   1 +
 net/netfilter/core.c           | 101 ++++++++++++++++++++++++++-------
 2 files changed, 81 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index ca9e63d6e0e4..6a6179af0d7c 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -45,6 +45,7 @@ enum nf_inet_hooks {
 	NF_INET_FORWARD,
 	NF_INET_LOCAL_OUT,
 	NF_INET_POST_ROUTING,
+	NF_INET_INGRESS,
 	NF_INET_NUMHOOKS
 };
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a7639501d78b..38feb1f0feda 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -282,6 +282,14 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 			return NULL;
 		return net->nf.hooks_bridge + hooknum;
 #endif
+	case NFPROTO_INET:
+		if (WARN_ON_ONCE(hooknum != NF_INET_INGRESS))
+			return NULL;
+		if (!dev || dev_net(dev) != net) {
+			WARN_ON_ONCE(1);
+			return NULL;
+		}
+		return &dev->nf_hooks_ingress;
 	case NFPROTO_IPV4:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= hooknum))
 			return NULL;
@@ -311,22 +319,56 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 	return NULL;
 }
 
+static int nf_ingress_check(struct net *net, const struct nf_hook_ops *reg,
+			    int hooknum)
+{
+#ifndef CONFIG_NETFILTER_INGRESS
+	if (reg->hooknum == hooknum)
+		return -EOPNOTSUPP;
+#endif
+	if (reg->hooknum != hooknum ||
+	    !reg->dev || dev_net(reg->dev) != net)
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
 {
-	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS;
+	if ((pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS) ||
+	    (pf == NFPROTO_INET && reg->hooknum == NF_INET_INGRESS))
+		return true;
+
+	return false;
 }
 
 static void nf_static_key_inc(const struct nf_hook_ops *reg, int pf)
 {
 #ifdef CONFIG_JUMP_LABEL
-       static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
+	int hooknum;
+
+	if (pf == NFPROTO_INET && reg->hooknum == NF_INET_INGRESS) {
+		pf = NFPROTO_NETDEV;
+		hooknum = NF_NETDEV_INGRESS;
+	} else {
+		hooknum = reg->hooknum;
+	}
+	static_key_slow_inc(&nf_hooks_needed[pf][hooknum]);
 #endif
 }
 
 static void nf_static_key_dec(const struct nf_hook_ops *reg, int pf)
 {
 #ifdef CONFIG_JUMP_LABEL
-       static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
+	int hooknum;
+
+	if (pf == NFPROTO_INET && reg->hooknum == NF_INET_INGRESS) {
+		pf = NFPROTO_NETDEV;
+		hooknum = NF_NETDEV_INGRESS;
+	} else {
+		hooknum = reg->hooknum;
+	}
+	static_key_slow_dec(&nf_hooks_needed[pf][hooknum]);
 #endif
 }
 
@@ -335,15 +377,22 @@ static int __nf_register_net_hook(struct net *net, int pf,
 {
 	struct nf_hook_entries *p, *new_hooks;
 	struct nf_hook_entries __rcu **pp;
+	int err;
 
-	if (pf == NFPROTO_NETDEV) {
-#ifndef CONFIG_NETFILTER_INGRESS
-		if (reg->hooknum == NF_NETDEV_INGRESS)
-			return -EOPNOTSUPP;
-#endif
-		if (reg->hooknum != NF_NETDEV_INGRESS ||
-		    !reg->dev || dev_net(reg->dev) != net)
-			return -EINVAL;
+	switch (pf) {
+	case NFPROTO_NETDEV:
+		err = nf_ingress_check(net, reg, NF_NETDEV_INGRESS);
+		if (err < 0)
+			return err;
+		break;
+	case NFPROTO_INET:
+		if (reg->hooknum != NF_INET_INGRESS)
+			break;
+
+		err = nf_ingress_check(net, reg, NF_INET_INGRESS);
+		if (err < 0)
+			return err;
+		break;
 	}
 
 	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
@@ -441,8 +490,12 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	if (reg->pf == NFPROTO_INET) {
-		__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
-		__nf_unregister_net_hook(net, NFPROTO_IPV6, reg);
+		if (reg->hooknum == NF_INET_INGRESS) {
+			__nf_unregister_net_hook(net, NFPROTO_INET, reg);
+		} else {
+			__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
+			__nf_unregister_net_hook(net, NFPROTO_IPV6, reg);
+		}
 	} else {
 		__nf_unregister_net_hook(net, reg->pf, reg);
 	}
@@ -467,14 +520,20 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	int err;
 
 	if (reg->pf == NFPROTO_INET) {
-		err = __nf_register_net_hook(net, NFPROTO_IPV4, reg);
-		if (err < 0)
-			return err;
-
-		err = __nf_register_net_hook(net, NFPROTO_IPV6, reg);
-		if (err < 0) {
-			__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
-			return err;
+		if (reg->hooknum == NF_INET_INGRESS) {
+			err = __nf_register_net_hook(net, NFPROTO_INET, reg);
+			if (err < 0)
+				return err;
+		} else {
+			err = __nf_register_net_hook(net, NFPROTO_IPV4, reg);
+			if (err < 0)
+				return err;
+
+			err = __nf_register_net_hook(net, NFPROTO_IPV6, reg);
+			if (err < 0) {
+				__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
+				return err;
+			}
 		}
 	} else {
 		err = __nf_register_net_hook(net, reg->pf, reg);
-- 
2.20.1

