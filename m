From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH net] net: nft: call ipv6_find_hdr() with explicitly initialized offset
Date: Fri, 20 Dec 2013 11:23:15 +0100
Message-ID: <1387534995-28883-1-git-send-email-dborkman@redhat.com>
Cc: netfilter-devel@vger.kernel.org,
	Hannes Frederic Sowa <hannes@stressinduktion.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab3LTKXZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:23:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In nft's nft_exthdr_eval() routine we process IPv6 extension header
through invoking ipv6_find_hdr(), but we call it with an uninitialized
offset variable that contains some stack value. In ipv6_find_hdr()
we then test if the value of offset != 0 and call skb_header_pointer()
on that offset in order to map struct ipv6hdr into it. Fix it up by
initializing offset to 0 as it was probably intended to be.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 net/netfilter/nft_exthdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 8e0bb75..55c939f 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -31,7 +31,7 @@ static void nft_exthdr_eval(const struct nft_expr *expr,
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	struct nft_data *dest = &data[priv->dreg];
-	unsigned int offset;
+	unsigned int offset = 0;
 	int err;
 
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
-- 
1.8.3.1

