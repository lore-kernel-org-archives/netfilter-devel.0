Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF963C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 01:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B867420989
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 01:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfBYB6y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 20:58:54 -0500
Received: from mx140-tc.baidu.com ([61.135.168.140]:42265 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbfBYB6y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 20:58:54 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 755C211C005B
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 09:58:40 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: force access of RCU protected data in nft_update_chain_stats
Date:   Mon, 25 Feb 2019 09:58:40 +0800
Message-Id: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

basechain->stats is rcu protected data, cannot assure that
twice accesses have the same result, so dereference it once.

basechain->stats is allocated by percpu allocater, if it is not NULL,
its percpu variable does not need to be checked with NULL

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/netfilter/nf_tables_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2a00aef7b6d4..9be622c76a62 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -98,20 +98,20 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 					    const struct nft_pktinfo *pkt)
 {
 	struct nft_base_chain *base_chain;
-	struct nft_stats *stats;
+	struct nft_stats *stats, *pstat;
 
 	base_chain = nft_base_chain(chain);
-	if (!rcu_access_pointer(base_chain->stats))
+
+	stats = rcu_dereference(base_chain->stats);
+	if (!stats)
 		return;
 
 	local_bh_disable();
-	stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
-	if (stats) {
-		u64_stats_update_begin(&stats->syncp);
-		stats->pkts++;
-		stats->bytes += pkt->skb->len;
-		u64_stats_update_end(&stats->syncp);
-	}
+	pstat = this_cpu_ptr(stats);
+	u64_stats_update_begin(&pstat->syncp);
+	pstat->pkts++;
+	pstat->bytes += pkt->skb->len;
+	u64_stats_update_end(&pstat->syncp);
 	local_bh_enable();
 }
 
-- 
2.16.2

