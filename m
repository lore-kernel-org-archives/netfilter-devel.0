Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E50C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DC4207ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 14:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEOOiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 10:38:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45292 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728028AbgEOOiF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 10:38:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZbTM-0000lx-W1; Fri, 15 May 2020 16:38:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     jacobraz@chromium.org
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: make conntrack userspace helpers work again
Date:   Fri, 15 May 2020 16:37:55 +0200
Message-Id: <20200515143755.23642-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515143632.GF11406@breakpoint.cc>
References: <20200515143632.GF11406@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

conntrackd has support for userspace-based connection tracking helpers,
to move parsing of control packets to userspace.

It works by registering a userspace helper using 'nfct' tool with the kernel, e.g.

nfct add helper rpc inet udp

Then, you need to set up iptables' rules to assign the new userspace
helper:

iptables -I OUTPUT -t raw -p udp --dport 111 -j CT --helper rpc

or, use nft:
ct helper rpchelper {
    type "rpc" protocol udp;
    l3proto inet
}

udp dport 111 ct helper set "rpchelper"

After rules are in place to assign the helper to the connection,
conntrackd is configured:

Helper {
  Type rpc inet udp {
     QueueNum 1
     QueueLen 1024
     Policy rpc {
         ExpectMax 1
         ExpectTimeout 300
         }
    }
}

Conntrack then tells the kernel to queue packets from the generic
'userspace' conntrack helper to userspace using the given queue number.

Just like with normal 'nfqueue' use, skbs leave the netfilter hook
context.  When userspace (conntrackd) sends back the accept verdict,
the skb gets reinjected into the netfilter machinery.

Problem is that after the helper hook was merged back into the confirm
one, the queueing itself occurs from the confirm hook, i.e. we queue
from the last netfilter callback in the hook-list.

Therefore, on return, the packet bypasses the confirm action and the
connection is never committed to the main conntrack table.

To fix this there are several ways:
1. revert the 'Fixes' commit and have a extra helper hook again.
   Works, but has the drawback of adding another indirect call for
   everyone.

2. Special case this: split the hooks only when userspace helper
   gets added, so queueing occurs at a lower priority again,
   and normal nqueue reinject would eventually call the last hook.

3. Extend the existing nf_queue ct update hook to allow a forced
   confirmation (plus run the seqadj code).

This goes for 3).

Based on an earlier patch from Pablo Neira Ayuso.
Compile tested only, nft_queue.sh test still passes.

Fixes: 827318feb69cb ("netfilter: conntrack: remove helper hook again")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h          |  3 +-
 include/net/netfilter/nf_queue.h   |  3 +-
 include/uapi/linux/netfilter.h     |  3 +-
 net/netfilter/nf_conntrack_core.c  | 67 +++++++++++++++++++++++++-----
 net/netfilter/nf_queue.c           |  7 +++-
 net/netfilter/nfnetlink_cthelper.c |  4 +-
 net/netfilter/nfnetlink_queue.c    | 26 ++++++++----
 7 files changed, 89 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index eb312e7ca36e..727705f71828 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -465,7 +465,8 @@ struct nf_conn;
 enum ip_conntrack_info;
 
 struct nf_ct_hook {
-	int (*update)(struct net *net, struct sk_buff *skb);
+	int (*update)(struct net *net, struct sk_buff *skb,
+		      u16 queue_flags);
 	void (*destroy)(struct nf_conntrack *);
 	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
 			      const struct sk_buff *);
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index e770bba00066..c8ddbdfa54d3 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -13,7 +13,8 @@ struct nf_queue_entry {
 	struct list_head	list;
 	struct sk_buff		*skb;
 	unsigned int		id;
-	unsigned int		hook_index;	/* index in hook_entries->hook[] */
+	u16			hook_index;	/* index in hook_entries->hook[] */
+	u16			queue_flags;	/* extra skb flags passed at NF_QUEUE time */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_device	*physin;
 	struct net_device	*physout;
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index ca9e63d6e0e4..aaca2c2e1b87 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -22,7 +22,8 @@
 #define NF_VERDICT_MASK 0x000000ff
 
 /* extra verdict flags have mask 0x0000ff00 */
-#define NF_VERDICT_FLAG_QUEUE_BYPASS	0x00008000
+#define NF_VERDICT_FLAG_USERSPACE_CT_HELPER	0x00004000
+#define NF_VERDICT_FLAG_QUEUE_BYPASS		0x00008000
 
 /* queue number (NF_QUEUE) or errno (NF_DROP) */
 #define NF_VERDICT_QMASK 0xffff0000
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1d57b95d3481..8480dc821f2e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2016,7 +2016,51 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 	nf_conntrack_get(skb_nfct(nskb));
 }
 
