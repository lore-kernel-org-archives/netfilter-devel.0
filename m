From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2] netfilter: nf_tables_arp: don't set forward chain
Date: Sun, 10 Dec 2017 21:27:53 +0100
Message-ID: <20171210202753.11128-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44712 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbdLJU2B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 15:28:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C64AEDA73F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:27:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8351DA793
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:27:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84720DA7F1
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:27:57 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 61127426CC80
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 21:27:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

46928a0b49f3 ("netfilter: nf_tables: remove multihook chains and
families") already removed this, this is a leftover.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Just a rebase on top of nf-next.

 net/ipv4/netfilter/nf_tables_arp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index 4bbc273b45e8..ec47c12cd137 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -34,7 +34,6 @@ static struct nft_af_info nft_af_arp __read_mostly = {
 	.hooks		= {
 		[NF_ARP_IN]		= nft_do_chain_arp,
 		[NF_ARP_OUT]		= nft_do_chain_arp,
-		[NF_ARP_FORWARD]	= nft_do_chain_arp,
 	},
 };
 
-- 
2.11.0

