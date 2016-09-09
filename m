From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/5] netfilter: nf_tables_ipv6: setup pktinfo transport field on failure to parse
Date: Fri,  9 Sep 2016 12:42:50 +0200
Message-ID: <1473417773-9840-2-git-send-email-pablo@netfilter.org>
References: <1473417773-9840-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbcIIKnC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 06:43:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF6332EFEA3
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:43:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F60E114D62
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:43:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0ED81150DA
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:42:56 +0200 (CEST)
In-Reply-To: <1473417773-9840-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the pktinfo protocol fields are initialized if this fails to
parse the transport header.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_ipv6.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 6aeee47..1e0ffd5 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -15,9 +15,10 @@ nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 	nft_set_pktinfo(pkt, skb, state);
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
-	/* If malformed, drop it */
-	if (protohdr < 0)
+	if (protohdr < 0) {
+		nft_set_pktinfo_proto_unspec(pkt, skb);
 		return -1;
+	}
 
 	pkt->tprot_set = true;
 	pkt->tprot = protohdr;
-- 
2.1.4

