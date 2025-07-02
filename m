Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C3B303DFB
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2025 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751478456; cv=none; b=rdREKNXWwppdOMopOXF8F2lBfKZMkPT0tBZN7JHlyIoMLYrARa7bpbLv2hYKNSBtVZ38S4I61rGzoAoT1BbdAtpG8lCPCplBgY/Y2dedXeVa/51xUw5yqNiQIIsJM8rzydN1ESzItCX3ImfMyGejgLOcCyAXUiuYrTZYHpFJ/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751478456; c=relaxed/simple;
	bh=eWK0GFVx8XuoPloJ9zILCHXiFtYD6dK68PIRrRhZMqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BYJgJgo6YVOn3p8RXL6CLgHcdCtsLyIy4fScjgtd1PynRs56x0qEY6ME13l2n3QngGnqcNx27p3PRZfLU1Gezu4U/EJDIP7fHU7nPPFJrfqHt0+KqhLH40BWYrlIWMMLRIK0h8vAeaNfeVicYsIviCtHfYp8dqkZ5Sl5pR/4dp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KNAmKq8B; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KNAmKq8B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mtE/laAmxapwFTnIHhFubDwBhd3wH55qQvzymK6BICA=; b=KNAmKq8B9YD0WCrQ08EJhhaR1E
	D81UKGWdk3vPIY0YwaoU0r1fLbHAy7BK3KCJZsjLEgOnWB1/cn3LBcFptej6+tPSSPWpIeVn/rSvd
	7SPmMZl1otdaQd1bp3stoeHrzR7Fbkbt5I9eWVkJFUAJvYLyyCa+VBHk8MMQvI281mgRyJycIA9ev
	wMAWb8iVA9r84N8Tg4pj2NiP2gbz3QW14nNQRMKRz9PSFK2SpQ9FeWH9V7Msj6jIsdO7A0rm95XYz
	7LSvLj2N99js9XNxjwxx/d864MyNDPY/TAMMzo5MJjIOp03xNmKwLLfEk6O334CLjAqtMhFQ+uPGL
	lmFQTkVw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uX1YQ-000000001Wo-35CB;
	Wed, 02 Jul 2025 19:47:30 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook registration
Date: Wed,  2 Jul 2025 19:47:25 +0200
Message-ID: <20250702174725.11371-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Require user space to set a flag upon flowtable or netdev-family chain
creation explicitly relaxing the hook registration when it comes to
non-existent interfaces. For the sake of simplicity, just restore error
condition if a given hook does not find an interface to bind to, leave
everyting else in place. Therefore:

- A wildcard interface spec is accepted as long as at least a single
  interface matches.
- Dynamic unregistering and re-registering of vanishing/re-appearing
  interfaces is still happening.

Note that this flag is persistent, i.e. included in ruleset dumps. This
effectively makes it "updatable": User space may create a "name-based"
flowtable for a non-existent interface, then update the flowtable to
drop the flag. What should happen then? Right now this is simply
accepted, even though the flowtable still does not bind to an interface.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  9 +++++++--
 net/netfilter/nf_tables_api.c            | 15 ++++++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 792836149eca..d08c7fbde1d1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -219,10 +219,12 @@ enum nft_chain_flags {
 	NFT_CHAIN_BASE		= (1 << 0),
 	NFT_CHAIN_HW_OFFLOAD	= (1 << 1),
 	NFT_CHAIN_BINDING	= (1 << 2),
+	NFT_CHAIN_NAME_BASED	= (1 << 3),
 };
 #define NFT_CHAIN_FLAGS		(NFT_CHAIN_BASE		| \
 				 NFT_CHAIN_HW_OFFLOAD	| \
-				 NFT_CHAIN_BINDING)
+				 NFT_CHAIN_BINDING	| \
+				 NFT_CHAIN_NAME_BASED)
 
 /**
  * enum nft_chain_attributes - nf_tables chain netlink attributes
@@ -1699,12 +1701,15 @@ enum nft_object_attributes {
  *
  * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
  * @NFT_FLOWTABLE_COUNTER: enable flow counters
+ * @NFT_FLOWTABLE_NAME_BASED: relax interface hooks
  */
 enum nft_flowtable_flags {
 	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
 	NFT_FLOWTABLE_COUNTER		= 0x2,
+	NFT_FLOWTABLE_NAME_BASED	= 0x4,
 	NFT_FLOWTABLE_MASK		= (NFT_FLOWTABLE_HW_OFFLOAD |
-					   NFT_FLOWTABLE_COUNTER)
+					   NFT_FLOWTABLE_COUNTER |
+					   NFT_FLOWTABLE_NAME_BASED)
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8fcc6393be38..5ae736715eec 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2374,7 +2374,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
 					struct list_head *hook_list,
-					struct netlink_ext_ack *extack)
+					struct netlink_ext_ack *extack,
+					bool relaxed)
 {
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
@@ -2392,6 +2393,12 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
+		if (!relaxed && list_empty(&hook->ops_list)) {
+			NL_SET_BAD_ATTR(extack, tmp);
+			nft_netdev_hook_free(hook);
+			err = -ENOENT;
+			goto err_hook;
+		}
 		if (nft_hook_list_find(hook_list, hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
 			nft_netdev_hook_free(hook);
@@ -2441,7 +2448,8 @@ static int nft_chain_parse_netdev(struct net *net, struct nlattr *tb[],
 		list_add_tail(&hook->list, hook_list);
 	} else if (tb[NFTA_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
-						   hook_list, extack);
+						   hook_list, extack,
+						   flags & NFT_CHAIN_NAME_BASED);
 		if (err < 0)
 			return err;
 
@@ -8847,6 +8855,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    struct nft_flowtable *flowtable,
 				    struct netlink_ext_ack *extack, bool add)
 {
+	bool relaxed = flowtable->data.flags & NFT_FLOWTABLE_NAME_BASED;
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nf_hook_ops *ops;
 	struct nft_hook *hook;
@@ -8897,7 +8906,7 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 		err = nf_tables_parse_netdev_hooks(ctx->net,
 						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
 						   &flowtable_hook->list,
-						   extack);
+						   extack, relaxed);
 		if (err < 0)
 			return err;
 	}
-- 
2.49.0

