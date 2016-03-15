From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/18] ipvs: handle ip_vs_fill_iph_skb_off failure
Date: Tue, 15 Mar 2016 02:27:47 +0100
Message-ID: <1458005282-24665-4-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33269 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335AbcCOB2i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:28:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7823D114F43
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 60099DA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8284CDA380
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:21 +0100 (CET)
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

ip_vs_fill_iph_skb_off() may not find an IP header, and gcc has
determined that ip_vs_sip_fill_param() then incorrectly accesses
the protocol fields:

net/netfilter/ipvs/ip_vs_pe_sip.c: In function 'ip_vs_sip_fill_param':
net/netfilter/ipvs/ip_vs_pe_sip.c:76:5: error: 'iph.protocol' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  if (iph.protocol != IPPROTO_UDP)
     ^
net/netfilter/ipvs/ip_vs_pe_sip.c:81:10: error: 'iph.len' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  dataoff = iph.len + sizeof(struct udphdr);
          ^

This adds a check for the ip_vs_fill_iph_skb_off() return code
before looking at the ip header data returned from it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b0e010c527de ("ipvs: replace ip_vs_fill_ip4hdr with ip_vs_fill_iph_skb_off")
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_pe_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index 1b8d594..c4e9ca0 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -70,10 +70,10 @@ ip_vs_sip_fill_param(struct ip_vs_conn_param *p, struct sk_buff *skb)
 	const char *dptr;
 	int retc;
 
-	ip_vs_fill_iph_skb(p->af, skb, false, &iph);
+	retc = ip_vs_fill_iph_skb(p->af, skb, false, &iph);
 
 	/* Only useful with UDP */
-	if (iph.protocol != IPPROTO_UDP)
+	if (!retc || iph.protocol != IPPROTO_UDP)
 		return -EINVAL;
 	/* todo: IPv6 fragments:
 	 *       I think this only should be done for the first fragment. /HS
-- 
2.1.4

