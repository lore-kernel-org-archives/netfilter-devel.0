Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF46FC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F74613E9
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhEEUqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 16:46:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45798 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhEEUqX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 16:46:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D7E52605AA
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 22:44:41 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
Date:   Wed,  5 May 2021 22:45:21 +0200
Message-Id: <20210505204521.2514-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not assume that the tcph->doff field is correct when parsing for TCP
options, skb_header_pointer() might fail to fetch these bits.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index e8f8875c6884..0fa2e2030427 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -186,6 +186,8 @@ static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 
 		ctx->optp = skb_header_pointer(skb, ip_hdrlen(skb) +
 				sizeof(struct tcphdr), ctx->optsize, opts);
+		if (!ctx->optp)
+			return NULL;
 	}
 
 	return tcp;
-- 
2.30.2

