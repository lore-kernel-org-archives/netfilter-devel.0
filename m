Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C5F361667;
	Fri,  4 Sep 2026 01:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485461; cv=none; b=r5yvFvdwyTFKgkkuOKXH2QjMCD5tnzqDmz1h1JA6EIc4ureLoVr+LRGPaBSAdEOsm0HPIdyqZ/H2MUw/Il3lhqARxt2L5e/rHFLgtm9MDcGnvoVt0QAdEWZEEFieyixeQwofiU/zm3vqGZATMPAWqheE7VmWu9A01l5kp/9DHe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485461; c=relaxed/simple;
	bh=kPoTkSesqja7VRwSGNXwsSuid/pSRu4vIXgfPFKRFe4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jILFWKcquvRx5d4uVeHSg1s/YFhVcvP6xs9vCrAsEQJt8YW6l0kbzBOzFrDPJT5TamuwtiaasoNXbj0eD9rTviNpeb1SjTmWL0RbCQhZtHtR2SHMzzyV6B9Pze3gDVGZ/lNTwo2Ay8wfuIK1+VfTSfbMV2KyFqloO11V3OswA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZoFf292z; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZoFf292z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788485459; x=1820021459;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WBHxEcwyqp/428hBV+vwW+4ffG79NFlouQSQGnLQwp0=;
  b=ZoFf292zagDyjnrLvshz1BBqNkd7NPzbug6fOKfHwf+M+IObj4F26Q3n
   z6Jl7Q/T5V5lm1VebI2iZgSLlQqHIBbHz0dCAAoa8wqR1Zg/Xn1CALiWY
   zqN+xoqs5Q4O/j54lDMgsXqOK5d2RGR+wRMkl6CoFsWeY2nBCOYs8tqXG
   zcTznBOWeZvGnUmp200emiaBoTCFIKZE/Qe9/3uyw0dPezbKU04Bzot/j
   +he8QUV9Uf8eCg5SKH6/WK9rZKbgTze4jclhGseQ26wHJGfCqRCer1Dmm
   z9II/j9/4Xg40m95jP2eNY+Mqqto/a4jtd/rrkzEaj3qbrrkEFZvO/hWV
   w==;
X-CSE-ConnectionGUID: LRT8OLV+SjGm/5XOd4XCAg==
X-CSE-MsgGUID: zGlewdTcSYSMbBgxwLRVmw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27757687"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 01:30:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:29242]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.132:2525] with esmtp (Farcaster)
 id 722a0692-86fb-4042-b3b8-e1954b4325e4; Fri, 4 Sep 2026 01:30:59 +0000 (UTC)
X-Farcaster-Flow-ID: 722a0692-86fb-4042-b3b8-e1954b4325e4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 01:30:58 +0000
Received: from dev-dsk-surajjs-2c-afd24e6d.us-west-2.amazon.com
 (10.189.247.117) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 01:30:58 +0000
From: Suraj Jitindar Singh <surajjs@amazon.com>
To: <stable@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
	<netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 5.10.y] netfilter: nf_tables: make nft_object rhltable per table
