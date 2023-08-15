Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6993C001DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 13:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbjHONj2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 09:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbjHONjI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 09:39:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88AAA173D
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Aug 2023 06:39:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nf_tables: GC transaction race with netns dismantle
Date:   Tue, 15 Aug 2023 15:39:01 +0200
Message-Id: <20230815133902.65242-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230815133902.65242-1-pablo@netfilter.org>
References: <20230815133902.65242-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use maybe_get_net() since GC workqueue might race with netns exit path.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed690dd1796..06c73aed149d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9480,9 +9480,14 @@ struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 	if (!trans)
 		return NULL;
 
+	trans->net = maybe_get_net(net);
+	if (!trans->net) {
+		kfree(trans);
+		return NULL;
+	}
+
 	refcount_inc(&set->refs);
 	trans->set = set;
-	trans->net = get_net(net);
 	trans->seq = gc_seq;
 
 	return trans;
-- 
2.30.2

