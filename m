From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 5/5] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Tue, 1 Sep 2015 09:54:19 +0900
Message-ID: <20150901005419.GF2642@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33108 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbIAAyY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:54:24 -0400
Received: by paczk9 with SMTP id zk9so8141210pac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:54:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150901003436.GA2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to include the conntrack information together
with the packet that is sent to user-space via NFLOG, then a
user-space program can acquire NATed information by this NFULA_CT
attribute.

Including the conntrack information is optional, you can set it
via NFULNL_CFG_F_CONNTRACK flag with the NFULA_CFG_FLAGS attribute
like NFQUEUE.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/net/netfilter/nfnetlink_queue.h      |    4 ++--
 include/uapi/linux/netfilter/nfnetlink_log.h |    3 +++
 net/netfilter/Kconfig                        |   12 +++++++-----
 net/netfilter/nfnetlink_log.c                |   18 +++++++++++++++---
 net/netfilter/nfnetlink_queue_ct.c           |    2 +-
 5 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nfnetlink_queue.h b/include/net/netfilter/nfnetlink_queue.h
index f94942b..05315ab 100644
--- a/include/net/netfilter/nfnetlink_queue.h
+++ b/include/net/netfilter/nfnetlink_queue.h
@@ -6,7 +6,7 @@
 struct nf_conn;
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
+struct nf_conn *nfqnl_ct_get(const struct sk_buff *entskb, size_t *size,
 			     enum ip_conntrack_info *ctinfo);
 struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
 			       const struct nlattr *attr,
@@ -20,7 +20,7 @@ int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 			u32 portid, u32 report);
 #else
 inline struct nf_conn *
-nfqnl_ct_get(struct sk_buff *entskb, size_t *size, enum ip_conntrack_info *ctinfo)
+nfqnl_ct_get(const struct sk_buff *entskb, size_t *size, enum ip_conntrack_info *ctinfo)
 {
 	return NULL;
 }
diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 90c2c95..081e7f9 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -51,6 +51,8 @@ enum nfulnl_attr_type {
 	NFULA_HWTYPE,			/* hardware type */
 	NFULA_HWHEADER,			/* hardware header */
 	NFULA_HWLEN,			/* hardware header length */
+	NFULA_CT,			/* nf_conntrack_netlink.h */
+	NFULA_CT_INFO,			/* enum ip_conntrack_info */
 
 	__NFULA_MAX
 };
@@ -93,5 +95,6 @@ enum nfulnl_attr_config {
 
 #define NFULNL_CFG_F_SEQ	0x0001
 #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
+#define NFULNL_CFG_F_CONNTRACK	0x0004
 
 #endif /* _NFNETLINK_LOG_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3e1b4ab..9c91cfa 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -363,12 +363,14 @@ config NF_CT_NETLINK_HELPER
 	  If unsure, say `N'.
 
 config NETFILTER_NETLINK_QUEUE_CT
-        bool "NFQUEUE integration with Connection Tracking"
-        default n
-        depends on NETFILTER_NETLINK_QUEUE
+	bool "NFQUEUE/NFLOG integration with Connection Tracking"
+	default n
+	depends on NF_CT_NETLINK
+	depends on NETFILTER_NETLINK_QUEUE || NETFILTER_NETLINK_LOG
 	help
-	  If this option is enabled, NFQUEUE can include Connection Tracking
-	  information together with the packet is the enqueued via NFNETLINK.
+	  If this option is enabled, NFQUEUE and NFLOG can include
+	  Connection Tracking information together with the packet is
+	  the enqueued via NFNETLINK.
 
 config NF_NAT
 	tristate
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 4670821..2ec2296 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -37,6 +37,7 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/nfnetlink_log.h>
+#include <net/netfilter/nfnetlink_queue.h>
 
 #include <linux/atomic.h>
 
@@ -401,7 +402,8 @@ __build_packet_message(struct nfnl_log_net *log,
 			unsigned int hooknum,
 			const struct net_device *indev,
 			const struct net_device *outdev,
-			const char *prefix, unsigned int plen)
+			const char *prefix, unsigned int plen,
+			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	struct nfulnl_msg_packet_hdr pmsg;
 	struct nlmsghdr *nlh;
@@ -575,6 +577,11 @@ __build_packet_message(struct nfnl_log_net *log,
 			 htonl(atomic_inc_return(&log->global_seq))))
 		goto nla_put_failure;
 
+	/* conntrack */
+	if (ct && nfqnl_ct_put(inst->skb, ct, NFULA_CT,
+			       ctinfo, NFULA_CT_INFO) < 0)
+		goto nla_put_failure;
+
 	if (data_len) {
 		struct nlattr *nla;
 		int size = nla_attr_size(data_len);
@@ -620,12 +627,15 @@ nfulnl_log_packet(struct net *net,
 		  const struct nf_loginfo *li_user,
 		  const char *prefix)
 {
-	unsigned int size, data_len;
+	size_t size;
+	unsigned int data_len;
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
 	unsigned int plen;
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
+	struct nf_conn *ct = NULL;
+	enum ip_conntrack_info uninitialized_var(ctinfo);
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
@@ -671,6 +681,8 @@ nfulnl_log_packet(struct net *net,
 		size += nla_total_size(sizeof(u_int32_t));
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
 		size += nla_total_size(sizeof(u_int32_t));
+	if (inst->flags & NFULNL_CFG_F_CONNTRACK)
+		ct = nfqnl_ct_get(skb, &size, &ctinfo);
 
 	qthreshold = inst->qthreshold;
 	/* per-rule qthreshold overrides per-instance */
@@ -715,7 +727,7 @@ nfulnl_log_packet(struct net *net,
 	inst->qlen++;
 
 	__build_packet_message(log, inst, skb, data_len, pf,
-				hooknum, in, out, prefix, plen);
+				hooknum, in, out, prefix, plen, ct, ctinfo);
 
 	if (inst->qlen >= qthreshold)
 		__nfulnl_flush(inst);
diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
index 299b5a8..02d0dfd 100644
--- a/net/netfilter/nfnetlink_queue_ct.c
+++ b/net/netfilter/nfnetlink_queue_ct.c
@@ -16,7 +16,7 @@
 
 struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
 
-struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
+struct nf_conn *nfqnl_ct_get(const struct sk_buff *entskb, size_t *size,
 			     enum ip_conntrack_info *ctinfo)
 {
 	struct nfq_ct_hook *nfq_ct;
-- 
1.7.10.4

