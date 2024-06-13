Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1378C143C51;
	Thu, 13 Jun 2024 11:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279137; cv=none; b=pWVIV5Hh1k+/Qe0YuQCFW7HifvyXgAQRuQIIYhW8JtcVHnO5mO3c7um6bNY1cO71sbth6qxg41cDLSmfC8DZ+Ie6seH5so0lRisaoVCsfBVfvGXHJLpBaSKCSX9rLdgysAF5v6kbIF1u1e/O7W6VQm8enfywr9NP2Ns5HHJS30A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279137; c=relaxed/simple;
	bh=wvlVjwmu/5vzTmfKc2hp32K3ik2sb9cUdEA8ItJREh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bdg3kZuEImhn0xdHsc68UdcdwK8YGcRozb5zMzXF5EHHoLKq+hVVa6yjsP4G5c6hKs62CJ4drk079ijE+EF7z7Eu9xG0lQ9zeo7iBIi5OCRmjtwAO+83/FWW7OFjx3poOo0FnLoe70eSaXeWUIGLCmRor6NrBMwhhlLoZuYbIBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bXWccHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bXWccHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40937C32786;
	Thu, 13 Jun 2024 11:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279136;
	bh=wvlVjwmu/5vzTmfKc2hp32K3ik2sb9cUdEA8ItJREh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bXWccHxGUBwyxa+Fw8Q7Z6GR35ewUfc0IzEDQCASvh8aGxCO5EgpPexQjopkKjs/
	 9xNzoUraZt5szG84aISCDTDIQ19lMJgDfRg4yb65K+jSTe/DsBY2g6PdmRhlSJUq/s
	 AdEoNcR7WBetust6RZ2g3aSTKzvIvxTNp4NGAQgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 180/213] netfilter: nf_tables: double hook unregistration in netns path
Date: Thu, 13 Jun 2024 13:33:48 +0200
Message-ID: <20240613113234.925300849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit f9a43007d3f7ba76d5e7f9421094f00f2ef202f8 upstream.

__nft_release_hooks() is called from pre_netns exit path which
unregisters the hooks, then the NETDEV_UNREGISTER event is triggered
which unregisters the hooks again.

[  565.221461] WARNING: CPU: 18 PID: 193 at net/netfilter/core.c:495 __nf_unregister_net_hook+0x247/0x270
[...]
[  565.246890] CPU: 18 PID: 193 Comm: kworker/u64:1 Tainted: G            E     5.18.0-rc7+ #27
[  565.253682] Workqueue: netns cleanup_net
[  565.257059] RIP: 0010:__nf_unregister_net_hook+0x247/0x270
[...]
[  565.297120] Call Trace:
[  565.300900]  <TASK>
[  565.304683]  nf_tables_flowtable_event+0x16a/0x220 [nf_tables]
[  565.308518]  raw_notifier_call_chain+0x63/0x80
[  565.312386]  unregister_netdevice_many+0x54f/0xb50

Unregister and destroy netdev hook from netns pre_exit via kfree_rcu
so the NETDEV_UNREGISTER path see unregistered hooks.

Fixes: 767d1216bff8 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c    |   34 +++++++++++++++++++++++++++-------
 net/netfilter/nft_chain_filter.c |    3 +++
 2 files changed, 30 insertions(+), 7 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -204,9 +204,10 @@ static int nf_tables_register_hook(struc
 	return nf_register_net_hook(net, ops);
 }
 
-static void nf_tables_unregister_hook(struct net *net,
-				      const struct nft_table *table,
-				      struct nft_chain *chain)
+static void __nf_tables_unregister_hook(struct net *net,
+					const struct nft_table *table,
+					struct nft_chain *chain,
+					bool release_netdev)
 {
 	const struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
@@ -221,6 +222,16 @@ static void nf_tables_unregister_hook(st
 		return basechain->type->ops_unregister(net, ops);
 
 	nf_unregister_net_hook(net, ops);
+	if (release_netdev &&
+	    table->family == NFPROTO_NETDEV)
+		nft_base_chain(chain)->ops.dev = NULL;
+}
+
+static void nf_tables_unregister_hook(struct net *net,
+				      const struct nft_table *table,
+				      struct nft_chain *chain)
+{
+	__nf_tables_unregister_hook(net, table, chain, false);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -5821,8 +5832,9 @@ nft_flowtable_type_get(struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
+						 bool release_netdev)
 {
 	int i;
 
@@ -5831,9 +5843,17 @@ static void nft_unregister_flowtable_net
 			continue;
 
 		nf_unregister_net_hook(net, &flowtable->ops[i]);
+		if (release_netdev)
+			flowtable->ops[i].dev = NULL;
 	}
 }
 
+static void nft_unregister_flowtable_net_hooks(struct net *net,
+					       struct nft_flowtable *flowtable)
+{
+	__nft_unregister_flowtable_net_hooks(net, flowtable, false);
+}
+
 static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 				  struct sk_buff *skb,
 				  const struct nlmsghdr *nlh,
@@ -7862,9 +7882,9 @@ static void __nft_release_table(struct n
 	ctx.family = table->family;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, flowtable);
+		__nft_unregister_flowtable_net_hooks(net, flowtable, true);
 	/* No packets are walking on these chains anymore. */
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -296,6 +296,9 @@ static void nft_netdev_event(unsigned lo
 		if (strcmp(basechain->dev_name, dev->name) != 0)
 			return;
 
+		if (!basechain->ops.dev)
+			return;
+
 		/* UNREGISTER events are also happpening on netns exit.
 		 *
 		 * Altough nf_tables core releases all tables/chains, only


