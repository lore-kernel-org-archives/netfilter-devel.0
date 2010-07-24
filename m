From: Karl Hiramoto <karl@hiramoto.org>
Subject: [RFC 4/4] nfnetlink_queue: allow part of a connection to bypass the queue
Date: Sat, 24 Jul 2010 17:44:45 +0200
Message-ID: <1279986285-11665-5-git-send-email-karl@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Cc: Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:53379 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0GXPqN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:46:13 -0400
Received: from homiemail-a30.g.dreamhost.com (caiajhbdcbbj.dreamhost.com [208.97.132.119])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 0F29D17C78B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 08:46:13 -0700 (PDT)
In-Reply-To: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If userspace knows that we want to ACCEPT X bytes of the connection,
allow nfnetlink_queue to accept the packets without queuing to userspace.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 include/linux/netfilter/nfnetlink_queue.h |    1 +
 net/netfilter/nfnetlink_queue.c           |  112 ++++++++++++++++++++++++++++-
 2 files changed, 112 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 2455fe5..f3dd99b 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -41,6 +41,7 @@ enum nfqnl_attr_type {
 	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
+	NFQA_ACCEPT_CONNBYTES, /* Accept the next N bytes, bypassing queue  */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 12e1ab3..b5f20c8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -30,6 +30,10 @@
 #include <linux/list.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_queue.h>
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+#include <net/netfilter/nf_conntrack_queue.h>
+#include <linux/tcp.h>
+#endif
 
 #include <asm/atomic.h>
 
@@ -385,6 +389,67 @@ nla_put_failure:
 	return NULL;
 }
 
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+static struct tcphdr *__get_tcp_hdr(const struct sk_buff *skb, uint8_t prot)
+{
+	if (prot == PF_INET)
+		return (struct tcphdr *)(skb->data + (ip_hdr(skb)->ihl * 4));
+	else if (prot == PF_INET6)
+		return (struct tcphdr *)(skb->data + 40);
+	else
+		BUG();
+
+	return NULL;
+}
+
+static int check_entry_reinject(struct nf_queue_entry *entry)
+{
+	struct nf_conn *ct;
+	struct nf_conntrack_queue *ct_queue;
+	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
+	const struct tcphdr *tcphdr;
+	ct = nf_ct_get(entry->skb, &ctinfo);
+
+	if (!ct || !nf_ct_is_confirmed(ct))
+		return -ENOENT;
+
+	ct_queue = nf_ct_ext_find(ct, NF_CT_EXT_QUEUE);
+	if (!ct_queue)
+		return -ENOENT;
+
+	spin_lock_bh(&ct_queue->lock);
+	pr_debug("%s:%d has ctinfo=%u\n", __func__, __LINE__, ctinfo);
+	dir = CTINFO2DIR(ctinfo);
+	if (ct_queue->dir[dir].connbytes) {
+		if (nf_ct_protonum(ct) == IPPROTO_TCP) {
+			tcphdr = __get_tcp_hdr(entry->skb, nf_ct_l3num(ct));
+
+			if (ntohl(tcphdr->seq) < ct_queue->dir[dir].tcp_seq)
+				goto reinject;
+			else
+				ct_queue->dir[dir].tcp_seq = 0; /* clear */
+		} else {
+			/* other proto */
+			if (ct_queue->dir[dir].connbytes < entry->skb->len) {
+				ct_queue->dir[dir].connbytes -= entry->skb->len;
+				goto reinject;
+			} else
+				ct_queue->dir[dir].connbytes = 0; /* clear */
+		}
+	}
+	spin_unlock_bh(&ct_queue->lock);
+
+
+	return -ENOENT;
+
+reinject:
+	spin_unlock_bh(&ct_queue->lock);
+	nf_reinject(entry, NF_ACCEPT);
+	return 0;
+}
+#endif
+
 static int
 nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
@@ -400,6 +465,11 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	if (queue->copy_mode == NFQNL_COPY_NONE)
 		goto err_out;
 
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+	if (!check_entry_reinject(entry))
+		return 0; /* bypass without enqueueing packet */
+#endif
+
 	nskb = nfqnl_build_packet_message(queue, entry);
 	if (nskb == NULL)
 		goto err_out;
@@ -604,6 +674,40 @@ static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
 	[NFQA_PAYLOAD]		= { .type = NLA_UNSPEC },
 };
 
+
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+static int recv_connbytes(u32 connbytes, struct nfqnl_instance *queue,
+	struct nf_queue_entry *entry)
+{
+	struct nf_conn *ct;
+	struct nf_conntrack_queue *ct_queue;
+	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_dir dir;
+	const struct tcphdr *tcphdr;
+
+	ct = nf_ct_get(entry->skb, &ctinfo);
+	if (!ct) {
+		pr_err("nf_queue: no conntrack info\n");
+		return -ENOENT;
+	}
+
+	dir = CTINFO2DIR(ctinfo);
+	ct_queue = nf_ct_ext_find(ct, NF_CT_EXT_QUEUE);
+	if (!ct_queue) {
+		pr_err("nf_queue: no conntrack queue ext\n");
+		return -ENOENT;
+	}
+
+	if (nf_ct_protonum(ct) == IPPROTO_TCP) {
+		tcphdr = __get_tcp_hdr(entry->skb, nf_ct_l3num(ct));
+		ct_queue->dir[dir].tcp_seq = connbytes;
+	} else
+		ct_queue->dir[dir].connbytes = connbytes;
+
+	return 0;
+}
+#endif
+
 static int
 nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		   const struct nlmsghdr *nlh,
@@ -611,7 +715,6 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
-
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	struct nfqnl_instance *queue;
 	unsigned int verdict;
@@ -659,6 +762,13 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	if (nfqa[NFQA_MARK])
 		entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
 
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+	if (nfqa[NFQA_ACCEPT_CONNBYTES])
+		recv_connbytes(
+			ntohl(nla_get_be32(nfqa[NFQA_ACCEPT_CONNBYTES])),
+			queue, entry);
+#endif
+
 	nf_reinject(entry, verdict);
 	return 0;
 
-- 
1.7.1

