Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49023C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 21:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DF86613D6
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 21:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhEEVoh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 17:44:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45852 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhEEVog (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 17:44:36 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 007DF63087
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 23:42:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nftables: Fix a memleak from userdata error path in new objects
Date:   Wed,  5 May 2021 23:43:34 +0200
Message-Id: <20210505214335.3462-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release object name if userdata allocation fails.

Fixes: b131c96496b3 ("netfilter: nf_tables: add userdata support for nft_object")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b7fe0a902ff..926da6ed8d51 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6615,9 +6615,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&obj->list);
 	return err;
 err_trans:
-	kfree(obj->key.name);
-err_userdata:
 	kfree(obj->udata);
+err_userdata:
+	kfree(obj->key.name);
 err_strdup:
 	if (obj->ops->destroy)
 		obj->ops->destroy(&ctx, obj);
-- 
2.30.2

