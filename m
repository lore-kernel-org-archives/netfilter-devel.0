Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2C1AB6EC
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344612; cv=none; b=LCN5EG69lC04On1ghYC618NoCbCjm5DppiA/t6iC+wzoADfN0drfyx4OM5aiM0VJMmXnnIUaUajY71tEQ0lW2KCM1BVKfKeksP9o6IwupnOpDRPfp/Mo8sKB3flYc79hNs/eYwo9KloYCqaBQBOsTzyD51yZDRi3+XZddl1UsIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344612; c=relaxed/simple;
	bh=3LqEFieiRUc2+prp3guxuw/Lv8z22/2G2jI2eQ7yy5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcZaqXK7+uS1uqeMMqMblkBXYDbahFNghbeTHB/Svc81m4NvsjwWSv+j91wooNSDlPFDE5PY9hlrHPEUhn0Mv/yPRFP14CRzvSUmlAXgryFwmXU0AgOZvnS8h/gL5YpWIf3xjEAPRX9YSBVZCgtvA+sPpdmjFnfaOTK9U7DAOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RwxBDOPT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RwxBDOPT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hmBGcHfQGUQXmLHlOrfWLyqbVjiz+Yht6vacvZ87lrg=; b=RwxBDOPTBL/OLQyEQPQ2FVu6HB
	AhWVGiLQAPPsuIfVh4h8F271XjSwOJ+P1AGnsqsNaB15lGSCIfBPMkhp+B6Z4m/9ClPYbc4yq/WNL
	9iA/iUQd2ldggnGdDOKXh616cehMkWMSIK0hrqPrG5pKilLZ2iE1enTCuHb8+1TxumDZq3WyCxUes
	iXpHfH8liBJZCSFO+unnnePLj1apsR779eHR5F+DJqLyJPvMX/Q7U6oIzXP3PTdjBu39f7n4/xv2u
	pnXbGwqGSan//DBk5senfXT5OqLxZg91zLmfxpxfBvm+lWav/hKKVsvcAvdYyap0Lh4v0fdhHnRJM
	YRy7ZGpA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEt-000000006F2-149A;
	Thu, 26 Sep 2024 11:56:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 17/18] netfilter: nf_tables: Add notications for hook changes
Date: Thu, 26 Sep 2024 11:56:42 +0200
Message-ID: <20240926095643.8801-18-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
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
- Describe new attributes in top comment
---
 include/net/netfilter/nf_tables.h        |  5 ++
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++
 net/netfilter/nf_tables_api.c            | 59 ++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c         |  2 +
 4 files changed, 76 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index eaf2f5184bdf..884ecf030323 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1133,6 +1133,11 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
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
index 9e9079321380..cb92375b77b0 100644
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
 
@@ -1768,10 +1770,18 @@ enum nft_synproxy_attributes {
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
index d5ce3ddeee26..15a8b7eee3ff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9316,6 +9316,64 @@ struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 
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
@@ -9363,6 +9421,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_flowtable_device_notify(flowtable, hook, dev, event);
 	}
 	return 0;
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 6a69f73126eb..7ca079a26e0f 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -362,6 +362,8 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_chain_device_notify(&basechain->chain,
+					      hook, dev, event);
 	}
 	return 0;
 }
-- 
2.43.0

