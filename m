From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] examples/nf-queue: receive large gso packets
Date: Thu, 25 Apr 2013 12:43:31 +0200
Message-ID: <1366886611-21666-5-git-send-email-fw@strlen.de>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45146 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757652Ab3DYKl3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:41:29 -0400
In-Reply-To: <1366886611-21666-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also, do not include
<linux/netfilter/nfnetlink_queue.h>.

problem is that the include guard in that file means
that linux_nfnetlink_queue.h (local copy of nfnetlink_queue.h in
libnetfiler_queue) will be empty, ie. the SKB_INFO/GSO attributes
added in the previous commit are not exposed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nf-queue.c |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 57ba483..67c9be2 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -11,8 +11,6 @@
 #include <linux/netfilter/nfnetlink.h>
 
 #include <linux/types.h>
-#include <linux/netfilter/nfnetlink_queue.h>
-
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
 static struct mnl_socket *nl;
@@ -51,7 +49,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
-	uint32_t id = 0;
+	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
 	uint16_t plen;
 
@@ -72,10 +70,32 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
 	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
 
+	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
+
+	if (attr[NFQA_CAP_LEN]) {
+		uint32_t orig_len = ntohl(mnl_attr_get_u32(attr[NFQA_CAP_LEN]));
+		if (orig_len != plen)
+			printf("truncated ");
+	}
+
+	if (skbinfo & NFQA_SKB_GSO)
+		printf("GSO ");
+
 	id = ntohl(ph->packet_id);
-	printf("packet received (id=%u hw=0x%04x hook=%u, payload len %u)\n",
+	printf("packet received (id=%u hw=0x%04x hook=%u, payload len %u",
 		id, ntohs(ph->hw_protocol), ph->hook, plen);
 
+	/*
+	 * ip/tcp checksums are not yet valid, e.g. due to GRO/GSO.
+	 * The application should behave as if the checksums are correct.
+	 *
+	 * If these packets are later forwarded/sent out, the checksums will
+	 * be corrected by kernel/hardware.
+	 */
+	if (skbinfo & NFQA_SKB_CSUMNOTREADY)
+		printf(", checksum not ready");
+	puts(")");
+
 	nfq_send_verdict(ntohs(nfg->res_id), id);
 
 	return MNL_CB_OK;
@@ -140,6 +160,9 @@ int main(int argc, char *argv[])
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_params(nlh, NFQNL_COPY_PACKET, 0xffff);
 
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(NFQA_CFG_F_GSO));
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(NFQA_CFG_F_GSO));
+
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
-- 
1.7.8.6

