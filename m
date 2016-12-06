From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_payload: restrict l4 checksum updates to l3 header mangling
Date: Tue,  6 Dec 2016 11:27:18 +0100
Message-ID: <1481020038-3235-1-git-send-email-pablo@netfilter.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752544AbcLFK2E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:28:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA972C0B36
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:27:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACF28DA853
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:27:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEEE4DA853
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:27:33 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow layer 4 header checksum updates if the layer 3 header was modified.

net/netfilter/nft_payload.c:261:15: note: 'tsum' was declared here
  __wsum fsum, tsum;
               ^
In file included from include/linux/skbuff.h:31:0,
                 from include/linux/if_ether.h:23,
                 from include/uapi/linux/ethtool.h:18,
                 from include/linux/ethtool.h:17,
                 from include/linux/netdevice.h:42,
                 from include/linux/if_vlan.h:15,
                 from net/netfilter/nft_payload.c:13:
include/net/checksum.h:71:9: warning: 'fsum' may be used uninitialized in this function [-Wmaybe-uninitialized]
  return csum_add(csum, ~addend);
         ^
net/netfilter/nft_payload.c:261:9: note: 'fsum' was declared here
  __wsum fsum, tsum;

Fixes: 556c291b3a1b ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 30d296340f9a..fe0fe2d3e73b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -257,6 +257,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	const struct nft_payload_set *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 	const u32 *src = &regs->data[priv->sreg];
+	bool csum_mangled = false;
 	int offset, csum_offset;
 	__wsum fsum, tsum;
 	__sum16 sum;
@@ -295,9 +296,11 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		if (!skb_make_writable(skb, csum_offset + sizeof(sum)) ||
 		    skb_store_bits(skb, csum_offset, &sum, sizeof(sum)) < 0)
 			goto err;
+
+		csum_mangled = true;
 	}
 
-	if (priv->csum_flags &&
+	if (priv->csum_flags && csum_mangled &&
 	    nft_payload_l4csum_update(pkt, skb, fsum, tsum) < 0)
 		goto err;
 
-- 
2.1.4

