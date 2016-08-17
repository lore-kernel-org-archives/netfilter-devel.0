From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables_netdev: set nft_pktinfo field for non-IP traffic
Date: Wed, 17 Aug 2016 17:14:59 +0200
Message-ID: <1471446899-12952-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbcHQPPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:15:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2D81DD1636
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:15:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21A8FDA3B0
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:15:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CDDFFDA800
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:15:03 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For non-IP traffic seen from the netdev family, set nft_pktinfo fields
other the value of these fields is garbage.

This patch sets transport protocol number to IPPROTO_RAW since 0 means
IPPROTO_IP, then zero transport and fragment offsets.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nf_tables_netdev.c  |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f2f1339..688a78b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -36,6 +36,16 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->pf = pkt->xt.family = state->pf;
 }
 
+static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
+					  struct sk_buff *skb,
+					  const struct nf_hook_state *state)
+{
+	nft_set_pktinfo(pkt, skb, state);
+	pkt->tprot = IPPROTO_RAW;
+	pkt->xt.thoff = 0;
+	pkt->xt.fragoff = 0;
+}
+
 /**
  * 	struct nft_verdict - nf_tables verdict
  *
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 5eefe4a..2556986 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -102,7 +102,7 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 		nft_netdev_set_pktinfo_ipv6(&pkt, skb, state);
 		break;
 	default:
-		nft_set_pktinfo(&pkt, skb, state);
+		nft_set_pktinfo_unspec(&pkt, skb, state);
 		break;
 	}
 
-- 
2.1.4

