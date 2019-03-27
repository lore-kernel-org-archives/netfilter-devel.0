Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0FDC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E550F2075C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553715025;
	bh=VmseP4cW3fe9niHuW0Is9N0JXM0IwEDP0nn1p6xWHdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dWZzGlVdat1mw4SuYMDe2stH9pXIjsy2pvTv/Za8+Y7RPY8Fc19hCO4d+RQMwo98v
	 QG9w8U0Av6ZAWSiuFiQ2VkzabRylAPrCSAjv70/S4VL8wx2LQ+ZbrSQv0JD3A0hv0g
	 wwpuu+j7S5iaBTwVXE17hmpiks92FboU1HfF9qIA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733117AbfC0TaY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732562AbfC0SDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B81222184E;
        Wed, 27 Mar 2019 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709813;
        bh=VmseP4cW3fe9niHuW0Is9N0JXM0IwEDP0nn1p6xWHdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpPSkokY9Ukofq3AalGXgtr739MToPWjtjfFblyD1l0DN4bb8QFWb6Qwq5e4JPBGw
         VO43NlNqmWevUFsD30H4Z5aGji+SleYgtkHxpPncPTxteWrb670y1tp3l+Si+4sAqP
         jY6vWz28XcF13rXcdDDh+h0FvgZKQj9cMLmAv5MU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Zhang Yu <zhangyu31@baidu.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 053/262] netfilter: nf_tables: check the result of dereferencing base_chain->stats
Date:   Wed, 27 Mar 2019 13:58:28 -0400
Message-Id: <20190327180158.10245-53-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit a9f5e78c403d2d62ade4f4c85040efc85f4049b8 ]

Check the result of dereferencing base_chain->stats, instead of result
of this_cpu_ptr with NULL.

base_chain->stats maybe be changed to NULL when a chain is updated and a
new NULL counter can be attached.

And we do not need to check returning of this_cpu_ptr since
base_chain->stats is from percpu allocator if it is non-NULL,
this_cpu_ptr returns a valid value.

And fix two sparse error by replacing rcu_access_pointer and
rcu_dereference with READ_ONCE under rcu_read_lock.

Thanks for Eric's help to finish this patch.

Fixes: 009240940e84c1 ("netfilter: nf_tables: don't assume chain stats are set when jumplabel is set")
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a50500232b0a..7e8dae82ca52 100644
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
2.19.1

