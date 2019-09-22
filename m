Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2816EC4360D
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 00:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE94420820
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 00:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfIVAKu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 20:10:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54049 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbfIVAKu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 20:10:50 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 3C798361616
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 10:10:32 +1000 (AEST)
Received: (qmail 30891 invoked by uid 501); 22 Sep 2019 00:10:31 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Enable clang build
Date:   Sun, 22 Sep 2019 10:10:31 +1000
Message-Id: <20190922001031.30848-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=J70Eh1EUuV4A:10 a=lVbKBNLKd87Sv00tPOwA:9 a=2Sz0eI1YI1RL6kAD:21
        a=QgKR1OCITnsPqlbM:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike gcc, clang insists to have EXPORT_SYMBOL(x) come before the definition
of x. So move all EXPORT_SYMBOL lines to just after the last #include line.

pktbuff.c was missing its associated header, so correct that as well.

gcc & clang produce different warnings. gcc warns that nfq_set_verdict_mark is
deprecated while clang warns of invalid conversion specifier 'Z' at
src/extra/ipv6.c:138 (should that be lower-case?)
---
 src/extra/ipv4.c         | 11 ++++----
 src/extra/ipv6.c         |  7 +++--
 src/extra/pktbuff.c      | 30 ++++++++++----------
 src/extra/tcp.c          | 15 +++++-----
 src/extra/udp.c          | 15 +++++-----
 src/libnetfilter_queue.c | 73 ++++++++++++++++++++++++------------------------
 src/nlmsg.c              | 15 +++++-----
 7 files changed, 87 insertions(+), 79 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index a93d113..73ba239 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -20,6 +20,12 @@
 
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_ip_get_hdr);
+EXPORT_SYMBOL(nfq_ip_set_transport_header);
+EXPORT_SYMBOL(nfq_ip_set_checksum);
+EXPORT_SYMBOL(nfq_ip_mangle);
+EXPORT_SYMBOL(nfq_ip_snprintf);
+
 /**
  * \defgroup ipv4 IPv4 helper functions
  * @{
@@ -53,7 +59,6 @@ struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
 
 	return iph;
 }
-EXPORT_SYMBOL(nfq_ip_get_hdr);
 
 /**
  * nfq_ip_set_transport_header - set transport header
@@ -71,7 +76,6 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 	pktb->transport_header = pktb->network_header + doff;
 	return 0;
 }
-EXPORT_SYMBOL(nfq_ip_set_transport_header);
 
 /**
  * nfq_ip_set_checksum - set IPv4 checksum
@@ -87,7 +91,6 @@ void nfq_ip_set_checksum(struct iphdr *iph)
 	iph->check = 0;
 	iph->check = nfq_checksum(0, (uint16_t *)iph, iph_len);
 }
-EXPORT_SYMBOL(nfq_ip_set_checksum);
 
 /**
  * nfq_ip_mangle - mangle IPv4 packet buffer
@@ -116,7 +119,6 @@ int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_ip_mangle);
 
 /**
  * nfq_pkt_snprintf_ip - print IPv4 header into buffer in iptables LOG format
@@ -147,7 +149,6 @@ int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_ip_snprintf);
 
 /**
  * @}
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 7c5dc9b..e6ec654 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -21,6 +21,10 @@
 
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_ip6_get_hdr);
+EXPORT_SYMBOL(nfq_ip6_set_transport_header);
+EXPORT_SYMBOL(nfq_ip6_snprintf);
+
 /**
  * \defgroup ipv6 IPv6 helper functions
  * @{
@@ -50,7 +54,6 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 
 	return ip6h;
 }
-EXPORT_SYMBOL(nfq_ip6_get_hdr);
 
 /**
  * nfq_ip6_set_transport_header - set transport header pointer for IPv6 packet
@@ -115,7 +118,6 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 	pktb->transport_header = cur;
 	return cur ? 1 : 0;
 }
-EXPORT_SYMBOL(nfq_ip6_set_transport_header);
 
 /**
  * nfq_ip6_snprintf - print IPv6 header into one buffer in iptables LOG format
@@ -143,7 +145,6 @@ int nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_ip6_snprintf);
 
 /**
  * @}
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 1c15a00..89b3337 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -18,6 +18,22 @@
 #include <netinet/tcp.h>
 
 #include "internal.h"
+#include "libnetfilter_queue/pktbuff.h"
+
+EXPORT_SYMBOL(pktb_alloc);
+EXPORT_SYMBOL(pktb_data);
+EXPORT_SYMBOL(pktb_len);
+EXPORT_SYMBOL(pktb_free);
+EXPORT_SYMBOL(pktb_push);
+EXPORT_SYMBOL(pktb_pull);
+EXPORT_SYMBOL(pktb_put);
+EXPORT_SYMBOL(pktb_trim);
+EXPORT_SYMBOL(pktb_tailroom);
+EXPORT_SYMBOL(pktb_mac_header);
+EXPORT_SYMBOL(pktb_network_header);
+EXPORT_SYMBOL(pktb_transport_header);
+EXPORT_SYMBOL(pktb_mangle);
+EXPORT_SYMBOL(pktb_mangled);
 
 /**
  * \defgroup pktbuff User-space network packet buffer
@@ -84,7 +100,6 @@ pktb_alloc(int family, void *data, size_t len, size_t extra)
 	}
 	return pktb;
 }
-EXPORT_SYMBOL(pktb_alloc);
 
 /**
  * pktb_data - return pointer to the beginning of the packet buffer
@@ -94,7 +109,6 @@ uint8_t *pktb_data(struct pkt_buff *pktb)
 {
 	return pktb->data;
 }
-EXPORT_SYMBOL(pktb_data);
 
 /**
  * pktb_len - return length of the packet buffer
@@ -104,7 +118,6 @@ uint32_t pktb_len(struct pkt_buff *pktb)
 {
 	return pktb->len;
 }
-EXPORT_SYMBOL(pktb_len);
 
 /**
  * pktb_free - release packet buffer
@@ -114,7 +127,6 @@ void pktb_free(struct pkt_buff *pktb)
 {
 	free(pktb);
 }
-EXPORT_SYMBOL(pktb_free);
 
 /**
  * pktb_push - update pointer to the beginning of the packet buffer
@@ -125,7 +137,6 @@ void pktb_push(struct pkt_buff *pktb, unsigned int len)
 	pktb->data -= len;
 	pktb->len += len;
 }
-EXPORT_SYMBOL(pktb_push);
 
 /**
  * pktb_pull - update pointer to the beginning of the packet buffer
@@ -136,7 +147,6 @@ void pktb_pull(struct pkt_buff *pktb, unsigned int len)
 	pktb->data += len;
 	pktb->len -= len;
 }
-EXPORT_SYMBOL(pktb_pull);
 
 /**
  * pktb_put - add extra bytes to the tail of the packet buffer
@@ -147,7 +157,6 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 	pktb->tail += len;
 	pktb->len += len;
 }
-EXPORT_SYMBOL(pktb_put);
 
 /**
  * pktb_trim - set new length for this packet buffer
@@ -157,7 +166,6 @@ void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->len = len;
 }
-EXPORT_SYMBOL(pktb_trim);
 
 /**
  * pktb_tailroom - get room in bytes in the tail of the packet buffer
@@ -167,7 +175,6 @@ unsigned int pktb_tailroom(struct pkt_buff *pktb)
 {
 	return pktb->data_len - pktb->len;
 }
-EXPORT_SYMBOL(pktb_tailroom);
 
 /**
  * pktb_mac_header - return pointer to layer 2 header (if any)
@@ -177,7 +184,6 @@ uint8_t *pktb_mac_header(struct pkt_buff *pktb)
 {
 	return pktb->mac_header;
 }
-EXPORT_SYMBOL(pktb_mac_header);
 
 /**
  * pktb_network_header - return pointer to layer 3 header
@@ -187,7 +193,6 @@ uint8_t *pktb_network_header(struct pkt_buff *pktb)
 {
 	return pktb->network_header;
 }
-EXPORT_SYMBOL(pktb_network_header);
 
 /**
  * pktb_transport_header - return pointer to layer 4 header (if any)
@@ -197,7 +202,6 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb)
 {
 	return pktb->transport_header;
 }
-EXPORT_SYMBOL(pktb_transport_header);
 
 static int pktb_expand_tail(struct pkt_buff *pkt, int extra)
 {
@@ -258,7 +262,6 @@ int pktb_mangle(struct pkt_buff *pkt,
 	pkt->mangled = true;
 	return 1;
 }
-EXPORT_SYMBOL(pktb_mangle);
 
 /**
  * pktb_mangled - return true if packet has been mangled
@@ -268,7 +271,6 @@ bool pktb_mangled(const struct pkt_buff *pkt)
 {
 	return pkt->mangled;
 }
-EXPORT_SYMBOL(pktb_mangled);
 
 /**
  * @}
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index d1cd79d..b60a529 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -25,6 +25,14 @@
 
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_tcp_get_hdr);
+EXPORT_SYMBOL(nfq_tcp_get_payload);
+EXPORT_SYMBOL(nfq_tcp_get_payload_len);
+EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv4);
+EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv6);
+EXPORT_SYMBOL(nfq_tcp_snprintf);
+EXPORT_SYMBOL(nfq_tcp_mangle_ipv4);
+
 /**
  * \defgroup tcp TCP helper functions
  * @{
@@ -51,7 +59,6 @@ struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
 
 	return (struct tcphdr *)pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_tcp_get_hdr);
 
 /**
  * nfq_tcp_get_payload - get the TCP packet payload
@@ -72,7 +79,6 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 
 	return pktb->transport_header + len;
 }
-EXPORT_SYMBOL(nfq_tcp_get_payload);
 
 /**
  * nfq_tcp_get_payload_len - get the tcp packet payload
@@ -84,7 +90,6 @@ nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
 {
 	return pktb->tail - pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_tcp_get_payload_len);
 
 /**
  * nfq_tcp_set_checksum_ipv4 - computes IPv4/TCP packet checksum
@@ -98,7 +103,6 @@ nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
 	tcph->check = 0;
 	tcph->check = nfq_checksum_tcpudp_ipv4(iph);
 }
-EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv4);
 
 /**
  * nfq_tcp_set_checksum_ipv6 - computes IPv6/TCP packet checksum
@@ -112,7 +116,6 @@ nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
 	tcph->check = 0;
 	tcph->check = nfq_checksum_tcpudp_ipv6(ip6h, tcph);
 }
-EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv6);
 
 /*
  *	The union cast uses a gcc extension to avoid aliasing problems
@@ -177,7 +180,6 @@ int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_tcp_snprintf);
 
 /**
  * nfq_tcp_mangle_ipv4 - mangle TCP/IPv4 packet buffer
@@ -208,7 +210,6 @@ nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_tcp_mangle_ipv4);
 
 /**
  * @}
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 8c44a66..e774e00 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -24,6 +24,14 @@
 
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_udp_get_hdr);
+EXPORT_SYMBOL(nfq_udp_get_payload);
+EXPORT_SYMBOL(nfq_udp_get_payload_len);
+EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv4);
+EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
+EXPORT_SYMBOL(nfq_udp_mangle_ipv4);
+EXPORT_SYMBOL(nfq_udp_snprintf);
+
 /**
  * \defgroup udp UDP helper functions
  * @{
@@ -48,7 +56,6 @@ struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
 
 	return (struct udphdr *)pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_udp_get_hdr);
 
 /**
  * nfq_udp_get_payload - get the UDP packet payload.
@@ -69,7 +76,6 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 
 	return pktb->transport_header + sizeof(struct udphdr);
 }
-EXPORT_SYMBOL(nfq_udp_get_payload);
 
 /**
  * nfq_udp_get_payload_len - get the udp packet payload.
@@ -79,7 +85,6 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
 	return pktb->tail - pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_udp_get_payload_len);
 
 /**
  * nfq_udp_set_checksum_ipv4 - computes a IPv4/TCP packet's segment
@@ -98,7 +103,6 @@ nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
 	udph->check = 0;
 	udph->check = nfq_checksum_tcpudp_ipv4(iph);
 }
-EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv4);
 
 /**
  * nfq_udp_set_checksum_ipv6 - computes a IPv6/TCP packet's segment
@@ -117,7 +121,6 @@ nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
 	udph->check = 0;
 	udph->check = nfq_checksum_tcpudp_ipv6(ip6h, udph);
 }
-EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
 
 /**
  * nfq_tcp_mangle_ipv4 - mangle TCP/IPv4 packet buffer
@@ -148,7 +151,6 @@ nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_udp_mangle_ipv4);
 
 /**
  * nfq_pkt_snprintf_udp_hdr - print udp header into one buffer in a humnan
@@ -163,7 +165,6 @@ int nfq_udp_snprintf(char *buf, size_t size, const struct udphdr *udph)
 	return snprintf(buf, size, "SPT=%u DPT=%u ",
 			htons(udph->source), htons(udph->dest));
 }
-EXPORT_SYMBOL(nfq_udp_snprintf);
 
 /**
  * @}
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 673e3b0..90acc01 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -34,6 +34,43 @@
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_errno);
+EXPORT_SYMBOL(nfq_nfnlh);
+EXPORT_SYMBOL(nfq_fd);
+EXPORT_SYMBOL(nfq_open);
+EXPORT_SYMBOL(nfq_open_nfnl);
+EXPORT_SYMBOL(nfq_close);
+EXPORT_SYMBOL(nfq_bind_pf);
+EXPORT_SYMBOL(nfq_unbind_pf);
+EXPORT_SYMBOL(nfq_create_queue);
+EXPORT_SYMBOL(nfq_destroy_queue);
+EXPORT_SYMBOL(nfq_handle_packet);
+EXPORT_SYMBOL(nfq_set_mode);
+EXPORT_SYMBOL(nfq_set_queue_flags);
+EXPORT_SYMBOL(nfq_set_queue_maxlen);
+EXPORT_SYMBOL(nfq_set_verdict);
+EXPORT_SYMBOL(nfq_set_verdict2);
+EXPORT_SYMBOL(nfq_set_verdict_batch);
+EXPORT_SYMBOL(nfq_set_verdict_batch2);
+EXPORT_SYMBOL(nfq_set_verdict_mark);
+EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
+EXPORT_SYMBOL(nfq_get_nfmark);
+EXPORT_SYMBOL(nfq_get_timestamp);
+EXPORT_SYMBOL(nfq_get_indev);
+EXPORT_SYMBOL(nfq_get_physindev);
+EXPORT_SYMBOL(nfq_get_outdev);
+EXPORT_SYMBOL(nfq_get_physoutdev);
+EXPORT_SYMBOL(nfq_get_indev_name);
+EXPORT_SYMBOL(nfq_get_physindev_name);
+EXPORT_SYMBOL(nfq_get_outdev_name);
+EXPORT_SYMBOL(nfq_get_physoutdev_name);
+EXPORT_SYMBOL(nfq_get_packet_hw);
+EXPORT_SYMBOL(nfq_get_uid);
+EXPORT_SYMBOL(nfq_get_gid);
+EXPORT_SYMBOL(nfq_get_secctx);
+EXPORT_SYMBOL(nfq_get_payload);
+EXPORT_SYMBOL(nfq_snprintf_xml);
+
 /**
  * \mainpage
  *
@@ -134,7 +171,6 @@ struct nfq_data {
 };
 
 int nfq_errno;
-EXPORT_SYMBOL(nfq_errno);
 
 /***********************************************************************
  * low level stuff 
@@ -222,7 +258,6 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 {
 	return h->nfnlh;
 }
-EXPORT_SYMBOL(nfq_nfnlh);
 
 /**
  *
@@ -298,7 +333,6 @@ int nfq_fd(struct nfq_handle *h)
 {
 	return nfnl_fd(nfq_nfnlh(h));
 }
-EXPORT_SYMBOL(nfq_fd);
 /**
  * @}
  */
