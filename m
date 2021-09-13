Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA04C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250B860E94
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbhIMJ0J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbhIMJ0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:26:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C3C061766
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Lo+fDpYBoPTM3gFXHe50kJzO0AzJi7XY09SoMEODqP0=; b=E2RQDPROJeuyn9VDDrsPByIi/p
        Rz0BNQ9Ac39cY3RZzn3zLO5iZ/o2W+F/tsiH6ehpdWWa0Ljo939/90zSZuK4UisGSpDIsE+tW/32o
        xnPfL2JnTXGZg3QucM2TBgarYO+CGO3NTtkp+9hPWFJ3/ZG18gGDInyER75paUswTlzU/f5FtYSYn
        JtHqEmXcf19C4TJE8DwK+mdgi6DhpStNt4A3l1YUy6MmUzgiRk256bDKJv86NnxDh+M9/lkRsXdtp
        cvkuMQZR4E76NX96yqxdjO4EKWSlvX/0R/BK3+sorcAE4kNcM8IH52YRVUSrpCnhvD/O2EsqAEOdV
        5fm5IIfQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPiCm-00GLzi-Jj; Mon, 13 Sep 2021 10:24:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: [xtables-addons 3/4] xt_ipp2p: move result printing code into separate functions
Date:   Mon, 13 Sep 2021 10:20:50 +0100
Message-Id: <20210913092051.79743-4-jeremy@azazel.net>
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
 extensions/xt_ipp2p.c | 75 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 14 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 298950514569..56fcbe497718 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -19,6 +19,27 @@ MODULE_AUTHOR("Eicke Friedrich/Klaus Degner <ipp2p@ipp2p.org>");
 MODULE_DESCRIPTION("An extension to iptables to identify P2P traffic.");
 MODULE_LICENSE("GPL");
 
+union ipp2p_addr {
+	__be32 ip;
+};
+
+struct ipp2p_result_printer {
+	const union ipp2p_addr *saddr, *daddr;
+	short sport, dport;
+	void (*print) (const union ipp2p_addr *, short,
+		       const union ipp2p_addr *, short,
+		       bool, unsigned int);
+};
+
+static void
+print_result (const struct ipp2p_result_printer *rp, bool result,
+	      unsigned int hlen)
+{
+	rp->print(rp->saddr, rp->sport,
+		  rp->daddr, rp->dport,
+		  result, hlen);
+}
+
 /* Search for UDP eDonkey/eMule/Kad commands */
 static unsigned int
 udp_search_edk(const unsigned char *t, const unsigned int packet_len)
@@ -807,10 +828,19 @@ static const struct {
 	{0},
 };
 
+static void
+ipp2p_print_result_tcp(const union ipp2p_addr *saddr, short sport,
+		       const union ipp2p_addr *daddr, short dport,
+		       bool p2p_result, unsigned int hlen)
+{
+	printk("IPP2P.debug:TCP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %u\n",
+	       p2p_result, &saddr->ip, sport, &daddr->ip, dport, hlen);
+}
+
 static bool
 ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 	     const unsigned char *haystack, unsigned int hlen,
-	     const struct iphdr *ip)
+	     const struct ipp2p_result_printer *rp)
 {
 	size_t tcph_len = tcph->doff * 4;
 	bool p2p_result = false;
@@ -838,11 +868,7 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 			p2p_result = matchlist[i].function_name(haystack, hlen);
 			if (p2p_result)	{
 				if (info->debug)
-					printk("IPP2P.debug:TCP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
-					       p2p_result, &ip->saddr,
-					       ntohs(tcph->source),
-					       &ip->daddr,
-					       ntohs(tcph->dest), hlen);
+					print_result(rp, p2p_result, hlen);
 				return p2p_result;
 			}
 		}
@@ -851,10 +877,19 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 	return p2p_result;
 }
 
+static void
+ipp2p_print_result_udp(const union ipp2p_addr *saddr, short sport,
+		       const union ipp2p_addr *daddr, short dport,
+		       bool p2p_result, unsigned int hlen)
+{
+	printk("IPP2P.debug:UDP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %u\n",
+	       p2p_result, &saddr->ip, sport, &daddr->ip, dport, hlen);
+}
+
 static bool
 ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
 	     const unsigned char *haystack, unsigned int hlen,
-	     const struct iphdr *ip)
+	     const struct ipp2p_result_printer *rp)
 {
 	size_t udph_len = sizeof(*udph);
 	bool p2p_result = false;
@@ -878,11 +913,7 @@ ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
 			p2p_result = udp_list[i].function_name(haystack, hlen);
 			if (p2p_result) {
 				if (info->debug)
-					printk("IPP2P.debug:UDP-match: %d from: %pI4:%hu to: %pI4:%hu Length: %d\n",
-					       p2p_result, &ip->saddr,
-					       ntohs(udph->source),
-					       &ip->daddr,
-					       ntohs(udph->dest), hlen);
+					print_result(rp, p2p_result, hlen);
 				return p2p_result;
 			}
 		}
@@ -896,6 +927,8 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_p2p_info *info = par->matchinfo;
 	const struct iphdr *ip = ip_hdr(skb);
+	struct ipp2p_result_printer printer;
+	union ipp2p_addr saddr, daddr;
 	const unsigned char *haystack;  /* packet-data */
 	unsigned int hlen;              /* packet-data length */
 
@@ -916,19 +949,33 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	haystack = skb_transport_header(skb);
 	hlen     = ntohs(ip->tot_len) - skb_transport_offset(skb);
 
+	saddr.ip = ip->saddr;
+	daddr.ip = ip->daddr;
+
+	printer.saddr = &saddr;
+	printer.daddr = &daddr;
+
 	switch (ip->protocol) {
 	case IPPROTO_TCP:	/* what to do with a TCP packet */
 	{
 		const struct tcphdr *tcph = tcp_hdr(skb);
 
-		return ipp2p_mt_tcp(info, tcph, haystack, hlen, ip);
+		printer.sport = ntohs(tcph->source);
+		printer.dport = ntohs(tcph->dest);
+		printer.print = ipp2p_print_result_tcp;
+
+		return ipp2p_mt_tcp(info, tcph, haystack, hlen, &printer);
 	}
 	case IPPROTO_UDP:	/* what to do with a UDP packet */
 	case IPPROTO_UDPLITE:
 	{
 		const struct udphdr *udph = udp_hdr(skb);
 
-		return ipp2p_mt_udp(info, udph, haystack, hlen, ip);
+		printer.sport = ntohs(udph->source);
+		printer.dport = ntohs(udph->dest);
+		printer.print = ipp2p_print_result_udp;
+
+		return ipp2p_mt_udp(info, udph, haystack, hlen, &printer);
 	}
 	default:
 		return 0;
-- 
2.33.0

