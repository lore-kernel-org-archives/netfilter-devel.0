Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22B5C28CC1
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B915624920
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559396249;
	bh=n+m6o8ArLQiT2h5XaaZBVCSiyu9AaupKRXP6MB3ZETo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uRXYJYOZ+ztrdxsWt4KfFcGHNdAm1Lxm6YHVXqti4xZd7QmZLl5wHPmCEa7/CFpQM
	 R/zbYXz8RF8LIgBkqn+0KE98nwAhcwTejTCUfZvJ9RjZcjue3BLqKbGKAUSV7eC5rR
	 yLk0yiTmD9eGNFWP4NvHriml4fCZBC5I3sjtI7jA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfFANhY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfFANVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2124327301;
        Sat,  1 Jun 2019 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395313;
        bh=n+m6o8ArLQiT2h5XaaZBVCSiyu9AaupKRXP6MB3ZETo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h66ZtpBjx9hkWw2zQoi/R7PnMLJp8rTgQBwAZ4qyS7RAft6soSTlTzsIS99WkMMSy
         M3r49pPgPW5XOH9ABiwKHgldUdAtMdJaAsYykDWKDa8tX5A2OVFMKANFW7143jCalL
         3LF+70o82iqwR5N5+qiTWelSDvIdnnLfjNHemz+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 067/173] netfilter: nf_tables: fix base chain stat rcu_dereference usage
Date:   Sat,  1 Jun 2019 09:17:39 -0400
Message-Id: <20190601131934.25053-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit edbd82c5fba009f68d20b5db585be1e667c605f6 ]

Following splat gets triggered when nfnetlink monitor is running while
xtables-nft selftests are running:

net/netfilter/nf_tables_api.c:1272 suspicious rcu_dereference_check() usage!
other info that might help us debug this:

1 lock held by xtables-nft-mul/27006:
 #0: 00000000e0f85be9 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x1a/0x50
Call Trace:
 nf_tables_fill_chain_info.isra.45+0x6cc/0x6e0
 nf_tables_chain_notify+0xf8/0x1a0
 nf_tables_commit+0x165c/0x1740

nf_tables_fill_chain_info() can be called both from dumps (rcu read locked)
or from the transaction path if a userspace process subscribed to nftables
notifications.

In the 'table dump' case, rcu_access_pointer() cannot be used: We do not
hold transaction mutex so the pointer can be NULLed right after the check.
Just unconditionally fetch the value, then have the helper return
immediately if its NULL.

In the notification case we don't hold the rcu read lock, but updates are
prevented due to transaction mutex. Use rcu_dereference_check() to make lockdep
aware of this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 25c2b98b9a960..eb3915b76ff47 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1147,6 +1147,9 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	u64 pkts, bytes;
 	int cpu;
 
+	if (!stats)
+		return 0;
+
 	memset(&total, 0, sizeof(total));
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
@@ -1204,6 +1207,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct nft_stats __percpu *stats;
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
@@ -1225,8 +1229,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE, basechain->type->name))
 			goto nla_put_failure;
 
-		if (rcu_access_pointer(basechain->stats) &&
-		    nft_dump_stats(skb, rcu_dereference(basechain->stats)))
+		stats = rcu_dereference_check(basechain->stats,
+					      lockdep_commit_lock_is_held(net));
+		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
 	}
 
-- 
2.20.1

