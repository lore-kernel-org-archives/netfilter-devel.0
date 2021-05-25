Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CA1C47086
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B63EC610A0
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 20:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhEYUxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 16:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhEYUxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 16:53:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F2EC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 May 2021 13:52:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lle27-0007U2-1Z; Tue, 25 May 2021 22:52:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: nf_tables: include function and module name in hook dumps
Date:   Tue, 25 May 2021 22:51:31 +0200
Message-Id: <20210525205133.5718-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210525205133.5718-1-fw@strlen.de>
References: <20210525205133.5718-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If KALLSYMS are available, include the hook function name and the
module name that registered the hook.

This avoids need to manually annotate all existing hooks.

Example output:
family ip hook prerouting {
        -0000000300 iptable_raw_hook [iptable_raw]
        -0000000150 iptable_mangle_hook [iptable_mangle]
        -0000000100 nf_nat_ipv4_pre_routing [nf_nat]
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h                |  4 ++++
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/core.c                     |  6 ++++++
 net/netfilter/nf_tables_api.c            | 13 +++++++++++++
 4 files changed, 27 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f0f3a8354c3c..63f77794f5ed 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -195,6 +195,10 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 
 void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 		       const struct nf_hook_entries *e);
+
+bool nf_get_hook_info(const struct nf_hook_ops *ops,
+		      char fn[KSYM_NAME_LEN], char **module_name);
+
 /**
  *	nf_hook - call a netfilter hook
  *
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5810e41eff33..ba6545a32e34 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -147,6 +147,8 @@ enum nft_list_attributes {
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
  * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
+ * @NFTA_HOOK_FUNCTION_NAME: hook function name (NLA_STRING)
+ * @NFTA_HOOK_MODULE_NAME: kernel module that registered this hook (NLA_STRING)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
@@ -154,6 +156,8 @@ enum nft_hook_attributes {
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
 	NFTA_HOOK_DEVS,
+	NFTA_HOOK_FUNCTION_NAME,
+	NFTA_HOOK_MODULE_NAME,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 63d032191e62..d14715c568c8 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -749,6 +749,12 @@ static struct pernet_operations netfilter_net_ops = {
 	.exit = netfilter_net_exit,
 };
 
+bool nf_get_hook_info(const struct nf_hook_ops *ops, char fn[KSYM_NAME_LEN], char **modname)
+{
+	return kallsyms_lookup((unsigned long)ops->hook, NULL, NULL, modname, fn);
+}
+EXPORT_SYMBOL_GPL(nf_get_hook_info);
+
 int __init netfilter_init(void)
 {
 	int ret;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5c9e372e3814..899a38615f46 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7983,6 +7983,7 @@ static int nf_tables_dump_one_hook(struct sk_buff *nlskb,
 {
 	unsigned int portid = NETLINK_CB(nlskb).portid;
 	struct net *net = sock_net(nlskb->sk);
+	char *module_name, fn[KSYM_NAME_LEN];
 	struct nlmsghdr *nlh;
 	int ret = -EMSGSIZE;
 
@@ -7991,6 +7992,18 @@ static int nf_tables_dump_one_hook(struct sk_buff *nlskb,
 	if (!nlh)
 		goto nla_put_failure;
 
+	if (nf_get_hook_info(ops, fn, &module_name)) {
+		ret = nla_put_string(nlskb, NFTA_HOOK_FUNCTION_NAME, fn);
+		if (ret)
+			goto nla_put_failure;
+
+		if (module_name) {
+			ret = nla_put_string(nlskb, NFTA_HOOK_MODULE_NAME, module_name);
+			if (ret)
+				goto nla_put_failure;
+		}
+	}
+
 	ret = nla_put_be32(nlskb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum));
 	if (ret)
 		goto nla_put_failure;
-- 
2.26.3

