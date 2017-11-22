From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: nf_tables_arp: don't set forward chain
Date: Wed, 22 Nov 2017 15:04:23 +0100
Message-ID: <20171122140424.14914-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdKVOEc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:04:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 426051D94B3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34F92DA863
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1763BDA863
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:28 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CFAFE403DFA0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:04:27 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

46928a0b49f3 ("netfilter: nf_tables: remove multihook chains and
families") already removed this, this is a leftover.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tables_arp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 981f7e283fca..89baee02eed4 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -33,7 +33,6 @@ static struct nft_af_info nft_af_arp __read_mostly = {
 	.hooks		= {
 		[NF_ARP_IN]		= nft_do_chain_arp,
 		[NF_ARP_OUT]		= nft_do_chain_arp,
-		[NF_ARP_FORWARD]	= nft_do_chain_arp,
 	},
 };
 
-- 
2.11.0

