Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CCC1A5B96
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731901; cv=none; b=rpAThoKve8L4mAvGR/wa4fLev5b3kNhcaeE0v0XGDVAbjAooCYHaoTygI6X3NPLguuKJV2stIW7QBVyUKZvtlPtrdKGPBTWNIYe8wmlGv8zl0cpXHQGC6MlcDQ6SocVRWaGmMvucFdaMAWepVOnFjgLxnyYrcUYdp2IYULGa+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731901; c=relaxed/simple;
	bh=7c4OD5+pIebKG9l5eA1Y40xnWCQKLrzKiavLx+lwXos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz+6Z7+vbSrjgqcJsCKemXs9/w395CNMA2uINVUXEF54mMoDPywkNOmDNM9ap5kittEDhpzHN130bp1H1AQsvmXCJGGka3m0WgIgEarkct+1WKey5b+VGtVZRlxXZ4Ruf51RPxnloULlaXQBHl87jOffRat8OXN5czfUbPnSP08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dQHbRJin; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dQHbRJin"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7jqzKgk108zEnAn6ULT6M4HsxlQhfy/lu/Dt9lE6src=; b=dQHbRJinwUn9nax+DXLIQVrhT6
	dNCG+ncKQMRz1OY2vRik44IlMYUp1e8QYFaYauO7e0ETbsc+EWIJ/Ywza+RYp2/sVZbg8ngyshaAq
	y2MXRkHV6HHcWy+ihDE0pkBdxLeKAM6y8zIbNzzpiDYxRWOlpLI4TwV9VKxLYwKbxBfA8pnMfjxFG
	GhXnls8KCHbIgIf4ANxZGCtkJHnENkZzQFrMwoi2E8gZrQ4gSzJM5llmhPD9BYab4j1h7yTtnKgqC
	aM94K/pVWQKbWS5G9RLGBp9XYLt8l5WCcYie1ZH6TRJ5MJv5Zs9zY/MHqUcDVftAOanOpTueISsNO
	Hshb7plw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iSw-000000004yE-3vSp;
	Tue, 15 Apr 2025 17:44:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 11/12] netfilter: nf_tables: Add notications for hook changes
Date: Tue, 15 Apr 2025 17:44:39 +0200
Message-ID: <20250415154440.22371-12-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Notify user space if netdev hooks are updated due to netdev add/remove
events. Send minimal notification messages by introducing
NFT_MSG_NEWDEV/DELDEV message types describing a single device only.

Upon NETDEV_CHANGENAME, the callback has no information about the
interface's old name. To provide a clear message to user space, include
the hook's stored interface name in the notification.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v4:
- Introduce NFTA_DEVICE_SPEC to contain the hook's stored ifname
---
 include/net/netfilter/nf_tables.h        |  5 ++
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++
 net/netfilter/nf_tables_api.c            | 59 ++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c         |  2 +
 4 files changed, 76 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5e49619ae49c..e4d8e451e935 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1142,6 +1142,11 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
+struct nft_hook;
+void nf_tables_chain_device_notify(const struct nft_chain *chain,
+				   const struct nft_hook *hook,
+				   const struct net_device *dev, int event);
+
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
 	NFT_CHAIN_T_ROUTE,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 49c944e78463..80d5f23263c3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -142,6 +142,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_GETSETELEM_RESET,
+	NFT_MSG_NEWDEV,
+	NFT_MSG_DELDEV,
 	NFT_MSG_MAX,
 };
 
@@ -1780,10 +1782,18 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_TABLE: table containing the flowtable or chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_FLOWTABLE: flowtable hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_CHAIN: chain hooking into the device (NLA_STRING)
+ * @NFTA_DEVICE_SPEC: hook spec matching the device (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_TABLE,
+	NFTA_DEVICE_FLOWTABLE,
+	NFTA_DEVICE_CHAIN,
+	NFTA_DEVICE_SPEC,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 04712e5363fb..bd86ddf8915b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9662,6 +9662,64 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
+static void
+nf_tables_device_notify(const struct nft_table *table, int attr,
+			const char *name, const struct nft_hook *hook,
+			const struct net_device *dev, int event)
+{
+	struct net *net = dev_net(dev);
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	u16 flags = 0;
+
+	if (!nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
+		return;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		goto err;
+
+	event = event == NETDEV_REGISTER ? NFT_MSG_NEWDEV : NFT_MSG_DELDEV;
+	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
+	nlh = nfnl_msg_put(skb, 0, 0, event, flags, table->family,
+			   NFNETLINK_V0, nft_base_seq(net));
+	if (!nlh)
+		goto err;
+
+	if (nla_put_string(skb, NFTA_DEVICE_TABLE, table->name) ||
+	    nla_put_string(skb, attr, name) ||
+	    nla_put(skb, NFTA_DEVICE_SPEC, hook->ifnamelen, hook->ifname) ||
+	    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
+		goto err;
+
+	nlmsg_end(skb, nlh);
+	nfnetlink_send(skb, net, 0, NFNLGRP_NFTABLES,
+		       nlmsg_report(nlh), GFP_KERNEL);
+	return;
+err:
+	if (skb)
+		kfree_skb(skb);
+	nfnetlink_set_err(net, 0, NFNLGRP_NFTABLES, -ENOBUFS);
+}
+
+void
+nf_tables_chain_device_notify(const struct nft_chain *chain,
+			      const struct nft_hook *hook,
+			      const struct net_device *dev, int event)
+{
+	nf_tables_device_notify(chain->table, NFTA_DEVICE_CHAIN,
+				chain->name, hook, dev, event);
+}
+
+static void
+nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
+				  const struct nft_hook *hook,
+				  const struct net_device *dev, int event)
+{
+	nf_tables_device_notify(ft->table, NFTA_DEVICE_FLOWTABLE,
+				ft->name, hook, dev, event);
+}
+
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			       struct nft_flowtable *flowtable, bool changename)
 {
@@ -9709,6 +9767,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_flowtable_device_notify(flowtable, hook, dev, event);
 		break;
 	}
 	return 0;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 2a0c50f7c65d..e6d965a56a7a 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -363,6 +363,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_chain_device_notify(&basechain->chain,
+					      hook, dev, event);
 	}
 	return 0;
 }
-- 
2.49.0

