Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DB3C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 10:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D3120748
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 10:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKOKpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:45:17 -0500
Received: from correo.us.es ([193.147.175.20]:41502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfKOKpR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 05:45:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 45E79303D0B
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 11:45:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37D05A7E2B
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 11:45:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D120A7E29; Fri, 15 Nov 2019 11:45:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95381A7E11;
        Fri, 15 Nov 2019 11:45:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 11:45:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6EB2B4251480;
        Fri, 15 Nov 2019 11:45:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn
Subject: [PATCH nf-next] netfilter: nf_tables: add nft_unregister_flowtable_hook()
Date:   Fri, 15 Nov 2019 11:45:02 +0100
Message-Id: <20191115104502.3753-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unbind flowtable callback if hook is unregistered.

This patch is implicitly fixing the error path of
nf_tables_newflowtable() and nft_flowtable_event().

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Supersedes: https://patchwork.ozlabs.org/patch/1194041/

This is also fixing the error path of nf_tables_newflowtable().

 net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ad3882e14e82..8d12ce317631 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5964,16 +5964,22 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
+static void nft_unregister_flowtable_hook(struct net *net,
+					  struct nft_flowtable *flowtable,
+					  struct nft_hook *hook)
+{
+	nf_unregister_net_hook(net, &hook->ops);
+	flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
+				    FLOW_BLOCK_UNBIND);
+}
+
 static void nft_unregister_flowtable_net_hooks(struct net *net,
 					       struct nft_flowtable *flowtable)
 {
 	struct nft_hook *hook;
 
-	list_for_each_entry(hook, &flowtable->hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
-	}
+	list_for_each_entry(hook, &flowtable->hook_list, list)
+		nft_unregister_flowtable_hook(net, flowtable, hook);
 }
 
 static int nft_register_flowtable_net_hooks(struct net *net,
@@ -6015,9 +6021,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		if (i-- <= 0)
 			break;
 
-		nf_unregister_net_hook(net, &hook->ops);
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_UNBIND);
+		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -6124,7 +6128,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return 0;
 err5:
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		nf_unregister_net_hook(net, &hook->ops);
+		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 	}
@@ -6469,7 +6473,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
 		if (hook->ops.dev != dev)
 			continue;
 
-		nf_unregister_net_hook(dev_net(dev), &hook->ops);
+		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
 		break;
-- 
2.11.0

