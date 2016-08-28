From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_tables_netdev: remove redundant ip_hdr assignment
Date: Sun, 28 Aug 2016 16:59:52 +0800
Message-ID: <1472374792-22765-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:49717 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755236AbcH1JAZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Aug 2016 05:00:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We have already use skb_header_pointer to get the ip header pointer,
so there's no need to use ip_hdr again. Moreover, in NETDEV INGRESS
hook, ip header maybe not linear, so use ip_hdr is not appropriate,
remove it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_netdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 5eefe4a..75d696f 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -30,7 +30,6 @@ nft_netdev_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
 	if (!iph)
 		return;
 
-	iph = ip_hdr(skb);
 	if (iph->ihl < 5 || iph->version != 4)
 		return;
 
-- 
2.5.5


