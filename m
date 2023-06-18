Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278BBEB64D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jun 2023 14:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjFRO7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jun 2023 10:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjFRO7n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2023 10:59:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2106018D
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2023 07:59:40 -0700 (PDT)
Date:   Sun, 18 Jun 2023 16:59:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix for deleting base chains
 with payload
Message-ID: <ZI8b1ySlPjUucbdH@calendula>
References: <20230616155611.2468-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Gceh780nrvX56S4E"
Content-Disposition: inline
In-Reply-To: <20230616155611.2468-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Gceh780nrvX56S4E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Phil,

On Fri, Jun 16, 2023 at 05:56:11PM +0200, Phil Sutter wrote:
> When deleting a base chain, iptables-nft simply submits the whole chain
> to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
> added by fixed commit then turned this into a chain update, destroying
> the hook but not the chain itself.
> 
> Detect the situation by checking if the chain's hook list becomes empty
> after removing all submitted hooks from it. A base chain without hooks
> is pointless, so revert back to deleting the chain.
> 
> Note the 'goto err_chain_del_hook', error path takes care of undoing the
> hook_list modification and releasing the unused chain_hook.

Could you give a try to this alternative patch?

Thanks.

--Gceh780nrvX56S4E
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 99f2297f8792..1ebf3c6aba62 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2811,21 +2811,18 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
-static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
+static int nft_delchain_hook(struct nft_ctx *ctx,
+			     struct nft_base_chain *basechain,
 			     struct netlink_ext_ack *extack)
 {
+	const struct nft_chain *chain = &basechain->chain;
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_chain_hook chain_hook = {};
-	struct nft_base_chain *basechain;
 	struct nft_hook *this, *hook;
 	LIST_HEAD(chain_del_list);
 	struct nft_trans *trans;
 	int err;
 
-	if (!nft_is_base_chain(chain))
-		return -EOPNOTSUPP;
-
-	basechain = nft_base_chain(chain);
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
 				   ctx->family, chain->flags, extack);
 	if (err < 0)
@@ -2915,7 +2912,12 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			return -EOPNOTSUPP;
 
-		return nft_delchain_hook(&ctx, chain, extack);
+		if (nft_is_base_chain(chain)) {
+			struct nft_base_chain *basechain = nft_base_chain(chain);
+
+			if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
+				return nft_delchain_hook(&ctx, basechain, extack);
+		}
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_NONREC &&

--Gceh780nrvX56S4E--
