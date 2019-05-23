Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5594C282E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 804A420881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfEWNn4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:56 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48840 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730549AbfEWNn4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0f-0007k0-EI; Thu, 23 May 2019 15:43:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/8] netfilter: tcpmss, optstrip: prefer skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:11 +0200
Message-Id: <20190523134412.3295-8-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This also changes optstrip to only make the tcp header writeable
rather than the entire packet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_TCPMSS.c      |  2 +-
 net/netfilter/xt_TCPOPTSTRIP.c | 28 +++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 98efb202f8b4..3e24443ab81c 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -89,7 +89,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	if (par->fragoff != 0)
 		return 0;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return -1;
 
 	len = skb->len - tcphoff;
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index eb92bffff11c..5a274813076a 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -31,33 +31,33 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 static unsigned int
 tcpoptstrip_mangle_packet(struct sk_buff *skb,
 			  const struct xt_action_param *par,
-			  unsigned int tcphoff, unsigned int minlen)
+			  unsigned int tcphoff)
 {
 	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
+	struct tcphdr *tcph, _th;
 	unsigned int optl, i, j;
-	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
-	int len, tcp_hdrlen;
+	int tcp_hdrlen;
 
 	/* This is a fragment, no TCP header is available */
 	if (par->fragoff != 0)
 		return XT_CONTINUE;
 
-	if (!skb_make_writable(skb, skb->len))
+	tcph = skb_header_pointer(skb, tcphoff, sizeof(_th), &_th);
+	if (!tcph)
 		return NF_DROP;
 
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return NF_DROP;
-
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	tcp_hdrlen = tcph->doff * 4;
+	if (tcp_hdrlen < sizeof(struct tcphdr))
+		return NF_DROP;
 
-	if (len < tcp_hdrlen)
+	if (skb_ensure_writable(skb, tcphoff + tcp_hdrlen))
 		return NF_DROP;
 
-	opt  = (u_int8_t *)tcph;
+	/* must reload tcph, might have been moved */
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	opt  = (u8 *)tcph;
 
 	/*
 	 * Walk through all TCP options - if we find some option to remove,
@@ -91,8 +91,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 static unsigned int
 tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
-	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
 #if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
@@ -109,8 +108,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
-	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+	return tcpoptstrip_mangle_packet(skb, par, tcphoff);
 }
 #endif
 
-- 
2.21.0

