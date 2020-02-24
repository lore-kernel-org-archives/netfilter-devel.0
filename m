Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EE2C35670
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06AFD2067D
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgBXAwk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:52:40 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35572 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbgBXAwk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:52:40 -0500
Received: from dimstar.local.net (n122-110-29-255.sun2.vic.optusnet.com.au [122.110.29.255])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id EE2463A1D71
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 11:52:26 +1100 (AEDT)
Received: (qmail 3687 invoked by uid 501); 24 Feb 2020 00:52:26 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: move static nfq_hdr_put from examples/nf-queue.c into the library since everyone is going to want it.
Date:   Mon, 24 Feb 2020 11:52:26 +1100
Message-Id: <20200224005226.3645-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200223221627.fuls57nduj5u7ree@salvia>
References: <20200223221627.fuls57nduj5u7ree@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=xEIwVUYJq7t7CX9UEWuoUA==:117 a=xEIwVUYJq7t7CX9UEWuoUA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=l697ptgUJYAA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=Kq9PGfCkUlZ2MXVWOHsA:9 a=xa45fc-ohCpsW9mt:21
        a=2_2shBK_XbCdLy38:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also rename nfq_hdr_put to nfq_nlmsg_put

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>

v2: Rename nfq_hdr_put to nfq_nlmsg_put on Pablo's suggestion
---
 examples/nf-queue.c                             | 21 +++----------------
 include/libnetfilter_queue/libnetfilter_queue.h |  1 +
 src/nlmsg.c                                     | 28 ++++++++++++++++++++++---
 3 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 960e244..3da2c24 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -20,21 +20,6 @@
 
 static struct mnl_socket *nl;
 
-static struct nlmsghdr *
-nfq_hdr_put(char *buf, int type, uint32_t queue_num)
-{
-	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type	= (NFNL_SUBSYS_QUEUE << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-
-	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_UNSPEC;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = htons(queue_num);
-
-	return nlh;
-}
-
 static void
 nfq_send_verdict(int queue_num, uint32_t id)
 {
@@ -42,7 +27,7 @@ nfq_send_verdict(int queue_num, uint32_t id)
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_VERDICT, queue_num);
+	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, queue_num);
 	nfq_nlmsg_verdict_put(nlh, id, NF_ACCEPT);
 
 	/* example to set the connmark. First, start NFQA_CT section: */
@@ -150,7 +135,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
+	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_BIND);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
@@ -158,7 +143,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
+	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_params(nlh, NFQNL_COPY_PACKET, 0xffff);
 
 	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(NFQA_CFG_F_GSO));
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 092c57d..34385a7 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -149,6 +149,7 @@ void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark);
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t pktlen);
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
+struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 4f09bf6..e141156 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -261,9 +261,9 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 
 /**
  * nfq_nlmsg_parse - set packet attributes from netlink message
- * \param nlh netlink message that you want to read.
- * \param attr pointer to array of attributes to set.
- * \returns MNL_CB_OK on success or MNL_CB_ERROR if any error occurs.
+ * \param nlh Pointer to netlink message
+ * \param attr Pointer to array of attributes to set
+ * \returns MNL_CB_OK on success or MNL_CB_ERROR if any error occurs
  */
 EXPORT_SYMBOL
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
@@ -272,6 +272,28 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 			      nfq_pkt_parse_attr_cb, attr);
 }
 
+/**
+ * nfq_nlmsg_put - Convert memory buffer into a Netlink buffer
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \returns Pointer to netlink message
+ */
+EXPORT_SYMBOL
+struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
+	nlh->nlmsg_flags = NLM_F_REQUEST;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	return nlh;
+}
+
 /**
  * @}
  */
-- 
2.14.5

