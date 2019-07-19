Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27640C76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF05B2186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfGSQqF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:46:05 -0400
Received: from mail.us.es ([193.147.175.20]:49860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731848AbfGSQpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40A98BAEFE
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21BD9202B8
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0EAA2DA704; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4441DA704;
        Fri, 19 Jul 2019 18:45:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3E5B74265A2F;
        Fri, 19 Jul 2019 18:45:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/14] netfilter: nf_tables: don't fail when updating base chain policy
Date:   Fri, 19 Jul 2019 18:45:11 +0200
Message-Id: <20190719164517.29496-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The following nftables test case fails on nf-next:

tests/shell/run-tests.sh tests/shell/testcases/transactions/0011chain_0

The test case contains:
add chain x y { type filter hook input priority 0; }
add chain x y { policy drop; }"

The new test
if (chain->flags ^ flags)
	return -EOPNOTSUPP;

triggers here, because chain->flags has NFT_BASE_CHAIN set, but flags
is 0 because no flag attribute was present in the policy update.

Just fetch the current flag settings of a pre-existing chain in case
userspace did not provide any.

Fixes: c9626a2cbdb20 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed17a7c29b86..014e06b0b5cf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1900,6 +1900,8 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_CHAIN_FLAGS])
 		flags = ntohl(nla_get_be32(nla[NFTA_CHAIN_FLAGS]));
+	else if (chain)
+		flags = chain->flags;
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
-- 
2.11.0


