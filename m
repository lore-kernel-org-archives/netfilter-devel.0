Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855BEC4740A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A5721D79
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfIKExb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 00:53:31 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59606 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfIKExb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 00:53:31 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9D881417F7;
        Wed, 11 Sep 2019 12:53:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 4/4] netfilter: nf_offload: clean offload things when the device unregister
Date:   Wed, 11 Sep 2019 12:53:24 +0800
Message-Id: <1568177604-26989-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
References: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzY6ISo*HjgzITQCFjASMAMZ
        TBIKFBVVSlVKTk1DSkxMTUtOTEhJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JSUg3Bg++
X-HM-Tid: 0a6d1eab4c172086kuqy9d881417f7
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When the net_device unregister, the netdevice_notifier will release
the related netdev basedchain and rules in this chains. So it is also
need to clean the offload things before the chain is destroy.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: use the new nft_flow_offload_chain api

 include/net/netfilter/nf_tables_offload.h |  2 +-
 net/netfilter/nf_tables_api.c             |  9 +++++--
 net/netfilter/nf_tables_offload.c         | 43 ++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index ddd048b..03cf585 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -77,7 +77,7 @@ struct nft_flow_rule {
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
-void nft_offload_init(void);
+int nft_offload_init(void);
 void nft_offload_exit(void);
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6f59ef..fef3051 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7694,15 +7694,20 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err4;
 
+	err = nft_offload_init();
+	if (err < 0)
+		goto err5;
+
 	/* must be last */
 	err = nfnetlink_subsys_register(&nf_tables_subsys);
 	if (err < 0)
-		goto err5;
+		goto err6;
 
 	nft_chain_route_init();
-	nft_offload_init();
 
 	return err;
+err6:
+	nft_offload_exit();
 err5:
 	rhltable_destroy(&nft_objname_ht);
 err4:
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 739a79c..21bb772 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -426,17 +426,58 @@ static void nft_indr_block_cb(struct net_device *dev,
 	mutex_unlock(&net->nft.commit_mutex);
 }
 
+static void nft_offload_chain_clean(struct nft_chain *chain)
+{
+	struct nft_rule *rule;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		nft_flow_offload_rule(chain, rule,
+				      NULL, FLOW_CLS_DESTROY);
+	}
+
+	nft_flow_offload_chain(chain, NULL, FLOW_BLOCK_UNBIND);
+}
+
+static int nft_offload_netdev_event(struct notifier_block *this,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	struct nft_chain *chain;
+
+	mutex_lock(&net->nft.commit_mutex);
+	chain = __nft_offload_get_chain(dev);
+	if (chain)
+		nft_offload_chain_clean(chain);
+	mutex_unlock(&net->nft.commit_mutex);
+
+	return NOTIFY_DONE;
+}
+
 static struct flow_indr_block_ing_entry block_ing_entry = {
 	.cb	= nft_indr_block_cb,
 	.list	= LIST_HEAD_INIT(block_ing_entry.list),
 };
 
-void nft_offload_init(void)
+static struct notifier_block nft_offload_netdev_notifier = {
+	.notifier_call	= nft_offload_netdev_event,
+};
+
+int nft_offload_init(void)
 {
+	int err;
+
+	err = register_netdevice_notifier(&nft_offload_netdev_notifier);
+	if (err < 0)
+		return err;
+
 	flow_indr_add_block_ing_cb(&block_ing_entry);
+
+	return 0;
 }
 
 void nft_offload_exit(void)
 {
 	flow_indr_del_block_ing_cb(&block_ing_entry);
+	unregister_netdevice_notifier(&nft_offload_netdev_notifier);
 }
-- 
1.8.3.1

