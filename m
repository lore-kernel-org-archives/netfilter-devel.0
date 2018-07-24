From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/9] netfilter: nf_tables: fix jumpstack depth validation
Date: Tue, 24 Jul 2018 18:31:25 +0200
Message-ID: <20180724163133.14586-2-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The level of struct nft_ctx is updated by nf_tables_check_loops().  That
is used to validate jumpstack depth. But jumpstack validation routine
doesn't update and validate recursively.  So, in some cases, chain depth
can be bigger than the NFT_JUMP_STACK_SIZE.

After this patch, The jumpstack validation routine is located in the
nft_chain_validate(). When new rules or new set elements are added, the
nft_table_validate() is called by the nf_tables_newrule and the
nf_tables_newsetelem. The nft_table_validate() calls the
nft_chain_validate() that visit all their children chains recursively.
So it can update depth of chain certainly.

Reproducer:
   %cat ./test.sh
   #!/bin/bash
   nft add table ip filter
   nft add chain ip filter input { type filter hook input priority 0\; }
   for ((i=0;i<20;i++)); do
	nft add chain ip filter a$i
   done

   nft add rule ip filter input jump a1

   for ((i=0;i<10;i++)); do
	nft add rule ip filter a$i jump a$((i+1))
   done

   for ((i=11;i<19;i++)); do
	nft add rule ip filter a$i jump a$((i+1))
   done

   nft add rule ip filter a10 jump a11

Result:
[  253.931782] WARNING: CPU: 1 PID: 0 at net/netfilter/nf_tables_core.c:186 nft_do_chain+0xacc/0xdf0 [nf_tables]
[  253.931915] Modules linked in: nf_tables nfnetlink ip_tables x_tables
[  253.932153] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.18.0-rc3+ #48
[  253.932153] RIP: 0010:nft_do_chain+0xacc/0xdf0 [nf_tables]
[  253.932153] Code: 83 f8 fb 0f 84 c7 00 00 00 e9 d0 00 00 00 83 f8 fd 74 0e 83 f8 ff 0f 84 b4 00 00 00 e9 bd 00 00 00 83 bd 64 fd ff ff 0f 76 09 <0f> 0b 31 c0 e9 bc 02 00 00 44 8b ad 64 fd
[  253.933807] RSP: 0018:ffff88011b807570 EFLAGS: 00010212
[  253.933807] RAX: 00000000fffffffd RBX: ffff88011b807660 RCX: 0000000000000000
[  253.933807] RDX: 0000000000000010 RSI: ffff880112b39d78 RDI: ffff88011b807670
[  253.933807] RBP: ffff88011b807850 R08: ffffed0023700ece R09: ffffed0023700ecd
[  253.933807] R10: ffff88011b80766f R11: ffffed0023700ece R12: ffff88011b807898
[  253.933807] R13: ffff880112b39d80 R14: ffff880112b39d60 R15: dffffc0000000000
[  253.933807] FS:  0000000000000000(0000) GS:ffff88011b800000(0000) knlGS:0000000000000000
[  253.933807] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  253.933807] CR2: 00000000014f1008 CR3: 000000006b216000 CR4: 00000000001006e0
[  253.933807] Call Trace:
[  253.933807]  <IRQ>
[  253.933807]  ? sched_clock_cpu+0x132/0x170
[  253.933807]  ? __nft_trace_packet+0x180/0x180 [nf_tables]
[  253.933807]  ? sched_clock_cpu+0x132/0x170
[  253.933807]  ? debug_show_all_locks+0x290/0x290
[  253.933807]  ? __lock_acquire+0x4835/0x4af0
[  253.933807]  ? inet_ehash_locks_alloc+0x1a0/0x1a0
[  253.933807]  ? unwind_next_frame+0x159e/0x1840
[  253.933807]  ? __read_once_size_nocheck.constprop.4+0x5/0x10
[  253.933807]  ? nft_do_chain_ipv4+0x197/0x1e0 [nf_tables]
[  253.933807]  ? nft_do_chain+0x5/0xdf0 [nf_tables]
[  253.933807]  nft_do_chain_ipv4+0x197/0x1e0 [nf_tables]
[  253.933807]  ? nft_do_chain_arp+0xb0/0xb0 [nf_tables]
[  253.933807]  ? __lock_is_held+0x9d/0x130
[  253.933807]  nf_hook_slow+0xc4/0x150
[  253.933807]  ip_local_deliver+0x28b/0x380
[  253.933807]  ? ip_call_ra_chain+0x3e0/0x3e0
[  253.933807]  ? ip_rcv_finish+0x1610/0x1610
[  253.933807]  ip_rcv+0xbcc/0xcc0
[  253.933807]  ? debug_show_all_locks+0x290/0x290
[  253.933807]  ? ip_local_deliver+0x380/0x380
[  253.933807]  ? __lock_is_held+0x9d/0x130
[  253.933807]  ? ip_local_deliver+0x380/0x380
[  253.933807]  __netif_receive_skb_core+0x1c9c/0x2240

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++--
 net/netfilter/nf_tables_api.c     | 11 ++++-------
 net/netfilter/nft_immediate.c     |  3 +++
 net/netfilter/nft_lookup.c        | 13 +++++++++++--
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 08c005ce56e9..4e82a4c49912 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -150,6 +150,7 @@ static inline void nft_data_debug(const struct nft_data *data)
  *	@portid: netlink portID of the original message
  *	@seq: netlink sequence number
  *	@family: protocol family
