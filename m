From: fgao@ikuai8.com
Subject: [PATCH nf-next] netfilter: log_arp: Use ARPHRD_ETHER instead of literal '1'
Date: Sun, 28 Aug 2016 21:41:22 +0800
Message-ID: <1472391682-13832-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG351.QQ.COM ([183.57.50.165]:35570 "EHLO smtpbg351.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbcH1Nu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 09:50:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There is one macro ARPHRD_ETHER which defines the ethernet proto for ARP,
so we could use it instead of the literal number '1'.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/ipv4/netfilter/nf_log_arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_log_arp.c b/net/ipv4/netfilter/nf_log_arp.c
index e7ad950..cf8f2d4 100644
--- a/net/ipv4/netfilter/nf_log_arp.c
+++ b/net/ipv4/netfilter/nf_log_arp.c
@@ -62,7 +62,7 @@ static void dump_arp_packet(struct nf_log_buf *m,
 	/* If it's for Ethernet and the lengths are OK, then log the ARP
 	 * payload.
 	 */
-	if (ah->ar_hrd != htons(1) ||
+	if (ah->ar_hrd != htons(ARPHRD_ETHER) ||
 	    ah->ar_hln != ETH_ALEN ||
 	    ah->ar_pln != sizeof(__be32))
 		return;
-- 
1.9.1


