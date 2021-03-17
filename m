Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BDBC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 10:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9231164EFD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 10:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCQKcJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 06:32:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47214 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhCQKcB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 06:32:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F025863515
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:31:57 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nftables: report EOPNOTSUPP on unsupported flowtable flags
Date:   Wed, 17 Mar 2021 11:31:55 +0100
Message-Id: <20210317103156.23859-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Error was not set accordingly.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 224c8e537cb3..0d034f895b7b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6963,8 +6963,10 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flowtable->data.flags =
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK)
+		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK) {
+			err = -EOPNOTSUPP;
 			goto err3;
+		}
 	}
 
 	write_pnet(&flowtable->data.net, net);
-- 
2.20.1

