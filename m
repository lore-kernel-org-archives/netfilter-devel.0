Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA470C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DC3206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfDKOju (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:39:50 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36474 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfDKOjq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 10:39:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hEarg-0001tP-7s; Thu, 11 Apr 2019 16:39:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/4] bridge: netfilter: unroll NF_HOOK helper in bridge input path
Date:   Thu, 11 Apr 2019 16:36:41 +0200
Message-Id: <20190411143642.1087-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
References: <20190411143642.1087-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace NF_HOOK() based invocation of the netfilter hooks with a private
copy of nf_hook_slow().

This copy has one difference: it can return the rx handler value expected
by the stack, i.e. RX_HANDLER_CONSUMED or RX_HANDLER_PASS.

This is needed by the next patch to invoke the ebtables
"broute" table via the standard netfilter hooks rather than the custom
"br_should_route_hook" indirection that is used now.

When the skb is to be "brouted", we must return RX_HANDLER_PASS from the
bridge rx input handler, but there is no way to indicate this via
NF_HOOK(), unless perhaps by some hack such as exposing bridge_cb in the
netfilter core or a percpu flag.

  text    data     bss     dec   filename
  3369      56       0    3425   net/bridge/br_input.o.before
  3458      40       0    3498   net/bridge/br_input.o.after

This allows removal of the "br_should_route_hook" in the next patch.

Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h |  3 ++
 net/bridge/br_input.c            | 55 +++++++++++++++++++++++++++++---
 net/netfilter/core.c             |  1 +
 net/netfilter/nf_internals.h     |  3 --
 net/netfilter/nf_queue.c         |  1 +
 5 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index a50a69f5334c..7239105d9d2e 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -119,4 +119,7 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 	return queue;
 }
 
+int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
+	     const struct nf_hook_entries *entries, unsigned int index,
+	     unsigned int verdict);
 #endif /* _NF_QUEUE_H */
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e2f93e5c72da..4ac34fb5f943 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -16,6 +16,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/netfilter_bridge.h>
+#include <net/netfilter/nf_queue.h>
 #include <linux/neighbour.h>
 #include <net/arp.h>
 #include <linux/export.h>
@@ -206,6 +207,55 @@ static int br_handle_local_finish(struct net *net, struct sock *sk, struct sk_bu
 	return 0;
 }
 
+static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
+{
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+	struct nf_hook_entries *e = NULL;
+	struct nf_hook_state state;
+	unsigned int verdict, i;
+	struct net *net;
+	int ret;
+
+	net = dev_net(skb->dev);
+#ifdef HAVE_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
+		goto frame_finish;
+#endif
+
+	e = rcu_dereference(net->nf.hooks_bridge[NF_BR_PRE_ROUTING]);
+	if (!e)
+		goto frame_finish;
+
+	nf_hook_state_init(&state, NF_BR_PRE_ROUTING,
+			   NFPROTO_BRIDGE, skb->dev, NULL, NULL,
+			   net, br_handle_frame_finish);
+
+	for (i = 0; i < e->num_hook_entries; i++) {
+		verdict = nf_hook_entry_hookfn(&e->hooks[i], skb, &state);
+		switch (verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
+			break;
+		case NF_DROP:
+			kfree_skb(skb);
+			return RX_HANDLER_CONSUMED;
+		case NF_QUEUE:
+			ret = nf_queue(skb, &state, e, i, verdict);
+			if (ret == 1)
+				continue;
+			return RX_HANDLER_CONSUMED;
+		default: /* STOLEN */
+			return RX_HANDLER_CONSUMED;
+		}
+	}
+frame_finish:
+	net = dev_net(skb->dev);
+	br_handle_frame_finish(net, NULL, skb);
+#else
+	br_handle_frame_finish(dev_net(skb->dev), NULL, skb);
+#endif
+	return RX_HANDLER_CONSUMED;
+}
+
 /*
  * Return NULL if skb is handled
  * note: already called with rcu_read_lock
@@ -304,10 +354,7 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		if (ether_addr_equal(p->br->dev->dev_addr, dest))
 			skb->pkt_type = PACKET_HOST;
 
-		NF_HOOK(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING,
-			dev_net(skb->dev), NULL, skb, skb->dev, NULL,
-			br_handle_frame_finish);
-		break;
+		return nf_hook_bridge_pre(skb, pskb);
 	default:
 drop:
 		kfree_skb(skb);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 93aaec3a54ec..71f06900473e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
 #include <net/net_namespace.h>
+#include <net/netfilter/nf_queue.h>
 #include <net/sock.h>
 
 #include "nf_internals.h"
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index e15779fd58e3..d6c43902ebd7 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -7,9 +7,6 @@
 #include <linux/netdevice.h>
 
 /* nf_queue.c */
-int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     const struct nf_hook_entries *entries, unsigned int index,
-	     unsigned int verdict);
 void nf_queue_nf_hook_drop(struct net *net);
 
 /* nf_log.c */
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a36a77bae1d6..9dc1d6e04946 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -240,6 +240,7 @@ int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nf_queue);
 
 static unsigned int nf_iterate(struct sk_buff *skb,
 			       struct nf_hook_state *state,
-- 
2.21.0

