Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BE7C00319
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8307720838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfCBShe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:34 -0500
Received: from mail.us.es ([193.147.175.20]:36386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbfCBShe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 247AA1361BB
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15EFDDA856
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AE61DA7FC; Sat,  2 Mar 2019 19:37:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F79ADA846;
        Sat,  2 Mar 2019 19:37:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B6F444265A2F;
        Sat,  2 Mar 2019 19:37:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/29] netfilter: nf_tables: check the result of dereferencing base_chain->stats
Date:   Sat,  2 Mar 2019 19:37:15 +0100
Message-Id: <20190302183720.3220-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

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
---
 net/netfilter/nf_tables_core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index e56a94dff34e..d0f168c2670f 100644
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
2.11.0


