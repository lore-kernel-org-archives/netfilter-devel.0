Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D8BC282E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC3682075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfDORAt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:49 -0400
Received: from mail.us.es ([193.147.175.20]:50470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbfDORAt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BBDA1C4422
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3161BDA70D
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27FB1DA706; Mon, 15 Apr 2019 19:00:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6875DA70F;
        Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BABF74265A5B;
        Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/22] bridge: netfilter: unroll NF_HOOK helper in bridge input path
Date:   Mon, 15 Apr 2019 19:00:26 +0200
Message-Id: <20190415170028.3470-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h |  3 +++
 net/bridge/br_input.c            | 55 +++++++++++++++++++++++++++++++++++++---
 net/netfilter/core.c             |  1 +
 net/netfilter/nf_internals.h     |  3 ---
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
2.11.0

