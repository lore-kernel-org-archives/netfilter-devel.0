Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C607C3A5AB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8066820820
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfIEEAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:00:24 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26796 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfIEEAX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 00:00:23 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5F986417C4;
        Thu,  5 Sep 2019 12:00:20 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 4/4] netfilter: nf_tables_offload: clean offload things when the device unregister
Date:   Thu,  5 Sep 2019 12:00:19 +0800
Message-Id: <1567656019-6881-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
References: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9IS0tLSklOQ0NOS0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nwg6Iio*GDg4MTdDEB0hATFW
        CAIKCh1VSlVKTk1MTU5NS0lLTkpLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9JT0w3Bg++
X-HM-Tid: 0a6cff9489af2086kuqy5f986417c4
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
v3: make use the patch 3

 include/net/netfilter/nf_tables_offload.h |  2 +-
 net/netfilter/nf_tables_api.c             |  9 +++++--
 net/netfilter/nf_tables_offload.c         | 43 ++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 643152f..acb6621 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -80,7 +80,7 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
-void nft_offload_init(void);
+int nft_offload_init(void);
 void nft_offload_exit(void);
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3d7e82..3c64b32 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7691,15 +7691,20 @@ static int __init nf_tables_module_init(void)
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
index e5977cf..20cde04 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -410,17 +410,58 @@ static void nft_indr_block_cb(struct net_device *dev,
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
+	nft_flow_offload_chain(chain, FLOW_BLOCK_UNBIND);
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
+	chain = nft_offload_netdev_iterate(dev);
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

