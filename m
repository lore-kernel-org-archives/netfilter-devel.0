Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7A9CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 19:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B01321872
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 19:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571771577;
	bh=h6lApnQoH4yeAnt+863Onqkxe9q1Vrdvkyfiparmxl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=idJPco2Ohxr+b5i5yTK0r/Ut6i0Dx9Q6aK7js+nHv+llhYjfC3+5Iihbsh6TKgE5N
	 a97wvsqL/yMvlMqV03pPeM8ttLWj2+v+4OLJKUvgzYIp7lDca9HJBwBDbu2yawOw+h
	 VX1b+0l/qFyPG8WalRHg9TI+NfmiuxerOToUtoqs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbfJVTMv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733029AbfJVTMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 15:12:35 -0400
Received: from localhost.localdomain (rrcs-50-75-166-42.nys.biz.rr.com [50.75.166.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC4621925;
        Tue, 22 Oct 2019 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571771554;
        bh=h6lApnQoH4yeAnt+863Onqkxe9q1Vrdvkyfiparmxl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSQdChrx2xCJVCgmc3ZIuW5sMYO4c5xYW9i/zxPQ5EKpxbt5Ysqzc+2hs2IT1yfVS
         q7BLNoQ8M0H/AVQZJKW0qtqppzRMae3AIXDxq7ywjpxd69IdaDpVUJgQaFh78xzAKh
         M6w6pV3AfHezs2jvBVi5DOmy1yFhHs8dHfsAQNtE=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 08/10] net/netfilter: Replace rcu_swap_protected() with rcu_replace()
Date:   Tue, 22 Oct 2019 12:12:13 -0700
Message-Id: <20191022191215.25781-8-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20191022191136.GA25627@paulmck-ThinkPad-P72>
References: <20191022191136.GA25627@paulmck-ThinkPad-P72>
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
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index d481f9b..3379974 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1461,8 +1461,9 @@ static void nft_chain_stats_replace(struct nft_trans *trans)
 	if (!nft_trans_chain_stats(trans))
 		return;
 
-	rcu_swap_protected(chain->stats, nft_trans_chain_stats(trans),
-			   lockdep_commit_lock_is_held(trans->ctx.net));
+	nft_trans_chain_stats(trans) =
+		rcu_replace_pointer(chain->stats, nft_trans_chain_stats(trans),
+				    lockdep_commit_lock_is_held(trans->ctx.net));
 
 	if (!nft_trans_chain_stats(trans))
 		static_branch_inc(&nft_counters_enabled);
-- 
2.9.5

