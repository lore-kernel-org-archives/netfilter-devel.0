Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F1EC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 13:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKINEN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 08:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKINEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 08:04:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 026F5C35
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 05:04:10 -0800 (PST)
Date:   Wed, 9 Nov 2022 14:04:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3] netfilter: nf_tables: add support to destroy
 operation
Message-ID: <Y2ulROgS20ef92+i@salvia>
References: <20221029085940.10307-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wrkumxWkfAVx8dt7"
Content-Disposition: inline
In-Reply-To: <20221029085940.10307-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wrkumxWkfAVx8dt7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, Oct 29, 2022 at 10:59:40AM +0200, Fernando Fernandez Mancera wrote:
> Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
> delete operation but ignoring the ENOENT errors.

A made a few comestic updates, then I realize we also need to handle
this from the command and abort paths. We also might need to update
the _notify() functions to report the destroy events to userspace
(that is still missing in the patch that I'm attaching).

I think this is almost there but it needs a bit more work.

Note, this patch applies on top of latests Phil's update on nf-next.

--wrkumxWkfAVx8dt7
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nf_tables-add-support-to-destroy-operation.patch"

From 3d4cd6ec426909cae841da5e97d5a2c8253ce840 Mon Sep 17 00:00:00 2001
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
Date: Sat, 29 Oct 2022 10:59:40 +0200
Subject: [PATCH] netfilter: nf_tables: add support to destroy operation

Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
delete operation but ignoring the ENOENT errors.

This is useful for the transaction semantics, where failing to delete an
object which does not exist results in aborting the transaction.

This new command allows the transaction to proceed in case the object
does not exist.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 14 ++++
 net/netfilter/nf_tables_api.c            | 95 ++++++++++++++++++++++++
 2 files changed, 109 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index cfa844da1ce6..ff677f3a6cad 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -98,6 +98,13 @@ enum nft_verdicts {
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
+ * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
+ * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
+ * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
+ * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
+ * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
+ * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -126,6 +133,13 @@ enum nf_tables_msg_types {
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
 	NFT_MSG_GETRULE_RESET,
+	NFT_MSG_DESTROYTABLE,
+	NFT_MSG_DESTROYCHAIN,
+	NFT_MSG_DESTROYRULE,
+	NFT_MSG_DESTROYSET,
+	NFT_MSG_DESTROYSETELEM,
+	NFT_MSG_DESTROYOBJ,
+	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 80e613405f6f..1dac9511f565 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1389,6 +1389,10 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(table)) {
+		if (PTR_ERR(table) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYTABLE)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(table);
 	}
@@ -2627,6 +2631,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, attr, genmask);
 	}
 	if (IS_ERR(chain)) {
+		if (PTR_ERR(chain) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(chain);
 	}
@@ -3717,6 +3725,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		if (nla[NFTA_RULE_HANDLE]) {
 			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
+					return 0;
+
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 				return PTR_ERR(rule);
 			}
@@ -3725,6 +3737,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		} else if (nla[NFTA_RULE_ID]) {
 			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
+					return 0;
+
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);
 			}
@@ -4729,6 +4745,10 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(set)) {
+		if (PTR_ERR(set) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSET)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(set);
 	}
@@ -6609,6 +6629,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
+		if (err == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
+			continue;
+
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
@@ -7253,6 +7277,10 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(obj)) {
+		if (PTR_ERR(obj) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYOBJ)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(obj);
 	}
@@ -7883,6 +7911,10 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	}
 
 	if (IS_ERR(flowtable)) {
+		if (PTR_ERR(flowtable) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYFLOWTABLE)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(flowtable);
 	}
