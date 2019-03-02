Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CDBC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5708820838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfCBSg3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:29 -0500
Received: from mail.us.es ([193.147.175.20]:36098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbfCBSg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7CDD1361B7
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8B1EDA846
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDD6CDA85D; Sat,  2 Mar 2019 19:36:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D21CADA863;
        Sat,  2 Mar 2019 19:36:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 454494265A2F;
        Sat,  2 Mar 2019 19:36:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/29] netfilter: nft_set_hash: bogus element self comparison from deactivation path
Date:   Sat,  2 Mar 2019 19:36:00 +0100
Message-Id: <20190302183613.3159-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the element from the loop iteration, not the same element we want to
deactivate otherwise this branch always evaluates true.

Fixes: 6c03ae210ce3 ("netfilter: nft_set_hash: add non-resizable hashtable implementation")
Reported-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 8d5611634a56..f4da3677bdfc 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -541,7 +541,7 @@ static void *nft_hash_deactivate(const struct net *net,
 
 	hash = nft_jhash(set, priv, &this->ext);
 	hlist_for_each_entry(he, &priv->table[hash], node) {
-		if (!memcmp(nft_set_ext_key(&this->ext), &elem->key.val,
+		if (!memcmp(nft_set_ext_key(&he->ext), &elem->key.val,
 			    set->klen) &&
 		    nft_set_elem_active(&he->ext, genmask)) {
 			nft_set_elem_change_active(net, set, &he->ext);
-- 
2.11.0


