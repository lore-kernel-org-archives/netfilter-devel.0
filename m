Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F96C35247
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 02:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A421820732
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 02:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBDCAS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 21:00:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58271 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbgBDCAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 21:00:18 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 960B73A2F1C
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 13:00:04 +1100 (AEDT)
Received: (qmail 6524 invoked by uid 501); 4 Feb 2020 02:00:03 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src: move static nfq_hdr_put from examples/nf-queue.c into the library since everyone is going to want it.
Date:   Tue,  4 Feb 2020 13:00:03 +1100
Message-Id: <20200204020003.6478-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200204020003.6478-1-duncan_roe@optusnet.com.au>
References: <20200204020003.6478-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=l697ptgUJYAA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=RAhjgGh_ZNwQOQctfxUA:9 a=A5nTlvcZHGX_js2M:21
        a=LNlhHzlcMOFk2SI9:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c                             | 15 -------------
 include/libnetfilter_queue/libnetfilter_queue.h |  1 +
 src/nlmsg.c                                     | 28 ++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 960e244..112c3bf 100644
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
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 092c57d..3372099 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -149,6 +149,7 @@ void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark);
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t pktlen);
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
+struct nlmsghdr *nfq_hdr_put(char *buf, int type, uint32_t queue_num);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 4f09bf6..f4123f3 100644
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
+ * nfq_hdr_put - Convert memory buffer into a Netlink buffer
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \returns Pointer to netlink message
+ */
+EXPORT_SYMBOL
+struct nlmsghdr *nfq_hdr_put(char *buf, int type, uint32_t queue_num)
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

