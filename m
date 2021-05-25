Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E57C47086
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52AFC610A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhEYUxw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 16:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhEYUxv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 16:53:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2B3C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2021 13:52:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lle2F-0007Ut-VB; Tue, 25 May 2021 22:52:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: nf_tables: include table and chain name when dumping hooks
Date:   Tue, 25 May 2021 22:51:33 +0200
Message-Id: <20210525205133.5718-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210525205133.5718-1-fw@strlen.de>
References: <20210525205133.5718-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For ip(6)tables, the function names will show 'raw', 'mangle',
and so on, but for nf_tables the interpreter name is identical for all
base chains in the same family, so its not easy to line up the defined
chains with the hook function name.

To make it easier to see how the ruleset lines up with the defined
hooks, extend the hook dump to include the chain+table name.

Example list:
family ip hook input {
  -0000000150 iptable_mangle_hook [iptable_mangle]
  +0000000000 nft_do_chain_inet [nf_tables]  # nft table filter chain input
 [..]                                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 25 +++++++++++
 net/netfilter/nf_tables_api.c            | 53 ++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ba6545a32e34..099fad689311 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -149,6 +149,7 @@ enum nft_list_attributes {
  * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
  * @NFTA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
  * @NFTA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
+ * @NFTA_HOOK_CHAIN_INFO: basechain hook metadata (NLA_NESTED)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
@@ -158,10 +159,34 @@ enum nft_hook_attributes {
 	NFTA_HOOK_DEVS,
 	NFTA_HOOK_FUNCTION_NAME,
 	NFTA_HOOK_MODULE_NAME,
+	NFTA_HOOK_CHAIN_INFO,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
 
+/**
+ * enum nft_chain_info_attributes - chain description
+ *
+ * NFTA_CHAIN_INFO_DESC: chain and table name (enum nft_table_attributes) (NLA_NESTED)
+ * NFTA_CHAIN_INFO_TYPE: chain type (enum nf_chain_type) (NLA_U32)
+ */
+enum nft_chain_info_attributes {
+	NFTA_CHAIN_INFO_UNSPEC,
+	NFTA_CHAIN_INFO_DESC,
+	NFTA_CHAIN_INFO_TYPE,
+	__NFTA_CHAIN_INFO_MAX,
+};
+#define NFTA_CHAIN_INFO_MAX (__NFTA_CHAIN_INFO_MAX - 1)
+
+/**
+ * enum nft_chain_info_attributes - chain description
+ *
+ * @NF_CHAININFO_TYPE_NF_TABLES nf_tables base chain
+ */
+enum nf_chaininfo_type {
+	NF_CHAININFO_TYPE_NF_TABLES = 0x1,
+};
+
 /**
  * enum nft_table_flags - nf_tables table flags
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e7e80c8ee123..d58e4b39efe1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7979,6 +7979,55 @@ struct nft_dump_hooks_data {
 	u8 hook;
 };
 
+static int nla_put_chain_hook_info(struct sk_buff *nlskb, const struct nft_dump_hooks_data *ctx,
+				   const struct nf_hook_ops *ops)
+{
+	struct net *net = sock_net(nlskb->sk);
+	struct nlattr *nest, *nest2;
+	struct nft_chain *chain;
+	int ret = 0;
+
+	if (ops->hook_ops_type != NF_HOOK_OP_NF_TABLES)
+		return 0;
+
+	chain = ops->priv;
+
+	if (WARN_ON_ONCE(!chain))
+		return 0;
+
+	if (!nft_is_active(net, chain))
+		return 0;
+
+	nest = nla_nest_start(nlskb, NFTA_HOOK_CHAIN_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	ret = nla_put_be32(nlskb, NFTA_CHAIN_INFO_TYPE,
+			   htonl(NF_CHAININFO_TYPE_NF_TABLES));
+	if (ret)
+		goto cancel_nest;
+
+	nest2 = nla_nest_start(nlskb, NFTA_CHAIN_INFO_DESC);
+	if (!nest2)
+		goto cancel_nest;
+
+	ret = nla_put_string(nlskb, NFTA_CHAIN_TABLE, chain->table->name);
+	if (ret)
+		goto cancel_nest;
+
+	ret = nla_put_string(nlskb, NFTA_CHAIN_NAME, chain->name);
+	if (ret)
+		goto cancel_nest;
+
+	nla_nest_end(nlskb, nest2);
+	nla_nest_end(nlskb, nest);
+	return ret;
+
+cancel_nest:
+	nla_nest_cancel(nlskb, nest);
+	return -EMSGSIZE;
+}
+
 static int nf_tables_dump_one_hook(struct sk_buff *nlskb,
 				   const struct nft_dump_hooks_data *ctx,
 				   const struct nf_hook_ops *ops)
@@ -8014,6 +8063,10 @@ static int nf_tables_dump_one_hook(struct sk_buff *nlskb,
 	if (ret)
 		goto nla_put_failure;
 
+	ret = nla_put_chain_hook_info(nlskb, ctx, ops);
+	if (ret)
+		goto nla_put_failure;
+
 	nlmsg_end(nlskb, nlh);
 	return 0;
 nla_put_failure:
-- 
2.26.3

