Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356D7EB64DA
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jul 2023 15:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjGPPRr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jul 2023 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjGPPRr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jul 2023 11:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B0890;
        Sun, 16 Jul 2023 08:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD85C60D30;
        Sun, 16 Jul 2023 15:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95B2C433C8;
        Sun, 16 Jul 2023 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689520665;
        bh=JKO+5MNWVtoFD/sDkDk1emQI3BxMpp+PGBJ+GC3SDSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fNAtskiE5OzUQ/joenr2bm6NqwP6U+niDr3XfpBziYuI6U7RLSMBRMeGIaXo37qzJ
         DtaBDiNSBJWBOVrOCaLZhTQPdauM1Jtc7s6YJXcgw/dr/3gtJkkgDSTlUHPev5Pn57
         oaHsasUvhFzILbYJCyZ9DXHuf+XFvfkY15btKKqQ=
Date:   Sun, 16 Jul 2023 17:17:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH -stable,5.15 2/2] netfilter: nf_tables: unbind
 non-anonymous set if rule construction fails
Message-ID: <2023071627-chatting-badge-2a0a@gregkh>
References: <20230705141411.53123-1-pablo@netfilter.org>
 <20230705141411.53123-3-pablo@netfilter.org>
 <2023070533-swimwear-audition-49e8@gregkh>
 <20230705202327.GH3751@breakpoint.cc>
 <ZKX1IHOhsm8XbmfB@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKX1IHOhsm8XbmfB@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 06, 2023 at 12:56:32AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> On Wed, Jul 05, 2023 at 10:23:27PM +0200, Florian Westphal wrote:
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Wed, Jul 05, 2023 at 04:14:11PM +0200, Pablo Neira Ayuso wrote:
> > > > [ 3e70489721b6c870252c9082c496703677240f53 ]
> > > > 
> > > > Otherwise a dangling reference to a rule object that is gone remains
> > > > in the set binding list.
> > > > 
> > > > Fixes: 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > >  net/netfilter/nf_tables_api.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > 
> > > But what about kernels newer than 5.15?  Surely this is also needed
> > > there as this only is going to first show up in 6.5-rc1, which hasn't
> > > been released yet.
> > 
> > Yes, do you need a backport? The commit cherry-picks cleanly to
> > 6.1.y, 6.2.y and 6.3.y.
> 
> Yes, if possible please cherry-pick:
> 
>   3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")
> 
> to:
>         6.1.y
>         6.2.y

Great, all now queued up. thanks.

greg k-h
