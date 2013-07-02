From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 10/15] netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()
Date: Tue,  2 Jul 2013 16:51:00 +0200
Message-ID: <1372776665-6795-10-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3GBOwY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:52:24 -0400
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In (bc6bcb5 netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
packet boundary), the use of tcp_hdr was introduced. However, we
cannot assume that skb->transport_header is set for non-local packets.

Cc: Florian Westphal <fw@strlen.de>
Reported-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: ed82c437320c48a4032492f4a55a7e2c934158b6

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

