From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/9] netfilter: xt_TCPMSS: add more sanity tests on tcph->doff
Date: Fri, 14 Apr 2017 02:26:43 +0200
Message-ID: <1492129611-29336-2-git-send-email-pablo@netfilter.org>
References: <1492129611-29336-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbdDNA1F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 20:27:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2BB9EE0439
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:27:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CF4FDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:27:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E844DA848
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 02:26:58 +0200 (CEST)
In-Reply-To: <1492129611-29336-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

Denys provided an awesome KASAN report pointing to an use
after free in xt_TCPMSS

I have provided three patches to fix this issue, either in xt_TCPMSS or
in xt_tcpudp.c. It seems xt_TCPMSS patch has the smallest possible
impact.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TCPMSS.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 27241a767f17..c64aca611ac5 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -104,7 +104,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	tcp_hdrlen = tcph->doff * 4;
 
-	if (len < tcp_hdrlen)
+	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
 		return -1;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
@@ -152,6 +152,10 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	if (len > tcp_hdrlen)
 		return 0;
 
+	/* tcph->doff has 4 bits, do not wrap it to 0 */
+	if (tcp_hdrlen >= 15 * 4)
+		return 0;
+
 	/*
 	 * MSS Option not found ?! add it..
 	 */
-- 
2.1.4

