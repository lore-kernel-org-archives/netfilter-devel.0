Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A86BC55181
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 23:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728412068F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 23:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgDTXzr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 19:55:47 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4269 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgDTXzr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 19:55:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E52524145E;
        Tue, 21 Apr 2020 07:55:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net/sched: act_ct: update nf_conn_acct for act_ct SW offload in flowtable
Date:   Tue, 21 Apr 2020 07:55:43 +0800
Message-Id: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVNTkJCQkJDT0xPSklKSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P006Nio6ATg3PAMwKRQJPzwz
        DAlPCRZVSlVKTkNMT0lNQk9PS0pDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNTUs3Bg++
X-HM-Tid: 0a719a04e3cf2086kuqye52524145e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When the act_ct SW offload in flowtable, The counter of the conntrack
entry will never update. So update the nf_conn_acct conuter in act_ct
flowtable software offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1a76639..9adff83 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -30,6 +30,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
@@ -536,6 +537,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
+	nf_ct_acct_update(ct, dir, skb->len);
 
 	return true;
 }
-- 
1.8.3.1