+ *	@level: depth of the chains
  *	@report: notify via unicast netlink message
  */
 struct nft_ctx {
@@ -160,6 +161,7 @@ struct nft_ctx {
 	u32				portid;
 	u32				seq;
 	u8				family;
+	u8				level;
 	bool				report;
 };
 
@@ -865,7 +867,6 @@ enum nft_chain_flags {
  *	@table: table that this chain belongs to
  *	@handle: chain handle
  *	@use: number of jump references to this chain
- *	@level: length of longest path to this chain
  *	@flags: bitmask of enum nft_chain_flags
  *	@name: name of the chain
  */
@@ -878,7 +879,6 @@ struct nft_chain {
 	struct nft_table		*table;
 	u64				handle;
 	u32				use;
-	u16				level;
 	u8				flags:6,
 					genmask:2;
 	char				*name;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 896d4a36081d..d41fa2c82f14 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -75,6 +75,7 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 {
 	ctx->net	= net;
 	ctx->family	= family;
+	ctx->level	= 0;
 	ctx->table	= table;
 	ctx->chain	= chain;
 	ctx->nla   	= nla;
@@ -2384,6 +2385,9 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 	struct nft_rule *rule;
 	int err;
 
+	if (ctx->level == NFT_JUMP_STACK_SIZE)
+		return -EMLINK;
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(ctx->net, rule))
 			continue;
@@ -6837,13 +6841,6 @@ int nft_validate_register_store(const struct nft_ctx *ctx,
 			err = nf_tables_check_loops(ctx, data->verdict.chain);
 			if (err < 0)
 				return err;
-
-			if (ctx->chain->level + 1 >
-			    data->verdict.chain->level) {
-				if (ctx->chain->level + 1 == NFT_JUMP_STACK_SIZE)
-					return -EMLINK;
-				data->verdict.chain->level = ctx->chain->level + 1;
-			}
 		}
 
 		return 0;
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 15adf8ca82c3..0777a93211e2 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -98,6 +98,7 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 				  const struct nft_data **d)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
 	const struct nft_data *data;
 	int err;
 
@@ -109,9 +110,11 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	switch (data->verdict.code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
+		pctx->level++;
 		err = nft_chain_validate(ctx, data->verdict.chain);
 		if (err < 0)
 			return err;
+		pctx->level--;
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 42e6fadf1417..c2a1d84cdfc4 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -155,7 +155,9 @@ static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
 				       struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
 	const struct nft_data *data;
+	int err;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
@@ -165,10 +167,17 @@ static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
 	switch (data->verdict.code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		return nft_chain_validate(ctx, data->verdict.chain);
+		pctx->level++;
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		pctx->level--;
+		break;
 	default:
-		return 0;
+		break;
 	}
+
+	return 0;
 }
 
 static int nft_lookup_validate(const struct nft_ctx *ctx,
-- 
2.11.0
