Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB8A4EB33
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951185; cv=none; b=shqFV4Q99AvtTyWz5DHQn1jfj99bAFTI4xZpsZCFlC6VHu1Mh75t5EkIK8Bo8LEV12XCNKAcrQLEqCEB8H68EYxkouOu5VwgGev9U6DpXfyJKsnnUbiAxQvpOf4nPfoSf3ekoUZNuuTwIO/Y5Irmn2GMdJZNkJ5/9ZRC+jg9pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951185; c=relaxed/simple;
	bh=PsZ1poWL3FemuF33AQ/o24kDzZehAnk4m2hq4HOgokw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQJLHCUfCF7fsMmea+auLh/ej6YvcHQZo4WCi5FAyYdT1XqbX3XUHxPELZ5bkzr6ELtEi63wlJ+QTaX0XTF2EdKK91BxBzLeVhW2qxJlIeSAhS/O7JefL8EJScGpAofMNEfDP/+CGRzh4pmG5dMXnDCQfhviIyvEOgIBIeUscIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gt7cwDL3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gt7cwDL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6qK7NHtNWEp4CvqrUxOKNhI4ZP6CAYLktc4qhupXF5Y=; b=gt7cwDL3rK0PNk7QOSG3ctYL95
	V2/GLqrGi2s1cyL5kOyyiZSt2lc0M9CL6FANrp57oJLiEZSB0ybO1g7qDHVJXzel2g47lJFcQvG5c
	EV6DR9OB/ZvE/flTX4f1DuTfHp6KCyAASGuag11cBdUFI2tCn23eOgCgIce0HGngk5zgpCJHR0Zle
	ghZuXYSP02yummvXm8pA3XCiDBtcQpggTanK2juUTjDK8KmPDtRZjIdZN0rhR27AjDQEIvb5N/FAr
	0c9ZCEGeS7H7ck4g/EWQWCDx8fpckZGfKeOuiO7+MEVRBWtHYT8Glhw+K8JragVCxfhQCRHepUc3I
	WQY1TzKg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHs-000000001dB-3Rcw;
	Fri, 17 May 2024 15:06:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 6/7] netfilter: nf_tables: Add notications for hook changes
Date: Fri, 17 May 2024 15:06:14 +0200
Message-ID: <20240517130615.19979-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517130615.19979-1-phil@nwl.cc>
References: <20240517130615.19979-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If netdev hooks are updated due to netdev add/remove events, notify user
space via the usual netlink notification mechanism.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 21 +++++++++++++++++----
 net/netfilter/nft_chain_filter.c  | 16 +++++++++++++---
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9cbef71f0462..bfa6cb7b2fd7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -223,6 +223,8 @@ struct nft_ctx {
 	bool				report;
 };
 
+void nft_commit_notify(struct net *net, u32 portid);
+
 enum nft_data_desc_flags {
 	NFT_DATA_DESC_SETELEM	= (1 << 0),
 };
@@ -1123,6 +1125,8 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
+void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
+			    const struct list_head *hook_list);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b3a5a2878459..39202166c2a2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1903,8 +1903,8 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
-				   const struct list_head *hook_list)
+void nf_tables_chain_notify(const struct nft_ctx *ctx, int event,
+			    const struct list_head *hook_list)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
@@ -9246,6 +9246,7 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
 	struct net *net;
+	int rc = 0;
 
 	if (event == NETDEV_CHANGENAME) {
 		nf_tables_flowtable_event(this, NETDEV_UNREGISTER, ptr);
@@ -9260,11 +9261,23 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(flowtable, &table->flowtables, list) {
-			if (nft_flowtable_event(event, dev, flowtable))
+			rc = nft_flowtable_event(event, dev, flowtable);
+			if (rc)
 				goto out_unlock;
 		}
 	}
 out_unlock:
+	if (rc == 1) {
+		struct nft_ctx ctx = {
+			.net = net,
+			.family = flowtable->table->family
+		};
+
+		nf_tables_flowtable_notify(&ctx, flowtable,
+					   &flowtable->hook_list,
+					   NFT_MSG_NEWFLOWTABLE);
+		nft_commit_notify(ctx.net, ctx.portid);
+	}
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
@@ -10148,7 +10161,7 @@ static void nf_tables_commit_release(struct net *net)
 	mutex_unlock(&nft_net->commit_mutex);
 }
 
-static void nft_commit_notify(struct net *net, u32 portid)
+void nft_commit_notify(struct net *net, u32 portid)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *batch_skb = NULL, *nskb, *skb;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index cc0cf47503f4..f6bea21dab16 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -342,6 +342,7 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
+	bool notify = false;
 
 	if (event != NETDEV_UNREGISTER &&
 	    event != NETDEV_REGISTER)
@@ -350,21 +351,29 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		switch (event) {
 		case NETDEV_UNREGISTER:
-			if (hook->ops.dev == dev)
+			if (hook->ops.dev == dev) {
 				nft_netdev_hook_dev_update(hook, NULL);
+				notify = true;
+			}
 			break;
 		case NETDEV_REGISTER:
 			if (hook->ops.dev ||
 			    strncmp(hook->ifname, dev->name, hook->ifnamelen))
 				break;
-			if (!nft_netdev_hook_dev_update(hook, dev))
-				return;
+			if (!nft_netdev_hook_dev_update(hook, dev)) {
+				notify = true;
+				goto out_notify;
+			}
 
 			printk(KERN_ERR "chain %s: Can't hook into device %s\n",
 			       ctx->chain->name, dev->name);
 			break;
 		}
 	}
+out_notify:
+	if (notify)
+		nf_tables_chain_notify(ctx, NFT_MSG_NEWCHAIN,
+				       &basechain->hook_list);
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
@@ -409,6 +418,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			nft_netdev_event(event, dev, &ctx);
 		}
 	}
+	nft_commit_notify(ctx.net, ctx.portid);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return NOTIFY_DONE;
-- 
2.43.0

