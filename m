Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFE9C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7502560E94
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhIMJ0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbhIMJ0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:26:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41425C061760
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M7Aus6GdabCi5xbfbKgADQAmIMtYafFadSsmMd4z0O8=; b=JWEfEdPuDx+Grn6JMWuLkIHHK3
        pRI+NYAdYoEqTI+DmlfB/RSNbSbfFFmomXcXxeUD3Z/AZnRDvqTWkmFgApBHxJWJBWaprdYOa5qHw
        hmZ5itd30p7ZZQk8GJld0/jyMord/CrjJsOrezo+yjaUECEKTXL10HjS/I8Wu+avqs9MNi23/ZFiA
        OF3zI+/WA3CEIqm9+dyYLLu4lRS8F8Bth3PklECrfb14lL3HuE/H4fkqnepVGFoX4269Q5GFCKSbm
        JCFLu8r58z88bl5rykZWStdEOa84jnNE7dNVDAuw8/iNhpwdmdYJB7gWuJ2npgB4R2ku6nk/aruVn
        TbM8v2Rw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPiCm-00GLzi-NW; Mon, 13 Sep 2021 10:24:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: [xtables-addons 4/4] xt_ipp2p: add ipv6 support
Date:   Mon, 13 Sep 2021 10:20:51 +0100
Message-Id: <20210913092051.79743-5-jeremy@azazel.net>
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
 extensions/libxt_ipp2p.c |   2 +-
 extensions/xt_ipp2p.c    | 110 ++++++++++++++++++++++++++++++---------
 2 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/extensions/libxt_ipp2p.c b/extensions/libxt_ipp2p.c
index 74be4bee95ea..38b3be3eed0d 100644
--- a/extensions/libxt_ipp2p.c
+++ b/extensions/libxt_ipp2p.c
@@ -230,7 +230,7 @@ static struct xtables_match ipp2p_mt_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "ipp2p",
 	.revision      = 1,
-	.family        = NFPROTO_IPV4,
+	.family        = NFPROTO_UNSPEC,
 	.size          = XT_ALIGN(sizeof(struct ipt_p2p_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_p2p_info)),
 	.help          = ipp2p_mt_help,
diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 56fcbe497718..74f7d18fc04b 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -21,6 +21,7 @@ MODULE_LICENSE("GPL");
 
 union ipp2p_addr {
 	__be32 ip;
+	struct in6_addr in6;
 };
 
 struct ipp2p_result_printer {
@@ -829,14 +830,23 @@ static const struct {
 };
 
 static void
-ipp2p_print_result_tcp(const union ipp2p_addr *saddr, short sport,
-		       const union ipp2p_addr *daddr, short dport,
-		       bool p2p_result, unsigned int hlen)
+ipp2p_print_result_tcp4(const union ipp2p_addr *saddr, short sport,
+			const union ipp2p_addr *daddr, short dport,
+			bool p2p_result, unsigned int hlen)
 {
 	printk("IPP2P.debug:TCP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %u\n",
 	       p2p_result, &saddr->ip, sport, &daddr->ip, dport, hlen);
 }
 
+static void
+ipp2p_print_result_tcp6(const union ipp2p_addr *saddr, short sport,
+			const union ipp2p_addr *daddr, short dport,
+			bool p2p_result, unsigned int hlen)
+{
+	printk("IPP2P.debug:TCP-match: %d from: %pI6:%hu to: %pI6:%hu Length: %u\n",
+	       p2p_result, &saddr->in6, sport, &daddr->in6, dport, hlen);
+}
+
 static bool
 ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 	     const unsigned char *haystack, unsigned int hlen,
@@ -878,14 +888,23 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 }
 
 static void
-ipp2p_print_result_udp(const union ipp2p_addr *saddr, short sport,
-		       const union ipp2p_addr *daddr, short dport,
-		       bool p2p_result, unsigned int hlen)
+ipp2p_print_result_udp4(const union ipp2p_addr *saddr, short sport,
+			const union ipp2p_addr *daddr, short dport,
+			bool p2p_result, unsigned int hlen)
 {
 	printk("IPP2P.debug:UDP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %u\n",
 	       p2p_result, &saddr->ip, sport, &daddr->ip, dport, hlen);
 }
 
+static void
+ipp2p_print_result_udp6(const union ipp2p_addr *saddr, short sport,
+			const union ipp2p_addr *daddr, short dport,
+			bool p2p_result, unsigned int hlen)
+{
+	printk("IPP2P.debug:UDP-match: %d from: %pI6:%hu to: %pI6:%hu Length: %u\n",
+	       p2p_result, &saddr->in6, sport, &daddr->in6, dport, hlen);
+}
+
 static bool
 ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
 	     const unsigned char *haystack, unsigned int hlen,
