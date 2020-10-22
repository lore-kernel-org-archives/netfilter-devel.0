Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A328C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 20:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38C024640
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 20:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371832AbgJVUkk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 16:40:40 -0400
Received: from correo.us.es ([193.147.175.20]:34402 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371812AbgJVUkj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 16:40:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 081BEE8E85
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 22:40:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDC3EDA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 22:40:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3827DA704; Thu, 22 Oct 2020 22:40:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7F85DA789
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 22:40:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 22:40:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A5DA442EE395
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 22:40:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nftables: fix netlink report logic in flowtable and genid
Date:   Thu, 22 Oct 2020 22:40:32 +0200
Message-Id: <20201022204032.28904-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The netlink report should be sent regardless the available listeners.

Fixes: 84d7fce69388 ("netfilter: nf_tables: export rule-set generation ID")
Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65cb8e3c13d9..9b70e136fb5d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7137,7 +7137,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 			GFP_KERNEL);
 	kfree(buf);
 
-	if (ctx->report &&
+	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
 		return;
 
@@ -7259,7 +7259,7 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
 			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
 
-	if (nlmsg_report(nlh) &&
+	if (!nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return;
 
-- 
2.20.1

