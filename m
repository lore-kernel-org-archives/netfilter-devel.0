Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5952FC3A5A5
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DBCA20820
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 04:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfIEEAW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:00:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26784 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfIEEAV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 00:00:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 419E641621;
        Thu,  5 Sep 2019 12:00:20 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 3/4] netfilter: nf_tables_offload: add nft_offload_netdev_iterate function
Date:   Thu,  5 Sep 2019 12:00:18 +0800
Message-Id: <1567656019-6881-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
References: <1567656019-6881-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJDS0tLS0xIT0hJQklZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PEk6DBw4GTg3Hzc5EB0*ATo5
        CisaCxBVSlVKTk1MTU5NS0lLSE5OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlDTEw3Bg++
X-HM-Tid: 0a6cff9489342086kuqy419e641621
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nft_offload_netdev_iterate function. It make code more common
and can be used for others.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: new patch

 net/netfilter/nf_tables_offload.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9657001..e5977cf 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -365,16 +365,13 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-static void nft_indr_block_cb(struct net_device *dev,
-			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      enum flow_block_command cmd)
+static struct nft_chain *nft_offload_netdev_iterate(struct net_device *dev)
 {
 	struct nft_base_chain *basechain;
 	struct net *net = dev_net(dev);
-	const struct nft_table *table;
-	const struct nft_chain *chain;
+	struct nft_chain *chain;
+	struct nft_table *table;
 
-	mutex_lock(&net->nft.commit_mutex);
 	list_for_each_entry(table, &net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
@@ -388,11 +385,28 @@ static void nft_indr_block_cb(struct net_device *dev,
 			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
 				continue;
 
-			nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
-			mutex_unlock(&net->nft.commit_mutex);
-			return;
+			return chain;
 		}
 	}
+
+	return NULL;
+}
+
+static void nft_indr_block_cb(struct net_device *dev,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command cmd)
+{
+	struct net *net = dev_net(dev);
+	struct nft_chain *chain;
+
+	mutex_lock(&net->nft.commit_mutex);
+	chain = nft_offload_netdev_iterate(dev);
+	if (chain) {
+		struct nft_base_chain *basechain;
+
+		basechain = nft_base_chain(chain);
+		nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
+	}
 	mutex_unlock(&net->nft.commit_mutex);
 }
 
-- 
1.8.3.1

