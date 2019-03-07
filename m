Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE63AC43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 22:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE95F20840
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 22:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfCGWWO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 17:22:14 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60236 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbfCGWWO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 17:22:14 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h21P2-00011t-1P; Thu, 07 Mar 2019 23:22:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: return immediately on empty commit
Date:   Thu,  7 Mar 2019 23:20:11 +0100
Message-Id: <20190307222011.25091-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running 'nft flush ruleset' while no rules exist, we will increment
the generation counter and announce a new genid to userspace, yet
nothing had changed in the first place.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcd9cb68d826..1904e081853c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6536,6 +6536,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_chain *chain;
 	struct nft_table *table;
 
+	if (list_empty(&net->nft.commit_list)) {
+		mutex_unlock(&net->nft.commit_mutex);
+		return 0;
+	}
+
 	/* 0. Validate ruleset, otherwise roll back for error reporting. */
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
-- 
2.19.2

