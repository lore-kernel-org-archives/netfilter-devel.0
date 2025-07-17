Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8F5292B41;
	Thu, 17 Jul 2025 09:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745905; cv=none; b=RNwGzI6OrNzv6+ywRzFWIvW/f1w8kSvY72rGdMVUvzSE3JXKvECp+eCoUZYQKznR59gsZNz2LlJ9hJIAFdc4tL97AvSzvyTn7Ua/Wvam7cKJSeYDzErozQfsvBJKfy/ba7JQUsqHZ+F/2mk1VxE27JvqBxqXpXfkU8DwEQHh2dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745905; c=relaxed/simple;
	bh=odeUCOpsg0cSjAXQ9doToSjDO8AeWugWpFUoUfMp9F4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LMBLD0CbgNzgGf9vzIN1jIUCjJ31xxTjQDb69kRD14hnA0HRRHogCmIDoY2YLxGaiKznBITkSQagnwUc82kxYLRYdcCqQvsiMN7BSuTe+cf+0hpt4bdnMLExYhIkuWLSLSCltgv5EWyQU6I3njMF9lYIoPGL5dtYjYHsuV8KNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jQWqpziA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bbFrTmUo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jQWqpziA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bbFrTmUo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 465CD602AF; Thu, 17 Jul 2025 11:51:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745901;
	bh=cGndYFXBglsllpMtkSoQ23N5q4zEyEO/TE6Xa9vHUHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQWqpziAuEjgmTy8u8toCD+pFI/3B4j+HBrdI6LgRdcAJ+lKVzh8RG/G+AuqTAaOk
	 E71OVldZHUES6mbLK5CSEfgpYv3Q4cipzrtWZKw24k0z2vl5USVy0xmKdWFcAquPY2
	 XTcAi3IStYAXGbT+k4h+ZA3lR+uoA0V0L/WYRkH9VCj53UulpuCFZ873wndtctCcXs
	 QRzRY02LHHmSz/X3BwGnAYVj5wZxLhzjksVQWO8WsnHcjoH5IMbbqF20J0bpPaKqgk
	 lxthnHO4L9DLGqrLF9BGue2hpfS9hBLzANoqqTQmDMT0JgYiDLM6tqzHhegW5qQdlg
	 vDeXnuLxUZ4NA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 431C3602BA;
	Thu, 17 Jul 2025 11:51:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745893;
	bh=cGndYFXBglsllpMtkSoQ23N5q4zEyEO/TE6Xa9vHUHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbFrTmUoyuYpA/ofVA9Gjf+kldONymUAGodtaAazKCQhJ+dfnfMXoNLCqzoZ0OyIu
	 pC1ppA9NdTY7Pe5FbjccSQcKw5QLghJsYIW9ZHdab4sW6B29/a3Zh1FscJlYj3ETGZ
	 zbOSiXZo4Bw7vK/QFBu5G1oGMqmLKnlD5zAh/381kPUzuTjdPMig1j59Jq2jSLvLsK
	 /vIewK/Q8XYq7lNM8jWwM2R3ULYubKAIesDzYdvUd4W63YidQLRHNsq2cZqUlplYTZ
	 I7I1PgAldI33hra5gk03oAwuzghEFfnpLV4ZO0ZlKclVpwNT7JhcHkHOEIRmQ1ZSQb
	 UIki9hc+BRp/w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 6/7] Revert "netfilter: nf_tables: Add notifications for hook changes"
Date: Thu, 17 Jul 2025 11:51:21 +0200
Message-Id: <20250717095122.32086-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250717095122.32086-1-pablo@netfilter.org>
References: <20250717095122.32086-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

This reverts commit 465b9ee0ee7bc268d7f261356afd6c4262e48d82.

Such notifications fit better into core or nfnetlink_hook code,
following the NFNL_MSG_HOOK_GET message format.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  5 --
 include/uapi/linux/netfilter/nf_tables.h | 10 ----
 include/uapi/linux/netfilter/nfnetlink.h |  2 -
 net/netfilter/nf_tables_api.c            | 59 ------------------------
 net/netfilter/nfnetlink.c                |  1 -
 net/netfilter/nft_chain_filter.c         |  2 -
 6 files changed, 79 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e4d8e451e935..5e49619ae49c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1142,11 +1142,6 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 void nf_tables_unbind_chain(const struct nft_ctx *ctx, struct nft_chain *chain);
 
-struct nft_hook;
-void nf_tables_chain_device_notify(const struct nft_chain *chain,
-				   const struct nft_hook *hook,
-				   const struct net_device *dev, int event);
-
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
 	NFT_CHAIN_T_ROUTE,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 518ba144544c..2beb30be2c5f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -142,8 +142,6 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_GETSETELEM_RESET,
