From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 08/11] netfilter: nft_quota: add depleted flag
 for objects
Date: Mon, 28 Nov 2016 11:27:49 +0100
Message-ID: <20161128102749.GA28585@breakpoint.cc>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
 <1480291270-3715-9-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34966 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754598AbcK1Kas (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 05:30:48 -0500
Content-Disposition: inline
In-Reply-To: <1480291270-3715-9-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Notify on depleted quota objects. The NFT_QUOTA_F_DEPLETED flag
> indicates we have reached overquota.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> -	nft_quota_do_eval(priv, regs, pkt);
> +	if (nft_overquota(priv, pkt) ^ nft_quota_invert(priv)) {
> +		if (test_and_set_bit(NFT_QUOTA_F_DEPLETED, &priv->flags)) {
> +			nft_obj_notify(nft_net(pkt), nft_chain(pkt)->table,
> +				       obj, 0, 0, NFT_MSG_NEWOBJ,
> +				       nft_pf(pkt), 0, GFP_ATOMIC);

I suspect this should be !test_and_set_bit()?

Or does this really want to call notify for every overquota hit?

