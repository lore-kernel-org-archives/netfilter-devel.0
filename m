Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69047C05027
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Feb 2023 17:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjBAR60 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 12:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBAR6Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 12:58:25 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5806D13D69;
        Wed,  1 Feb 2023 09:58:24 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 9DD964DF1A;
        Wed,  1 Feb 2023 19:58:22 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id F20DD4DE6F;
        Wed,  1 Feb 2023 19:58:18 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 6D9273C0439;
        Wed,  1 Feb 2023 19:58:16 +0200 (EET)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 311HwGdp114534;
        Wed, 1 Feb 2023 19:58:16 +0200
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 311HwC8W114527;
        Wed, 1 Feb 2023 19:58:12 +0200
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH net-next] ipvs: avoid kfree_rcu without 2nd arg
Date:   Wed,  1 Feb 2023 19:56:53 +0200
Message-Id: <20230201175653.114334-1-ja@ssi.bg>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid possible synchronize_rcu() as part from the
kfree_rcu() call when 2nd arg is not provided.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 include/net/ip_vs.h            | 1 +
 net/netfilter/ipvs/ip_vs_est.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index c6c61100d244..6d71a5ff52df 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -461,6 +461,7 @@ void ip_vs_stats_free(struct ip_vs_stats *stats);
 
 /* Multiple chains processed in same tick */
 struct ip_vs_est_tick_data {
+	struct rcu_head		rcu_head;
 	struct hlist_head	chains[IPVS_EST_TICK_CHAINS];
 	DECLARE_BITMAP(present, IPVS_EST_TICK_CHAINS);
 	DECLARE_BITMAP(full, IPVS_EST_TICK_CHAINS);
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index df56073bb282..25c7118d9348 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -549,7 +549,7 @@ void ip_vs_stop_estimator(struct netns_ipvs *ipvs, struct ip_vs_stats *stats)
 	__set_bit(row, kd->avail);
 	if (!kd->tick_len[row]) {
 		RCU_INIT_POINTER(kd->ticks[row], NULL);
-		kfree_rcu(td);
+		kfree_rcu(td, rcu_head);
 	}
 	kd->est_count--;
 	if (kd->est_count) {
-- 
2.39.1


