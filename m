From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/10] netfilter: nft_ct: do cleanup work when NFTA_CT_DIRECTION is invalid
Date: Wed, 15 Mar 2017 18:01:12 +0100
Message-ID: <1489597272-30347-11-git-send-email-pablo@netfilter.org>
References: <1489597272-30347-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753194AbdCORBp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 13:01:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CB941324E0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 18:01:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E507DA725
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 18:01:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10944DA870
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 18:01:25 +0100 (CET)
In-Reply-To: <1489597272-30347-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We should jump to invoke __nft_ct_set_destroy() instead of just
return error.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 91585b5e5307..0264258c46fe 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -544,7 +544,8 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		case IP_CT_DIR_REPLY:
 			break;
 		default:
-			return -EINVAL;
+			err = -EINVAL;
+			goto err1;
 		}
 	}
 
-- 
2.1.4

