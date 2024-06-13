Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E23175AD;
	Thu, 13 Jun 2024 01:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240554; cv=none; b=jTXzMJpagnccbW9wGzF9Uvlet/ZZar00D0BCo/wBMvsMetJy94yn7Sf5zRRVBdS35X4XGV9VSyOs+3pYJtSnDzM1Yf31fN++tzkf00Mpe7wkCmtp24yOAgPuJF75fY5cRgD83RwGFQmuk+aCUvbK37mxmsC4I2Wq7lQPh/NogBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240554; c=relaxed/simple;
	bh=YgxPR9x0hFBPxvVRxK+wkz2SmPIEfVZkwZErzcQFqqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Eud6PewNrFfnRWD6A0kq/Yg1njrdVyGeEapnnAD0aVXeTZlwviPwa1rGHeBBr/4IvIDULKBJjLHxdKKAPy/P6HkLZWx5JpPw4xR7qYvLqOwLM31FexeZy98Dq/KTTlonB2hQrJU/E1VdQgymeKFJuLBv2RhD45rQKdlJZ/Y+/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 22/40] netfilter: nf_tables: double hook unregistration in netns path
Date: Thu, 13 Jun 2024 03:01:51 +0200
Message-Id: <20240613010209.104423-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/netfilter/nf_tables_api.c    | 34 +++++++++++++++++++++++++-------
 net/netfilter/nft_chain_filter.c |  3 +++
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 719b30d6ec64..adab83a22f6c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -204,9 +204,10 @@ static int nf_tables_register_hook(struct net *net,
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
@@ -221,6 +222,16 @@ static void nf_tables_unregister_hook(struct net *net,
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
@@ -5821,8 +5832,9 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	return ERR_PTR(-ENOENT);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
+						 bool release_netdev)
 {
 	int i;
 
@@ -5831,9 +5843,17 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
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
@@ -7862,9 +7882,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
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
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index a308d45ee95e..397aa83f54e0 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -296,6 +296,9 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (strcmp(basechain->dev_name, dev->name) != 0)
 			return;
 
+		if (!basechain->ops.dev)
+			return;
+
 		/* UNREGISTER events are also happpening on netns exit.
 		 *
 		 * Altough nf_tables core releases all tables/chains, only
-- 
2.30.2

