Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D561184542
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863845; cv=none; b=MWITfg08PaBnb+z4mHEYr6v5pEm/8jdcmpAIdpivbi4+hDZuuGnxLZ2NPdmSmp7VrPD/5cMoSPoTskajIKlT0iysdeTzLlbTwDnjDeXGct5GfkMRkesbAElynfYnLn4wQfJhlJ00IXlOlTSvr0n7c/EV8Eqh3AIWfv+rB7HtBug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863845; c=relaxed/simple;
	bh=Ao5JQH2KiDVztcE8Gw73Q1OJODRH/inY/tNLv7epdsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4u7VqoyinCOiHoJjGwjtclaNOXWutfT/27oZk5d/mR29eZRrXELSm2Mn6F8XFiu8kpgc1df7JC6vZ4eJvGbixp9rMZ0+r7aKyW+LzEk/mL2BG0d55j5d3UWe6NoEzqZXiQVUXY4JJ0pLoHT59h9GbmqNuoX2+2XgYEBIF7Bzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=luwNwGRo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="luwNwGRo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CO1fi2rliaRWY1DuStQNXllJU+cgYZ7qaNYpRvmB2Pc=; b=luwNwGRo85mZzhylmA9ESzAQzh
	g1LTUdAG6LZIv61KrrV3dOIEYvxA9ttE0WVKEkbCIquqWF5yf1C2QXPca6qKj3xnBPGNoquP3BCSK
	EORwXJvqw5J1f+WzZwtzFww7a++TOFtfjc850awdPzfJB2vf12HVvZU/Mzj1F4Mxojbx01hhnd6Lx
	b7w8ysLWHgEJ+5mpEX/l16qcoNVmXrDzN6eTu0WG+Fj+NqouFU0zHXxaQgPbDgnK8Ca2NlindWnas
	FpgOPqHm1C5OnbuK++NUdC4jGUEq8l6sDH0p5RcoCb9iecc9SyGZRnuMLoEOmKZHE9ScQArptsUCt
	7RuRKg+w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAa-000000006K2-3ntI;
	Fri, 20 Sep 2024 22:24:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications for hook changes
Date: Fri, 20 Sep 2024 22:23:46 +0200
Message-ID: <20240920202347.28616-16-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240920202347.28616-1-phil@nwl.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
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

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |  2 +
 include/uapi/linux/netfilter/nf_tables.h |  5 +++
 net/netfilter/nf_tables_api.c            | 56 ++++++++++++++++++++++++
 net/netfilter/nft_chain_filter.c         |  1 +
 4 files changed, 64 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index eaf2f5184bdf..f8da38e45277 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1132,6 +1132,8 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
+void nf_tables_chain_device_notify(const struct nft_chain *chain,
+				   const struct net_device *dev, int event);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d6476ca5d7a6..3a874febf1ac 100644
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
 
@@ -1772,6 +1774,9 @@ enum nft_synproxy_attributes {
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_TABLE,
+	NFTA_DEVICE_FLOWTABLE,
+	NFTA_DEVICE_CHAIN,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ba2038ea56d2..463ad196a32e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9316,6 +9316,61 @@ struct nf_hook_ops *nft_hook_find_ops(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops);
 
+static void
+nf_tables_device_notify(const struct nft_table *table, int attr,
+			const char *name, const struct net_device *dev,
+			int event)
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
+			      const struct net_device *dev, int event)
+{
+	nf_tables_device_notify(chain->table, NFTA_DEVICE_CHAIN,
+				chain->name, dev, event);
+}
+
+static void
+nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
+				  const struct net_device *dev, int event)
+{
+	nf_tables_device_notify(ft->table, NFTA_DEVICE_FLOWTABLE,
+				ft->name, dev, event);
+}
+
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			       struct nft_flowtable *flowtable)
 {
@@ -9357,6 +9412,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_flowtable_device_notify(flowtable, dev, event);
 	}
 	return 0;
 }
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index f7290dc20a53..7a35b034d0c6 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -357,6 +357,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
+		nf_tables_chain_device_notify(ctx->chain, dev, event);
 	}
 	return 0;
 }
-- 
2.43.0

