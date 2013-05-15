From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
Date: Wed, 15 May 2013 14:05:52 +0200
Message-ID: <1368619552-30635-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56415 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab3EOMGA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 08:06:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This target assumes that tcph->doff is well-formed, that may be well
not the case. Add extra sanity checkings to avoid possible crash due
to read/write out of the real packet boundary.

Reported-by: Rafal Kupka <rkupka@telemetry.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TCPOPTSTRIP.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 25fd1c4..3cdd56f 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -30,17 +30,33 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 
 static unsigned int
 tcpoptstrip_mangle_packet(struct sk_buff *skb,
-			  const struct xt_tcpoptstrip_target_info *info,
+			  const struct xt_action_param *par,
 			  unsigned int tcphoff, unsigned int minlen)
 {
+	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
 	unsigned int optl, i, j;
 	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
+	int len;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
 
 	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
+	len = skb->len - tcphoff;
+	if (len < sizeof(struct tcphdr))
+		return NF_DROP;
+
+	len -= sizeof(*tcph);
+
+	/* Truncated TCP options, skip */
+	if ((tcp_hdr(skb)->doff - 5) * 4 > len)
+		return NF_DROP;
+
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	opt  = (u_int8_t *)tcph;
 
@@ -51,7 +67,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 	for (i = sizeof(struct tcphdr); i < tcp_hdrlen(skb); i += optl) {
 		optl = optlen(opt, i);
 
-		if (i + optl > tcp_hdrlen(skb))
+		if (i + optl > len)
 			break;
 
 		if (!tcpoptstrip_test_bit(info->strip_bmap, opt[i]))
@@ -76,7 +92,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 static unsigned int
 tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
+	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
 	       sizeof(struct iphdr) + sizeof(struct tcphdr));
 }
 
@@ -94,7 +110,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
+	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
 	       sizeof(*ipv6h) + sizeof(struct tcphdr));
 }
 #endif
-- 
1.7.10.4

