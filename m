Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44EDC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A7342173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfBZJON (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:14:13 -0500
Received: from mx133-tc.baidu.com ([61.135.168.133]:27651 "EHLO
        tc-sys-mailedm06.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbfBZJON (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 04:14:13 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm06.tc.baidu.com (Postfix) with ESMTP id 44677263C003;
        Tue, 26 Feb 2019 17:13:56 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
Subject: [PATCH][v2] netfilter: check the result of dereferencing base_chain->stats
Date:   Tue, 26 Feb 2019 17:13:56 +0800
Message-Id: <1551172436-5233-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

check the result of dereferencing base_chain->stats, instead of
result of this_cpu_ptr with NULL

base_chain->stats maybe be changed to NULL when a chain is
updated and a new NULL counter can be attached

and we do not need to check returning of this_cpu_ptr since
base_chain->stats is from percpu allocator if it is non-NULL,
this_cpu_ptr returns a valid value

and fix two sparse error by replacing rcu_access_pointer and
rcu_dereference with READ_ONCE under rcu_read_lock

Thanks for Eric's help to finish this patch

Fixes: 009240940e84c1 ("netfilter: nf_tables: don't assume chain stats are set when jumplabel is set")
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 v1 -->v2: move the dereferencing under bh disable context, and fix two sparse

 net/netfilter/nf_tables_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2a00aef7b6d4..7dfbc6746846 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -98,21 +98,23 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 					    const struct nft_pktinfo *pkt)
 {
 	struct nft_base_chain *base_chain;
+	struct nft_stats __percpu *pstats;
 	struct nft_stats *stats;
 
 	base_chain = nft_base_chain(chain);
-	if (!rcu_access_pointer(base_chain->stats))
-		return;
 
-	local_bh_disable();
-	stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
-	if (stats) {
+	rcu_read_lock();
+	pstats = READ_ONCE(base_chain->stats);
+	if (pstats) {
+		local_bh_disable();
+		stats = this_cpu_ptr(pstats);
 		u64_stats_update_begin(&stats->syncp);
 		stats->pkts++;
 		stats->bytes += pkt->skb->len;
 		u64_stats_update_end(&stats->syncp);
+		local_bh_enable();
 	}
-	local_bh_enable();
+	rcu_read_unlock();
 }
 
 struct nft_jumpstack {
-- 
2.16.2

