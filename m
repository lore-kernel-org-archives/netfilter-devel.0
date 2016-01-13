From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_ct: keep counters away from CONFIG_NF_CONNTRACK_LABELS
Date: Wed, 13 Jan 2016 17:47:53 +0100
Message-ID: <1452703673-4046-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbcAMQsC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 11:48:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E58692E784D
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 17:48:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D463FDA860
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 17:48:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D035BDA801
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 17:47:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is accidental, they don't depend on the label infrastructure.

Fixes: 48f66c905a97 ("netfilter: nft_ct: add byte/packet counter support")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a0eb216..d4a4619 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -127,6 +127,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			       NF_CT_LABELS_MAX_SIZE - size);
 		return;
 	}
+#endif
 	case NFT_CT_BYTES: /* fallthrough */
 	case NFT_CT_PKTS: {
 		const struct nf_conn_acct *acct = nf_conn_acct_find(ct);
@@ -138,7 +139,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		memcpy(dest, &count, sizeof(count));
 		return;
 	}
-#endif
 	default:
 		break;
 	}
-- 
2.1.4

