Return-Path: <SRS0=bPAQ=64=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE02C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 04:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 754FE20575
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 May 2020 04:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgENEfx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 May 2020 00:35:53 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58755 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgENEfw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 May 2020 00:35:52 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail109.syd.optusnet.com.au (Postfix) with SMTP id 20B12D792E9
        for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2020 14:35:47 +1000 (AEST)
Received: (qmail 1309 invoked by uid 501); 14 May 2020 04:35:47 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] example: nf-queue: use pkt_buff (updated)
Date:   Thu, 14 May 2020 14:35:47 +1000
Message-Id: <20200514043547.1255-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200514043547.1255-1-duncan_roe@optusnet.com.au>
References: <20200514043547.1255-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20200426132356.8346-3-pablo@netfilter.org>
References: <20200426132356.8346-3-pablo@netfilter.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=Zop7vPSz-8r78q76v34A:9 a=_YyiWX3kw4eOLg-o:21 a=tEm59D-WalUOrs8p:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Use the 5-args pktb_setup() variant.
- Demonstrate using pktb_head_size() once in main() to set size of array
  in callback stack.
- Output 2 hex digits per character.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index f0d4c2e..1d0cba4 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static struct mnl_socket *nl;
+static size_t sizeof_pktbuff;
 
 static void
 nfq_send_verdict(int queue_num, uint32_t id)
@@ -51,7 +52,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
-	struct pkt_buff *pktb = data;
+	struct pkt_buff *pktb;
+	uint8_t pktbuff[sizeof_pktbuff];
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
 	uint8_t *payload;
@@ -74,7 +76,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
 
-	pktb_build_data(pktb, mnl_attr_get_payload(attr[NFQA_PAYLOAD]), plen);
+	pktb = pktb_setup(AF_INET, pktbuff, sizeof pktbuff,
+			  mnl_attr_get_payload(attr[NFQA_PAYLOAD]), plen);
 
 	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 
@@ -106,7 +109,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	payload = pktb_data(pktb);
 
 	for (i = 0; i < pktb_len(pktb); i++)
-		printf("%x", payload[i] & 0xff);
+		printf("%02x", payload[i]);
 
 	printf("]\n");
 
@@ -120,7 +123,6 @@ int main(int argc, char *argv[])
 	char *buf;
 	/* largest possible packet payload, plus netlink data overhead: */
 	size_t sizeof_buf = 0xffff + (MNL_SOCKET_BUFFER_SIZE/2);
-	struct pkt_buff *pktb;
 	struct nlmsghdr *nlh;
 	int ret;
 	unsigned int portid, queue_num;
@@ -174,12 +176,7 @@ int main(int argc, char *argv[])
 	 */
 	ret = 1;
 	mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret, sizeof(int));
-
-	pktb = pktb_alloc_head();
-	if (!pktb) {
-		perror("pktb_alloc");
-		exit(EXIT_FAILURE);
-	}
+	sizeof_pktbuff = pktb_head_size(); /* Avoid multiple calls in CB */
 
 	for (;;) {
 		ret = mnl_socket_recvfrom(nl, buf, sizeof_buf);
@@ -188,14 +185,13 @@ int main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
-		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, pktb);
+		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
 		if (ret < 0){
 			perror("mnl_cb_run");
 			exit(EXIT_FAILURE);
 		}
 	}
 
-	pktb_free(pktb);
 	mnl_socket_close(nl);
 
 	return 0;
-- 
2.14.5

