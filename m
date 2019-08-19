Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B4AC3A59D
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 09:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37EA520989
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 09:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfHSJqx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 05:46:53 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38462 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHSJqw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 05:46:52 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 480A641BE7;
        Mon, 19 Aug 2019 17:46:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_table_offload: Fix the incorrect rcu usage in nft_indr_block_get_and_ing_cmd
Date:   Mon, 19 Aug 2019 17:46:47 +0800
Message-Id: <1566208007-22513-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNQ0JLS0tKSUJNQkJMSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Py46Nzo5STg#DzhCTyJCKzw0
        HCwKFAJVSlVKTk1NSUtDS0tDSE1DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSks3Bg++
X-HM-Tid: 0a6ca945a0762086kuqy480a641be7
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The nft_indr_block_get_and_ing_cmd is called in netdevice notify
It is the incorrect rcu case, To fix it just traverse the list under
the commit mutex.

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b95e27b..bcaafc8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -359,15 +359,18 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 				    void *cb_priv,
 				    enum flow_block_command command)
 {
-	struct net *net = dev_net(dev);
+	const struct nft_chain *chain, *nr;
 	const struct nft_table *table;
-	const struct nft_chain *chain;
+	struct nft_ctx ctx = {
+		.net	= dev_net(dev),
+	};
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	mutex_lock(&ctx.net->nft.commit_mutex);
+	list_for_each_entry(table, &ctx.net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
+		list_for_each_entry_safe(chain, nr, &table->chains, list) {
 			if (nft_is_base_chain(chain)) {
 				struct nft_base_chain *basechain;
 
@@ -382,4 +385,5 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 			}
 		}
 	}
+	mutex_unlock(&ctx.net->nft.commit_mutex);
 }
-- 
1.8.3.1

