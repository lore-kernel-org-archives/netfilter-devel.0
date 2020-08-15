Return-Path: <SRS0=d1l0=BZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE61C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4EE20657
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 22:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgHOWSv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:18:51 -0400
Received: from correo.us.es ([193.147.175.20]:38910 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgHOWSu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0BA1DA8A2
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B45CEDA84B
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9C45DA73F; Sat, 15 Aug 2020 12:32:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E1EADA73D;
        Sat, 15 Aug 2020 12:32:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 988FB42EF4E0;
        Sat, 15 Aug 2020 12:32:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/8] netfilter: nf_tables: free chain context when BINDING flag is missing
Date:   Sat, 15 Aug 2020 12:31:57 +0200
Message-Id: <20200815103201.1768-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot found a memory leak in nf_tables_addchain() because the chain
object is not free'd correctly on error.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: syzbot+c99868fde67014f7e9f5@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d878e34e3354..fd814e514f94 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2018,8 +2018,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	if (nla[NFTA_CHAIN_NAME]) {
 		chain->name = nla_strdup(nla[NFTA_CHAIN_NAME], GFP_KERNEL);
 	} else {
-		if (!(flags & NFT_CHAIN_BINDING))
-			return -EINVAL;
+		if (!(flags & NFT_CHAIN_BINDING)) {
+			err = -EINVAL;
+			goto err1;
+		}
 
 		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
 		chain->name = kstrdup(name, GFP_KERNEL);
-- 
2.20.1

