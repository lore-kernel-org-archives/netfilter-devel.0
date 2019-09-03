Return-Path: <SRS0=xNQb=W6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CF7C3A59E
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 03:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E036217F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 03:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfICDPd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 23:15:33 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:11866 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfICDPd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 23:15:33 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A87D4418AC;
        Tue,  3 Sep 2019 11:15:27 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3] netfilter: nf_table_offload: Fix the incorrect rcu usage in nft_indr_block_cb
Date:   Tue,  3 Sep 2019 11:15:27 +0800
Message-Id: <1567480527-27473-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVOQ0lCQkJMS01JTUNISllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRw6PQw*NDgrVjABEjFCMzIP
        DggKCghVSlVKTk1MT0NLTklMQ0tCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSE83Bg++
X-HM-Tid: 0a6cf51ebb652086kuqya87d4418ac
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The flow_block_ing_cmd() needs to call blocking functions while iterating
block_ing_cb_list, nft_indr_block_cb is in the cb_list,
So it is the incorrect rcu case. To fix it just traverse the list under
the commit mutex.

Fixes: 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: rebase to patches 1156728 and 1156729

 net/netfilter/nf_tables_offload.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 113ac40..ca9e0cb 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -357,11 +357,12 @@ static void nft_indr_block_cb(struct net_device *dev,
 	const struct nft_table *table;
 	const struct nft_chain *chain;
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(table, &net->nft.tables, list) {
 		if (table->family != NFPROTO_NETDEV)
 			continue;
 
-		list_for_each_entry_rcu(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_base_chain(chain))
 				continue;
 
@@ -370,9 +371,11 @@ static void nft_indr_block_cb(struct net_device *dev,
 				continue;
 
 			nft_indr_block_ing_cmd(dev, basechain, cb, cb_priv, cmd);
+			mutex_unlock(&net->nft.commit_mutex);
 			return;
 		}
 	}
+	mutex_unlock(&net->nft.commit_mutex);
 }
 
 static struct flow_indr_block_ing_entry block_ing_entry = {
-- 
1.8.3.1

