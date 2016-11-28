From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 08/11] netfilter: nft_quota: add depleted flag
 for objects
Date: Mon, 28 Nov 2016 12:08:35 +0100
Message-ID: <20161128110748.GB1024@salvia>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
 <1480291270-3715-9-git-send-email-pablo@netfilter.org>
 <20161128102749.GA28585@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932857AbcK1LJL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 06:09:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 390A9EBAC1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:09:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 294DE1F698D
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:09:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BCBB1F699A
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:09:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128102749.GA28585@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 11:27:49AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Notify on depleted quota objects. The NFT_QUOTA_F_DEPLETED flag
> > indicates we have reached overquota.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > -	nft_quota_do_eval(priv, regs, pkt);
> > +	if (nft_overquota(priv, pkt) ^ nft_quota_invert(priv)) {
> > +		if (test_and_set_bit(NFT_QUOTA_F_DEPLETED, &priv->flags)) {
> > +			nft_obj_notify(nft_net(pkt), nft_chain(pkt)->table,
> > +				       obj, 0, 0, NFT_MSG_NEWOBJ,
> > +				       nft_pf(pkt), 0, GFP_ATOMIC);
> 
> I suspect this should be !test_and_set_bit()?
> 
> Or does this really want to call notify for every overquota hit?

That's right, my test here was just checking for the first event then
stop. Will fix up this, thanks for reviewing.
