Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7F1C43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 04:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D6C2245A
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 04:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfKMEqu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:46:50 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41526 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfKMEqu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 23:46:50 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E34D54184C;
        Wed, 13 Nov 2019 12:46:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] netfilter: flow_table_core: remove unnecessary parameter in flow_offload_fill_dir
Date:   Wed, 13 Nov 2019 12:46:40 +0800
Message-Id: <1573620402-10318-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlNS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ny46Ghw*STg0IRQdCEkVHQ0u
        PkwaCjxVSlVKTkxITUlLT0tIQkJPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJTE03Bg++
X-HM-Tid: 0a6e6315ceed2086kuqye34d54184c
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The ct is already in the struct flow_offload. We should remove it

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8468d2d..9889d52 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -18,11 +18,11 @@
 static LIST_HEAD(flowtables);
 
 static void
-flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
+flow_offload_fill_dir(struct flow_offload *flow,
 		      enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
-	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+	struct nf_conntrack_tuple *ctt = &flow->ct->tuplehash[dir].tuple;
 
 	ft->dir = dir;
 
@@ -57,8 +57,8 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 
 	flow->ct = ct;
 
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
-- 
1.8.3.1

