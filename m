Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B47C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9180720854
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCHKWU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:22:20 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbfCHKWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 05:22:20 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h2Cdt-0004bu-Bu; Fri, 08 Mar 2019 11:22:17 +0100
Date:   Fri, 8 Mar 2019 11:22:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        kfm@plushkava.net
Subject: Re: [PATCH nf] netfilter: nf_tables: fix set double-free in abort
 path
Message-ID: <20190308102217.ty3x6bncjucqcczi@breakpoint.cc>
References: <20190307193041.28798-1-fw@strlen.de>
 <20190308003415.i5kkbpferkhae3rm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308003415.i5kkbpferkhae3rm@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> So the problem is only the use-after-free from the NEWSETELEM abort
> path, right?

That and the double-freeing of the set.

> Probably we can fix this problem with this patch too? Idea is to keep
> this 'bound' internal flag, in that case, this turns the NEWSET and
> NEWSETELEM abort path into noop.

Good idea, but your patch still causes UAF.

> @@ -6617,10 +6617,13 @@ static void nf_tables_abort_release(struct nft_trans *trans)
>  		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
>  		break;
>  	case NFT_MSG_NEWSET:
> -		if (!nft_trans_set_bound(trans))
> -			nft_set_destroy(nft_trans_set(trans));
> +		if (nft_trans_set(trans)->bound)
> +			break;
> +		nft_set_destroy(nft_trans_set(trans));

Its not safe to use nft_trans_set() here anymore, as the set
has already been released by nf_tables_rule_destroy().

>  	case NFT_MSG_NEWSETELEM:
> +		if (nft_trans_elem_set(trans)->bound)
> +			break;

Same here.

Either the transactions themselves need to be yanked here, before
nf_tables_abort_release() is run, or the 'bound' flag needs to be
stored in the transaction struct.

I'd guess nft_trans_delete() is enough instead of plain break,
in case the set is bound we know expr destructor removes the set,
and if we avoid removal of the elements then those are removed too
when the set is destroyed.

This seems to make things work for me, on top of your patch:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6786,8 +6786,10 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			if (nft_trans_set(trans)->bound)
+			if (nft_trans_set(trans)->bound) {
+				nft_trans_destroy(trans);
 				break;
+			}
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
@@ -6796,8 +6798,10 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
-			if (nft_trans_elem_set(trans)->bound)
+			if (nft_trans_elem_set(trans)->bound) {
+				nft_trans_destroy(trans);
 				break;
+			}
 			te = (struct nft_trans_elem *)trans->data;
 			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
