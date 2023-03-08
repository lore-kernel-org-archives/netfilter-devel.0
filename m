Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741A3C678D5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Mar 2023 19:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCHTbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Mar 2023 14:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjCHTb2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2023 14:31:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B513CF0C0;
        Wed,  8 Mar 2023 11:31:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzVG-0003sZ-9p; Wed, 08 Mar 2023 20:31:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH net-next 8/9] netfilter: conntrack: fix typo
Date:   Wed,  8 Mar 2023 20:30:32 +0100
Message-Id: <20230308193033.13965-9-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193033.13965-1-fw@strlen.de>
References: <20230308193033.13965-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

There's a spelling mistake in a comment.  Fix it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7250082e7de5..004c54132a3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1294,7 +1294,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_confirm);
 
-/* Returns true if a connection correspondings to the tuple (required
+/* Returns true if a connection corresponds to the tuple (required
    for NAT). */
 int
 nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
-- 
2.39.2