@@ -366,7 +400,6 @@ struct nfq_handle *nfq_open(void)
 
 	return qh;
 }
-EXPORT_SYMBOL(nfq_open);
 
 /**
  * @}
@@ -419,7 +452,6 @@ out_free:
 	free(h);
 	return NULL;
 }
-EXPORT_SYMBOL(nfq_open_nfnl);
 
 /**
  * \addtogroup LibrarySetup
@@ -447,7 +479,6 @@ int nfq_close(struct nfq_handle *h)
 		free(h);
 	return ret;
 }
-EXPORT_SYMBOL(nfq_close);
 
 /**
  * nfq_bind_pf - bind a nfqueue handler to a given protocol family
@@ -464,7 +495,6 @@ int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
-EXPORT_SYMBOL(nfq_bind_pf);
 
 /**
  * nfq_unbind_pf - unbind nfqueue handler from a protocol family
@@ -480,7 +510,6 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
-EXPORT_SYMBOL(nfq_unbind_pf);
 
 
 /**
@@ -555,7 +584,6 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 	add_qh(qh);
 	return qh;
 }
-EXPORT_SYMBOL(nfq_create_queue);
 
 /**
  * @}
@@ -583,7 +611,6 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_destroy_queue);
 
 /**
  * nfq_handle_packet - handle a packet received from the nfqueue subsystem
@@ -601,7 +628,6 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
 	return nfnl_handle_packet(h->nfnlh, buf, len);
 }
-EXPORT_SYMBOL(nfq_handle_packet);
 
 /**
  * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
@@ -638,7 +664,6 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_mode);
 
 /**
  * nfq_set_queue_flags - set flags (options) for the kernel queue
@@ -729,7 +754,6 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_queue_flags);
 
 /**
  * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
@@ -760,7 +784,6 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_queue_maxlen);
 
 /**
  * @}
@@ -854,7 +877,6 @@ int nfq_set_verdict(struct nfq_q_handle *qh, uint32_t id,
 	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict);
 
 /**
  * nfq_set_verdict2 - like nfq_set_verdict, but you can set the mark.
@@ -872,7 +894,6 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict2);
 
 /**
  * nfq_set_verdict_batch - issue verdicts on several packets at once
@@ -892,7 +913,6 @@ int nfq_set_verdict_batch(struct nfq_q_handle *qh, uint32_t id,
 	return __set_verdict(qh, id, verdict, 0, 0, 0, NULL,
 					NFQNL_MSG_VERDICT_BATCH);
 }
-EXPORT_SYMBOL(nfq_set_verdict_batch);
 
 /**
  * nfq_set_verdict_batch2 - like nfq_set_verdict_batch, but you can set a mark.
@@ -907,7 +927,6 @@ int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
-EXPORT_SYMBOL(nfq_set_verdict_batch2);
 
 /**
  * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
@@ -930,7 +949,6 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict_mark);
 
 /**
  * @}
@@ -970,7 +988,6 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
 					struct nfqnl_msg_packet_hdr);
 }
-EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
 
 /**
  * nfq_get_nfmark - get the packet mark
@@ -982,7 +999,6 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_nfmark);
 
 /**
  * nfq_get_timestamp - get the packet timestamp
@@ -1006,7 +1022,6 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 
 	return 0;
 }
-EXPORT_SYMBOL(nfq_get_timestamp);
 
 /**
  * nfq_get_indev - get the interface that the packet was received through
@@ -1023,7 +1038,6 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_indev);
 
 /**
  * nfq_get_physindev - get the physical interface that the packet was received
@@ -1037,7 +1051,6 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_physindev);
 
 /**
  * nfq_get_outdev - gets the interface that the packet will be routed out
@@ -1051,7 +1064,6 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_outdev);
 
 /**
  * nfq_get_physoutdev - get the physical interface that the packet output
@@ -1067,7 +1079,6 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_physoutdev);
 
 /**
  * nfq_get_indev_name - get the name of the interface the packet
@@ -1113,7 +1124,6 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 	uint32_t ifindex = nfq_get_indev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_indev_name);
 
 /**
  * nfq_get_physindev_name - get the name of the physical interface the
@@ -1133,7 +1143,6 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 	uint32_t ifindex = nfq_get_physindev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_physindev_name);
 
 /**
  * nfq_get_outdev_name - get the name of the physical interface the
@@ -1153,7 +1162,6 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 	uint32_t ifindex = nfq_get_outdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_outdev_name);
 
 /**
  * nfq_get_physoutdev_name - get the name of the interface the
@@ -1174,7 +1182,6 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 	uint32_t ifindex = nfq_get_physoutdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_physoutdev_name);
 
 /**
  * nfq_get_packet_hw
@@ -1203,7 +1210,6 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
 					struct nfqnl_msg_packet_hw);
 }
-EXPORT_SYMBOL(nfq_get_packet_hw);
 
 /**
  * nfq_get_uid - get the UID of the user the packet belongs to
@@ -1223,7 +1229,6 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
 	return 1;
 }
-EXPORT_SYMBOL(nfq_get_uid);
 
 /**
  * nfq_get_gid - get the GID of the user the packet belongs to
@@ -1243,7 +1248,6 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
 	return 1;
 }
-EXPORT_SYMBOL(nfq_get_gid);
 
 /**
  * nfq_get_secctx - get the security context for this packet
@@ -1269,7 +1273,6 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 
 	return 0;
 }
-EXPORT_SYMBOL(nfq_get_secctx);
 
 /**
  * nfq_get_payload - get payload 
@@ -1291,7 +1294,6 @@ int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 
 	return -1;
 }
-EXPORT_SYMBOL(nfq_get_payload);
 
 /**
  * @}
@@ -1489,7 +1491,6 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 
 	return len;
 }
-EXPORT_SYMBOL(nfq_snprintf_xml);
 
 /**
  * @}
diff --git a/src/nlmsg.c b/src/nlmsg.c
index ba28c77..34b42d5 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -25,6 +25,14 @@
 
 #include "internal.h"
 
+EXPORT_SYMBOL(nfq_nlmsg_verdict_put);
+EXPORT_SYMBOL(nfq_nlmsg_verdict_put_mark);
+EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
+EXPORT_SYMBOL(nfq_nlmsg_cfg_put_cmd);
+EXPORT_SYMBOL(nfq_nlmsg_cfg_put_params);
+EXPORT_SYMBOL(nfq_nlmsg_cfg_put_qmaxlen);
+EXPORT_SYMBOL(nfq_nlmsg_parse);
+
 /**
  * \defgroup nfq_verd Verdict helpers
  * @{
@@ -38,20 +46,17 @@ void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
 	};
 	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put);
 
 void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark)
 {
 	mnl_attr_put_u32(nlh, NFQA_MARK, htonl(mark));
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put_mark);
 
 void
 nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t plen)
 {
 	mnl_attr_put(nlh, NFQA_PAYLOAD, plen, pkt);
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
 
 /**
  * @}
@@ -93,7 +98,6 @@ void nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
 	};
 	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(command), &command);
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_cmd);
 
 void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 {
@@ -103,13 +107,11 @@ void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 	};
 	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_params);
 
 void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
 {
 	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queue_maxlen));
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_qmaxlen);
 
 /**
  * @}
@@ -184,7 +186,6 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 	return mnl_attr_parse(nlh, sizeof(struct nfgenmsg),
 			      nfq_pkt_parse_attr_cb, attr);
 }
-EXPORT_SYMBOL(nfq_nlmsg_parse);
 
 /**
  * @}
-- 
2.14.5

