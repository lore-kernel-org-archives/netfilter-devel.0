Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61E9C83F19
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 23:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbjH3X7r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245217AbjH3X7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 19:59:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FB61CD2;
        Wed, 30 Aug 2023 16:59:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/5] netfilter: nf_tables: Audit log rule reset
Date:   Thu, 31 Aug 2023 01:59:35 +0200
Message-Id: <20230830235935.465690-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230830235935.465690-1-pablo@netfilter.org>
References: <20230830235935.465690-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Resetting rules' stateful data happens outside of the transaction logic,
so 'get' and 'dump' handlers have to emit audit log entries themselves.

Fixes: 8daa8fde3fc3f ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/audit.h         |  1 +
 kernel/auditsc.c              |  1 +
 net/netfilter/nf_tables_api.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 192bf03aacc5..51b1b7054a23 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -118,6 +118,7 @@ enum audit_nfcfgop {
 	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
 	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 	AUDIT_NFT_OP_SETELEM_RESET,
+	AUDIT_NFT_OP_RULE_RESET,
 	AUDIT_NFT_OP_INVALID,
 };
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 38481e318197..fc0c7c03eeab 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -144,6 +144,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
 	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
 	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
 	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
+	{ AUDIT_NFT_OP_RULE_RESET,		"nft_reset_rule"           },
 	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 361e98e71692..2c81cee858d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3422,6 +3422,18 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
+static void audit_log_rule_reset(const struct nft_table *table,
+				 unsigned int base_seq,
+				 unsigned int nentries)
+{
+	char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
+			      table->name, base_seq);
+
+	audit_log_nfcfg(buf, table->family, nentries,
+			AUDIT_NFT_OP_RULE_RESET, GFP_ATOMIC);
+	kfree(buf);
+}
+
 struct nft_rule_dump_ctx {
 	char *table;
 	char *chain;
@@ -3528,6 +3540,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 done:
 	rcu_read_unlock();
 
+	if (reset && idx > cb->args[0])
+		audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
+
 	cb->args[0] = idx;
 	return skb->len;
 }
@@ -3635,6 +3650,9 @@ static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_fill_rule_info;
 
+	if (reset)
+		audit_log_rule_reset(table, nft_pernet(net)->base_seq, 1);
+
 	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
 err_fill_rule_info:
-- 
2.30.2

