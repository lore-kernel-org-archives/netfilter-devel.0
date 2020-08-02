Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBC9C433E1
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 18:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFB120759
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 18:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHBScQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Aug 2020 14:32:16 -0400
Received: from correo.us.es ([193.147.175.20]:45784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgHBScJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Aug 2020 14:32:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12895E4B90
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 20:32:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04AF1DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 20:32:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EC4B9DA791; Sun,  2 Aug 2020 20:32:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D22D1DA72F;
        Sun,  2 Aug 2020 20:32:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 20:32:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 03F884265A2F;
        Sun,  2 Aug 2020 20:32:04 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/7] netfilter: nf_tables: extended netlink error reporting for expressions
Date:   Sun,  2 Aug 2020 20:31:47 +0200
Message-Id: <20200802183149.2808-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802183149.2808-1-pablo@netfilter.org>
References: <20200802183149.2808-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends 36dd1bcc07e5 ("netfilter: nf_tables: initial support
for extended ACK reporting") to include netlink extended error reporting
for expressions. This allows userspace to identify what rule expression
is triggering the error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0d96e4eb754d..fac552b0179f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2509,6 +2509,7 @@ int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 
 struct nft_expr_info {
 	const struct nft_expr_ops	*ops;
+	const struct nlattr		*attr;
 	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
 };
 
@@ -2556,7 +2557,9 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	} else
 		ops = type->ops;
 
+	info->attr = nla;
 	info->ops = ops;
+
 	return 0;
 
 err1:
@@ -3214,8 +3217,10 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
 		err = nf_tables_newexpr(&ctx, &info[i], expr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, info[i].attr);
 			goto err2;
+		}
 
 		if (info[i].ops->validate)
 			nft_validate_state_update(net, NFT_VALIDATE_NEED);
-- 
2.20.1

