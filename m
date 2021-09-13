Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4A1C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D2660E94
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhIMJ0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbhIMJ0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:26:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DAC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wQOi6ixMpuSU5zIDCIa1AnOa+qaISS26+CxWgyVo/jM=; b=AOj6HDguOoKWL30ZHjZ9N9keBM
        azxvEJHxpbPwIU+9aar6AQRiLb0Gqp+MqULv8s0qcXdJQxBPEXgwzgQDrGl8Y0LAu5gSpua5/meZE
        xHpDC7v2FJsbaR9/eZnQ4WBLEVnDHsooYzvUNpHXkDxX8ivbQ3pw0gXkzYlFYk3A2CgmHIOiyawdO
        9Ve+8MBrEoHHjlYy5vR35bvhEicTxeT3hyloGWeoL/sbpHMQ7Q3H44O2HWoep3c5zKIARqmtFUtHk
        RuTlv99N/8vrHIyJeey7nUenEPVC8iybwsn5xMfy998s+GwMPlG8VCkP+rH42K+3yxcadTfFh0iB/
        Dl72ofdw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPiCm-00GLzi-GM; Mon, 13 Sep 2021 10:24:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: [xtables-addons 2/4] xt_ipp2p: move the protocol-specific code out into separate functions
Date:   Mon, 13 Sep 2021 10:20:49 +0100
Message-Id: <20210913092051.79743-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913092051.79743-1-jeremy@azazel.net>
References: <20210913092051.79743-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 165 ++++++++++++++++++++++++------------------
 1 file changed, 93 insertions(+), 72 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 4e0fbb675c76..298950514569 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -807,15 +807,97 @@ static const struct {
 	{0},
 };
 
+static bool
+ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
+	     const unsigned char *haystack, unsigned int hlen,
+	     const struct iphdr *ip)
+{
+	size_t tcph_len = tcph->doff * 4;
+	bool p2p_result = false;
+	int i = 0;
+
+	if (tcph->fin) return 0;  /* if FIN bit is set bail out */
+	if (tcph->syn) return 0;  /* if SYN bit is set bail out */
+	if (tcph->rst) return 0;  /* if RST bit is set bail out */
+
+	if (hlen < tcph_len) {
+		if (info->debug)
+			pr_info("TCP header indicated packet larger than it is\n");
+		return 0;
+	}
+	if (hlen == tcph_len)
+		return 0;
+
+	haystack += tcph_len;
+	hlen     -= tcph_len;
+
+	while (matchlist[i].command) {
+		if ((info->cmd & matchlist[i].command) == matchlist[i].command &&
+		    hlen > matchlist[i].packet_len)
+		{
+			p2p_result = matchlist[i].function_name(haystack, hlen);
+			if (p2p_result)	{
+				if (info->debug)
+					printk("IPP2P.debug:TCP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
+					       p2p_result, &ip->saddr,
+					       ntohs(tcph->source),
+					       &ip->daddr,
+					       ntohs(tcph->dest), hlen);
+				return p2p_result;
+			}
+		}
+		i++;
+	}
+	return p2p_result;
+}
+
+static bool
+ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
+	     const unsigned char *haystack, unsigned int hlen,
+	     const struct iphdr *ip)
+{
+	size_t udph_len = sizeof(*udph);
+	bool p2p_result = false;
+	int i = 0;
+
+	if (hlen < udph_len) {
+		if (info->debug)
+			pr_info("UDP header indicated packet larger than it is\n");
+		return 0;
+	}
+	if (hlen == udph_len)
+		return 0;
+
+	haystack += udph_len;
+	hlen     -= udph_len;
+
+	while (udp_list[i].command) {
+		if ((info->cmd & udp_list[i].command) == udp_list[i].command &&
+		    hlen > udp_list[i].packet_len)
+		{
+			p2p_result = udp_list[i].function_name(haystack, hlen);
+			if (p2p_result) {
+				if (info->debug)
+					printk("IPP2P.debug:UDP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
+					       p2p_result, &ip->saddr,
+					       ntohs(udph->source),
+					       &ip->daddr,
+					       ntohs(udph->dest), hlen);
+				return p2p_result;
+			}
+		}
+		i++;
+	}
+	return p2p_result;
+}
+
 static bool
 ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_p2p_info *info = par->matchinfo;
