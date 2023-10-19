Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C244DCDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 20:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjJSUZT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 16:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjJSUZT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 16:25:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C37116
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:25:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qtZZy-0002P1-Kl; Thu, 19 Oct 2023 22:25:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp offload
Date:   Thu, 19 Oct 2023 22:25:04 +0200
Message-ID: <20231019202507.16439-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds a small internal mapping table so that a new bpf (xdp) kfunc
can perform lookups in a flowtable.

I have no intent to push this without nft integration of the xdp program,
this RFC is just to get comments on the general direction because there
is a chicken/egg issue:

As-is, xdp program has access to the device pointer, but no way to do a
lookup in a flowtable -- there is no way to obtain the needed struct
without whacky stunts.

This would allow to such lookup just from device address: the bpf
kfunc would call nf_flowtable_by_dev() internally.

Limitation:

A device cannot be added to multiple flowtables, the mapping needs
to be unique.

As for integration with the kernel, there are several options:

1. Auto-add to the dev-xdp table whenever HW offload is requested.

2. Add to the dev-xdp table, but only if the HW offload request fails.
   (softfallback).

3. add a dedicated 'xdp offload' flag to UAPI.

3) should not be needed, because userspace already controls this:
   to make it work userspace needs to attach the xdp program to the
   network device in the first place.

My thinking is to add a xdp-offload flag to the nft grammer only.
Its not needed on nf uapi side and it would tell nft to attach the xdp
flowtable forward program to the devices listed in the flowtable.

Also, packet flow is altered (qdiscs is bypassed), which is a strong
argument against default-usage.

The xdp prog source would be included with nftables.git and nft
would either attach/detach them or ship an extra prog that does this (TBD).

Open questions:

Do we need to support dev-in-multiple flowtables?  I would like to
avoid this, this likely means the future "xdp" flag in nftables would
be restricted to "inet" family.  Alternative would be to change the key to
'device address plus protocol family', the xdp prog could derive that from the
packet data.

Timeout handling.  Should the XDP program even bother to refresh the
flowtable timeout?

It might make more sense to intentionally have packets
flow through the normal path periodically so neigh entries are up to date.

Also note that flow_offload_xdp struct likely needs to have a refcount
or genmask so that it integrates with the two-phase commit protocol on
netfilter side
(i.e., we should allow 're-add' because its needed to make flush+reload
 work).

Not SoB, too raw for my taste.

CC: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 131 +++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a010b25076ca..10313d296a8a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -17,6 +17,92 @@ static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
 
+struct flow_offload_xdp {
+	struct hlist_node hnode;
+
+	unsigned long net_device_addr;
+	struct nf_flowtable *ft;
+
+	struct rcu_head	rcuhead;
+};
+
+#define NF_XDP_HT_BITS	4
+static DEFINE_HASHTABLE(nf_xdp_hashtable, NF_XDP_HT_BITS);
+static DEFINE_MUTEX(nf_xdp_hashtable_lock);
+
+/* caller must hold rcu read lock */
+struct nf_flowtable *nf_flowtable_by_dev(const struct net_device *dev)
+{
+	unsigned long key = (unsigned long)dev;
+	const struct flow_offload_xdp *cur;
+
+	hash_for_each_possible_rcu(nf_xdp_hashtable, cur, hnode, key) {
+		if (key == cur->net_device_addr)
+			return cur->ft;
+	}
+
+	return NULL;
+}
+
+static int nf_flowtable_by_dev_insert(struct nf_flowtable *ft,
+				      const struct net_device *dev)
+{
+	unsigned long key = (unsigned long)dev;
+	struct flow_offload_xdp *cur;
+	int err = 0;
+
+	mutex_lock(&nf_xdp_hashtable_lock);
+	hash_for_each_possible(nf_xdp_hashtable, cur, hnode, key) {
+		if (key != cur->net_device_addr)
+			continue;
+		err = -EEXIST;
+		break;
+	}
+
+	if (err == 0) {
+		struct flow_offload_xdp *new;
+
+		new = kzalloc(sizeof(*new), GFP_KERNEL);
+		if (new) {
+			new->net_device_addr = key;
+			new->ft = ft;
+
+			hash_add_rcu(nf_xdp_hashtable, &new->hnode, key);
+		} else {
+			err = -ENOMEM;
+		}
+	}
+
+	mutex_unlock(&nf_xdp_hashtable_lock);
+
+	DEBUG_NET_WARN_ON_ONCE(err == 0 && nf_flowtable_by_dev(dev) != ft);
+
+	return err;
+}
+
+static void nf_flowtable_by_dev_remove(const struct net_device *dev)
+{
+	unsigned long key = (unsigned long)dev;
+	struct flow_offload_xdp *cur;
+	bool found = false;
+
+	mutex_lock(&nf_xdp_hashtable_lock);
+
+	hash_for_each_possible(nf_xdp_hashtable, cur, hnode, key) {
+		if (key != cur->net_device_addr)
+			continue;
+
+		hash_del_rcu(&cur->hnode);
+		kfree_rcu(cur, rcuhead);
+		found = true;
+		break;
+	}
+
+	mutex_unlock(&nf_xdp_hashtable_lock);
+
+	WARN_ON_ONCE(!found);
+}
+
 struct flow_offload_work {
 	struct list_head	list;
 	enum flow_cls_command	cmd;
@@ -1183,6 +1269,38 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 	return 0;
 }
 
+static int nf_flow_offload_xdp_setup(struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd)
+{
+	switch (cmd) {
+	case FLOW_BLOCK_BIND:
+		return nf_flowtable_by_dev_insert(flowtable, dev);
+	case FLOW_BLOCK_UNBIND:
+		nf_flowtable_by_dev_remove(dev);
+		return 0;
+	}
+
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
+static void nf_flow_offload_xdp_cancel(struct nf_flowtable *flowtable,
+				       struct net_device *dev,
+				       enum flow_block_command cmd)
+{
+	switch (cmd) {
+	case FLOW_BLOCK_BIND:
+		nf_flowtable_by_dev_remove(dev);
+		return;
+	case FLOW_BLOCK_UNBIND:
+		/* We do not re-bind in case hw offload would report error
+		 * on *unregister*.
+		 */
+		break;
+	}
+}
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd)
@@ -1191,6 +1309,15 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo;
 	int err;
 
+	/* XXX:
+	 *
+	 * XDP offload could be made 'never fails', as xdp
+	 * frames that don't match are simply passed up to
+	 * normal nf hooks (skb sw flowtable), or to stack.
+	 */
+	if (nf_flow_offload_xdp_setup(flowtable, dev, cmd))
+		return -EBUSY;
+
 	if (!nf_flowtable_hw_offload(flowtable))
 		return 0;
 
@@ -1200,8 +1327,10 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	else
 		err = nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
 						     &extack);
-	if (err < 0)
+	if (err < 0) {
+		nf_flow_offload_xdp_cancel(flowtable, dev, cmd);
 		return err;
+	}
 
 	return nf_flow_table_block_setup(flowtable, &bo, cmd);
 }
-- 
2.41.0

