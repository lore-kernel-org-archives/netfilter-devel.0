Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37F1C7EE2F
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjFFW7F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbjFFW67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:58:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA97B172B;
        Tue,  6 Jun 2023 15:58:57 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 1/5] netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()
Date:   Wed,  7 Jun 2023 00:58:47 +0200
Message-Id: <20230606225851.67394-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606225851.67394-1-pablo@netfilter.org>
References: <20230606225851.67394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

The nla_nest_start_noflag() function may fail and return NULL;
the return value needs to be checked.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc5675962de4..3445b8e1f462 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1600,6 +1600,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 
 	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
+		if (!nest_devs)
+			goto nla_put_failure;
 
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
-- 
2.30.2

