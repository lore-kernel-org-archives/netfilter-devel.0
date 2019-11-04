Return-Path: <SRS0=62bg=Y4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C667CA9EB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 13:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E4020869
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 13:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKDNwt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Nov 2019 08:52:49 -0500
Received: from correo.us.es ([193.147.175.20]:56806 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfKDNwt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Nov 2019 08:52:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C23AFF2C0
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:52:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DC80D1DBB
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:52:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6368FD2B1E; Mon,  4 Nov 2019 14:52:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AEC2A7EC1
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:52:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Nov 2019 14:52:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 66E274251480
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:52:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: bogus EOPNOTSUPP on basechain update
Date:   Mon,  4 Nov 2019 14:52:41 +0100
Message-Id: <20191104135242.31662-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userspace never includes the NFT_BASE_CHAIN flag, this flag is inferred
from the NFTA_CHAIN_HOOK atribute. The chain update path does not allow
to update flags at this stage, the existing sanity check bogusly hits
EOPNOTSUPP in the basechain case if the offload flag is set on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13f09412cc6a..7a95de60e302 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2177,6 +2177,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		flags |= chain->flags & NFT_BASE_CHAIN;
 		return nf_tables_updchain(&ctx, genmask, policy, flags);
 	}
 
-- 
2.11.0

