Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699AFEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 08:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjFSI7R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjFSI67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 04:58:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B6C9DA
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 01:58:56 -0700 (PDT)
Date:   Mon, 19 Jun 2023 10:58:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix for deleting base chains
 with payload
Message-ID: <ZJAYzHYDnqcbq05B@calendula>
References: <20230616155611.2468-1-phil@nwl.cc>
 <ZI8b1ySlPjUucbdH@calendula>
 <ZJAYHMk/HCUvnwIn@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PtpQf1NEyCExCsit"
Content-Disposition: inline
In-Reply-To: <ZJAYHMk/HCUvnwIn@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--PtpQf1NEyCExCsit
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Jun 19, 2023 at 10:55:59AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 18, 2023 at 04:59:38PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, Jun 16, 2023 at 05:56:11PM +0200, Phil Sutter wrote:
> > > When deleting a base chain, iptables-nft simply submits the whole chain
> > > to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
> > > added by fixed commit then turned this into a chain update, destroying
> > > the hook but not the chain itself.
> > > 
> > > Detect the situation by checking if the chain's hook list becomes empty
> > > after removing all submitted hooks from it. A base chain without hooks
> > > is pointless, so revert back to deleting the chain.
> > > 
> > > Note the 'goto err_chain_del_hook', error path takes care of undoing the
> > > hook_list modification and releasing the unused chain_hook.
> > 
> > Could you give a try to this alternative patch?
> 
> This is the full patch.

I forgot to mangle the patch description describing the new approach.

--PtpQf1NEyCExCsit
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nf_tables-Fix-for-deleting-base-chains-wit.patch"

From 3da13f15a02e065e12080f2d66f81289aa6ebd69 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Fri, 16 Jun 2023 17:56:11 +0200
Subject: [PATCH] netfilter: nf_tables: Fix for deleting base chains with
 payload

When deleting a base chain, iptables-nft simply submits the whole chain
to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
added by fixed commit then turned this into a chain update, destroying
the hook but not the chain itself. Detect the situation by checking if
the chain is either the netdev or inet/ingress type.

Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1db2f4b2aa4..4c7937fd803f 100644
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
@@ -2910,7 +2907,12 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
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
-- 
2.30.2


--PtpQf1NEyCExCsit--
