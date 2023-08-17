Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BBEC678DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Aug 2023 23:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355987AbjHQXOB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355996AbjHQXOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 19:14:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D5302D79
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Aug 2023 16:13:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: GC transaction race with abort path
Date:   Fri, 18 Aug 2023 01:13:52 +0200
Message-Id: <20230817231352.8412-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Abort path is missing a synchronization point with GC transactions. Add
GC sequence number hence any GC transaction losing race will be
discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 358f19b3712a..c2817d7ee653 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10335,8 +10335,12 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
-	int ret = __nf_tables_abort(net, action);
+	unsigned int gc_seq;
+	int ret;
 
+	gc_seq = nft_gc_seq_begin(nft_net);
+	ret = __nf_tables_abort(net, action);
+	nft_gc_seq_end(nft_net, gc_seq);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
-- 
2.30.2

