From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_TCPMSS: Add IPv6 default MSS
Date: Mon, 10 Jun 2013 08:30:38 -0400
Message-ID: <20130610123038.GA5089@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44024 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FLDnY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:43:24 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so5493786pde.32
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2013 20:43:24 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As a followup to commit 409b545a ("netfilter: xt_TCPMSS: Fix violation of RFC879
in absence of MSS option"), John Heffner points out that IPv6 has a higher MTU
than IPv4, and thus a higher minimum MSS.  Update TCPMSS target to account
for this, and update RFC comment.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-tcpmss_ipv6

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 53af7db..f123cbd 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -48,7 +48,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		     const struct xt_tcpmss_info *info,
 		     unsigned int in_mtu,
 		     unsigned int tcphoff,
-		     unsigned int minlen)
+		     unsigned int minlen,
+		     unsigned int family)
 {
 	struct tcphdr *tcph;
 	unsigned int tcplen, i;
@@ -126,11 +127,16 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	skb_put(skb, TCPOLEN_MSS);
 
 	/*
-	 * RFC 879 states that the default MSS is 536 without specific
-	 * knowledge that the destination host is prepared to accept larger.
-	 * Since no MSS was provided, we MUST NOT set a value > 536.
+	 * IPv4: RFC 1122 states "If an MSS option is not received at connection
+	 * setup, TCP MUST assume a default send MSS of 536". 
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
 	 */
-	newmss = min(newmss, (u16)536);
+	if (family == PF_INET)
+		newmss=min(newmss, (u16)536);
+	else
+		newmss=min(newmss, (u16)1220);
 
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
@@ -192,7 +198,8 @@ tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
+				   sizeof(*iph) + sizeof(struct tcphdr),
+				   PF_INET);
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {
@@ -221,7 +228,8 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+				   sizeof(*ipv6h) + sizeof(struct tcphdr),
+				   PF_INET6);
 	if (ret < 0)
 		return NF_DROP;
 	if (ret > 0) {

--RnlQjJ0d97Da+TV1--
