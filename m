Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472B1C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 01:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B47222C2
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 01:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570067011;
	bh=xq8wmWF+0DYuEKeGS/ddPyJZMDAJsFE60aB2Uqwti3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wvct7DmvnlkguYsq/yRe8UbMtYqOvxnr8xeuH5HuVHKKH0+2ez3mDHjsAUOMdZr/r
	 7e/cVfTaSSpSK0EtZ8tDvQyBbrMFNAI/7N6ERuC2pQcMqrIkbNEa8y3opnfDqzIk6Z
	 D3wBixcMsA3kdht4s9OD0ri9u/GCidlTVIaXLTuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfJCBnQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 21:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfJCBnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 21:43:15 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FAF4222D0;
        Thu,  3 Oct 2019 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570066994;
        bh=xq8wmWF+0DYuEKeGS/ddPyJZMDAJsFE60aB2Uqwti3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hme6n4Ct0Suv+l2Qm305v/Ju/zEgOuS6xD0Vf/X69g2ny2htKdl2dMRUzrx6JpTUy
         SZqldfIaXWvz29wFwhciGdLHURIzm2ZMuldSVe9XUp0RVFlsA/iUzSWRqmDKsSe+eU
         9M4hFETLInKX3BGorqhaibyKIJx9R2Ls61MSmgcA=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 8/9] net/netfilter: Replace rcu_swap_protected() with rcu_replace()
Date:   Wed,  2 Oct 2019 18:43:09 -0700
Message-Id: <20191003014310.13262-8-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20191003014153.GA13156@paulmck-ThinkPad-P72>
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
Cc: <netdev@vger.kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d481f9b..8499baf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1461,8 +1461,9 @@ static void nft_chain_stats_replace(struct nft_trans *trans)
 	if (!nft_trans_chain_stats(trans))
 		return;
 
-	rcu_swap_protected(chain->stats, nft_trans_chain_stats(trans),
-			   lockdep_commit_lock_is_held(trans->ctx.net));
+	nft_trans_chain_stats(trans) =
+		rcu_replace(chain->stats, nft_trans_chain_stats(trans),
+			    lockdep_commit_lock_is_held(trans->ctx.net));
 
 	if (!nft_trans_chain_stats(trans))
 		static_branch_inc(&nft_counters_enabled);
-- 
2.9.5

