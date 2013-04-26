From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] src: add new GSO handling capabilities
Date: Fri, 26 Apr 2013 10:33:30 +0200
Message-ID: <1366965211-23412-4-git-send-email-fw@strlen.de>
References: <1366965211-23412-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48575 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413Ab3DZIb1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:31:27 -0400
In-Reply-To: <1366965211-23412-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows userspace to ask for large gso packets via nfqueue.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnetfilter_queue/linux_nfnetlink_queue.h |   13 +++++++++++-
 include/linux/netfilter/nfnetlink_queue.h          |   21 +++++++++++++++----
 src/libnetfilter_queue.c                           |    6 +++++
 src/nlmsg.c                                        |    2 +
 4 files changed, 36 insertions(+), 6 deletions(-)

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
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index da44b33..a2308ae 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -44,6 +44,8 @@ enum nfqnl_attr_type {
 	NFQA_PAYLOAD,			/* opaque data payload */
 	NFQA_CT,			/* nf_conntrack_netlink.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
+	NFQA_CAP_LEN,			/* __u32 length of captured packet */
+	NFQA_SKB_INFO,			/* __u32 skb meta information */
 
 	__NFQA_MAX
 };
@@ -80,19 +82,28 @@ struct nfqnl_msg_config_params {
 	__u8	copy_mode;	/* enum nfqnl_config_mode */
 } __attribute__ ((packed));
 
-enum nfqnl_flags {
-	NFQNL_F_NONE		= 0,
-	NFQNL_F_CONNTRACK	= (1 << 0),
-};
 
 enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
 	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
-	NFQA_CFG_FLAGS,			/* __u32 */
+	NFQA_CFG_MASK,			/* identify which flags to change */
+	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
 
+/* Flags for NFQA_CFG_FLAGS */
+#define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
+#define NFQA_CFG_F_CONNTRACK			(1 << 1)
+#define NFQA_CFG_F_GSO				(1 << 2)
+#define NFQA_CFG_F_MAX				(1 << 3)
+
+/* flags for NFQA_SKB_INFO */
+/* packet appears to have wrong checksums, but they are ok */
+#define NFQA_SKB_CSUMNOTREADY (1 << 0)
+/* packet is GSO (i.e., exceeds device mtu) */
+#define NFQA_SKB_GSO (1 << 1)
+
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
index 6c4a139..e7a30e0 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -132,6 +132,8 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
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