@@ -8292,6 +8324,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
+	[NFT_MSG_DESTROYTABLE] = {
+		.call		= nf_tables_deltable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_table_policy,
+	},
 	[NFT_MSG_NEWCHAIN] = {
 		.call		= nf_tables_newchain,
 		.type		= NFNL_CB_BATCH,
@@ -8310,6 +8348,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
+	[NFT_MSG_DESTROYCHAIN] = {
+		.call		= nf_tables_delchain,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_CHAIN_MAX,
+		.policy		= nft_chain_policy,
+	},
 	[NFT_MSG_NEWRULE] = {
 		.call		= nf_tables_newrule,
 		.type		= NFNL_CB_BATCH,
@@ -8334,6 +8378,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
+	[NFT_MSG_DESTROYRULE] = {
+		.call		= nf_tables_delrule,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
 	[NFT_MSG_NEWSET] = {
 		.call		= nf_tables_newset,
 		.type		= NFNL_CB_BATCH,
@@ -8352,6 +8402,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
+	[NFT_MSG_DESTROYSET] = {
+		.call		= nf_tables_delset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
 	[NFT_MSG_NEWSETELEM] = {
 		.call		= nf_tables_newsetelem,
 		.type		= NFNL_CB_BATCH,
@@ -8370,6 +8426,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_DESTROYSETELEM] = {
+		.call		= nf_tables_delsetelem,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
 	[NFT_MSG_GETGEN] = {
 		.call		= nf_tables_getgen,
 		.type		= NFNL_CB_RCU,
@@ -8392,6 +8454,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
+	[NFT_MSG_DESTROYOBJ] = {
+		.call		= nf_tables_delobj,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
 	[NFT_MSG_GETOBJ_RESET] = {
 		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
@@ -8416,6 +8484,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
+	[NFT_MSG_DESTROYFLOWTABLE] = {
+		.call		= nf_tables_delflowtable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_FLOWTABLE_MAX,
+		.policy		= nft_flowtable_policy,
+	},
 };
 
 static int nf_tables_validate(struct net *net)
@@ -8509,6 +8583,7 @@ static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
+	case NFT_MSG_DESTROYTABLE:
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
@@ -8516,26 +8591,32 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DESTROYCHAIN:
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
+	case NFT_MSG_DESTROYRULE:
 		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
+	case NFT_MSG_DESTROYSET:
 		nft_set_destroy(&trans->ctx, nft_trans_set(trans));
 		break;
 	case NFT_MSG_DELSETELEM:
+	case NFT_MSG_DESTROYSETELEM:
 		nf_tables_set_elem_destroy(&trans->ctx,
 					   nft_trans_elem_set(trans),
 					   nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
+	case NFT_MSG_DESTROYOBJ:
 		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
 		break;
 	case NFT_MSG_DELFLOWTABLE:
+	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
 			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
@@ -8987,6 +9068,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
+		case NFT_MSG_DESTROYTABLE:
 			list_del_rcu(&trans->ctx.table->list);
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_DELTABLE);
 			break;
@@ -9003,6 +9085,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
+		case NFT_MSG_DESTROYCHAIN:
 			nft_chain_del(trans->ctx.chain);
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
 			nf_tables_unregister_hook(trans->ctx.net,
@@ -9020,6 +9103,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELRULE:
+		case NFT_MSG_DESTROYRULE:
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
@@ -9042,6 +9126,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
 			list_del_rcu(&nft_trans_set(trans)->list);
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_DELSET, GFP_KERNEL);
@@ -9056,6 +9141,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
+		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
 			nf_tables_setelem_notify(&trans->ctx, te->set,
@@ -9082,6 +9168,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
+		case NFT_MSG_DESTROYOBJ:
 			nft_obj_del(nft_trans_obj(trans));
 			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
 					     NFT_MSG_DELOBJ);
@@ -9106,6 +9193,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
+		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
@@ -9214,6 +9302,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELTABLE:
+		case NFT_MSG_DESTROYTABLE:
 			nft_clear(trans->ctx.net, trans->ctx.table);
 			nft_trans_destroy(trans);
 			break;
@@ -9235,6 +9324,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
+		case NFT_MSG_DESTROYCHAIN:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, trans->ctx.chain);
 			nft_trans_destroy(trans);
@@ -9249,6 +9339,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
+		case NFT_MSG_DESTROYRULE:
 			trans->ctx.chain->use++;
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
@@ -9266,6 +9357,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
 			nft_trans_destroy(trans);
@@ -9281,6 +9373,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				atomic_dec(&te->set->nelems);
 			break;
 		case NFT_MSG_DELSETELEM:
+		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
 			nft_setelem_data_activate(net, te->set, &te->elem);
@@ -9300,6 +9393,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
+		case NFT_MSG_DESTROYOBJ:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_obj(trans));
 			nft_trans_destroy(trans);
@@ -9316,6 +9410,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELFLOWTABLE:
+		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				list_splice(&nft_trans_flowtable_hooks(trans),
 					    &nft_trans_flowtable(trans)->hook_list);
-- 
2.30.2


--wrkumxWkfAVx8dt7--
