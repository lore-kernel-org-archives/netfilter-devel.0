Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E25CC47404
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2420F2054F
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfJHAuF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:50:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42005 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729708AbfJHAuE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 20:50:04 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 7C6F543EBF6
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 11:49:49 +1100 (AEDT)
Received: (qmail 25677 invoked by uid 501); 8 Oct 2019 00:49:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/5] src: doc: Miscellaneous updates
Date:   Tue,  8 Oct 2019 11:49:44 +1100
Message-Id: <20191008004948.25632-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
References: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=PO7r1zJSAAAA:8
        a=EwM3G6XomzPRkvz7jn8A:9 a=e5v64WcD_RWYd8SG:21 a=TUPM0A_QL3Xez6QK:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(These updates only cover functions used in a recent project)

 src/extra/ipv4.c: - nfq_ip_set_transport_header(): Add explanatory notes
                   - nfq_ip_mangle()
                     - Advise that there is a return code
                     - Note that IPv4 length is updated as well as checksum

 src/extra/pktbuff.c: - pktb_alloc(): Minor rewording (English usage)
                      - pktb_mangle(): Document

 src/extra/udp.c: - nfq_udp_get_hdr(): Fix params
                  - nfq_udp_get_payload(): Fix params
                  - nfq_udp_get_payload_len(): Fix params
                  - nfq_udp_mangle_ipv4(): Rewrite documentation

 src/nlmsg.c: - nfq_nlmsg_verdict_put(): Document
              - nfq_nlmsg_cfg_put_cmd():
                - Change name (was: nfq_nlmsg_cfg_build_request)
                - Fix params
                - Delete function return documentation (void fn)
              - nfq_nlmsg_cfg_put_params(); Document (params only)
              - nfq_nlmsg_cfg_put_qmaxlen(): Document (params only)
              - nfq_nlmsg_parse:
                - Change name (was: nfq_pkt_parse)
                - Fix params

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c    |  9 +++++++--
 src/extra/pktbuff.c | 15 ++++++++++++++-
 src/extra/udp.c     | 28 +++++++++++++++-------------
 src/nlmsg.c         | 36 +++++++++++++++++++++++++++---------
 4 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index a93d113..20f3c12 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -59,6 +59,10 @@ EXPORT_SYMBOL(nfq_ip_get_hdr);
  * nfq_ip_set_transport_header - set transport header
  * \param pktb: pointer to network packet buffer
  * \param iph: pointer to the IPv4 header
+ *
+ * Sets the \b transport_header field in \b pktb
+ *
+ * Level 4 helper functions need this to be set.
  */
 int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 {
@@ -97,8 +101,9 @@ EXPORT_SYMBOL(nfq_ip_set_checksum);
  * \param match_len: length of the existing content you want to mangle
  * \param rep_buffer: pointer to data you want to use to replace current content
  * \param rep_len: length of data you want to use to replace current content
- *
- * \note This function recalculates the IPv4 checksum (if needed).
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv4 length and recalculates the IPv4
+ * checksum (if necessary)
  */
 int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
 		  unsigned int match_offset, unsigned int match_len,
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 1c15a00..25b173b 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -36,7 +36,7 @@
  * \param extra Extra memory in the tail to be allocated (for mangling)
  *
  * This function returns a packet buffer that contains the packet data and
- * some extra memory room in the tail (in case of requested).
+ * some extra memory room in the tail (if requested).
  *
  * \return a pointer to a new queue handle or NULL on failure.
  */
@@ -224,6 +224,19 @@ static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
 	return 1;
 }
 
