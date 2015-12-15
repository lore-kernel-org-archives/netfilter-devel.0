From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: use skb->protocol instead of assuming ethernet header
Date: Tue, 15 Dec 2015 21:29:16 +0100
Message-ID: <1450211356-10927-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60649 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbbLOU3Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 15:29:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1BA8E18FCE3
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:29:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0D3EFDA804
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:29:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0AE3EDA804
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2015 21:29:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise we may end up with incorrect network and transport header for
other protocols.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 3e9c87b..b6605e0 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -94,7 +94,7 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 {
 	struct nft_pktinfo pkt;
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		nft_netdev_set_pktinfo_ipv4(&pkt, skb, state);
 		break;
-- 
2.1.4

