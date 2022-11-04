Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E9AC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Nov 2022 22:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKDWSm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKDWSl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Nov 2022 18:18:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5BE2CE33
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Nov 2022 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=o3pQULTiOngsLUrCR4qn1rD1ltwAfMnv4CGC4wHIoNE=; b=XfJ+pwp7me41nY9xNoYSJHmBrr
        +IEymQBsfQP/4aTjS51qKV/n23DxJwv7opNIpRbq3rMEm43YPj82wB1wkqeYLvk/zt3h/qaV7UEhg
        l6D0MOFSl5kMdy+tPU57s1xt0p9E3tj+4ofkeZuoVq97kTNmiGWHJsMw+if9KzwDmzk+9S7mIeowS
        5UCx64PIK/BaJkMO0e4Hj5RTEbAlvvPoRL1V/+PmMAX9IDuBR7V5m/pFGpInzJW7jYMdf05PeHZh9
        Y4vvRFV0cwj4cx/X+Pb/E6aofNtiDI1NztIxfBgAJkpl4onoXiUpQZW3FHML4q0dUY2IBwi1VqLLE
        ylGoFWFQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1or51I-0007iH-LH; Fri, 04 Nov 2022 23:18:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [nf-next RFC] netfilter: nf_tables: Compatibility interface for nft_rule
Date:   Fri,  4 Nov 2022 23:18:27 +0100
Message-Id: <20221104221827.30335-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept extra expressions from user space which should replace active
one(s) when the rule is being dumped. Each of those expressions
specifies the index of the first expression to replace, the number of
consecutive expressions it replaces and a blob of data to dump. While
the latter should adhere to the expected NFTA_LIST_ELEM content format,
the kernel actually treats it as opaque data and therefore may not even
support the expression type being dumped.

The practical application of this is to enable iptables-nft to use
native nftables expressions while still maintaining compatibility
towards older versions not expecting (or correctly parsing) them.

Here's the effect in practice with a customized iptables-nft. First add
a rule with two matches that had been converted already, netlink dump
shows the native expressions used:

| # iptables-nft -vv -A FORWARD -m limit --limit 3/hour -m mark --mark 0x23/0x42
|   all opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0   limit: avg 3/hour burst 5 mark match 0x23/0x42
| table filter ip flags 0 use 0 handle 0
| ip filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0
| ip filter FORWARD
|   [ limit rate 3/hour burst 5 type packets flags 0x0 ]
|   [ meta load mark => reg 1 ]
|   [ bitwise reg 1 = ( reg 1 & 0x00000042 ) ^ 0x00000000 ]
|   [ cmp eq reg 1 0x00000023 ]
|   [ counter pkts 0 bytes 0 ]

Listing the rule shows how the previously attached compat expressions
replaced the native code in output:

| # iptables-nft -vv -S
| ip filter FORWARD 2
|   [ match name limit rev 0 ]
|   [ match name mark rev 1 ]
|   [ counter pkts 0 bytes 0 ]
|
| -P INPUT ACCEPT -c 0 0
| -P FORWARD ACCEPT -c 0 0
| -P OUTPUT ACCEPT -c 0 0
| -A FORWARD -m limit --limit 3/hour -m mark --mark 0x23/0x42 -c 0 0

Note also how the rule is correctly interpreted since iptables-nft
continues to support the legacy limit and mark match extensions.

This patch should have relatively low impact if not in use: struct
nft_rule increases by one pointer which has to be checked upon dumping
or freeing of the rule.

Disclaimer: This is not the much simpler "attach the rule as text" we
discussed, but I would like to at least propose it since it works for
existing releases.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        |   8 ++
 include/uapi/linux/netfilter/nf_tables.h |  18 ++++
 net/netfilter/nf_tables_api.c            | 129 ++++++++++++++++++++++-
 3 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e252..cf00753b1446e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -939,6 +939,13 @@ struct nft_expr_ops {
 	void				*data;
 };
 
