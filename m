From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH] libmnl: security context retrieval in nf-queue example
Date: Tue, 16 Jun 2015 18:14:47 +0200
Message-ID: <55804B77.1030207@samsung.com>
References: <20150527124957.GA19819@salvia> <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc> <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc> <557AB559.1000001@samsung.com>
 <20150612130240.GA29551@salvia> <558015A9.8060703@samsung.com>
 <20150616123706.GA32486@salvia> <55801D8A.9050701@samsung.com>
 <20150616152522.GA3959@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22920 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbbFPQOu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 12:14:50 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ100EFJP4N2FC0@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 16 Jun 2015 17:14:47 +0100 (BST)
In-reply-to: <20150616152522.GA3959@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Below is a complete libnetfilter_queue patch:


[PATCH] libnetfilter_queue: add security context information

This commit adds security context information structures
and functions.

This will allow userspace to find the security context of each
packet (if it exists) and make decisions based on that.
It should work for SELinux and SMACK.

Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
---
 include/libnetfilter_queue/libnetfilter_queue.h    |  2 ++
 include/libnetfilter_queue/linux_nfnetlink_queue.h |  4 +++-
 include/linux/netfilter/nfnetlink_queue.h          |  4 +++-
 src/libnetfilter_queue.c                           | 23 ++++++++++++++++++++++
 src/nlmsg.c                                        |  1 +
 utils/nfqnl_test.c                                 | 14 +++++++++++--
 6 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 8194a4f..d7734e6 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -105,6 +105,7 @@ extern uint32_t nfq_get_outdev(struct nfq_data *nfad);
 extern uint32_t nfq_get_physoutdev(struct nfq_data *nfad);
 extern int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid);
 extern int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid);
+extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
 
 extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			      struct nfq_data *nfad, char *name);
@@ -129,6 +130,7 @@ enum {
 	NFQ_XML_TIME	= (1 << 5),
 	NFQ_XML_UID	= (1 << 6),
 	NFQ_XML_GID	= (1 << 7),
+	NFQ_XML_SECCTX  = (1 << 8),
 	NFQ_XML_ALL	= ~0U,
 };
 
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 5b6ae95..1975dfa 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -53,6 +53,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,			/* security context string */
 
 	__NFQA_MAX
 };
@@ -106,7 +107,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
 #define NFQA_CFG_F_GSO				(1 << 2)
 #define NFQA_CFG_F_UID_GID			(1 << 3)
-#define NFQA_CFG_F_MAX				(1 << 4)
+#define NFQA_CFG_F_SECCTX			(1 << 4)
+#define NFQA_CFG_F_MAX				(1 << 5)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 22f5d45..030672d 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -49,6 +49,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,
 
 	__NFQA_MAX
 };
@@ -102,7 +103,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
 #define NFQA_CFG_F_GSO				(1 << 2)
 #define NFQA_CFG_F_UID_GID			(1 << 3)
-#define NFQA_CFG_F_MAX				(1 << 4)
+#define NFQA_CFG_F_SECCTX			(1 << 4)
+#define NFQA_CFG_F_MAX				(1 << 5)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index c9ed865..84184ee 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1218,6 +1218,29 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 }
 EXPORT_SYMBOL(nfq_get_gid);
 
+
+/**
+ * nfq_get_secctx - get the security context for this packet
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param secdata data to write the security context to
+ *
+ * \return -1 on error, otherwise > 0
+ */
+int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
+{
+	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
+		return -1;
+
+	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data,
+							NFQA_SECCTX, char);
+
+	if (*secdata)
+		return NFA_PAYLOAD(nfad->data[NFQA_SECCTX-1]);
+
+	return 0;
+}
+EXPORT_SYMBOL(nfq_get_secctx);
+
 /**
  * nfq_get_payload - get payload 
  * \param nfad Netlink packet data handle passed to callback function
diff --git a/src/nlmsg.c b/src/nlmsg.c
index aebdd5e..cabd8be 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -137,6 +137,7 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFQA_IFINDEX_PHYSOUTDEV:
 	case NFQA_CAP_LEN:
 	case NFQA_SKB_INFO:
+	case NFQA_SECCTX:
 	case NFQA_UID:
 	case NFQA_GID:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index b760cf0..783bc6c 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -17,7 +17,7 @@ static uint32_t print_pkt (struct nfq_data *tb)
 	struct nfqnl_msg_packet_hw *hwph;
 	uint32_t mark, ifi, uid, gid;
 	int ret;
-	unsigned char *data;
+	unsigned char *data, *secdata;
 
 	ph = nfq_get_msg_packet_hdr(tb);
 	if (ph) {
@@ -61,6 +61,10 @@ static uint32_t print_pkt (struct nfq_data *tb)
 	if (nfq_get_gid(tb, &gid))
 		printf("gid=%u ", gid);
 
+	ret = nfq_get_secctx(tb, &secdata);
+	if (ret > 0)
+		printf("secctx=\"%.*s\" ", ret, secdata);
+
 	ret = nfq_get_payload(tb, &data);
 	if (ret >= 0)
 		printf("payload_len=%d ", ret);
@@ -76,7 +80,7 @@ static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
 {
 	uint32_t id = print_pkt(nfa);
 	printf("entering callback\n");
-	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
+	return nfq_set_verdict2(qh, id, NF_ACCEPT, 0x3, 0, NULL);
 }
 
 int main(int argc, char **argv)
@@ -134,6 +138,12 @@ int main(int argc, char **argv)
 				"retrieve process UID/GID.\n");
 	}
 
+	printf("setting flags to request security context\n");
+	if (nfq_set_queue_flags(qh, NFQA_CFG_F_SECCTX, NFQA_CFG_F_SECCTX)) {
+		fprintf(stderr, "This kernel version does not allow to "
+				"retrieve security context.\n");
+	}
+
 	printf("Waiting for packets...\n");
 
 	fd = nfq_fd(h);
-- 
2.0.1

