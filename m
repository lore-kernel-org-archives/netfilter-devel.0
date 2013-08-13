From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-queue] build: avoid sym namespace pollution
Date: Tue, 13 Aug 2013 10:48:50 +0200
Message-ID: <1376383730-11731-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:6672 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313Ab3HMIs5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:48:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

as of f40eabb01 (add pkt_buff and protocol helper functions)
lnetfilter_queue exports a function named 'checksum'.  This is a bit
too generic and causes crash with applications that worked fine before.

This patch makes the functions checksum, checksum_tcpudp_ipv4 and
checksum_tcpudp_ipv6 local by building with fvis-hidden and adding
EXPORTs for the legacy api calls and the ones that seem to have missing
EXPORT tags (mainly pktbuf api).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Alternative would be to rename "checksum" to something
 more nfq specific, or putting it in some header and make it static.

 Make_global.am           |    2 +-
 src/extra/pktbuff.c      |   12 ++++++++++++
 src/internal.h           |    2 ++
 src/libnetfilter_queue.c |   38 +++++++++++++++++++++++++++++++++++---
 4 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 9bc8ea1..91da5da 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,2 +1,2 @@
 AM_CPPFLAGS = -I${top_srcdir}/include ${LIBNFNETLINK_CFLAGS} ${LIBMNL_CFLAGS}
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 0bd778d..1c15a00 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -84,6 +84,7 @@ pktb_alloc(int family, void *data, size_t len, size_t extra)
 	}
 	return pktb;
 }
+EXPORT_SYMBOL(pktb_alloc);
 
 /**
  * pktb_data - return pointer to the beginning of the packet buffer
@@ -93,6 +94,7 @@ uint8_t *pktb_data(struct pkt_buff *pktb)
 {
 	return pktb->data;
 }
+EXPORT_SYMBOL(pktb_data);
 
 /**
  * pktb_len - return length of the packet buffer
@@ -102,6 +104,7 @@ uint32_t pktb_len(struct pkt_buff *pktb)
 {
 	return pktb->len;
 }
+EXPORT_SYMBOL(pktb_len);
 
 /**
  * pktb_free - release packet buffer
@@ -111,6 +114,7 @@ void pktb_free(struct pkt_buff *pktb)
 {
 	free(pktb);
 }
+EXPORT_SYMBOL(pktb_free);
 
 /**
  * pktb_push - update pointer to the beginning of the packet buffer
@@ -121,6 +125,7 @@ void pktb_push(struct pkt_buff *pktb, unsigned int len)
 	pktb->data -= len;
 	pktb->len += len;
 }
+EXPORT_SYMBOL(pktb_push);
 
 /**
  * pktb_pull - update pointer to the beginning of the packet buffer
@@ -131,6 +136,7 @@ void pktb_pull(struct pkt_buff *pktb, unsigned int len)
 	pktb->data += len;
 	pktb->len -= len;
 }
+EXPORT_SYMBOL(pktb_pull);
 
 /**
  * pktb_put - add extra bytes to the tail of the packet buffer
@@ -141,6 +147,7 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 	pktb->tail += len;
 	pktb->len += len;
 }
+EXPORT_SYMBOL(pktb_put);
 
 /**
  * pktb_trim - set new length for this packet buffer
@@ -150,6 +157,7 @@ void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->len = len;
 }
+EXPORT_SYMBOL(pktb_trim);
 
 /**
  * pktb_tailroom - get room in bytes in the tail of the packet buffer
@@ -159,6 +167,7 @@ unsigned int pktb_tailroom(struct pkt_buff *pktb)
 {
 	return pktb->data_len - pktb->len;
 }
+EXPORT_SYMBOL(pktb_tailroom);
 
 /**
  * pktb_mac_header - return pointer to layer 2 header (if any)
@@ -168,6 +177,7 @@ uint8_t *pktb_mac_header(struct pkt_buff *pktb)
 {
 	return pktb->mac_header;
 }
+EXPORT_SYMBOL(pktb_mac_header);
 
 /**
  * pktb_network_header - return pointer to layer 3 header
@@ -177,6 +187,7 @@ uint8_t *pktb_network_header(struct pkt_buff *pktb)
 {
 	return pktb->network_header;
 }
+EXPORT_SYMBOL(pktb_network_header);
 
 /**
  * pktb_transport_header - return pointer to layer 4 header (if any)
@@ -186,6 +197,7 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb)
 {
 	return pktb->transport_header;
 }
+EXPORT_SYMBOL(pktb_transport_header);
 
 static int pktb_expand_tail(struct pkt_buff *pkt, int extra)
 {
diff --git a/src/internal.h b/src/internal.h
index 37bf79e..7f9d5f4 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -2,6 +2,8 @@
 #define INTERNAL_H 1
 
 #include "config.h"
+#include <stdint.h>
+#include <stdbool.h>
 #ifdef HAVE_VISIBILITY_HIDDEN
 #	define __visible	__attribute__((visibility("default")))
 #	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf944f0..86e555c 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -32,6 +32,7 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
+#include "src/internal.h"
 
 /**
  * \mainpage
@@ -133,6 +134,7 @@ struct nfq_data {
 };
 
 int nfq_errno;
+EXPORT_SYMBOL(nfq_errno);
 
 /***********************************************************************
  * low level stuff 
@@ -225,6 +227,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 {
 	return h->nfnlh;
 }
+EXPORT_SYMBOL(nfq_nfnlh);
 
 /**
  *
@@ -300,7 +303,7 @@ int nfq_fd(struct nfq_handle *h)
 {
 	return nfnl_fd(nfq_nfnlh(h));
 }
-
+EXPORT_SYMBOL(nfq_fd);
 /**
  * @}
  */
