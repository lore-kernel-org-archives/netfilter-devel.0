Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6828ECDB46E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 08:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjJLI5r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjJLI5r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 04:57:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F42990;
        Thu, 12 Oct 2023 01:57:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqrVk-00076Q-VP; Thu, 12 Oct 2023 10:57:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        coreteam@netfilter.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH net 3/7] netfilter: nf_tables: Annotate struct nft_pipapo_match with __counted_by
Date:   Thu, 12 Oct 2023 10:57:06 +0200
Message-ID: <20231012085724.15155-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231012085724.15155-1-fw@strlen.de>
References: <20231012085724.15155-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time via CONFIG_UBSAN_BOUNDS (for
array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct nft_pipapo_match.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Link: https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci [1]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 25a75591583e..2e164a319945 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -147,7 +147,7 @@ struct nft_pipapo_match {
 	unsigned long * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
-	struct nft_pipapo_field f[];
+	struct nft_pipapo_field f[] __counted_by(field_count);
 };
 
 /**
-- 
2.41.0

