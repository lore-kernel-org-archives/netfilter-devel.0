From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_TCPMSS: Add safe fragmentation handling
Date: Mon, 10 Jun 2013 00:06:34 -0400
Message-ID: <20130610040634.GB2742@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8GpibOaaTibBMecb"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64637 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3FJSF6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:05:58 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so3225560pde.23
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2013 11:05:57 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Similar to commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix possible mangling
beyond packet boundary"), add safe fragment handling to xt_TCPMSS.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-tcpmss-frag

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index a75240f..d81b760 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -45,17 +45,22 @@ optlen(const u_int8_t *opt, unsigned int offset)
 
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_tcpmss_info *info,
+		     const struct xt_action_param *par,
 		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
+	const struct xt_tcpmss_info *info = par->targinfo;
 	struct tcphdr *tcph;
 	unsigned int tcplen, i;
 	__be16 oldval;
 	u16 newmss;
 	u8 *opt;
 
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
+
 	if (!skb_make_writable(skb, skb->len))
 		return -1;
 
@@ -182,7 +187,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
@@ -211,7 +216,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));

--8GpibOaaTibBMecb--