@@ -368,6 +371,7 @@ struct nfq_handle *nfq_open(void)
 
 	return qh;
 }
+EXPORT_SYMBOL(nfq_open);
 
 /**
  * @}
@@ -416,6 +420,7 @@ out_free:
 	free(h);
 	return NULL;
 }
+EXPORT_SYMBOL(nfq_open_nfnl);
 
 /**
  * \addtogroup LibrarySetup
@@ -443,6 +448,7 @@ int nfq_close(struct nfq_handle *h)
 		free(h);
 	return ret;
 }
+EXPORT_SYMBOL(nfq_close);
 
 /**
  * nfq_bind_pf - bind a nfqueue handler to a given protocol family
@@ -458,6 +464,7 @@ int nfq_bind_pf(struct nfq_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
+EXPORT_SYMBOL(nfq_bind_pf);
 
 /**
  * nfq_unbind_pf - unbind nfqueue handler from a protocol family
@@ -471,7 +478,7 @@ int nfq_unbind_pf(struct nfq_handle *h, u_int16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
-
+EXPORT_SYMBOL(nfq_unbind_pf);
 
 
 /**
@@ -544,6 +551,7 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 	add_qh(qh);
 	return qh;
 }
+EXPORT_SYMBOL(nfq_create_queue);
 
 /**
  * @}
@@ -571,6 +579,7 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 
 	return ret;
 }
+EXPORT_SYMBOL(nfq_destroy_queue);
 
 /**
  * nfq_handle_packet - handle a packet received from the nfqueue subsystem
@@ -588,6 +597,7 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
 	return nfnl_handle_packet(h->nfnlh, buf, len);
 }
+EXPORT_SYMBOL(nfq_handle_packet);
 
 /**
  * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
@@ -624,6 +634,7 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
+EXPORT_SYMBOL(nfq_set_mode);
 
 /**
  * nfq_set_queue_flags - set flags (options) for the kernel queue
@@ -676,6 +687,7 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
+EXPORT_SYMBOL(nfq_set_queue_flags);
 
 /**
  * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
@@ -706,6 +718,7 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
+EXPORT_SYMBOL(nfq_set_queue_maxlen);
 
 /**
  * @}
@@ -798,7 +811,8 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 {
 	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf,
 						NFQNL_MSG_VERDICT);
-}	
+}
+EXPORT_SYMBOL(nfq_set_verdict);
 
 /**
  * nfq_set_verdict2 - like nfq_set_verdict, but you can set the mark.
@@ -816,6 +830,7 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
+EXPORT_SYMBOL(nfq_set_verdict2);
 
 /**
  * nfq_set_verdict_batch - issue verdicts on several packets at once
@@ -835,6 +850,7 @@ int nfq_set_verdict_batch(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, 0, 0, 0, NULL,
 					NFQNL_MSG_VERDICT_BATCH);
 }
+EXPORT_SYMBOL(nfq_set_verdict_batch);
 
 /**
  * nfq_set_verdict_batch2 - like nfq_set_verdict_batch, but you can set a mark.
@@ -849,6 +865,7 @@ int nfq_set_verdict_batch2(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
+EXPORT_SYMBOL(nfq_set_verdict_batch2);
 
 /**
  * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
@@ -871,6 +888,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
+EXPORT_SYMBOL(nfq_set_verdict_mark);
 
 /**
  * @}
@@ -910,6 +928,7 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
 					struct nfqnl_msg_packet_hdr);
 }
+EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
 
 /**
  * nfq_get_nfmark - get the packet mark
@@ -921,6 +940,7 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
 }
+EXPORT_SYMBOL(nfq_get_nfmark);
 
 /**
  * nfq_get_timestamp - get the packet timestamp
@@ -944,6 +964,7 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 
 	return 0;
 }
+EXPORT_SYMBOL(nfq_get_timestamp);
 
 /**
  * nfq_get_indev - get the interface that the packet was received through
@@ -960,6 +981,7 @@ u_int32_t nfq_get_indev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, u_int32_t));
 }
+EXPORT_SYMBOL(nfq_get_indev);
 
 /**
  * nfq_get_physindev - get the physical interface that the packet was received
@@ -973,6 +995,7 @@ u_int32_t nfq_get_physindev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, u_int32_t));
 }
+EXPORT_SYMBOL(nfq_get_physindev);
 
 /**
  * nfq_get_outdev - gets the interface that the packet will be routed out
@@ -986,6 +1009,7 @@ u_int32_t nfq_get_outdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, u_int32_t));
 }
+EXPORT_SYMBOL(nfq_get_outdev);
 
 /**
  * nfq_get_physoutdev - get the physical interface that the packet output
@@ -1001,6 +1025,7 @@ u_int32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, u_int32_t));
 }
+EXPORT_SYMBOL(nfq_get_physoutdev);
 
 /**
  * nfq_get_indev_name - get the name of the interface the packet
@@ -1046,6 +1071,7 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 	u_int32_t ifindex = nfq_get_indev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
+EXPORT_SYMBOL(nfq_get_indev_name);
 
 /**
  * nfq_get_physindev_name - get the name of the physical interface the
@@ -1065,6 +1091,7 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 	u_int32_t ifindex = nfq_get_physindev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
+EXPORT_SYMBOL(nfq_get_physindev_name);
 
 /**
  * nfq_get_outdev_name - get the name of the physical interface the
@@ -1084,6 +1111,7 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 	u_int32_t ifindex = nfq_get_outdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
+EXPORT_SYMBOL(nfq_get_outdev_name);
 
 /**
  * nfq_get_physoutdev_name - get the name of the interface the
@@ -1104,6 +1132,7 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 	u_int32_t ifindex = nfq_get_physoutdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
+EXPORT_SYMBOL(nfq_get_physoutdev_name);
 
 /**
  * nfq_get_packet_hw
@@ -1132,6 +1161,7 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
 					struct nfqnl_msg_packet_hw);
 }
+EXPORT_SYMBOL(nfq_get_packet_hw);
 
 /**
  * nfq_get_payload - get payload 
@@ -1153,6 +1183,7 @@ int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 
 	return -1;
 }
+EXPORT_SYMBOL(nfq_get_payload);
 
 /**
  * @}
@@ -1339,6 +1370,7 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 
 	return len;
 }
+EXPORT_SYMBOL(nfq_snprintf_xml);
 
 /**
  * @}
-- 
1.7.8.6

