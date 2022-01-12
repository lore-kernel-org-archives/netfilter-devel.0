Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2C9C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352872AbiALLbo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:31:44 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48962 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352881AbiALLbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 06:31:39 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C31B8605C6;
        Wed, 12 Jan 2022 12:28:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH nf] netfilter: nf_tables: set last expression in register tracking area
Date:   Wed, 12 Jan 2022 12:31:34 +0100
Message-Id: <20220112113134.340731-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_rule_for_each_expr() sets on last to nft_rule_last(), however, this
is coming after track.last field is set on.

Use nft_expr_last() to set track.last accordingly.

Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cde8cd0d1a7..cf454f8ca2b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8299,7 +8299,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			return -ENOMEM;
 
 		size = 0;
-		track.last = last;
+		track.last = nft_expr_last(rule);
 		nft_rule_for_each_expr(expr, last, rule) {
 			track.cur = expr;
 
-- 
2.30.2

