Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84B5C71142
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 16:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 883E720830
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 16:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfGMQ7n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 12:59:43 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44982 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727768AbfGMQ7m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 12:59:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmLN6-0003nr-UP; Sat, 13 Jul 2019 18:59:41 +0200
Date:   Sat, 13 Jul 2019 18:59:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_dynset: support for element deletion
Message-ID: <20190713165940.gyqrhab4z3eookgl@breakpoint.cc>
References: <20190713160302.31308-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713160302.31308-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> This patch implements the delete operation from the ruleset.
> 
> It implements a new delete() function in nft_set_rhash. It is simpler
> to use than the already existing remove(), because it only takes the set
> and the key as arguments, whereas remove() expects a full
> nft_set_elem structure.

Looks good, I plan to review all your posted patches on monday.

some nits below, 

> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -312,6 +312,8 @@ struct nft_set_ops {
>  						  const struct nft_expr *expr,
>  						  struct nft_regs *regs,
>  						  const struct nft_set_ext **ext);
> +	bool				(*delete)(const struct nft_set *set,
> +						  const u32 *key);

Can you add a small comment here that explains the functions at the
start are those used on packet path, and rest are control plane/slow
path ones?

> +static bool nft_dynset_update(uint8_t sreg_key, int op, u64 timeout,

Can you use plain u8 here?  In case you haven't seen it, there is
scripts/checkpatch.pl in the kernel tree.

> +	if (he == NULL)
> +		return false;
> +
> +	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
> +	return true;

Perhaps add a small comment here that rhashtable_remove_fast retval
is ignored intentionally?

I.e., don't make this return false in case two cpus race to remove same
entry.

Otherwise, this looks really good, thanks for working on this!