+/**
+ * pktb_mangle - adjust contents of a packet
+ * \param pkt Pointer to packet buffer
+ * \param dataoff Offset to layer 3 header. Specify zero to access layer 2 (IP)
+ * header
+ * \param match_offset Further offset to content that you want to mangle
+ * \param match_len Length of the existing content you want to mangle
+ * \param rep_buffer Pointer to data you want to use to replace current content
+ * \param rep_len Length of data you want to use to replace current content
+ * \returns 1 for success and 0 for failure. Failure will occur if the \b extra
+ * argument to the pktb_alloc() call that created \b pkt is less than the excess
+ * of \b rep_len over \b match_len
+ */
 int pktb_mangle(struct pkt_buff *pkt,
 		 unsigned int dataoff,
 		 unsigned int match_offset,
diff --git a/src/extra/udp.c b/src/extra/udp.c
index f89d314..92165b4 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -31,8 +31,7 @@
 
 /**
  * nfq_udp_get_hdr - get the UDP header.
- * \param head: pointer to the beginning of the packet
- * \param tail: pointer to the tail of the packet
+ * \param pktb: Pointer to network packet buffer
  *
  * This function returns NULL if invalid UDP header is found. On success,
  * it returns the UDP header.
@@ -52,8 +51,8 @@ EXPORT_SYMBOL(nfq_udp_get_hdr);
 
 /**
  * nfq_udp_get_payload - get the UDP packet payload.
- * \param udph: the pointer to the UDP header.
- * \param tail: pointer to the tail of the packet
+ * \param udph: Pointer to UDP header
+ * \param pktb: Pointer to network packet buffer
  */
 void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 {
@@ -73,7 +72,8 @@ EXPORT_SYMBOL(nfq_udp_get_payload);
 
 /**
  * nfq_udp_get_payload_len - get the udp packet payload.
- * \param udp: the pointer to the udp header.
+ * \param udph: Pointer to UDP header
+ * \param pktb: Pointer to network packet buffer
  */
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
@@ -120,14 +120,16 @@ nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
 EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
 
 /**
- * nfq_tcp_mangle_ipv4 - mangle TCP/IPv4 packet buffer
- * \param pktb: pointer to network packet buffer
- * \param match_offset: offset to content that you want to mangle
- * \param match_len: length of the existing content you want to mangle
- * \param rep_buffer: pointer to data you want to use to replace current content 
- * \param rep_len: length of data you want to use to replace current content
- *
- * \note This function recalculates the IPv4 and TCP checksums for you.
+ * nfq_udp_mangle_ipv4 - Mangle UDP/IPv4 packet buffer
+ * \param pktb: Pointer to network packet buffer
+ * \param match_offset: Offset from start of UDP data of content that you want
+ * to mangle
+ * \param match_len: Length of the existing content you want to mangle
+ * \param rep_buffer: Pointer to data you want to use to replace current content
+ * \param rep_len: Length of data you want to use to replace current content
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv4 and UDP lengths and recalculates their
+ * checksums for you.
  */
 int
 nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
diff --git a/src/nlmsg.c b/src/nlmsg.c
index ba28c77..ac0adab 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -30,6 +30,16 @@
  * @{
  */
 
+/**
+ * nfq_nlmsg_verdict_put - Put a verdict into a Netlink header
+ * \param nlh Pointer to netlink message
+ * \param id ID assigned to packet by netfilter
+ * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ *
+ * See examples/nf-queue.c, line 46 for an example of how to use this function.
+ * The calling sequence is \b main --> \b mnl_cb_run --> \b queue_cb -->
+ * \b nfq_send_verdict --> \b nfq_nlmsg_verdict_put
+ */
 void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
 {
 	struct nfqnl_msg_verdict_hdr vh = {
@@ -63,13 +73,10 @@ EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
  */
 
 /**
- * nfq_nlmsg_cfg_build_request- build netlink config message
- * \param buf Buffer where netlink message is going to be written.
- * \param cfg Structure that contains the config parameters.
- * \param command nfqueue nfnetlink command.
- *
- * This function returns a pointer to the netlink message. If something goes
- * wrong it returns NULL.
+ * nfq_nlmsg_cfg_put_cmd Add netlink config command to netlink message
+ * \param nlh Pointer to netlink message
+ * \param pf Packet family (e.g. AF_INET)
+ * \param cmd nfqueue nfnetlink command.
  *
  * Possible commands are:
  *
@@ -95,6 +102,12 @@ void nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
 }
 EXPORT_SYMBOL(nfq_nlmsg_cfg_put_cmd);
 
+/**
+ * nfq_nlmsg_cfg_put_params Add parameter to netlink message
+ * \param nlh Pointer to netlink message
+ * \param mode one of NFQNL_COPY_NONE, NFQNL_COPY_META or NFQNL_COPY_PACKET
+ * \param range value of parameter
+ */
 void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 {
 	struct nfqnl_msg_config_params params = {
@@ -105,6 +118,11 @@ void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 }
 EXPORT_SYMBOL(nfq_nlmsg_cfg_put_params);
 
+/**
+ * nfq_nlmsg_cfg_put_qmaxlen Add queue maximum length to netlink message
+ * \param nlh Pointer to netlink message
+ * \param queue_maxlen Maximum queue length
+ */
 void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
 {
 	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queue_maxlen));
@@ -172,9 +190,9 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 }
 
 /**
- * nfq_pkt_parse - set packet attributes from netlink message
+ * nfq_nlmsg_parse - set packet attributes from netlink message
  * \param nlh netlink message that you want to read.
- * \param pkt pointer to the packet to set.
+ * \param attr pointer to array of attributes to set.
  *
  * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
  * success.
-- 
2.14.5

