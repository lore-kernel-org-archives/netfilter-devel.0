Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BFEC7EE22
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjERJrM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjERJrL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:47:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4EF1720
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:47:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pzaDv-0005dm-BO; Thu, 18 May 2023 11:47:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@breakpoint.cc
Cc:     Jakub Kicinski <kuba@kernel.org>, eric@breakpoint.cc,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/9] netfilter: nft_set_pipapo: Use struct_size()
Date:   Thu, 18 May 2023 11:46:38 +0200
Message-Id: <20230518094642.84097-6-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518094642.84097-1-fw@strlen.de>
References: <20230518094642.84097-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Use struct_size() instead of hand writing it.
This is less verbose and more informative.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 06d46d182634..34c684e121d3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1274,8 +1274,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	struct nft_pipapo_match *new;
 	int i;
 
-	new = kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
-		      GFP_KERNEL);
+	new = kmalloc(struct_size(new, f, old->field_count), GFP_KERNEL);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
@@ -2059,8 +2058,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
 
-	m = kmalloc(sizeof(*priv->match) + sizeof(*f) * field_count,
-		    GFP_KERNEL);
+	m = kmalloc(struct_size(m, f, field_count), GFP_KERNEL);
 	if (!m)
 		return -ENOMEM;
 
-- 
2.40.1

