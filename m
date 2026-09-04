Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC69377566;
	Fri,  4 Sep 2026 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485470; cv=none; b=GxARmoNBMIORIw7KA/74J3QrSoiSsgfHQ3dUFZ6XiUQZpcn12cSfnGIguZKbjfsjB2NtyT/fc+2GSiftFkzPKghDUzuGyE2QxdFKOUVVngirp5Wqwl/jNwwM0DVBEsq+0dZo9cdx92v4+p0HJHQL0sZnznPt1K5nBF0fOsmq6tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485470; c=relaxed/simple;
	bh=RLYIBihWFAZe8Pd+AhyecYDThJcw4PROecgrkLzIoCE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z1w7xuRJXW76sY1z/SMTGC2oM6wdxUT7azkR3CHLf6+Tup8ZNLzSRS1pUfYV8jYMxbYMsT7a58s8uR6xxSdRhHhhDSdJ848ZU5M82ID91bFbN3i+OqW2XzuXms6PfEuRWaorl+5salROMCVD1ouUmPzkzDUUw75EZGPxsfLxLpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=rcPpKyR4; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="rcPpKyR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788485469; x=1820021469;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bahJnU9qsHIbxRAQzoBVDDsLsFedAZHhW5MPInxWE84=;
  b=rcPpKyR4FxrCKeFkuB/BWSC+B/SoQE1NOLgBSyb4Llw2tz+pNMfPeerd
   JSbEk3MaxQmEvsVM8v+Wq4J/HXjEo2TPE/F06XjR4Y8Ji2memrRGhqK+H
   lU/mQI0ISh3PCN59di+Qs4MI3gdIYF3wcldR4Dooa9Nf/GCdlB18c0OCY
   iZjB/Kt7WlGxIGbPEex+QQ8h+gM74jeGcvB+JTMD+COzgs+o6QTQg5Xkd
   0Es6xs9jRaz1jtncYv6jGWdMvGPCeJ2I1AuJ02BOFls4BU1mdxhcj2IXt
   /aBf6TDtv8I0llm687IZgq2pdwj750s+feg9hWmyj1fFumrsy7AOhuI6n
   w==;
X-CSE-ConnectionGUID: 6eqHi8/dTJao1iW7qe1bqg==
X-CSE-MsgGUID: KyDRdKszQcyRYRAyaKWXIA==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27782135"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 01:31:05 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:14188]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.243:2525] with esmtp (Farcaster)
 id 836b5b7c-d03b-4cc0-bcc0-1335b995bfd2; Fri, 4 Sep 2026 01:31:05 +0000 (UTC)
X-Farcaster-Flow-ID: 836b5b7c-d03b-4cc0-bcc0-1335b995bfd2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 01:31:05 +0000
Received: from dev-dsk-surajjs-2c-afd24e6d.us-west-2.amazon.com
 (10.189.247.117) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 01:31:05 +0000
From: Suraj Jitindar Singh <surajjs@amazon.com>
To: <stable@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
	<netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 6.1.y] netfilter: nf_tables: make nft_object rhltable per table
Date: Fri, 4 Sep 2026 01:31:02 +0000
Message-ID: <20260904013102.22326-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWB002.ant.amazon.com (10.13.139.190) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit f4f699790590bd0896c48a71e9232a65198f92f0 upstream.

The nft_object rhltable is global, this allows for accessing objects
that are being dismangled from lookup path by other existing netns.
Given the nft_obj_destroy() releases the object inmediately, this might
lead to use-after-free of these objects that are being released.
Make the existing rhltable per table to address this issue to deal with
with the nft_rcv_nl_event() path too.

Update nft_obj_lookup() to take the table as non-const, otherwise,
compiler complains when passing the objname_ht to rhltable_lookup().

