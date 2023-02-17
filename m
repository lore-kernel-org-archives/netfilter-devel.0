Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BC4C6FA99
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 12:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBQMa1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 07:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjBQMaP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 07:30:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93DBF6783E;
        Fri, 17 Feb 2023 04:30:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 5/6] ipvs: avoid kfree_rcu without 2nd arg
Date:   Fri, 17 Feb 2023 13:29:56 +0100
Message-Id: <20230217122957.799277-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230217122957.799277-1-pablo@netfilter.org>
References: <20230217122957.799277-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Avoid possible synchronize_rcu() as part from the
kfree_rcu() call when 2nd arg is not provided.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index ce2a1549b304..c5970ba416ae 100644
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
2.30.2

