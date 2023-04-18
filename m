Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C084C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 14:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDROu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjDROuz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 10:50:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 288D83C02;
        Tue, 18 Apr 2023 07:50:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/5] netfilter: nf_tables: Modify nla_memdup's flag to GFP_KERNEL_ACCOUNT
Date:   Tue, 18 Apr 2023 16:50:45 +0200
Message-Id: <20230418145048.67270-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230418145048.67270-1-pablo@netfilter.org>
References: <20230418145048.67270-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Chen Aotian <chenaotian2@163.com>

For memory alloc that store user data from nla[NFTA_OBJ_USERDATA],
use GFP_KERNEL_ACCOUNT is more suitable.

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Chen Aotian <chenaotian2@163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6004d4b24451..cd52109e674a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7052,7 +7052,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-- 
2.30.2

