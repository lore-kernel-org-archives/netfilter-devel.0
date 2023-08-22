Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A13FEE49A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 15:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237287AbjHVPoJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbjHVPoI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 11:44:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6CDCCB;
        Tue, 22 Aug 2023 08:44:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qYTY1-0003G7-9n; Tue, 22 Aug 2023 17:44:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Justin Stitt <justinstitt@google.com>
Subject: [PATCH net-next 05/10] netfilter: nf_tables: refactor deprecated strncpy
Date:   Tue, 22 Aug 2023 17:43:26 +0200
Message-ID: <20230822154336.12888-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230822154336.12888-1-fw@strlen.de>
References: <20230822154336.12888-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Justin Stitt <justinstitt@google.com>

Prefer `strscpy_pad` over `strncpy`.

Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 601c9e09d07a..04b51f285332 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -151,7 +151,7 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 		if (priv->flags & NFTA_FIB_F_PRESENT)
 			*dreg = !!dev;
 		else
-			strncpy(reg, dev ? dev->name : "", IFNAMSIZ);
+			strscpy_pad(reg, dev ? dev->name : "", IFNAMSIZ);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.41.0

