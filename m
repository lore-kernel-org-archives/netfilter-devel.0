Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DE6C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 13:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 725452085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 13:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfHSNWt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:22:49 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:63550 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfHSNWt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 09:22:49 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 586424164A;
        Mon, 19 Aug 2019 21:22:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: nf_table_offload: Fix the incorrect rcu usage in nft_indr_block_get_and_ing_cmd
Date:   Mon, 19 Aug 2019 21:22:32 +0800
Message-Id: <1566220952-27225-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VLT0tCQkJDQ0JITEhMQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mww6Syo4PzgzITg9CUMuExwd
        DBcKCzJVSlVKTk1NSUlLQk5IT09LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLTUw3Bg++
X-HM-Tid: 0a6caa0b271f2086kuqy586424164a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The flow_block_ing_cmd() needs to call blocking functions while iterating
block_ing_cb_list, nft_indr_block_get_and_ing_cmd is in the cb_list,
So it is the incorrect rcu case. To fix it just traverse the list under
the commit mutex.

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b95e27b..5431741 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -363,11 +363,12 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(table, &net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->chains, list) {
 			if (nft_is_base_chain(chain)) {
 				struct nft_base_chain *basechain;
 
@@ -382,4 +383,5 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 			}
 		}
 	}
+	mutex_unlock(&net->nft.commit_mutex);
 }
-- 
1.8.3.1

