Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6576C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A3464E61
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCQQFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:05:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48262 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbhCQQFI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:05:08 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0CF1D6355F
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 16:16:46 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 5/6] netfilter: flowtable: call dst_check() to fall back to classic forwarding
Date:   Wed, 17 Mar 2021 16:16:40 +0100
Message-Id: <20210317151641.19637-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210317151641.19637-1-pablo@netfilter.org>
References: <20210317151641.19637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case the route is stale, pass up the packet to the classic forwarding
path for re-evaluation and schedule this flow entry for removal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
new patch in this batch

 net/netfilter/nf_flow_table_ip.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 714dc083f093..3a8423899def 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -197,14 +197,6 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static int nf_flow_offload_dst_check(struct dst_entry *dst)
-{
-	if (unlikely(dst_xfrm(dst)))
-		return dst_check(dst, 0) ? 0 : -1;
-
-	return 0;
-}
-
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -256,7 +248,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
@@ -476,7 +468,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
-- 
2.20.1

