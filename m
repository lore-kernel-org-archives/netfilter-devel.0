From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] netfilter: nf_tables: only allow in/output for arp packets
Date: Tue, 18 Jul 2017 12:13:58 +0200
Message-ID: <1500372839-6735-5-git-send-email-pablo@netfilter.org>
References: <1500372839-6735-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdGRKOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 06:14:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A69A6A416C
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:14:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 963B7DA46B
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:14:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C114DA81E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:13:59 +0200 (CEST)
In-Reply-To: <1500372839-6735-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

arp packets cannot be forwarded.

They can be bridged, but then they can be filtered using
either ebtables or nftables bridge family.

The bridge netfilter exposes a "call-arptables" switch which
pushes packets into arptables, but lets not expose this for nftables, so better
close this asap.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tables_arp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 805c8ddfe860..4bbc273b45e8 100644
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
2.1.4

