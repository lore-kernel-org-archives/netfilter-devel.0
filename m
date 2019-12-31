Return-Path: <SRS0=FFQ3=2V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1321C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 11:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7B6206D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Dec 2019 11:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLaLDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Dec 2019 06:03:22 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52381 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbfLaLDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Dec 2019 06:03:22 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 6C1017E8115
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Dec 2019 22:03:08 +1100 (AEDT)
Received: (qmail 29007 invoked by uid 501); 31 Dec 2019 11:03:07 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Always use pktb as formal arg of type struct pkt_buff
Date:   Tue, 31 Dec 2019 22:03:07 +1100
Message-Id: <20191231110307.28963-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191230115321.oganzk6xmfsylcmz@salvia>
References: <20191230115321.oganzk6xmfsylcmz@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=KPYt1rvk0rywP6UJibYA:9 a=kmFg7kd5F6rJCuYC:21
        a=Njw_gCYqBYjMmGJF:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All remaining instances of pkt refer to something other than a pkt_buff.

In the prototype for nfq_nlmsg_parse, pkt is changed to attr.

Inconsistent whitespace in headers has been left for another day.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/libnetfilter_queue.h      |  2 +-
 include/libnetfilter_queue/libnetfilter_queue_ipv4.h |  2 +-
 include/libnetfilter_queue/libnetfilter_queue_tcp.h  |  4 ++--
 include/libnetfilter_queue/libnetfilter_queue_udp.h  |  2 +-
 include/libnetfilter_queue/pktbuff.h                 |  2 +-
 src/extra/pktbuff.c                                  | 14 +++++++-------
 src/extra/tcp.c                                      |  8 ++++----
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 2e38411..092c57d 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -148,7 +148,7 @@ void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict);
 void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark);
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t pktlen);
 
-int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **pkt);
+int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/include/libnetfilter_queue/libnetfilter_queue_ipv4.h b/include/libnetfilter_queue/libnetfilter_queue_ipv4.h
index e707f1f..17be93e 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_ipv4.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_ipv4.h
@@ -7,7 +7,7 @@ struct iphdr;
 struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb);
 int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph);
 void nfq_ip_set_checksum(struct iphdr *iph);
-int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph);
 
 #endif
diff --git a/include/libnetfilter_queue/libnetfilter_queue_tcp.h b/include/libnetfilter_queue/libnetfilter_queue_tcp.h
index 997d997..e1b9690 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_tcp.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_tcp.h
@@ -13,8 +13,8 @@ struct ip6_hdr;
 void nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph);
 void nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h);
 
-int nfq_tcp_mangle_ipv4(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
-int nfq_tcp_mangle_ipv6(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_tcp_mangle_ipv4(struct pkt_buff *pktb, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_tcp_mangle_ipv6(struct pkt_buff *pktb, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcp);
 
diff --git a/include/libnetfilter_queue/libnetfilter_queue_udp.h b/include/libnetfilter_queue/libnetfilter_queue_udp.h
index f9fd609..9d594f2 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_udp.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_udp.h
@@ -10,7 +10,7 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 void nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph);
 void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h);
 
-int nfq_udp_mangle_ipv4(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_udp_mangle_ipv4(struct pkt_buff *pktb, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 int nfq_udp_mangle_ipv6(struct pkt_buff *pktb, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 int nfq_udp_snprintf(char *buf, size_t size, const struct udphdr *udp);
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 5bcc3e5..42bc153 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -19,7 +19,7 @@ uint8_t *pktb_mac_header(struct pkt_buff *pktb);
 uint8_t *pktb_network_header(struct pkt_buff *pktb);
 uint8_t *pktb_transport_header(struct pkt_buff *pktb);
 
-int pktb_mangle(struct pkt_buff *pkt, int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int pktb_mangle(struct pkt_buff *pktb, int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 bool pktb_mangled(const struct pkt_buff *pktb);
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6250fbf..37f6bc0 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -271,26 +271,26 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb)
  * @}
  */
 
-static int pktb_expand_tail(struct pkt_buff *pkt, int extra)
+static int pktb_expand_tail(struct pkt_buff *pktb, int extra)
 {
 	/* No room in packet, cannot mangle it. We don't support dynamic
 	 * reallocation. Instead, increase the size of the extra room in
 	 * the tail in pktb_alloc.
 	 */
-	if (pkt->len + extra > pkt->data_len)
+	if (pktb->len + extra > pktb->data_len)
 		return 0;
 
-	pkt->len += extra;
-	pkt->tail = pkt->tail + extra;
+	pktb->len += extra;
+	pktb->tail = pktb->tail + extra;
 	return 1;
 }
 
-static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
+static int enlarge_pkt(struct pkt_buff *pktb, unsigned int extra)
 {
-	if (pkt->len + extra > 65535)
+	if (pktb->len + extra > 65535)
 		return 0;
 
-	if (!pktb_expand_tail(pkt, extra - pktb_tailroom(pkt)))
+	if (!pktb_expand_tail(pktb, extra - pktb_tailroom(pktb)))
 		return 0;
 
 	return 1;
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 64ab85f..0f83500 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -188,17 +188,17 @@ int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
  * \note This function recalculates the IPv4 and TCP checksums for you.
  */
 EXPORT_SYMBOL
-int nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
+int nfq_tcp_mangle_ipv4(struct pkt_buff *pktb,
 			unsigned int match_offset, unsigned int match_len,
 			const char *rep_buffer, unsigned int rep_len)
 {
 	struct iphdr *iph;
 	struct tcphdr *tcph;
 
-	iph = (struct iphdr *)pkt->network_header;
-	tcph = (struct tcphdr *)(pkt->network_header + iph->ihl*4);
+	iph = (struct iphdr *)pktb->network_header;
+	tcph = (struct tcphdr *)(pktb->network_header + iph->ihl*4);
 
-	if (!nfq_ip_mangle(pkt, iph->ihl*4 + tcph->doff*4,
+	if (!nfq_ip_mangle(pktb, iph->ihl*4 + tcph->doff*4,
 				match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
-- 
2.14.5

