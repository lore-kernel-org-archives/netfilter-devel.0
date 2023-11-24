Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03812C1A2;
	Fri, 24 Nov 2023 19:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRKNZUIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7A1C433C8;
	Fri, 24 Nov 2023 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854096;
	bh=ZIUQaLKxcdX8152UpZBoQZ/HEwN/PKXbtUvPp218UEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRKNZUIbWtiyjPAxJmG3Qr9oM0KT0BzGGqjTLwF7Ez2kgB+gp5VNFMEJe6D1H+wYM
	 L5MatNdwijQPPgYmX5Wrsr9pAtCNv3mgrzQVbHjpB+/up4UmIN0EB7AO0sck2hefTt
	 JMtpebyiUD6mR+CYDyCLJdoWlRPBMsAllPtcYIhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 155/159] netfilter: nf_tables: double hook unregistration in netns path
Date: Fri, 24 Nov 2023 17:56:12 +0000
Message-ID: <20231124171948.242563153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -219,9 +219,10 @@ static int nf_tables_register_hook(struc
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
@@ -236,6 +237,16 @@ static void nf_tables_unregister_hook(st
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
@@ -5997,8 +6008,9 @@ nft_flowtable_type_get(struct net *net,
 	return ERR_PTR(-ENOENT);
 }
 
-static void nft_unregister_flowtable_net_hooks(struct net *net,
-					       struct nft_flowtable *flowtable)
+static void __nft_unregister_flowtable_net_hooks(struct net *net,
+						 struct nft_flowtable *flowtable,
+						 bool release_netdev)
 {
 	int i;
 
@@ -6007,9 +6019,17 @@ static void nft_unregister_flowtable_net
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
@@ -8192,9 +8212,9 @@ static void __nft_release_hook(struct ne
 	struct nft_chain *chain;
 
 	list_for_each_entry(chain, &table->chains, list)
-		nf_tables_unregister_hook(net, table, chain);
+		__nf_tables_unregister_hook(net, table, chain, true);
 	list_for_each_entry(flowtable, &table->flowtables, list)
-		nft_unregister_flowtable_net_hooks(net, flowtable);
+		__nft_unregister_flowtable_net_hooks(net, flowtable, true);
 }
 
 static void __nft_release_hooks(struct net *net)
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


