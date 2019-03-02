Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A67C4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA61C20838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfCBSgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:33 -0500
Received: from mail.us.es ([193.147.175.20]:36090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbfCBSg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25FEE1361AE
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14400DA863
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 09BF9DA84E; Sat,  2 Mar 2019 19:36:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E05ADA796;
        Sat,  2 Mar 2019 19:36:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C2E5C4265A2F;
        Sat,  2 Mar 2019 19:36:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/29] netfilter: nft_set_hash: remove nft_hash_key()
Date:   Sat,  2 Mar 2019 19:36:01 +0100
Message-Id: <20190302183613.3159-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

hashtable is never used for 2-byte keys, remove nft_hash_key().

Fixes: e240cd0df481 ("netfilter: nf_tables: place all set backends in one single module")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index f4da3677bdfc..03df08801e28 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -442,15 +442,6 @@ static void *nft_hash_get(const struct net *net, const struct nft_set *set,
 	return ERR_PTR(-ENOENT);
 }
 
-/* nft_hash_select_ops() makes sure key size can be either 2 or 4 bytes . */
-static inline u32 nft_hash_key(const u32 *key, u32 klen)
-{
-	if (klen == 4)
-		return *key;
-
-	return *(u16 *)key;
-}
-
 static bool nft_hash_lookup_fast(const struct net *net,
 				 const struct nft_set *set,
 				 const u32 *key, const struct nft_set_ext **ext)
@@ -460,11 +451,11 @@ static bool nft_hash_lookup_fast(const struct net *net,
 	const struct nft_hash_elem *he;
 	u32 hash, k1, k2;
 
-	k1 = nft_hash_key(key, set->klen);
+	k1 = *key;
 	hash = jhash_1word(k1, priv->seed);
 	hash = reciprocal_scale(hash, priv->buckets);
 	hlist_for_each_entry_rcu(he, &priv->table[hash], node) {
-		k2 = nft_hash_key(nft_set_ext_key(&he->ext)->data, set->klen);
+		k2 = *(u32 *)nft_set_ext_key(&he->ext)->data;
 		if (k1 == k2 &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			*ext = &he->ext;
-- 
2.11.0


