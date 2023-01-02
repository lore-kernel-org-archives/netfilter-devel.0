Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3218EC3DA7A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 12:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjABMkm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 07:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjABMkl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 07:40:41 -0500
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5F46423
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 04:40:40 -0800 (PST)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4NlwSl3NYwz9t2L;
        Mon,  2 Jan 2023 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1672663239; bh=XNc5MWDqC9pVLTlq8TfuXW+HnYBVht79t8VKCiPqoxA=;
        h=From:To:Cc:Subject:Date:From;
        b=NG6lFw48aaHIhH8rjIM9rYnbuwwbDvq9WaFp1pFZ5CdZLJM4dkLIhqlhLfrUKM+9K
         FxFoVgZmjHxk+kktci2MsZ90G3EnSLpu6+RvcKUxYvEjXAh7m9rNuQcYmJ0YT0KLPB
         mZdmOuvwc7lHsQOz+7Vlo4UCUpmFjPkrNLKcZW3U=
X-Riseup-User-ID: D363601576E43AEAD435DFE9E54A6DF25D10F616B0D7D00D7E8CDA82EA04346E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4NlwSj6zB6z5vP3;
        Mon,  2 Jan 2023 12:40:37 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next v4] netfilter: nf_tables: add support to destroy operation
Date:   Mon,  2 Jan 2023 13:39:57 +0100
Message-Id: <20230102123957.1729-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
delete operation but ignoring the ENOENT errors.

This is useful for the transaction semantics, where failing to delete an
object which does not exist results in aborting the transaction.

This new command allows the transaction to proceed in case the object
does not exist.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: initial patch
v2: fix bug on rule destroy without handle
v3: adjust some lines length
v4: apply Pablo's changes and update the _notify() to report the destroy events to userspace.
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
index 832b881f7c17..2b59e6a5afd7 100644
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
@@ -3704,6 +3712,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
 					 genmask);
 		if (IS_ERR(chain)) {
+			if (PTR_ERR(rule) == -ENOENT &&
+			    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
+				return 0;
+
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
 		}
@@ -3717,6 +3729,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -6611,6 +6631,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
+		if (err == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
+			continue;
+
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
@@ -7255,6 +7279,10 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(obj)) {
+		if (PTR_ERR(obj) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYOBJ)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(obj);
 	}
@@ -7885,6 +7913,10 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	}
 
 	if (IS_ERR(flowtable)) {
+		if (PTR_ERR(flowtable) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYFLOWTABLE)
+			return 0;
+
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(flowtable);
 	}
@@ -8294,6 +8326,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8312,6 +8350,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8336,6 +8380,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8354,6 +8404,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8372,6 +8428,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8394,6 +8456,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8418,6 +8486,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8511,6 +8585,7 @@ static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
 	case NFT_MSG_DELTABLE:
+	case NFT_MSG_DESTROYTABLE:
 		nf_tables_table_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_NEWCHAIN:
@@ -8518,23 +8593,29 @@ static void nft_commit_release(struct nft_trans *trans)
 		kfree(nft_trans_chain_name(trans));
 		break;
 	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DESTROYCHAIN:
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
+	case NFT_MSG_DESTROYRULE:
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
@@ -8986,6 +9067,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELTABLE:
+		case NFT_MSG_DESTROYTABLE:
 			list_del_rcu(&trans->ctx.table->list);
 			nf_tables_table_notify(&trans->ctx, NFT_MSG_DELTABLE);
 			break;
@@ -9002,6 +9084,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
+		case NFT_MSG_DESTROYCHAIN:
 			nft_chain_del(trans->ctx.chain);
 			nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN);
 			nf_tables_unregister_hook(trans->ctx.net,
@@ -9019,6 +9102,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELRULE:
+		case NFT_MSG_DESTROYRULE:
 			list_del_rcu(&nft_trans_rule(trans)->list);
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
@@ -9044,6 +9128,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
 			list_del_rcu(&nft_trans_set(trans)->list);
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_DELSET, GFP_KERNEL);
@@ -9058,6 +9143,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
+		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
 			nf_tables_setelem_notify(&trans->ctx, te->set,
@@ -9084,6 +9170,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
+		case NFT_MSG_DESTROYOBJ:
 			nft_obj_del(nft_trans_obj(trans));
 			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
 					     NFT_MSG_DELOBJ);
@@ -9108,6 +9195,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELFLOWTABLE:
+		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
@@ -9216,6 +9304,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELTABLE:
+		case NFT_MSG_DESTROYTABLE:
 			nft_clear(trans->ctx.net, trans->ctx.table);
 			nft_trans_destroy(trans);
 			break;
@@ -9237,6 +9326,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELCHAIN:
+		case NFT_MSG_DESTROYCHAIN:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, trans->ctx.chain);
 			nft_trans_destroy(trans);
@@ -9251,6 +9341,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
+		case NFT_MSG_DESTROYRULE:
 			trans->ctx.chain->use++;
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
@@ -9268,6 +9359,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_set(trans));
 			nft_trans_destroy(trans);
@@ -9283,6 +9375,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				atomic_dec(&te->set->nelems);
 			break;
 		case NFT_MSG_DELSETELEM:
+		case NFT_MSG_DESTROYSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
 			nft_setelem_data_activate(net, te->set, &te->elem);
@@ -9302,6 +9395,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELOBJ:
+		case NFT_MSG_DESTROYOBJ:
 			trans->ctx.table->use++;
 			nft_clear(trans->ctx.net, nft_trans_obj(trans));
 			nft_trans_destroy(trans);
@@ -9318,6 +9412,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			}
 			break;
 		case NFT_MSG_DELFLOWTABLE:
+		case NFT_MSG_DESTROYFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
 				list_splice(&nft_trans_flowtable_hooks(trans),
 					    &nft_trans_flowtable(trans)->hook_list);
-- 
2.30.2