+struct nft_compat_expr {
+        int pos;
+        int len;
+        int dlen;
+        void *data;
+};
+
 /**
  *	struct nft_rule - nf_tables rule
  *
@@ -951,6 +958,7 @@ struct nft_expr_ops {
  */
 struct nft_rule {
 	struct list_head		list;
+	struct nft_compat_expr		*compat_exprs;
 	u64				handle:42,
 					genmask:2,
 					dlen:12,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c2..c8c0f1b2bd395 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -278,15 +278,33 @@ enum nft_rule_compat_flags {
  *
  * @NFTA_RULE_COMPAT_PROTO: numeric value of handled protocol (NLA_U32)
  * @NFTA_RULE_COMPAT_FLAGS: bitmask of enum nft_rule_compat_flags (NLA_U32)
+ * @NFTA_RULE_COMPAT_EXPRESSIONS: Replacement expressions in dumps (NLA_NESTED)
  */
 enum nft_rule_compat_attributes {
 	NFTA_RULE_COMPAT_UNSPEC,
 	NFTA_RULE_COMPAT_PROTO,
 	NFTA_RULE_COMPAT_FLAGS,
+	NFTA_RULE_COMPAT_EXPRESSIONS,
 	__NFTA_RULE_COMPAT_MAX
 };
 #define NFTA_RULE_COMPAT_MAX	(__NFTA_RULE_COMPAT_MAX - 1)
 
+/**
+ * enum nft_rule_compat_expression - compat expression data
+ *
+ * @NFTA_RULE_COMPAT_EXPR_POS: index of expression this replaces (NLA_U32)
+ * @NFTA_RULE_COMPAT_EXPR_LEN: number of expressions this replaces (NLA_U32)
+ * @NFTA_RULE_COMPAT_EXPR_INFO: expression blob to dump (NLA_BINARY)
+ */
+enum nft_rule_compat_expression {
+	NFTA_RULE_COMPAT_EXPR_UNSPEC,
+	NFTA_RULE_COMPAT_EXPR_POS,
+	NFTA_RULE_COMPAT_EXPR_LEN,
+	NFTA_RULE_COMPAT_EXPR_INFO,
+	__NFTA_RULE_COMPAT_EXPR_MAX
+};
+#define NFTA_RULE_COMPAT_EXPR_MAX	(__NFTA_RULE_COMPAT_EXPR_MAX - 1)
+
 /**
  * enum nft_set_flags - nf_tables set flags
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a0653a8dfa827..3a867a52bc3ad 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_tables_compat.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
@@ -2992,6 +2993,36 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_CHAIN_ID]	= { .type = NLA_U32 },
 };
 
+static int nft_rule_dump_compat_exprs(struct sk_buff *skb,
+				      const struct nft_rule *rule)
+{
+	const struct nft_compat_expr *cur = rule->compat_exprs;
+	const struct nft_expr *expr, *next;
+	int expr_idx = -1, skip = 0;
+
+	nft_rule_for_each_expr(expr, next, rule) {
+		expr_idx++;
+
+		if (skip) {
+			skip--;
+			continue;
+		}
+
+		if (!cur->len || expr_idx != cur->pos) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+				return -1;
+			continue;
+		}
+
+		if (nla_put(skb, NFTA_LIST_ELEM, cur->dlen, cur->data) < 0)
+			return -1;
+
+		skip = cur->len - 1;
+		cur++;
+	}
+	return 0;
+}
+
 static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 portid, u32 seq, int event,
 				    u32 flags, int family,
@@ -3029,9 +3060,14 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
 	if (list == NULL)
 		goto nla_put_failure;
-	nft_rule_for_each_expr(expr, next, rule) {
-		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+	if (rule->compat_exprs) {
+		if (nft_rule_dump_compat_exprs(skb, rule) < 0)
 			goto nla_put_failure;
+	} else {
+		nft_rule_for_each_expr(expr, next, rule) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+				goto nla_put_failure;
+		}
 	}
 	nla_nest_end(skb, list);
 
@@ -3318,6 +3354,15 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 		nf_tables_expr_destroy(ctx, expr);
 		expr = next;
 	}
+	if (rule->compat_exprs) {
+		struct nft_compat_expr *cur = rule->compat_exprs;
+
+		while (cur->len) {
+			kfree(cur->data);
+			cur++;
+		}
+		kfree(rule->compat_exprs);
+	}
 	kfree(rule);
 }
 
@@ -3385,12 +3430,83 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 
 #define NFT_RULE_MAXEXPRS	128
 
+static const struct nla_policy
+nft_rule_compat_expression_policy[NFTA_RULE_COMPAT_EXPR_MAX + 1] = {
+	[NFTA_RULE_COMPAT_EXPR_POS]	= { .type = NLA_U32 },
+	[NFTA_RULE_COMPAT_EXPR_LEN]	= { .type = NLA_U32 },
+	[NFTA_RULE_COMPAT_EXPR_INFO]	= { .type = NLA_BINARY },
+};
+
+static struct nft_compat_expr *
+nft_parse_compat_exprs_nla(const struct nlattr *nla)
+{
+	struct nft_compat_expr *compat_exprs, *cur;
+	int idx = 0, num_exprs = 0;
+	struct nlattr *tmp;
+	int err, rem;
+
+	nla = nla_find_nested(nla, NFTA_RULE_COMPAT_EXPRESSIONS);
+	if (!nla)
+		return NULL;
+
+	nla_for_each_nested(tmp, nla, rem)
+		num_exprs++;
+
+	if (!num_exprs)
+		return NULL;
+
+	compat_exprs = kvmalloc_array(num_exprs + 1,
+				      sizeof(*compat_exprs), GFP_KERNEL);
+	if (!compat_exprs)
+		return ERR_PTR(-ENOMEM);
+
+	cur = compat_exprs;
+	nla_for_each_nested(tmp, nla, rem) {
+		struct nlattr *tb[NFTA_RULE_COMPAT_EXPR_MAX + 1];
+		int err;
+
+		if (idx >= NFT_RULE_MAXEXPRS)
+			return ERR_PTR(-ENOMEM);
+
+		err = nla_parse_nested_deprecated(tb, NFTA_RULE_COMPAT_EXPR_MAX,
+						  tmp, nft_rule_compat_expression_policy, NULL);
+		if (err < 0)
+			return ERR_PTR(err);
+
+		if (!tb[NFTA_RULE_COMPAT_EXPR_POS] ||
+		    !tb[NFTA_RULE_COMPAT_EXPR_LEN] ||
+		    !tb[NFTA_RULE_COMPAT_EXPR_INFO]) {
+			err = -EINVAL;
+			goto out_free;
+		}
+
+		cur->pos = nla_get_u32(tb[NFTA_RULE_COMPAT_EXPR_POS]);
+		cur->len = nla_get_u32(tb[NFTA_RULE_COMPAT_EXPR_LEN]);
+		cur->dlen = nla_len(tb[NFTA_RULE_COMPAT_EXPR_INFO]);
+		cur->data = kvmalloc(cur->dlen, GFP_KERNEL);
+		if (!cur->data) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		nla_memcpy(cur->data,
+			   tb[NFTA_RULE_COMPAT_EXPR_INFO], cur->dlen);
+		cur++;
+	}
+	cur->len = 0;
+	return compat_exprs;
+out_free:
+	kfree(compat_exprs);
+	return ERR_PTR(err);
+}
+
 static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	unsigned int size, i, n, ulen = 0, usize = 0;
+	struct nft_compat_expr *compat_exprs = NULL;
 	u8 genmask = nft_genmask_next(info->net);
 	struct nft_rule *rule, *old_rule = NULL;
 	struct nft_expr_info *expr_info = NULL;
@@ -3508,6 +3624,14 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (size >= 1 << 12)
 		goto err_release_expr;
 
+	if (nla[NFTA_RULE_COMPAT]) {
+		compat_exprs = nft_parse_compat_exprs_nla(nla[NFTA_RULE_COMPAT]);
+		if (IS_ERR(compat_exprs)) {
+			err = PTR_ERR(compat_exprs);
+			goto err_release_expr;
+		}
+	}
+
 	if (nla[NFTA_RULE_USERDATA]) {
 		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
 		if (ulen > 0)
@@ -3524,6 +3648,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	rule->handle = handle;
 	rule->dlen   = size;
 	rule->udata  = ulen ? 1 : 0;
+	rule->compat_exprs = compat_exprs;
 
 	if (ulen) {
 		udata = nft_userdata(rule);
-- 
2.38.0

