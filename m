Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FCEC001DE
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jul 2023 19:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjGPTTc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jul 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGPTTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jul 2023 15:19:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61626E4B;
        Sun, 16 Jul 2023 12:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF3F60DD0;
        Sun, 16 Jul 2023 19:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FD5C433C7;
        Sun, 16 Jul 2023 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689535170;
        bh=z3BQArUV7xSEtTSKR0EvciQBzut/GOegGbiqHeLMpRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZ8lCOl1jOZ4P8PWY6L1RnmNY+FBZxBX0VzrYjAVWOM0r8mlskxulrRCbu+MbisHN
         Ho2Ieu0/TRzv8LN2CjgLx5DPlPoZKpj5qxr+fKg67KXtu6XnxBV1jaEsdKcTNZIbtr
         JJlh985iUR/wADynYP3zsmwMzn4QLtqYnhh3m4BY=
Date:   Sun, 16 Jul 2023 21:19:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
        sashal@kernel.org
Subject: Re: [PATCH -stable,5.10 v3 01/11] netfilter: nf_tables: use
 net_generic infra for transaction data
Message-ID: <2023071612-slip-atrium-f5fb@gregkh>
References: <20230713084859.71541-1-pablo@netfilter.org>
 <20230713084859.71541-2-pablo@netfilter.org>
 <2023071608-pushcart-egotism-c77f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023071608-pushcart-egotism-c77f@gregkh>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 16, 2023 at 09:18:29PM +0200, Greg KH wrote:
> On Thu, Jul 13, 2023 at 10:48:49AM +0200, Pablo Neira Ayuso wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > [ Upstream commit 0854db2aaef3fcdd3498a9d299c60adea2aa3dc6 ]
> > 
> > This moves all nf_tables pernet data from struct net to a net_generic
> > extension, with the exception of the gencursor.
> > 
> > The latter is used in the data path and also outside of the nf_tables
> > core. All others are only used from the configuration plane.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netfilter/nf_tables.h |  10 +
> >  include/net/netns/nftables.h      |   7 -
> >  net/netfilter/nf_tables_api.c     | 382 ++++++++++++++++++------------
> >  net/netfilter/nf_tables_offload.c |  30 ++-
> >  net/netfilter/nft_chain_filter.c  |  11 +-
> >  net/netfilter/nft_dynset.c        |   6 +-
> >  6 files changed, 279 insertions(+), 167 deletions(-)
> 
> This doesn't apply to the 5.10.y tree, what version did you make it
> against?

Ick, nevermind, operator error, my fault, this is now queued up, thanks!

greg k-h
