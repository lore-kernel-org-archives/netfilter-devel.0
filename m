Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98F6C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 May 2022 16:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiE3QYM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 May 2022 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241720AbiE3QYL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 May 2022 12:24:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DB08980A6
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2022 09:24:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: nf_tables: hold mutex on netns pre_exit path
Date:   Mon, 30 May 2022 18:24:05 +0200
Message-Id: <20220530162406.3935-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

clean_net() runs in workqueue while walking over the lists, grab mutex.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing in initial submission.

 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3c7fab36133b..2c6c956c7bbc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9882,7 +9882,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_pre_exit_net(struct net *net)
 {
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	mutex_lock(&nft_net->commit_mutex);
 	__nft_release_hooks(net);
+	mutex_unlock(&nft_net->commit_mutex);
 }
 
 static void __net_exit nf_tables_exit_net(struct net *net)
-- 
2.30.2

