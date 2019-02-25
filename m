Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC96C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 13:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D6D20652
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 13:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfBYNNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:13:51 -0500
Received: from mail.us.es ([193.147.175.20]:59544 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbfBYNNv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 08:13:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 135AA53AA32
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:13:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1805DA84E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:13:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E6948DA872; Mon, 25 Feb 2019 14:13:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE996DA84E;
        Mon, 25 Feb 2019 14:13:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Feb 2019 14:13:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BC5094265A2F;
        Mon, 25 Feb 2019 14:13:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf 1/3] netfilter: nft_set_hash: fix lookups with fixed size hash on big endian
Date:   Mon, 25 Feb 2019 14:13:41 +0100
Message-Id: <20190225131343.8080-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call jhash_1word() for the 4-bytes key case from the insertion and
deactivation path, otherwise big endian arch set lookups fail.

Fixes: 446a8268b7f5 ("netfilter: nft_set_hash: add lookup variant for fixed size hashtable")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 339a9dd1c832..8d5611634a56 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -474,6 +474,23 @@ static bool nft_hash_lookup_fast(const struct net *net,
 	return false;
 }
 
+static u32 nft_jhash(const struct nft_set *set, const struct nft_hash *priv,
+		     const struct nft_set_ext *ext)
+{
+	const struct nft_data *key = nft_set_ext_key(ext);
+	u32 hash, k1;
+
+	if (set->klen == 4) {
+		k1 = *(u32 *)key;
+		hash = jhash_1word(k1, priv->seed);
+	} else {
+		hash = jhash(key, set->klen, priv->seed);
+	}
+	hash = reciprocal_scale(hash, priv->buckets);
+
+	return hash;
+}
+
 static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 			   const struct nft_set_elem *elem,
 			   struct nft_set_ext **ext)
@@ -483,8 +500,7 @@ static int nft_hash_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext),
 			    nft_set_ext_key(&he->ext), set->klen) &&
@@ -523,8 +539,7 @@ static void *nft_hash_deactivate(const struct net *net,
 	u8 genmask = nft_genmask_next(net);
 	u32 hash;
 
-	hash = jhash(nft_set_ext_key(&this->ext), set->klen, priv->seed);
-	hash = reciprocal_scale(hash, priv->buckets);
+	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
 		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
 			    set->klen) &&
-- 
2.11.0

