Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8A2C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 11:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhLQLis (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 06:38:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60814 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhLQLir (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 06:38:47 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 902B3605C2;
        Fri, 17 Dec 2021 12:36:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next,v2 1/5] netfilter: nf_tables: remove rcu read-size lock
Date:   Fri, 17 Dec 2021 12:38:33 +0100
Message-Id: <20211217113837.1253-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Chain stats are updated from the Netfilter hook path which already run
under rcu read-size lock section.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_tables_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index adc348056076..41c7509955e6 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -110,7 +110,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 
 	base_chain = nft_base_chain(chain);
 
-	rcu_read_lock();
 	pstats = READ_ONCE(base_chain->stats);
 	if (pstats) {
 		local_bh_disable();
@@ -121,7 +120,6 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 		u64_stats_update_end(&stats->syncp);
 		local_bh_enable();
 	}
-	rcu_read_unlock();
 }
 
 struct nft_jumpstack {
-- 
2.30.2

