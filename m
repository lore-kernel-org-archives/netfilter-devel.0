Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C706DC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DFD120674
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgFCDzR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:55:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41856 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgFCDzR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 23:55:17 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 0FAC2820F0C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 13:55:13 +1000 (AEST)
Received: (qmail 17593 invoked by uid 501); 3 Jun 2020 03:55:12 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 1/1] examples: Use sendmsg() to avoid packet copy in nfq_nlmsg_verdict_put_pkt()
Date:   Wed,  3 Jun 2020 13:55:12 +1000
Message-Id: <20200603035512.17544-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200603035512.17544-1-duncan_roe@optusnet.com.au>
References: <20200603035512.17544-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=dcpdSKjAiVK6bzsqbZwA:9 a=Gbv0C6KDiTPWvZ_-:21 a=KYiktv7KUKElNUuF:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch does a null mangle of every 2nd packet (packet is unchanged but
pktb->mangled is set).

Mangling every 2nd packet tests all code paths, but turns out to be essential
for IPv6 on the 'lo' interface, but because such packets always have "checksum
not ready"; and the kernel insists that mangled packets have a good checksum.
So every second UDP is lost, while TCP gets through on the retransmit.

The static functions at the front really belong in the appropriate libraries.

      Diagram of in-memory verdict construction with packet data

KEY:        ++++                     ++++
            |  | Occurs once         <  > Occurs zero or more times
            ++++                     ++++

                      +++++++++
                      |nlmsg  |\
                      |header | \
                      +++++++++  }
                      <attrib >  }
                      <header >  }
                      <------->  } first
                      <attrib >  } IOV
                      <payload>  }
                      +++++++++  }
                      |packet |  }
                      |attrib | /
                      |header |/
                      +++++++++
                      <attrib >\
                      <header > \
                      <------->  } last IOV
                      <attrib > /
                      <payload>/
                      +++++++++

Second IOV covers packet data.
Third IOV covers padding after packet data (if required).

The count in the nlmsg header indexes attributes until all are added.
Add packet data length and pad length to count before sending to kernel.

Without packet data, there is one IOV.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 122 insertions(+), 6 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..192ec68 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -14,22 +14,118 @@
 #include <linux/netfilter/nfnetlink_queue.h>
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/pktbuff.h>
 
 /* only for NFQA_CT, not needed otherwise: */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static struct mnl_socket *nl;
 
+/* Suggested additions to libnetfilter_queue.h */
+
+struct nfq_iovec {
+	struct iovec	iov[4];
+	int		iovidx;
+	char		padbuf[3];
+};
+
+/* Suggested addition to libmnl */
+
+static ssize_t
+mnl_socket_sendmsg(struct mnl_socket *nl, struct iovec *iov, int iovcnt)
+{
+	/* Could have this at top level since > 1 function will now use it */
+	static struct sockaddr_nl snl = {
+		.nl_family = AF_NETLINK
+	};
+
+	const struct msghdr msg = {
+		.msg_name = &snl,
+		.msg_namelen = sizeof snl,
+		.msg_iov = iov,
+		.msg_iovlen = iovcnt,
+		.msg_control = NULL,
+		.msg_controllen = 0,
+		.msg_flags = 0,
+	};
+
+	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+}
+
+/* Suggested additions to libnetfilter_queue */
+
+static void
+nfq_verdict_iov_init(struct nlmsghdr *nlh, struct nfq_iovec *vec)
+{
+	vec->iov[0].iov_base = nlh;
+	vec->iovidx = 0;
+}
+
 static void
