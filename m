Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110B6C61D94
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbjKUM2y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjKUM2y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97D7110;
        Tue, 21 Nov 2023 04:28:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Ps1-0005DD-CW; Tue, 21 Nov 2023 13:28:49 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/8] netfilter: nf_tables: add flowtable map for xdp offload
Date:   Tue, 21 Nov 2023 13:27:50 +0100
Message-ID: <20231121122800.13521-8-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds a small internal mapping table so that a new bpf (xdp) kfunc
can perform lookups in a flowtable.

As-is, xdp program has access to the device pointer, but no way to do a
lookup in a flowtable -- there is no way to obtain the needed struct
without questionable stunts.

This allows to obtain an nf_flowtable pointer given a net_device
structure.

A device cannot be added to multiple flowtables, the mapping needs
to be unique.  This is enforced when a flowtables with the
NF_FLOWTABLE_XDP_OFFLOAD was added.

Exposure of this NF_FLOWTABLE_XDP_OFFLOAD in UAPI could be avoided,
iff the 'net_device maps to 0 or 1 flowtable' paradigm is enforced
regardless of offload-or-not flag.

HOWEVER, that does break existing behaviour.

An alternative would be to repurpose the hw offload flag by allowing
XDP fallback when hw offload cannot be done due to lack of ndo
callbacks.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h |   7 ++
 net/netfilter/nf_flow_table_offload.c | 131 +++++++++++++++++++++++++-
 net/netfilter/nf_tables_api.c         |   3 +-
 3 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 11985d9b8370..b8b7fcb98732 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -93,6 +93,11 @@ static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
 	return flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD;
 }
 
+static inline bool nf_flowtable_xdp_offload(struct nf_flowtable *flowtable)
+{
+	return flowtable->flags & NF_FLOWTABLE_XDP_OFFLOAD;
+}
+
 enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_ORIGINAL = IP_CT_DIR_ORIGINAL,
 	FLOW_OFFLOAD_DIR_REPLY = IP_CT_DIR_REPLY,
@@ -299,6 +304,8 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
+struct nf_flowtable *nf_flowtable_by_dev(const struct net_device *dev);
+
 unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a010b25076ca..9ec7aa4ad2e5 100644
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
+		new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
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
@@ -1183,6 +1269,44 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 	return 0;
 }
 
+static int nf_flow_offload_xdp_setup(struct nf_flowtable *flowtable,
+				     struct net_device *dev,
+				     enum flow_block_command cmd)
+{
+	if (!nf_flowtable_xdp_offload(flowtable))
+		return 0;
+
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
+	if (!nf_flowtable_xdp_offload(flowtable))
+		return;
+
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
@@ -1191,6 +1315,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	struct flow_block_offload bo;
 	int err;
 
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4e21311ec768..223ca4d0e2a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8198,7 +8198,8 @@ static bool nft_flowtable_offload_clash(struct net *net,
 	const struct nft_table *table;
 
 	/* No offload requested, no need to validate */
-	if (!nf_flowtable_hw_offload(flowtable->ft))
+	if (!nf_flowtable_hw_offload(flowtable->ft) &&
+	    !nf_flowtable_xdp_offload(flowtable->ft))
 		return false;
 
 	nft_net = nft_pernet(net);
-- 
2.41.0

