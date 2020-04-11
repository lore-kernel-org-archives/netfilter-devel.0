Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1559CC2BA19
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E42E220787
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648628;
	bh=i9OQRqz18EKYo98AmcF8sbyidSFaViJ8xiK2FLqYuco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t5ABRcdnBJ5uafSQZ/aD05AHr2TL43VyVR2SCOI/L1qvmFCld6mIHaZhJ14rynGZi
	 pOyhfxPd1J9jyU+jyMyM2aRt2aG7j/q0ZT0b2SASZyTNNgMVEloR6n43tqKCjBQyii
	 UEbmzjDSTnYoz3/Nx8n/5PRlsedevhvIjpTYDmtw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgDKXGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgDKXGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67A621744;
        Sat, 11 Apr 2020 23:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646375;
        bh=i9OQRqz18EKYo98AmcF8sbyidSFaViJ8xiK2FLqYuco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdFDzVgjKK9GVGe7xyvRzM2BPckT11NVmeOw9qLvdKbBYuIJHKI0rArX5pXTXAL0j
         NYcj/ONb4+Po18YQ+RPMK+i1I4QRz410ACxXgqDKXTL7MxQ7dc/3HPjiWBG3UitMn2
         Jw2jMuPvf6p92tT/9UwueFAsy74LN4aQHc4nx6+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 117/149] netfilter: nf_tables: silence a RCU-list warning in nft_table_lookup()
Date:   Sat, 11 Apr 2020 19:03:14 -0400
Message-Id: <20200411230347.22371-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 0a6a9515fe390976cd762c52d8d4f446d7a14285 ]

It is safe to traverse &net->nft.tables with &net->nft.commit_mutex
held using list_for_each_entry_rcu(). Silence the PROVE_RCU_LIST false
positive,

WARNING: suspicious RCU usage
net/netfilter/nf_tables_api.c:523 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by iptables/1384:
 #0: ffffffff9745c4a8 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x25/0x60 [nf_tables]

Call Trace:
 dump_stack+0xa1/0xea
 lockdep_rcu_suspicious+0x103/0x10d
 nft_table_lookup.part.0+0x116/0x120 [nf_tables]
 nf_tables_newtable+0x12c/0x7d0 [nf_tables]
 nfnetlink_rcv_batch+0x559/0x1190 [nfnetlink]
 nfnetlink_rcv+0x1da/0x210 [nfnetlink]
 netlink_unicast+0x306/0x460
 netlink_sendmsg+0x44b/0x770
 ____sys_sendmsg+0x46b/0x4a0
 ___sys_sendmsg+0x138/0x1a0
 __sys_sendmsg+0xb6/0x130
 __x64_sys_sendmsg+0x48/0x50
 do_syscall_64+0x69/0xf4
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d11f1a74d43c9..f09d15e7fe2b2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -520,7 +520,8 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry_rcu(table, &net->nft.tables, list) {
+	list_for_each_entry_rcu(table, &net->nft.tables, list,
+				lockdep_is_held(&net->nft.commit_mutex)) {
 		if (!nla_strcmp(nla, table->name) &&
 		    table->family == family &&
 		    nft_active_genmask(table, genmask))
-- 
2.20.1

