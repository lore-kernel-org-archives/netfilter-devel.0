Return-Path: <SRS0=YvWH=YU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBEFCA9EBC
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029612070B
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfJ0MCm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Oct 2019 08:02:42 -0400
Received: from correo.us.es ([193.147.175.20]:60128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfJ0MCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F33B7FC46
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53A15B8005
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 494AEB8001; Sun, 27 Oct 2019 13:02:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A90FDA72F;
        Sun, 27 Oct 2019 13:02:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2F8B542EE395;
        Sun, 27 Oct 2019 13:02:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nf_tables_offload: restore basechain deletion
Date:   Sun, 27 Oct 2019 13:02:18 +0100
Message-Id: <20191027120221.2884-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unbind callbacks on chain deletion.

Fixes: 8fc618c52d16 ("netfilter: nf_tables_offload: refactor the nft_flow_offload_chain function")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e546f759b7a7..ad783f4840ef 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -347,7 +347,7 @@ int nft_flow_rule_offload_commit(struct net *net)
 
 			policy = nft_trans_chain_policy(trans);
 			err = nft_flow_offload_chain(trans->ctx.chain, &policy,
-						     FLOW_BLOCK_BIND);
+						     FLOW_BLOCK_UNBIND);
 			break;
 		case NFT_MSG_NEWRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
-- 
2.11.0

