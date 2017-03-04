From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: set pktinfo->thoff at AH header if found
Date: Sat,  4 Mar 2017 19:53:47 +0100
Message-ID: <1488653627-4815-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752007AbdCDSyP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Mar 2017 13:54:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2BED1AEA73
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 19:54:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1211BAAA2
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 19:54:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58115BAAA1
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2017 19:54:04 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter reports that IPv6 AH header matching is broken. From
userspace, nft generates bytecode that expects to find the AH header at
NFT_PAYLOAD_TRANSPORT_HEADER both for IPv4 and IPv6. However,
pktinfo->thoff is set to the inner header after the AH header in IPv6,
while in IPv4 pktinfo->thoff points to the AH header indeed. This
behaviour is inconsistent. This patch fixes this problem by updating
ipv6_find_hdr() to get the IP6_FH_F_AUTH flag so this function stops at
the AH header, so both IPv4 and IPv6 pktinfo->thoff point to the AH
header.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I prefer to fix this now, rather than living with this inconsistency
forever. nft IPv6 AH matching has been broken since day 1, so we're sure
that nobody has been using this.

For those willing match to inner headers, I prefer we explore inner
matching via explicit syntax and likely new payload base definition in
enum nft_payload_bases.

 include/net/netfilter/nf_tables_ipv6.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index d150b5066201..97983d1c05e4 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -9,12 +9,13 @@ nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 		     struct sk_buff *skb,
 		     const struct nf_hook_state *state)
 {
+	unsigned int flags = IP6_FH_F_AUTH;
 	int protohdr, thoff = 0;
 	unsigned short frag_off;
 
 	nft_set_pktinfo(pkt, skb, state);
 
-	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
+	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
 	if (protohdr < 0) {
 		nft_set_pktinfo_proto_unspec(pkt, skb);
 		return;
@@ -32,6 +33,7 @@ __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 				const struct nf_hook_state *state)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	unsigned int flags = IP6_FH_F_AUTH;
 	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = 0;
 	unsigned short frag_off;
@@ -50,7 +52,7 @@ __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 	if (pkt_len + sizeof(*ip6h) > skb->len)
 		return -1;
 
-	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
+	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
 	if (protohdr < 0)
 		return -1;
 
-- 
2.1.4

