Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C0DC32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 14:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0262B218DE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 14:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfI3O1t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 10:27:49 -0400
Received: from correo.us.es ([193.147.175.20]:40154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731375AbfI3O1t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 10:27:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3F8BDC1B83
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 16:27:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3087A21FE4
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 16:27:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25D23FB362; Mon, 30 Sep 2019 16:27:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F339ACE17F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 16:27:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Sep 2019 16:27:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DBF0442EF9E1
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 16:27:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] checksum: Fix UDP checksum calculation
Date:   Mon, 30 Sep 2019 16:27:41 +0200
Message-Id: <20190930142741.16575-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The level 4 protocol is part of the UDP and TCP calculations.
nfq_checksum_tcpudp_ipv4() was using IPPROTO_TCP in this calculation,
which gave the wrong answer for UDP.

Based on patch from Alin Nastac, and patch description from Duncan Roe.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/extra/checksum.c | 9 +++++----
 src/extra/tcp.c      | 4 ++--
 src/extra/udp.c      | 4 ++--
 src/internal.h       | 5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/src/extra/checksum.c b/src/extra/checksum.c
index f367f75bbef3..4d52a998dc82 100644
--- a/src/extra/checksum.c
+++ b/src/extra/checksum.c
@@ -35,7 +35,7 @@ uint16_t nfq_checksum(uint32_t sum, uint16_t *buf, int size)
 	return (uint16_t)(~sum);
 }
 
-uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph)
+uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph, uint16_t protonum)
 {
 	uint32_t sum = 0;
 	uint32_t iph_len = iph->ihl*4;
@@ -46,13 +46,14 @@ uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph)
 	sum += (iph->saddr) & 0xFFFF;
 	sum += (iph->daddr >> 16) & 0xFFFF;
 	sum += (iph->daddr) & 0xFFFF;
-	sum += htons(IPPROTO_TCP);
+	sum += htons(protonum);
 	sum += htons(len);
 
 	return nfq_checksum(sum, (uint16_t *)payload, len);
 }
 
-uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr)
+uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
+				  uint16_t protonum)
 {
 	uint32_t sum = 0;
 	uint32_t hdr_len = (uint32_t *)transport_hdr - (uint32_t *)ip6h;
@@ -68,7 +69,7 @@ uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr)
 		sum += (ip6h->ip6_dst.s6_addr16[i] >> 16) & 0xFFFF;
 		sum += (ip6h->ip6_dst.s6_addr16[i]) & 0xFFFF;
 	}
-	sum += htons(IPPROTO_TCP);
+	sum += htons(protonum);
 	sum += htons(ip6h->ip6_plen);
 
 	return nfq_checksum(sum, (uint16_t *)payload, len);
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index d1cd79d9de67..a66f3924145b 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -96,7 +96,7 @@ nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	tcph->check = 0;
-	tcph->check = nfq_checksum_tcpudp_ipv4(iph);
+	tcph->check = nfq_checksum_tcpudp_ipv4(iph, IPPROTO_TCP);
 }
 EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv4);
 
@@ -110,7 +110,7 @@ nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	tcph->check = 0;
-	tcph->check = nfq_checksum_tcpudp_ipv6(ip6h, tcph);
+	tcph->check = nfq_checksum_tcpudp_ipv6(ip6h, tcph, IPPROTO_TCP);
 }
 EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv6);
 
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 8c44a66e8209..c48a179dfccb 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -96,7 +96,7 @@ nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	udph->check = 0;
-	udph->check = nfq_checksum_tcpudp_ipv4(iph);
+	udph->check = nfq_checksum_tcpudp_ipv4(iph, IPPROTO_UDP);
 }
 EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv4);
 
@@ -115,7 +115,7 @@ nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	udph->check = 0;
-	udph->check = nfq_checksum_tcpudp_ipv6(ip6h, udph);
+	udph->check = nfq_checksum_tcpudp_ipv6(ip6h, udph, IPPROTO_UDP);
 }
 EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
 
diff --git a/src/internal.h b/src/internal.h
index 558d267bf602..d648bfe112e8 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -15,8 +15,9 @@ struct iphdr;
 struct ip6_hdr;
 
 uint16_t nfq_checksum(uint32_t sum, uint16_t *buf, int size);
-uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph);
-uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr);
+uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph, uint16_t protonum);
+uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
+				  uint16_t protonum);
 
 struct pkt_buff {
 	uint8_t *mac_header;
-- 
2.11.0