-	NFT_MSG_NEWDEV,
-	NFT_MSG_DELDEV,
 	NFT_MSG_MAX,
 };
 
@@ -1786,18 +1784,10 @@ enum nft_synproxy_attributes {
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
- * @NFTA_DEVICE_TABLE: table containing the flowtable or chain hooking into the device (NLA_STRING)
- * @NFTA_DEVICE_FLOWTABLE: flowtable hooking into the device (NLA_STRING)
- * @NFTA_DEVICE_CHAIN: chain hooking into the device (NLA_STRING)
- * @NFTA_DEVICE_SPEC: hook spec matching the device (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
-	NFTA_DEVICE_TABLE,
-	NFTA_DEVICE_FLOWTABLE,
-	NFTA_DEVICE_CHAIN,
-	NFTA_DEVICE_SPEC,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 50d807af2649..6cd58cd2a6f0 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -25,8 +25,6 @@ enum nfnetlink_groups {
 #define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	NFNLGRP_NFTRACE,
 #define NFNLGRP_NFTRACE			NFNLGRP_NFTRACE
-	NFNLGRP_NFT_DEV,
-#define NFNLGRP_NFT_DEV			NFNLGRP_NFT_DEV
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24c71ecb2179..a7240736f98e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9686,64 +9686,6 @@ struct nf_hook_ops *nft_hook_find_ops_rcu(const struct nft_hook *hook,
 }
 EXPORT_SYMBOL_GPL(nft_hook_find_ops_rcu);
 
-static void
-nf_tables_device_notify(const struct nft_table *table, int attr,
-			const char *name, const struct nft_hook *hook,
-			const struct net_device *dev, int event)
-{
-	struct net *net = dev_net(dev);
-	struct nlmsghdr *nlh;
-	struct sk_buff *skb;
-	u16 flags = 0;
-
-	if (!nfnetlink_has_listeners(net, NFNLGRP_NFT_DEV))
-		return;
-
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb)
-		goto err;
-
-	event = event == NETDEV_REGISTER ? NFT_MSG_NEWDEV : NFT_MSG_DELDEV;
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, 0, 0, event, flags, table->family,
-			   NFNETLINK_V0, nft_base_seq(net));
-	if (!nlh)
-		goto err;
-
-	if (nla_put_string(skb, NFTA_DEVICE_TABLE, table->name) ||
-	    nla_put_string(skb, attr, name) ||
-	    nla_put(skb, NFTA_DEVICE_SPEC, hook->ifnamelen, hook->ifname) ||
-	    nla_put_string(skb, NFTA_DEVICE_NAME, dev->name))
-		goto err;
-
-	nlmsg_end(skb, nlh);
-	nfnetlink_send(skb, net, 0, NFNLGRP_NFT_DEV,
-		       nlmsg_report(nlh), GFP_KERNEL);
-	return;
-err:
-	if (skb)
-		kfree_skb(skb);
-	nfnetlink_set_err(net, 0, NFNLGRP_NFT_DEV, -ENOBUFS);
-}
-
-void
-nf_tables_chain_device_notify(const struct nft_chain *chain,
-			      const struct nft_hook *hook,
-			      const struct net_device *dev, int event)
-{
-	nf_tables_device_notify(chain->table, NFTA_DEVICE_CHAIN,
-				chain->name, hook, dev, event);
-}
-
-static void
-nf_tables_flowtable_device_notify(const struct nft_flowtable *ft,
-				  const struct nft_hook *hook,
-				  const struct net_device *dev, int event)
-{
-	nf_tables_device_notify(ft->table, NFTA_DEVICE_FLOWTABLE,
-				ft->name, hook, dev, event);
-}
-
 static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			       struct nft_flowtable *flowtable, bool changename)
 {
@@ -9791,7 +9733,6 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
-		nf_tables_flowtable_device_notify(flowtable, hook, dev, event);
 		break;
 	}
 	return 0;
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ac77fc21632d..e598a2a252b0 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -86,7 +86,6 @@ static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_NFTABLES]		= NFNL_SUBSYS_NFTABLES,
 	[NFNLGRP_ACCT_QUOTA]		= NFNL_SUBSYS_ACCT,
 	[NFNLGRP_NFTRACE]		= NFNL_SUBSYS_NFTABLES,
-	[NFNLGRP_NFT_DEV]		= NFNL_SUBSYS_NFTABLES,
 };
 
 static struct nfnl_net *nfnl_pernet(struct net *net)
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 846d48ba8965..b16185e9a6dd 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -363,8 +363,6 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			list_add_tail_rcu(&ops->list, &hook->ops_list);
 			break;
 		}
-		nf_tables_chain_device_notify(&basechain->chain,
-					      hook, dev, event);
 		break;
 	}
 	return 0;
-- 
2.39.5

