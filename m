Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36074C5AE5C
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1712321D79
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 04:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfIKEx3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 00:53:29 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:59574 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfIKEx2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 00:53:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5BCA0417D1;
        Wed, 11 Sep 2019 12:53:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 1/4] netfilter: nf_tables_offload: add __nft_offload_get_chain function
Date:   Wed, 11 Sep 2019 12:53:21 +0800
Message-Id: <1568177604-26989-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
References: <1568177604-26989-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pgg6Mgw4PjgzFzQfPDJNMAFC
        SDUKCjdVSlVKTk1DSkxMTUtOT0lNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOTUI3Bg++
X-HM-Tid: 0a6d1eab4b092086kuqy5bca0417d1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add __nft_offload_get_chain function. It make code more common
and can be used for others. __nft_offload_get_chain fix check
the offload flags.

The flow_block_ing_cmd() needs to call blocking functions while iterating
block_ing_cb_list, nft_indr_block_cb is in the cb_list. Also fix
nft_indr_block_cb in incorrect rcu case.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 net/netfilter/nf_tables_offload.c | 52 +++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 239cb78..e200491 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -369,33 +369,49 @@ int nft_flow_rule_offload_commit(struct net *net)
 	return err;
 }
 
-static void nft_indr_block_cb(struct net_device *dev,
-			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      enum flow_block_command command)
+static struct nft_chain *__nft_offload_get_chain(struct net_device *dev)
 {
+	struct nft_base_chain *basechain;
 	struct net *net = dev_net(dev);
 	const struct nft_table *table;
-	const struct nft_chain *chain;
+	struct nft_chain *chain;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry(table, &net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
-			if (nft_is_base_chain(chain)) {
-				struct nft_base_chain *basechain;
-
-				basechain = nft_base_chain(chain);
-				if (!strncmp(basechain->dev_name, dev->name,
-					     IFNAMSIZ)) {
-					nft_indr_block_ing_cmd(dev, basechain,
-							       cb, cb_priv,
-							       command);
-					return;
-				}
-			}
+		list_for_each_entry(chain, &table->chains, list) {
+			if (!nft_is_base_chain(chain) ||
+			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			basechain = nft_base_chain(chain);
+			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
+				continue;
+
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
+	chain = __nft_offload_get_chain(dev);
+	if (chain) {
+		struct nft_base_chain *basechain;
+
+		basechain = nft_base_chain(chain);
+		nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
+	}
+	mutex_unlock(&net->nft.commit_mutex);
 }
 
 static struct flow_indr_block_ing_entry block_ing_entry = {
-- 
1.8.3.1