Date: Fri, 4 Sep 2026 01:30:55 +0000
Message-ID: <20260904013055.22116-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
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
[ 5.10: More extensive conflicts than 6.1 in nf_tables_api.c because 5.10
  lacks several mainline refactors: 0be908750162 ("netfilter: nf_tables:
  pass nft_table to destroy function", v6.11), e169285f8c56 ("netfilter:
  nf_tables: do not store nft_ctx in transaction objects", v6.11),
  f80a612dd77c ("netfilter: nf_tables: add support to destroy
  operation", v6.3), 797d49805ddc ("netfilter: nfnetlink: pass struct
  nfnl_info to rcu callbacks", v5.13) and 6001a930ce03 ("netfilter:
  nftables: introduce table ownership", v5.12). Resolved by: destroying
  the per-table objname_ht via ctx->table in nf_tables_table_destroy();
  dropping only the const on the local table in nf_tables_getobj()
  (which still uses the pre-nfnl_info API); passing the owning table
  trans->ctx.table to nft_obj_del() in the commit and abort paths
  (struct nft_trans still embeds an nft_ctx and 5.10 has no
  NFT_MSG_DESTROYOBJ case); and removing the global nft_objname_ht
  rhltable_init/destroy from module init, keeping 5.10's numeric error
  labels. The header and all other hunks applied cleanly. ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 include/net/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nf_tables_api.c     | 34 +++++++++++++++----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5fd9aade9b77..3115e95eaabf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1099,6 +1099,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@sets: sets in the table
  *	@objects: stateful objects in the table
  *	@flowtables: flow tables in the table
+ *	@objname_ht: hashtable for objects lookup by name
  *	@hgenerator: handle generator state
  *	@handle: table handle
  *	@use: number of chain references to this table
@@ -1114,6 +1115,7 @@ struct nft_table {
 	struct list_head		sets;
 	struct list_head		objects;
 	struct list_head		flowtables;
+	struct rhltable			objname_ht;
 	u64				hgenerator;
 	u64				handle;
 	u32				use;
@@ -1186,7 +1188,7 @@ static inline void *nft_obj_data(const struct nft_object *obj)
 #define nft_expr_obj(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 71b01feab5a0..9e6fa02bae89 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -44,8 +44,6 @@ enum {
 	NFT_VALIDATE_DO,
 };
 
-static struct rhltable nft_objname_ht;
-
 static u32 nft_chain_hash(const void *data, u32 len, u32 seed);
 static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed);
 static int nft_chain_hash_cmp(struct rhashtable_compare_arg *, const void *);
@@ -1295,6 +1293,10 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (err)
 		goto err_chain_ht;
 
+	err = rhltable_init(&table->objname_ht, &nft_objname_ht_params);
+	if (err < 0)
+		goto err_obj_ht;
+
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
 	INIT_LIST_HEAD(&table->objects);
@@ -1311,6 +1313,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	list_add_tail_rcu(&table->list, &nft_net->tables);
 	return 0;
 err_trans:
+	rhltable_destroy(&table->objname_ht);
+err_obj_ht:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
 	kfree(table->udata);
@@ -1469,6 +1473,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 		return;
 
 	rhltable_destroy(&ctx->table->chains_ht);
+	rhltable_destroy(&ctx->table->objname_ht);
 	kfree(ctx->table->name);
 	kfree(ctx->table->udata);
 	kfree(ctx->table);
@@ -6192,7 +6197,7 @@ void nft_unregister_obj(struct nft_object_type *obj_type)
 EXPORT_SYMBOL_GPL(nft_unregister_obj);
 
 struct nft_object *nft_obj_lookup(const struct net *net,
-				  const struct nft_table *table,
+				  struct nft_table *table,
 				  const struct nlattr *nla, u32 objtype,
 				  u8 genmask)
 {
@@ -6208,7 +6213,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 		     !lockdep_commit_lock_is_held(net));
 
 	rcu_read_lock();
-	list = rhltable_lookup(&nft_objname_ht, &k, nft_objname_ht_params);
+	list = rhltable_lookup(&table->objname_ht, &k, nft_objname_ht_params);
 	if (!list)
 		goto out;
 
@@ -6482,7 +6487,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err_trans;
 
-	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
+	err = rhltable_insert(&table->objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
 		goto err_obj_ht;
@@ -6668,7 +6673,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	u8 genmask = nft_genmask_cur(net);
 	int family = nfmsg->nfgen_family;
-	const struct nft_table *table;
+	struct nft_table *table;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	bool reset = false;
@@ -8224,9 +8229,9 @@ static void nf_tables_commit_chain(struct net *net, struct nft_chain *chain)
 		nf_tables_commit_chain_free_rules_old(g0);
 }
 
-static void nft_obj_del(struct nft_object *obj)
+static void nft_obj_del(struct nft_table *table, struct nft_object *obj)
 {
-	rhltable_remove(&nft_objname_ht, &obj->rhlhead, nft_objname_ht_params);
+	rhltable_remove(&table->objname_ht, &obj->rhlhead, nft_objname_ht_params);
 	list_del_rcu(&obj->list);
 }
 
@@ -8806,7 +8811,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
-			nft_obj_del(nft_trans_obj(trans));
+			nft_obj_del(trans->ctx.table, nft_trans_obj(trans));
 			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
 					     NFT_MSG_DELOBJ);
 			break;
@@ -9054,7 +9059,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_trans_destroy(trans);
 			} else {
 				nft_use_dec_restore(&trans->ctx.table->use);
-				nft_obj_del(nft_trans_obj(trans));
+				nft_obj_del(trans->ctx.table, nft_trans_obj(trans));
 			}
 			break;
 		case NFT_MSG_DELOBJ:
@@ -9711,7 +9716,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_set_destroy(&ctx, set);
 	}
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
-		nft_obj_del(obj);
+		nft_obj_del(table, obj);
 		nft_use_dec(&table->use);
 		nft_obj_destroy(&ctx, obj);
 	}
@@ -9818,10 +9823,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err3;
 
-	err = rhltable_init(&nft_objname_ht, &nft_objname_ht_params);
-	if (err < 0)
-		goto err4;
-
 	err = nft_offload_init();
 	if (err < 0)
 		goto err5;
@@ -9837,8 +9838,6 @@ static int __init nf_tables_module_init(void)
 err6:
 	nft_offload_exit();
 err5:
-	rhltable_destroy(&nft_objname_ht);
-err4:
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 err3:
 	nf_tables_core_module_exit();
@@ -9861,7 +9860,6 @@ static void __exit nf_tables_module_exit(void)
 	cancel_work_sync(&trans_gc_work);
 	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
-	rhltable_destroy(&nft_objname_ht);
 	nf_tables_core_module_exit();
 }
 
-- 
2.47.3