-	const unsigned char  *haystack;
 	const struct iphdr *ip = ip_hdr(skb);
-	bool p2p_result = false;
-	int i = 0;
-	unsigned int hlen = ntohs(ip->tot_len) - ip_hdrlen(skb);	/* hlen = packet-data length */
+	const unsigned char *haystack;  /* packet-data */
+	unsigned int hlen;              /* packet-data length */
 
 	/* must not be a fragment */
 	if (par->fragoff != 0) {
@@ -831,84 +913,23 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return 0;
 	}
 
-	haystack = skb_network_header(skb) + ip_hdrlen(skb);
+	haystack = skb_transport_header(skb);
+	hlen     = ntohs(ip->tot_len) - skb_transport_offset(skb);
 
 	switch (ip->protocol) {
 	case IPPROTO_TCP:	/* what to do with a TCP packet */
 	{
-		const struct tcphdr *tcph = (const void *)ip + ip_hdrlen(skb);
-
-		if (tcph->fin) return 0;  /* if FIN bit is set bail out */
-		if (tcph->syn) return 0;  /* if SYN bit is set bail out */
-		if (tcph->rst) return 0;  /* if RST bit is set bail out */
-
-		if (tcph->doff * 4 > hlen) {
-			if (info->debug)
-				pr_info("TCP header indicated packet larger than it is\n");
-			return 0;
-		}
-		if (tcph->doff * 4 == hlen)
-			return 0;
+		const struct tcphdr *tcph = tcp_hdr(skb);
 
-		haystack += tcph->doff * 4; /* get TCP-Header-Size */
-		hlen     -= tcph->doff * 4;
-
-		while (matchlist[i].command) {
-			if ((info->cmd & matchlist[i].command) == matchlist[i].command &&
-			    hlen > matchlist[i].packet_len)
-			{
-				p2p_result = matchlist[i].function_name(haystack, hlen);
-				if (p2p_result)	{
-					if (info->debug)
-						printk("IPP2P.debug:TCP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
-						       p2p_result, &ip->saddr,
-						       ntohs(tcph->source),
-						       &ip->daddr,
-						       ntohs(tcph->dest), hlen);
-					return p2p_result;
-				}
-			}
-			i++;
-		}
-		return p2p_result;
+		return ipp2p_mt_tcp(info, tcph, haystack, hlen, ip);
 	}
-
-	case IPPROTO_UDP:	/* what to do with an UDP packet */
+	case IPPROTO_UDP:	/* what to do with a UDP packet */
 	case IPPROTO_UDPLITE:
 	{
-		const struct udphdr *udph = (const void *)ip + ip_hdrlen(skb);
+		const struct udphdr *udph = udp_hdr(skb);
 
-		if (sizeof(*udph) > hlen) {
-			if (info->debug)
-				pr_info("UDP header indicated packet larger than it is\n");
-			return 0;
-		}
-		if (sizeof(*udph) == hlen)
-			return 0;
-
-		haystack += sizeof(*udph);
-		hlen     -= sizeof(*udph);
-
-		while (udp_list[i].command) {
-			if ((info->cmd & udp_list[i].command) == udp_list[i].command &&
-			    hlen > udp_list[i].packet_len)
-			{
-				p2p_result = udp_list[i].function_name(haystack, hlen);
-				if (p2p_result) {
-					if (info->debug)
-						printk("IPP2P.debug:UDP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
-						       p2p_result, &ip->saddr,
-						       ntohs(udph->source),
-						       &ip->daddr,
-						       ntohs(udph->dest), hlen);
-					return p2p_result;
-				}
-			}
-			i++;
-		}
-		return p2p_result;
+		return ipp2p_mt_udp(info, udph, haystack, hlen, ip);
 	}
-
 	default:
 		return 0;
 	}
-- 
2.33.0

