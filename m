From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: [PATCH net-next 00/43] Simplify netfilter and network
 namespaces (take 2)
Date: Thu, 18 Jun 2015 17:49:43 +0200 (CEST)
Message-ID: <550613382.33095.1434642583328.JavaMail.zimbra@tpip.net>
References: <87616ppt3h.fsf@x220.int.ebiederm.org> <87r3pae5hn.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:59531 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbbFRPtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 11:49:53 -0400
In-Reply-To: <87r3pae5hn.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- Original Message -----
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Subject: [PATCH net-next 00/43] Simplify netfilter and network namespaces (take 2)

After all the chains, including the basechains, are now per netns,
it should be possible to remove pnet from basechain.

like this????

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8a61d8c..91bfded 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -788,7 +788,6 @@ struct nft_stats {
  *     struct nft_base_chain - nf_tables base chain
  *
  *     @ops: netfilter hook ops
- *     @pnet: net namespace that this chain belongs to
  *     @type: chain type
  *     @policy: default policy
  *     @stats: per-cpu chain stats
@@ -797,7 +796,6 @@ struct nft_stats {
  */
 struct nft_base_chain {
        struct nf_hook_ops              ops[NFT_HOOK_OPS_MAX];
-       possible_net_t                  pnet;
        const struct nf_chain_type      *type;
        u8                              policy;
        u8                              flags;
@@ -811,9 +809,11 @@ static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chai
        return container_of(chain, struct nft_base_chain, chain);
 }
 
-int nft_register_basechain(struct nft_base_chain *basechain,
+int nft_register_basechain(struct net *net,
+                          struct nft_base_chain *basechain,
                           unsigned int hook_nops);
-void nft_unregister_basechain(struct nft_base_chain *basechain,
+void nft_unregister_basechain(struct net *net,
+                             struct nft_base_chain *basechain,
                              unsigned int hook_nops);
 
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed9ef99..b0346be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -127,11 +127,10 @@ static void nft_trans_destroy(struct nft_trans *trans)
        kfree(trans);
 }
 
-int nft_register_basechain(struct nft_base_chain *basechain,
+int nft_register_basechain(struct net *net,
+                          struct nft_base_chain *basechain,
                           unsigned int hook_nops)
 {
-       struct net *net = read_pnet(&basechain->pnet);
-
        if (basechain->flags & NFT_BASECHAIN_DISABLED)
                return 0;
 
@@ -139,11 +138,10 @@ int nft_register_basechain(struct nft_base_chain *basechain,
 }
 EXPORT_SYMBOL_GPL(nft_register_basechain);
 
-void nft_unregister_basechain(struct nft_base_chain *basechain,
+void nft_unregister_basechain(struct net *net,
+                             struct nft_base_chain *basechain,
                              unsigned int hook_nops)
 {
-       struct net *net = read_pnet(&basechain->pnet);
-
        if (basechain->flags & NFT_BASECHAIN_DISABLED)
                return;
 
@@ -152,6 +150,7 @@ void nft_unregister_basechain(struct nft_base_chain *basechain,
 EXPORT_SYMBOL_GPL(nft_unregister_basechain);
 
 static int nf_tables_register_hooks(const struct nft_table *table,
+                                   struct net *net,
                                    struct nft_chain *chain,
                                    unsigned int hook_nops)
 {
@@ -159,10 +158,11 @@ static int nf_tables_register_hooks(const struct nft_table *table,
            !(chain->flags & NFT_BASE_CHAIN))
                return 0;
 
-       return nft_register_basechain(nft_base_chain(chain), hook_nops);
+       return nft_register_basechain(net, nft_base_chain(chain), hook_nops);
 }
 
 static void nf_tables_unregister_hooks(const struct nft_table *table,
+                                      struct net *net,
                                       struct nft_chain *chain,
                                       unsigned int hook_nops)
 {
@@ -170,7 +170,7 @@ static void nf_tables_unregister_hooks(const struct nft_table *table,
            !(chain->flags & NFT_BASE_CHAIN))
                return;
 
-       nft_unregister_basechain(nft_base_chain(chain), hook_nops);
+       nft_unregister_basechain(net, nft_base_chain(chain), hook_nops);
 }
 
 /* Internal table flags */
@@ -588,6 +588,7 @@ err:
 }
 
 static int nf_tables_table_enable(const struct nft_af_info *afi,
+                                 struct net *net,
                                  struct nft_table *table)
 {
        struct nft_chain *chain;
@@ -597,7 +598,7 @@ static int nf_tables_table_enable(const struct nft_af_info *afi,
                if (!(chain->flags & NFT_BASE_CHAIN))
                        continue;
 
-               err = nft_register_basechain(nft_base_chain(chain), afi->nops);
+               err = nft_register_basechain(net, nft_base_chain(chain), afi->nops);
                if (err < 0)
                        goto err;
 
@@ -612,19 +613,20 @@ err:
                if (i-- <= 0)
                        break;
 
-               nft_unregister_basechain(nft_base_chain(chain), afi->nops);
+               nft_unregister_basechain(net, nft_base_chain(chain), afi->nops);
        }
        return err;
 }
 
 static void nf_tables_table_disable(const struct nft_af_info *afi,
+                                   struct net *net,
                                    struct nft_table *table)
 {
        struct nft_chain *chain;
 
        list_for_each_entry(chain, &table->chains, list) {
                if (chain->flags & NFT_BASE_CHAIN)
-                       nft_unregister_basechain(nft_base_chain(chain),
+                       nft_unregister_basechain(net, nft_base_chain(chain),
                                                 afi->nops);
        }
 }
@@ -655,7 +657,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
                nft_trans_table_enable(trans) = false;
        } else if (!(flags & NFT_TABLE_F_DORMANT) &&
                   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-               ret = nf_tables_table_enable(ctx->afi, ctx->table);
+               ret = nf_tables_table_enable(ctx->afi, ctx->net, ctx->table);
                if (ret >= 0) {
                        ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
                        nft_trans_table_enable(trans) = true;
@@ -1426,7 +1428,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
                        rcu_assign_pointer(basechain->stats, stats);
                }
 
-               write_pnet(&basechain->pnet, net);
                basechain->type = type;
                chain = &basechain->chain;
 
@@ -1458,7 +1459,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
        chain->table = table;
        nla_strlcpy(chain->name, name, NFT_CHAIN_MAXNAMELEN);
 
-       err = nf_tables_register_hooks(table, chain, afi->nops);
+       err = nf_tables_register_hooks(table, net, chain, afi->nops);
        if (err < 0)
                goto err1;
 
@@ -1471,7 +1472,7 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
        list_add_tail_rcu(&chain->list, &table->chains);
        return 0;
 err2:
-       nf_tables_unregister_hooks(table, chain, afi->nops);
+       nf_tables_unregister_hooks(table, net, chain, afi->nops);
 err1:
        nf_tables_chain_destroy(chain);
        return err;
@@ -3911,6 +3912,7 @@ static int nf_tables_commit(struct sk_buff *skb)
                        if (nft_trans_table_update(trans)) {
                                if (!nft_trans_table_enable(trans)) {
                                        nf_tables_table_disable(trans->ctx.afi,
+                                                               net,
                                                                trans->ctx.table);
                                        trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
                                }
@@ -3935,6 +3937,7 @@ static int nf_tables_commit(struct sk_buff *skb)
                case NFT_MSG_DELCHAIN:
                        nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
                        nf_tables_unregister_hooks(trans->ctx.table,
                                                   trans->ctx.afi->nops);
                        break;
@@ -4037,6 +4040,7 @@ static int nf_tables_abort(struct sk_buff *skb)
                        if (nft_trans_table_update(trans)) {
                                if (nft_trans_table_enable(trans)) {
                                        nf_tables_table_disable(trans->ctx.afi,
+                                                               net,
                                                                trans->ctx.table);
                                        trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
                                }
@@ -4059,6 +4063,7 @@ static int nf_tables_abort(struct sk_buff *skb)
                                trans->ctx.table->use--;
                                list_del_rcu(&trans->ctx.chain->list);
                                nf_tables_unregister_hooks(trans->ctx.table,
+                                                          net,
                                                           trans->ctx.chain,
                                                           trans->ctx.afi->nops);
                        }
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 5f23b86..5928fa1 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -112,7 +112,6 @@ unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
        const struct nft_chain *chain = priv, *basechain = chain;
-       const struct net *net = read_pnet(&nft_base_chain(basechain)->pnet);
        const struct nft_rule *rule;
        const struct nft_expr *expr, *last;
        struct nft_regs regs;
@@ -120,7 +119,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
        struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
        struct nft_stats *stats;
        int rulenum;
-       unsigned int gencursor = nft_genmask_cur(net);
+       unsigned int gencursor = nft_genmask_cur(pkt->net);
 
 do_chain:
        rulenum = 0;
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 7b9c053..e72f119 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -171,7 +171,7 @@ static void nft_netdev_event(unsigned long event, struct nft_af_info *afi,
                basechain->ops[0].dev = dev;
                basechain->flags &= ~NFT_BASECHAIN_DISABLED;
                if (!(table->flags & NFT_TABLE_F_DORMANT))
-                       nft_register_basechain(basechain, afi->nops);
+                       nft_register_basechain(dev_net(dev), basechain, afi->nops);
                break;
        case NETDEV_UNREGISTER:
                if (strcmp(basechain->dev_name, dev->name) != 0)
@@ -180,7 +180,7 @@ static void nft_netdev_event(unsigned long event, struct nft_af_info *afi,
                BUG_ON(basechain->flags & NFT_BASECHAIN_DISABLED);
 
                if (!(table->flags & NFT_TABLE_F_DORMANT))
-                       nft_unregister_basechain(basechain, afi->nops);
+                       nft_unregister_basechain(dev_net(dev), basechain, afi->nops);
 
                dev_put(basechain->ops[0].dev);
                basechain->ops[0].dev = NULL;

Andreas
