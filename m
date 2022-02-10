Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D88C43219
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Feb 2022 23:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345464AbiBJXKa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:10:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345462AbiBJXK3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 18:10:29 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED6DE5F4E;
        Thu, 10 Feb 2022 15:10:29 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E39E9601D5;
        Fri, 11 Feb 2022 00:10:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/6] netfilter: nft_synproxy: unregister hooks on init error path
Date:   Fri, 11 Feb 2022 00:10:19 +0100
Message-Id: <20220210231021.204488-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210231021.204488-1-pablo@netfilter.org>
References: <20220210231021.204488-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Disable the IPv4 hooks if the IPv6 hooks fail to be registered.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_synproxy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index a0109fa1e92d..1133e06f3c40 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -191,8 +191,10 @@ static int nft_synproxy_do_init(const struct nft_ctx *ctx,
 		if (err)
 			goto nf_ct_failure;
 		err = nf_synproxy_ipv6_init(snet, ctx->net);
-		if (err)
+		if (err) {
+			nf_synproxy_ipv4_fini(snet, ctx->net);
 			goto nf_ct_failure;
+		}
 		break;
 	}
 
-- 
2.30.2

