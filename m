Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E7EC77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 06:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjECGdA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 02:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjECGc7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 02:32:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BD941BCA;
        Tue,  2 May 2023 23:32:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
Date:   Wed,  3 May 2023 08:32:48 +0200
Message-Id: <20230503063250.13700-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230503063250.13700-1-pablo@netfilter.org>
References: <20230503063250.13700-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user does not specify hook number and priority, then assume this is
a chain/flowtable update. Therefore, report ENOENT which provides a
better hint than EINVAL. Set on extended netlink error report to refer
to the chain name.

Fixes: 5b6743fb2c2a ("netfilter: nf_tables: skip flowtable hooknum and priority on device updates")
Fixes: 5efe72698a97 ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 09542951656c..8b6c61a2196c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2075,8 +2075,10 @@ static int nft_chain_parse_hook(struct net *net,
 
 	if (!basechain) {
 		if (!ha[NFTA_HOOK_HOOKNUM] ||
-		    !ha[NFTA_HOOK_PRIORITY])
-			return -EINVAL;
+		    !ha[NFTA_HOOK_PRIORITY]) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_NAME]);
+			return -ENOENT;
+		}
 
 		hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 		hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
@@ -7693,7 +7695,7 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 };
 
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
-				    const struct nlattr *attr,
+				    const struct nlattr * const nla[],
 				    struct nft_flowtable_hook *flowtable_hook,
 				    struct nft_flowtable *flowtable,
 				    struct netlink_ext_ack *extack, bool add)
@@ -7705,15 +7707,18 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	INIT_LIST_HEAD(&flowtable_hook->list);
 
-	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
+	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX,
+					  nla[NFTA_FLOWTABLE_HOOK],
 					  nft_flowtable_hook_policy, NULL);
 	if (err < 0)
 		return err;
 
 	if (add) {
 		if (!tb[NFTA_FLOWTABLE_HOOK_NUM] ||
-		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY])
-			return -EINVAL;
+		    !tb[NFTA_FLOWTABLE_HOOK_PRIORITY]) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
+			return -ENOENT;
+		}
 
 		hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
 		if (hooknum != NF_NETDEV_INGRESS)
@@ -7898,8 +7903,8 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	u32 flags;
 	int err;
 
-	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, false);
+	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
+				       extack, false);
 	if (err < 0)
 		return err;
 
@@ -8044,8 +8049,8 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	if (err < 0)
 		goto err3;
 
-	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, true);
+	err = nft_flowtable_parse_hook(&ctx, nla, &flowtable_hook, flowtable,
+				       extack, true);
 	if (err < 0)
 		goto err4;
 
@@ -8107,8 +8112,8 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
-	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, extack, false);
+	err = nft_flowtable_parse_hook(ctx, nla, &flowtable_hook, flowtable,
+				       extack, false);
 	if (err < 0)
 		return err;
 
-- 
2.30.2

