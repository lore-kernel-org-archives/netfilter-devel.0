From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nftables: onlly allow in/output for arp packets
Date: Fri,  7 Jul 2017 13:29:03 +0200
Message-ID: <20170707112903.9545-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41104 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750938AbdGGL3J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 07:29:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

arp packets cannot be forwarded.

They can be bridged, but then they can be filtered using
either ebtables or nftables bridge family.

The bridge netfilter exposes a "call-arptables" switch which
pushes packets into arptables, but lets not expose this for nftables, so better
close this asap.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_tables_arp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 805c8dd..4bbc273 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -72,8 +72,7 @@ static const struct nf_chain_type filter_arp = {
 	.family		= NFPROTO_ARP,
 	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_ARP_IN) |
-			  (1 << NF_ARP_OUT) |
-			  (1 << NF_ARP_FORWARD),
+			  (1 << NF_ARP_OUT),
 };
 
 static int __init nf_tables_arp_init(void)
-- 
2.9.4