-nfq_send_verdict(int queue_num, uint32_t id)
+nfq_nlmsg_verdict_iov_put_pkt(struct nlmsghdr *nlh, const void * pkt,
+			      uint32_t plen, struct nfq_iovec *vec)
+{
+	struct nlattr *attrib = mnl_nlmsg_get_payload_tail(nlh);
+	uint16_t payload_len = MNL_ATTR_HDRLEN + plen;
+	int pad;
+
+	/* Duplicate the first part of mnl_attr_put() */
+	attrib->nla_type = NFQA_PAYLOAD;
+	attrib->nla_len = payload_len;
+	nlh->nlmsg_len += MNL_ATTR_HDRLEN;
+
+	vec->iov[vec->iovidx].iov_len = nlh->nlmsg_len;
+	vec->iov[++vec->iovidx].iov_base = (void *)pkt;
+	vec->iov[vec->iovidx].iov_len = plen;
+	pad = MNL_ALIGN(plen) - plen;
+	if (pad) {
+		memset(vec->padbuf, 0, pad);
+		vec->iov[++vec->iovidx].iov_base = vec->padbuf;
+		vec->iov[vec->iovidx].iov_len = pad;
+	}
+	vec->iov[++vec->iovidx].iov_base = vec->iov[0].iov_base +
+					   vec->iov[0].iov_len;
+}
+
+static ssize_t
+nfq_socket_sendmsg(struct mnl_socket *nl, struct nlmsghdr *nlh,
+		   struct nfq_iovec *vec)
+{
+	if (vec->iovidx) {
+		int i;
+
+		vec->iov[vec->iovidx].iov_len = nlh->nlmsg_len -
+						vec->iov[0].iov_len;
+		for (i = 1; i < vec->iovidx; i++)
+			nlh->nlmsg_len += vec->iov[i].iov_len;
+	}
+	else
+		vec->iov[0].iov_len = nlh->nlmsg_len;
+
+	return mnl_socket_sendmsg(nl, vec->iov,
+				  vec->iovidx +
+				  (vec->iov[vec->iovidx].iov_len ? 1 : 0));
+}
+
+/* End suggested additions */
+
+static void
+nfq_send_verdict(int queue_num, uint32_t id, struct pkt_buff *pktb)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
+	struct nfq_iovec niov;
 
 	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, queue_num);
+	nfq_verdict_iov_init(nlh, &niov);
 	nfq_nlmsg_verdict_put(nlh, id, NF_ACCEPT);
 
+	/* Example to update packet contents using sendmsg() */
+	if (pktb_mangled(pktb))
+		nfq_nlmsg_verdict_iov_put_pkt(nlh, pktb_data(pktb),
+					      pktb_len(pktb), &niov);
+
 	/* example to set the connmark. First, start NFQA_CT section: */
 	nest = mnl_attr_nest_start(nlh, NFQA_CT);
 
@@ -40,8 +136,9 @@ nfq_send_verdict(int queue_num, uint32_t id)
 	/* end conntrack section */
 	mnl_attr_nest_end(nlh, nest);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
+	if (nfq_socket_sendmsg(nl, nlh, &niov) < 0)
+	{
+		perror("nfq_socket_sendmsg");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -50,9 +147,12 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
+	struct pkt_buff *pktb;
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
 	uint16_t plen;
+	static bool mangle = false;
+	bool csum_bad = false;
 
 	if (nfq_nlmsg_parse(nlh, attr) < 0) {
 		perror("problems parsing");
@@ -69,7 +169,9 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
 
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
-	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
+
+	pktb = pktb_alloc(AF_INET, mnl_attr_get_payload(attr[NFQA_PAYLOAD]),
+			  plen, 0);
 
 	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 
@@ -93,11 +195,25 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	 * If these packets are later forwarded/sent out, the checksums will
 	 * be corrected by kernel/hardware.
 	 */
-	if (skbinfo & NFQA_SKB_CSUMNOTREADY)
+	if (skbinfo & NFQA_SKB_CSUMNOTREADY) {
 		printf(", checksum not ready");
+		csum_bad = true;
+	}
 	puts(")");
 
-	nfq_send_verdict(ntohs(nfg->res_id), id);
+	/* Mangle every 2nd packet to exercise both code paths */
+	/* Nothing gets changed but set the 'mangled' flag */
+	mangle = !mangle;
+	if (mangle) {
+		pktb_mangle(pktb, 0, 0, 0, NULL, 0);
+		if (csum_bad)
+			puts("Warning: kernel will discard mangled packet "
+			     "owing to bad checksum");
+	}
+
+	nfq_send_verdict(ntohs(nfg->res_id), id, pktb);
+
+	pktb_free(pktb);
 
 	return MNL_CB_OK;
 }
-- 
2.14.5