Fixes: 4d44175aa5bb ("netfilter: nf_tables: handle nft_object lookups via rhltable")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ 6.1: Conflicts in nf_tables_api.c because 6.1 lacks three mainline
  refactors: 0be908750162 ("netfilter: nf_tables: pass nft_table to
  destroy function", v6.11), e169285f8c56 ("netfilter: nf_tables: do
  not store nft_ctx in transaction objects", v6.11) and f80a612dd77c
  ("netfilter: nf_tables: add support to destroy operation", v6.3).
  As a result 6.1's nf_tables_table_destroy() still takes an nft_ctx;
  struct nft_trans still embeds an nft_ctx (so the owning table is
  trans->ctx.table, not a per-transaction table local); and the commit
  path has no NFT_MSG_DESTROYOBJ case. Resolved by destroying the
  per-table objname_ht via ctx->table in nf_tables_table_destroy(), and
  by passing the owning table trans->ctx.table to nft_obj_del() in the
  commit and abort paths; 6.1's single NFT_MSG_DELOBJ case is retained.
  The header and all other hunks applied cleanly. ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4e8cf4e13f8f..6c82feab2ad5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1211,6 +1211,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@objname_ht: hashtable for objects lookup by name
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1226,6 +1227,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct rhltable			objname_ht;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1304,7 +1306,7 @@ static inline void *nft_obj_data(const struct nft_object *obj)
 #define nft_expr_obj(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7240f494d83b..71ada0af4c85 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -42,8 +42,6 @@ enum {
 	NFT_VALIDATE_DO,
 };
 
-static struct rhltable nft_objname_ht;
-
 static u32 nft_chain_hash(const void *data, u32 len, u32 seed);
 static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_chain_hash_cmp(struct rhashtable_compare_arg *, const void *);
@@ -1419,6 +1417,10 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err)
 		goto err_chain_ht;
 
+	err = rhltable_init(&table->objname_ht, &nft_objname_ht_params);
+	if (err < 0)
+		goto err_obj_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1437,6 +1439,8 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhltable_destroy(&table->objname_ht);
+err_obj_ht:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
 	kfree(table->udata);
@@ -1599,6 +1603,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 		return;
 
 	rhltable_destroy(&ctx->table->chains_ht);
+	rhltable_destroy(&ctx->table->objname_ht);
 	kfree(ctx->table->name);
 	kfree(ctx->table->udata);
 	kfree(ctx->table);
@@ -7151,7 +7156,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type)
 EXPORT_SYMBOL_GPL(nft_unregister_obj);
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask)
 {
@@ -7167,7 +7172,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 		     !lockdep_commit_lock_is_held(net));
 
 	rcu_read_lock();
-	list = rhltable_lookup(&nft_objname_ht, &k, nft_objname_ht_params);
+	list = rhltable_lookup(&table->objname_ht, &k, nft_objname_ht_params);
 	if (!list)
 		goto out;
 
@@ -7446,7 +7451,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_trans;
 
-	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
+	err = rhltable_insert(&table->objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
 		goto err_obj_ht;
@@ -7642,8 +7647,8 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
-	const struct nft_table *table;
 	struct net *net = info->net;
+	struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	u32 objtype;
@@ -9310,9 +9315,9 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
-static void nft_obj_del(struct nft_object *obj)
+static void nft_obj_del(struct nft_table *table, struct nft_object *obj)
 {
-	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
+	rhltable_remove(&table->objname_ht, &obj->rhlhead, nft_objname_ht_params);
 	list_del_rcu(&obj->list);
 }
 
@@ -9963,7 +9968,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
-			nft_obj_del(nft_trans_obj(trans));
+			nft_obj_del(trans->ctx.table, nft_trans_obj(trans));
 			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
 					     NFT_MSG_DELOBJ);
 			break;
@@ -10222,7 +10227,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&trans->ctx.table->use);
-				nft_obj_del(nft_trans_obj(trans));
+				nft_obj_del(trans->ctx.table, nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
@@ -10860,7 +10865,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
-		nft_obj_del(obj);
+		nft_obj_del(table, obj);
 		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
@@ -11023,10 +11028,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err_netdev_notifier;
 
-	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
-	if (err < 0)
-		goto err_rht_objname;
-
 	err = nft_offload_init();
 	if (err < 0)
 		goto err_offload;
@@ -11049,8 +11050,6 @@ static int __init nf_tables_module_init(void)
 err_netlink_notifier:
 	nft_offload_exit();
 err_offload:
-	rhltable_destroy(&nft_objname_ht);
-err_rht_objname:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 err_netdev_notifier:
 	nf_tables_core_module_exit();
@@ -11074,7 +11073,6 @@ static void __exit nf_tables_module_exit(void)
 	cancel_work_sync(&trans_gc_work);
 	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
-	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
 }
 
-- 
2.47.3