@@ -926,13 +945,19 @@ static bool
 ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_p2p_info *info = par->matchinfo;
-	const struct iphdr *ip = ip_hdr(skb);
 	struct ipp2p_result_printer printer;
 	union ipp2p_addr saddr, daddr;
 	const unsigned char *haystack;  /* packet-data */
 	unsigned int hlen;              /* packet-data length */
-
-	/* must not be a fragment */
+	u8 family = xt_family(par);
+	int protocol;
+
+	/* must not be a fragment
+	 *
+	 * NB, `par->fragoff` may be zero for a fragmented IPv6 packet.
+	 * However, in that case the later call to `ipv6_find_hdr` will not find
+	 * a transport protocol, and so we will return 0 there.
+	 */
 	if (par->fragoff != 0) {
 		if (info->debug)
 			printk("IPP2P.match: offset found %d\n", par->fragoff);
@@ -946,23 +971,47 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return 0;
 	}
 
-	haystack = skb_transport_header(skb);
-	hlen     = ntohs(ip->tot_len) - skb_transport_offset(skb);
+	if (family == NFPROTO_IPV4) {
+
+		const struct iphdr *ip = ip_hdr(skb);
+
+		saddr.ip = ip->saddr;
+		daddr.ip = ip->daddr;
+
+		protocol = ip->protocol;
 
-	saddr.ip = ip->saddr;
-	daddr.ip = ip->daddr;
+		hlen = ip_transport_len(skb);
+
+	} else {
+
+		const struct ipv6hdr *ip = ipv6_hdr(skb);
+		int thoff = 0;
+
+		saddr.in6 = ip->saddr;
+		daddr.in6 = ip->daddr;
+
+		protocol = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
+		if (protocol < 0)
+			return 0;
+
+		hlen = ipv6_transport_len(skb);
+
+	}
 
 	printer.saddr = &saddr;
 	printer.daddr = &daddr;
 
-	switch (ip->protocol) {
+	haystack = skb_transport_header(skb);
+
+	switch (protocol) {
 	case IPPROTO_TCP:	/* what to do with a TCP packet */
 	{
 		const struct tcphdr *tcph = tcp_hdr(skb);
 
 		printer.sport = ntohs(tcph->source);
 		printer.dport = ntohs(tcph->dest);
-		printer.print = ipp2p_print_result_tcp;
+		printer.print = family == NFPROTO_IPV4 ?
+			ipp2p_print_result_tcp4 : ipp2p_print_result_tcp6;
 
 		return ipp2p_mt_tcp(info, tcph, haystack, hlen, &printer);
 	}
@@ -973,7 +1022,8 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 		printer.sport = ntohs(udph->source);
 		printer.dport = ntohs(udph->dest);
-		printer.print = ipp2p_print_result_udp;
+		printer.print = family == NFPROTO_IPV4 ?
+			ipp2p_print_result_udp4 : ipp2p_print_result_udp6;
 
 		return ipp2p_mt_udp(info, udph, haystack, hlen, &printer);
 	}
@@ -982,23 +1032,33 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 }
 
-static struct xt_match ipp2p_mt_reg __read_mostly = {
-	.name       = "ipp2p",
-	.revision   = 1,
-	.family     = NFPROTO_IPV4,
-	.match      = ipp2p_mt,
-	.matchsize  = sizeof(struct ipt_p2p_info),
-	.me         = THIS_MODULE,
+static struct xt_match ipp2p_mt_reg[] __read_mostly = {
+	{
+		.name       = "ipp2p",
+		.revision   = 1,
+		.family     = NFPROTO_IPV4,
+		.match      = ipp2p_mt,
+		.matchsize  = sizeof(struct ipt_p2p_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "ipp2p",
+		.revision   = 1,
+		.family     = NFPROTO_IPV6,
+		.match      = ipp2p_mt,
+		.matchsize  = sizeof(struct ipt_p2p_info),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init ipp2p_mt_init(void)
 {
-	return xt_register_match(&ipp2p_mt_reg);
+	return xt_register_matches(ipp2p_mt_reg, ARRAY_SIZE(ipp2p_mt_reg));
 }
 
 static void __exit ipp2p_mt_exit(void)
 {
-	xt_unregister_match(&ipp2p_mt_reg);
+	xt_unregister_matches(ipp2p_mt_reg, ARRAY_SIZE(ipp2p_mt_reg));
 }
 
 module_init(ipp2p_mt_init);
-- 
2.33.0

