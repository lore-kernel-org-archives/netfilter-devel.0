From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH -next] netfilter: nfqueue: add ability to dump list of supported attributes
Date: Tue,  4 Jun 2013 17:37:53 +0200
Message-ID: <1370360273-20633-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36643 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813Ab3FDPfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:35:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allows userspace to dump the list of known (extended) attributes.
For SKB_INFO, we set all the info flag bits supported by the running kernel.

The latter is required because absence of some bits in the info attribute will
either mean "skb did not have the property" OR "this kernel doesn't know about
this flag".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Recent discussion of the
 "netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag" patch
 (http://patchwork.ozlabs.org/patch/246460/) shows that we'll need
 to tell userspace the supported info bits in the NFAQ_SKB_INFO attribute.

 While we could add another NFAQ_SKB_INFO_FLAGS attribute, that seems
 insane since the value will never change (unless kernel update).

 Adding feature flags also seems to be wrong (API abuse, plus we'd
 waste a new feature flag for every new SKB_INFO bit).

 On startup, userspace would bind the queue, and then send
 NFQNL_MSG_ATTRIBUTES request to kernel.

 In the reply, the known extended attrs will be set, i.e:

if (attr[NFQA_SKB_INFO]) {
  uint32_t skbinfo = ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO]));
  if (skbinfo & NFQA_SKB_CSUMNOTVERIFIED) /* kernel support checksum hints */

After this, userspace can process queued packets and interpret absence of flags
correctly.

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index a2308ae..efb02ae 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -9,6 +9,7 @@ enum nfqnl_msg_types {
 	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
 	NFQNL_MSG_CONFIG,		/* connect to a particular queue */
 	NFQNL_MSG_VERDICT_BATCH,	/* batchv from userspace to kernel */
+	NFQNL_MSG_ATTRIBUTES,		/* list of supported attributes */
 
 	NFQNL_MSG_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 3880899..f16ef3a 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -997,6 +997,56 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 }
 
 static int
+__nfqnl_dump_attrs(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nlmsghdr *nlh;
+	int i;
+	uint32_t value;
+
+	if (cb->args[0] >= __NFQA_MAX)
+		return 0;
+
+	if (cb->args[0] == 0)
+		cb->args[0] = NFQA_CT;
+
+	nlh = nlmsg_put(skb, 0, 0,
+		NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_ATTRIBUTES,
+		sizeof(struct nfgenmsg), 0);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	for (i = cb->args[0]; i < __NFQA_MAX; i++) {
+		switch (i) {
+		case NFQA_SKB_INFO:
+			value = NFQA_SKB_GSO | NFQA_SKB_CSUMNOTREADY;
+			break;
+		default:
+			value = 0;
+			break;
+		}
+		if (nla_put_u32(skb, i, htonl(value)))
+			break;
+	}
+
+	if (cb->args[0] <= i) {
+		nlmsg_end(skb, nlh);
+		return -EMSGSIZE;
+	}
+	cb->args[0] = i;
+	return nlmsg_end(skb, nlh);
+}
+
+static int nfqnl_dump_attrs(struct sock *ctnl, struct sk_buff *skb,
+			  const struct nlmsghdr *nlh,
+			  const struct nlattr * const attr[])
+{
+	struct netlink_dump_control c = {
+		.dump = __nfqnl_dump_attrs,
+	};
+	return netlink_dump_start(ctnl, skb, nlh, &c);
+}
+
+static int
 nfqnl_recv_unsupp(struct sock *ctnl, struct sk_buff *skb,
 		  const struct nlmsghdr *nlh,
 		  const struct nlattr * const nfqa[])
@@ -1145,6 +1195,7 @@ static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
 	[NFQNL_MSG_VERDICT_BATCH]={ .call_rcu = nfqnl_recv_verdict_batch,
 				    .attr_count = NFQA_MAX,
 				    .policy = nfqa_verdict_batch_policy },
+	[NFQNL_MSG_ATTRIBUTES]   = { .call = nfqnl_dump_attrs, },
 };
 
 static const struct nfnetlink_subsystem nfqnl_subsys = {
-- 
1.7.8.6

