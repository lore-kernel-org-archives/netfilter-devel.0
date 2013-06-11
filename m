From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()
Date: Tue, 11 Jun 2013 02:13:56 +0200
Message-ID: <1370909636-3532-1-git-send-email-pablo@netfilter.org>
Cc: kernel@linuxace.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab3FKAOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jun 2013 20:14:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In (bc6bcb5 netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
packet boundary), the use of tcp_hdr was introduced. However, we
cannot assume that skb->transport_header is set for non-local packets.

Cc: Florian Westphal <fw@strlen.de>
Reported-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TCPOPTSTRIP.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 1eb1a44..b68fa19 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -48,11 +48,13 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 		return NF_DROP;
 
 	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr) ||
-	    tcp_hdr(skb)->doff * 4 > len)
+	if (len < (int)sizeof(struct tcphdr))
 		return NF_DROP;
 
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	if (tcph->doff * 4 > len)
+		return NF_DROP;
+
 	opt  = (u_int8_t *)tcph;
 
 	/*
-- 
1.7.10.4

