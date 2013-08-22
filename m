From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-queue] api: add nfq_nlmsg_get_timestamp helper
Date: Thu, 22 Aug 2013 17:07:17 +0200
Message-ID: <1377184037-19790-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49366 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab3HVPH1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:07:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The NFQA_TIMESTAMP structure is in network byte order, so it seems
appropriate to add a helper to convert it to a timeval struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nf-queue.c                             |    9 ++++++++-
 include/libnetfilter_queue/libnetfilter_queue.h |    2 ++
 src/nlmsg.c                                     |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 1f465ad..2722426 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -5,6 +5,7 @@
 #include <string.h>
 #include <time.h>
 #include <arpa/inet.h>
+#include <sys/time.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
@@ -54,6 +55,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
 	uint16_t plen;
+	struct timeval tv;
 
 	if (nfq_nlmsg_parse(nlh, attr) < 0) {
 		perror("problems parsing");
@@ -72,7 +74,11 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
 	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
 
-	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
+	if (attr[NFQA_TIMESTAMP])
+		nfq_nlmsg_get_timestamp(attr[NFQA_TIMESTAMP], &tv);
+	else
+		gettimeofday(&tv, NULL);
+	printf("%lu:%06lu ", (long) tv.tv_sec, (long) tv.tv_usec);
 
 	if (attr[NFQA_CAP_LEN]) {
 		uint32_t orig_len = ntohl(mnl_attr_get_u32(attr[NFQA_CAP_LEN]));
@@ -80,6 +86,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 			printf("truncated ");
 	}
 
+	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 	if (skbinfo & NFQA_SKB_GSO)
 		printf("GSO ");
 
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index b9f16e2..537cabf 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -144,6 +144,8 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **pkt);
 
+void nfq_nlmsg_get_timestamp(const struct nlattr *attr, struct timeval *tv);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e7a30e0..10f96cf 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -172,5 +172,20 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 EXPORT_SYMBOL(nfq_nlmsg_parse);
 
 /**
+ * nfq_nlmsg_get_timestamp - get the packet timestamp
+ * \param attr pointer to valid NFQA_TIMESTAMP attribute header
+ * \param timeval structure to fill with data
+ *
+ * This function always succeeds.
+ */
+void nfq_nlmsg_get_timestamp(const struct nlattr *attr, struct timeval *tv)
+{
+	struct nfqnl_msg_packet_timestamp *ts = mnl_attr_get_payload(attr);
+	tv->tv_sec = __be64_to_cpu(ts->sec);
+	tv->tv_usec = __be64_to_cpu(ts->usec);
+}
+EXPORT_SYMBOL(nfq_nlmsg_get_timestamp);
+
+/**
  * @}
  */
-- 
1.7.8.6

