From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] src: add new GSO handling capabilities
Date: Thu, 25 Apr 2013 12:43:30 +0200
Message-ID: <1366886611-21666-4-git-send-email-fw@strlen.de>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45145 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757608Ab3DYKl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:41:27 -0400
In-Reply-To: <1366886611-21666-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows userspace to ask for large gso packets via nfqueue.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnetfilter_queue/linux_nfnetlink_queue.h |   13 ++++++++++++-
 src/libnetfilter_queue.c                           |    6 ++++++
 src/nlmsg.c                                        |    2 ++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 58c8ca5..81a485b 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -45,6 +45,10 @@ enum nfqnl_attr_type {
 	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
+	NFQA_CT,			/* nf_conntrack_netlink.h */
+	NFQA_CT_INFO,			/* enum ip_conntrack_info */
+	NFQA_CAP_LEN,                   /* __u32 length of captured packet */
+	NFQA_SKB_INFO,                  /* __u32 skb meta information */
 
 	__NFQA_MAX
 };
@@ -96,6 +100,13 @@ enum nfqnl_attr_config {
 /* Flags/options for NFQA_CFG_FLAGS */
 #define NFQA_CFG_F_FAIL_OPEN		(1 << 0)
 #define NFQA_CFG_F_CONNTRACK		(1 << 1)
-#define NFQA_CFG_F_MAX			(1 << 2)
+#define NFQA_CFG_F_GSO			(1 << 2)
+#define NFQA_CFG_F_MAX			(1 << 3)
+
+/* flags for NFQA_SKB_INFO */
+/* packet appears to have wrong checksums, but they are ok */
+#define NFQA_SKB_CSUMNOTREADY (1 << 0)
+/* packet is GSO (i.e., exceeds device mtu) */
+#define NFQA_SKB_GSO (1 << 1)
 
 #endif /* _NFNETLINK_QUEUE_H */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 2894ccd..b933a2a 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -639,6 +639,12 @@ int nfq_set_mode(struct nfq_q_handle *qh,
  * - NFQA_CFG_F_CONNTRACK (requires Linux kernel >= 3.6): the kernel will
  *   include the Connection Tracking system information.
  *
+ * - NFQA_CFG_F_GSO (requires Linux kernel >= 3.10): the kernel will
+ *   not normalize offload packets, i.e. your application will need to
+ *   be able to handle packets larger than the mtu (up to 64k) and will
+ *   need to check the NFQA_SKB_INFO attribute to determine when ip/tcp
+ *   checksums are valid even if they appear to be invalid.
+ *
  * Here's a little code snippet to show how to use this API:
  * \verbatim
 	uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e592ebd..37fa6b8 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -130,6 +130,8 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFQA_IFINDEX_OUTDEV:
 	case NFQA_IFINDEX_PHYSINDEV:
 	case NFQA_IFINDEX_PHYSOUTDEV:
+	case NFQA_CAP_LEN:
+	case NFQA_SKB_INFO:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			return MNL_CB_ERROR;
 		break;
-- 
1.7.8.6

