Return-Path: <SRS0=kr0B=54=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1CAC2BB86
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Apr 2020 08:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B063B20708
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Apr 2020 08:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgDLIqV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Apr 2020 04:46:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37452 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgDLIqV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Apr 2020 04:46:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Apr 2020 11:46:18 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03C8kIxe023441;
        Sun, 12 Apr 2020 11:46:18 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, davem@davemloft.net
Cc:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net] netfilter: flowtable: Free block_cb when being deleted
Date:   Sun, 12 Apr 2020 11:45:47 +0300
Message-Id: <20200412084547.2217-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Free block_cb memory when asked to be deleted.

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index c0cb79495c35..4344e572b7f9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -421,10 +421,12 @@ void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 
 	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
-	if (block_cb)
+	if (block_cb) {
 		list_del(&block_cb->list);
-	else
+		flow_block_cb_free(block_cb);
+	} else {
 		WARN_ON(true);
+	}
 	up_write(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
-- 
2.8.4

