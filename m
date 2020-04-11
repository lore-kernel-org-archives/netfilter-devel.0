Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A4C2BB86
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB2F2051A
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648122;
	bh=xzf5hfC0BW3CdJWDOSiTK6rM7jvE5ABl6OUtU0wT4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zYjOsLtjSuZ8K9yydc1aZNkLXUaS1laB31QuGQPme7yZAghUGAbBim8aHpqrvLUcc
	 31LdD0YU7OtvEgmvi+a8qS5uTry/vc5UxdcB2J6IepuAx6bz1cl52gsi+O8e4WbOgq
	 sXXFHihrSKqluYkQyvpxGfzJFE46ADqge1zhnSMI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgDKXfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbgDKXJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0FA6216FD;
        Sat, 11 Apr 2020 23:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646543;
        bh=xzf5hfC0BW3CdJWDOSiTK6rM7jvE5ABl6OUtU0wT4Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DmzsZB5iyhn/RbI8CpEgw7XooZ1UDfdUNhd4NbYY2ci61INb7tvJzoJ66ojjdNPc
         DlM/p/62o3BC7vbccjfo2jd8L4AIiC3tcO5at0HzFqmUFw8ootDpbSRkncqM6b2ddR
         9SxEQRjcxeGUSdCh5y5btI/FBF62YNiNIxIRp2xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 095/121] netfilter: nf_tables: silence a RCU-list warning in nft_table_lookup()
Date:   Sat, 11 Apr 2020 19:06:40 -0400
Message-Id: <20200411230706.23855-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
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
index 11a2a7b5312ee..61c544801e534 100644
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

