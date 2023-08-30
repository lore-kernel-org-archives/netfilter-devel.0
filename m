Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943ABC83F1A
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 23:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbjH3X7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344570AbjH3X7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 19:59:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBAFCCCF;
        Wed, 30 Aug 2023 16:59:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/5] netfilter: nf_tables: Audit log setelem reset
Date:   Thu, 31 Aug 2023 01:59:34 +0200
Message-Id: <20230830235935.465690-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230830235935.465690-1-pablo@netfilter.org>
References: <20230830235935.465690-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Since set element reset is not integrated into nf_tables' transaction
logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESET
handling.

For the sake of simplicity, catchall element reset will always generate
a dedicated log entry. This relieves nf_tables_dump_set() from having to
adjust the logged element count depending on whether a catchall element
was found or not.

Fixes: 079cd633219d7 ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/audit.h         |  1 +
 kernel/auditsc.c              |  1 +
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++---
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6a3a9e122bb5..192bf03aacc5 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -117,6 +117,7 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_OBJ_RESET,
 	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+	AUDIT_NFT_OP_SETELEM_RESET,
 	AUDIT_NFT_OP_INVALID,
 };
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index addeed3df15d..38481e318197 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -143,6 +143,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
 	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
 	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
 	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
+	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
 	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 41b826dff6f5..361e98e71692 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -102,6 +102,7 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 	[NFT_MSG_NEWFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	[NFT_MSG_GETFLOWTABLE]	= AUDIT_NFT_OP_INVALID,
 	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
+	[NFT_MSG_GETSETELEM_RESET] = AUDIT_NFT_OP_SETELEM_RESET,
 };
 
 static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
@@ -5624,13 +5625,25 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
 }
 
+static void audit_log_nft_set_reset(const struct nft_table *table,
+				    unsigned int base_seq,
+				    unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_SETELEM_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_set_dump_ctx {
 	const struct nft_set	*set;
 	struct nft_ctx		ctx;
 };
 
 static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
-				 const struct nft_set *set, bool reset)
+				 const struct nft_set *set, bool reset,
+				 unsigned int base_seq)
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_cur(net);
@@ -5646,6 +5659,8 @@ static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
 
 		elem.priv = catchall->elem;
 		ret = nf_tables_fill_setelem(skb, set, &elem, reset);
+		if (reset && !ret)
+			audit_log_nft_set_reset(set->table, base_seq, 1);
 		break;
 	}
 
@@ -5725,12 +5740,17 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
 
 	if (!args.iter.err && args.iter.count == cb->args[0])
-		args.iter.err = nft_set_catchall_dump(net, skb, set, reset);
+		args.iter.err = nft_set_catchall_dump(net, skb, set,
+						      reset, cb->seq);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
 
+	if (reset && args.iter.count > args.iter.skip)
+		audit_log_nft_set_reset(table, cb->seq,
+					args.iter.count - args.iter.skip);
+
 	if (args.iter.err && args.iter.err != -EMSGSIZE)
 		return args.iter.err;
 	if (args.iter.count == cb->args[0])
@@ -5955,13 +5975,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
+	int rem, err = 0, nelems = 0;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
 	bool reset = false;
-	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
 				 genmask, 0);
@@ -6004,8 +6024,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 			NL_SET_BAD_ATTR(extack, attr);
 			break;
 		}
+		nelems++;
 	}
 
+	if (reset)
+		audit_log_nft_set_reset(table, nft_pernet(net)->base_seq,
+					nelems);
+
 	return err;
 }
 
-- 
2.30.2

