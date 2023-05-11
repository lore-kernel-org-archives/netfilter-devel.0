Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DE4C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 15:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbjEKPmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 11:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238797AbjEKPmG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 11:42:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7742861AE;
        Thu, 11 May 2023 08:42:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 3/6] netfilter: nft_hash: fix nft_hash_deactivate
Date:   Thu, 11 May 2023 17:41:40 +0200
Message-Id: <20230511154143.52469-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230511154143.52469-1-pablo@netfilter.org>
References: <20230511154143.52469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ backport for 4.14 of 7f4dae2d7f03d2aaf3b7d8343d4509c8d9d7ca9b ]

Jindřich Makovička says:
  The logical OR looks fishy to me. Shouldn't be && there instead?

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1199
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index a684234bd229..eb7db31dd173 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -520,7 +520,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
-			    set->klen) ||
+			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
 			return he;
-- 
2.30.2

