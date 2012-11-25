From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] examples: nf-queue: fix api usage
Date: Sun, 25 Nov 2012 16:54:32 +0100
Message-ID: <1353858872-12348-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43736 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab2KYP5z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2012 10:57:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1. struct nlattr *attr[NFQA_MAX+1] must be initialized.
   Otherwise, attr[FOO] might be non-null after parsing
   even if that attribute isn't present in the message.

2. mnl_attr_get_payload will never return NULL (if the
   attribute is NULL, it returns MNL_ATTR_HDRLEN.)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nf-queue.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 4d56751..3d64386 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -31,12 +31,11 @@ nfq_hdr_put(char *buf, int type, uint32_t queue_num)
 	return nlh;
 }
 
-static int
+static void
 nfq_send_verdict(int queue_num, uint32_t id)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	int ret;
 
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_VERDICT, queue_num);
 	nfq_nlmsg_verdict_put(nlh, id, NF_ACCEPT);
@@ -45,16 +44,15 @@ nfq_send_verdict(int queue_num, uint32_t id)
 		perror("mnl_socket_send");
 		exit(EXIT_FAILURE);
 	}
-
-	return ret;
 }
 
 static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
-	struct nlattr *attr[NFQA_MAX+1];
+	struct nlattr *attr[NFQA_MAX+1] = {};
 	uint32_t id = 0;
 	struct nfgenmsg *nfg;
+	uint16_t plen;
 
 	if (nfq_nlmsg_parse(nlh, attr) < 0) {
 		perror("problems parsing");
@@ -63,18 +61,22 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfg = mnl_nlmsg_get_payload(nlh);
 
-	ph = (struct nfqnl_msg_packet_hdr *)
-		mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
-	if (ph == NULL) {
-		perror("problems retrieving metaheader");
+	if (attr[NFQA_PACKET_HDR] == NULL) {
+		fputs("metaheader not set\n", stderr);
 		return MNL_CB_ERROR;
 	}
 
-	id = ntohl(ph->packet_id);
+	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
 
-	printf("packet received (id=%u hw=0x%04x hook=%u)\n",
-		id, ntohs(ph->hw_protocol), ph->hook);
+	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
+	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
+
+	id = ntohl(ph->packet_id);
+	printf("packet received (id=%u hw=0x%04x hook=%u, payload len %u)\n",
+		id, ntohs(ph->hw_protocol), ph->hook, plen);
 
+	puts("sleep 10 seconds");
+	sleep(10);
 	nfq_send_verdict(ntohs(nfg->res_id), id);
 
 	return MNL_CB_OK;
-- 
1.7.8.6

