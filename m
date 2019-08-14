Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0C4C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 13:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6A82064A
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 13:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfHNN7D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:59:03 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34184 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbfHNN7D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 09:59:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxtnp-00035o-QR; Wed, 14 Aug 2019 15:59:01 +0200
Date:   Wed, 14 Aug 2019 15:59:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_dynset: support for element deletion
Message-ID: <20190814135901.pzbgax4q7p5xh2p5@breakpoint.cc>
References: <20190813065849.4745-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813065849.4745-1-a@juaristi.eus>
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
> 
> Signed-off-by: Ander Juaristi <a@juaristi.eus>

Patch looks ok, but why did you add so many changes?

> -void nft_dynset_eval(const struct nft_expr *expr,
> -		     struct nft_regs *regs, const struct nft_pktinfo *pkt)
> +static bool nft_dynset_update(u8 sreg_key, int op, u64 timeout,
> +			      const struct nft_expr *expr,
> +			      const struct nft_pktinfo *pkt,
> +			      struct nft_regs *regs, struct nft_set *set)

Why is this new helper needed?

> +void nft_dynset_eval(const struct nft_expr *expr,
> +		     struct nft_regs *regs, const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_dynset *priv = nft_expr_priv(expr);
> +	struct nft_set *set = priv->set;
> +
> +	if (priv->op == NFT_DYNSET_OP_DELETE) {
> +		set->ops->delete(set, &regs->data[priv->sreg_key]);
		return;
	}

... so no need for 'else' clause and no need to reformat all of this.