-static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+static unsigned int nf_confirm_cthelper(struct sk_buff *skb, u16 flags)
+{
+	enum ip_conntrack_info ctinfo;
+	u8 pnum __maybe_unused;
+	unsigned int protoff;
+	struct nf_conn *ct;
+
+	if ((flags & NF_VERDICT_FLAG_USERSPACE_CT_HELPER) == 0)
+		return NF_ACCEPT;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return NF_ACCEPT;
+
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		pnum = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+					   &frag_off);
+		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+			return NF_ACCEPT;
+		break;
+#endif
+	default:
+		return NF_ACCEPT;
+	}
+
+	return nf_confirm(skb, protoff, ct, ctinfo);
+}
+
+static int nf_conntrack_update(struct net *net, struct sk_buff *skb, u16 queue_flags)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
@@ -2029,18 +2073,21 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	u8 l4num;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct))
-		return 0;
+	if (!ct)
+		return NF_ACCEPT;
+
+	if (nf_ct_is_confirmed(ct))
+		return nf_confirm_cthelper(skb, queue_flags);
 
 	l3num = nf_ct_l3num(ct);
 
 	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
 	if (dataoff <= 0)
-		return -1;
+		return NF_DROP;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
 			     l4num, net, &tuple))
-		return -1;
+		return NF_DROP;
 
 	if (ct->status & IPS_SRC_NAT) {
 		memcpy(tuple.src.u3.all,
@@ -2060,7 +2107,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 
 	h = nf_conntrack_find_get(net, nf_ct_zone(ct), &tuple);
 	if (!h)
-		return 0;
+		return nf_confirm_cthelper(skb, queue_flags);
 
 	/* Store status bits of the conntrack that is clashing to re-do NAT
 	 * mangling according to what it has been done already to this packet.
@@ -2073,19 +2120,19 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 
 	nat_hook = rcu_dereference(nf_nat_hook);
 	if (!nat_hook)
-		return 0;
+		return nf_confirm_cthelper(skb, queue_flags);
 
 	if (status & IPS_SRC_NAT &&
 	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_SRC,
 				IP_CT_DIR_ORIGINAL) == NF_DROP)
-		return -1;
+		return NF_DROP;
 
 	if (status & IPS_DST_NAT &&
 	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_DST,
 				IP_CT_DIR_ORIGINAL) == NF_DROP)
-		return -1;
+		return NF_DROP;
 
-	return 0;
+	return nf_confirm_cthelper(skb, queue_flags);
 }
 
 static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bbd1209694b8..722846821e10 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -153,7 +153,7 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 }
 
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
-		      unsigned int index, unsigned int queuenum)
+		      u16 index, u16 queue_flags, unsigned int queuenum)
 {
 	struct nf_queue_entry *entry = NULL;
 	const struct nf_queue_handler *qh;
@@ -191,6 +191,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.skb	= skb,
 		.state	= *state,
 		.hook_index = index,
+		.queue_flags = queue_flags,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
@@ -222,7 +223,9 @@ int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 {
 	int ret;
 
-	ret = __nf_queue(skb, state, index, verdict >> NF_VERDICT_QBITS);
+	ret = __nf_queue(skb, state, index,
+			 verdict & NF_VERDICT_FLAG_USERSPACE_CT_HELPER,
+			 verdict >> NF_VERDICT_QBITS);
 	if (ret < 0) {
 		if (ret == -ESRCH &&
 		    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index a5f294aa8e4c..55aa5bacc603 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -60,7 +60,9 @@ nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 		return NF_ACCEPT;
 
 	/* If the user-space helper is not available, don't block traffic. */
-	return NF_QUEUE_NR(helper->queue_num) | NF_VERDICT_FLAG_QUEUE_BYPASS;
+	return NF_QUEUE_NR(helper->queue_num) |
+	       NF_VERDICT_FLAG_QUEUE_BYPASS |
+	       NF_VERDICT_FLAG_USERSPACE_CT_HELPER;
 }
 
 static const struct nla_policy nfnl_cthelper_tuple_pol[NFCTH_TUPLE_MAX+1] = {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3243a31f6e82..ddb4a32f6ba5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -223,22 +223,32 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 	return entry;
 }
 
+static bool nfqnl_skb_needs_ct_update(struct sk_buff *skb)
+{
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
+	return ct && !nf_ct_is_confirmed(ct);
+}
+
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	struct nf_ct_hook *ct_hook;
-	int err;
 
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
-		rcu_read_lock();
+		bool nf_ct_helper = false;
+
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook) {
-			err = ct_hook->update(entry->state.net, entry->skb);
-			if (err < 0)
-				verdict = NF_DROP;
-		}
-		rcu_read_unlock();
+		if (!ct_hook)
+			return nf_reinject(entry, verdict);
+
+		nf_ct_helper = entry->queue_flags & NF_VERDICT_FLAG_USERSPACE_CT_HELPER;
+
+		if (nfqnl_skb_needs_ct_update(entry->skb) || nf_ct_helper)
+			verdict = ct_hook->update(entry->state.net, entry->skb,
+						  entry->queue_flags);
 	}
 	nf_reinject(entry, verdict);
 }
-- 
2.26.2

