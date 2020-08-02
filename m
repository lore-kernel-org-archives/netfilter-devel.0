Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3632C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE4342076A
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 01:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgHBBaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 21:30:11 -0400
Received: from correo.us.es ([193.147.175.20]:39348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgHBBaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 21:30:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92D6BE34C5
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83F25DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 78A30DA78A; Sun,  2 Aug 2020 03:30:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57FECDA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 03:30:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3BB8F4265A2F
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 03:30:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: extended netlink error reporting for expressions
Date:   Sun,  2 Aug 2020 03:30:01 +0200
Message-Id: <20200802013002.14916-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802013002.14916-1-pablo@netfilter.org>
References: <20200802013002.14916-1-pablo@netfilter.org>
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

