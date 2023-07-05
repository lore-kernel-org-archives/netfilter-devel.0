Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2764EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 22:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjGEW4j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGEW4j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 18:56:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85AC11980;
        Wed,  5 Jul 2023 15:56:37 -0700 (PDT)
Date:   Thu, 6 Jul 2023 00:56:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH -stable,5.15 2/2] netfilter: nf_tables: unbind
 non-anonymous set if rule construction fails
Message-ID: <ZKX1IHOhsm8XbmfB@calendula>
References: <20230705141411.53123-1-pablo@netfilter.org>
 <20230705141411.53123-3-pablo@netfilter.org>
 <2023070533-swimwear-audition-49e8@gregkh>
 <20230705202327.GH3751@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230705202327.GH3751@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg,

On Wed, Jul 05, 2023 at 10:23:27PM +0200, Florian Westphal wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jul 05, 2023 at 04:14:11PM +0200, Pablo Neira Ayuso wrote:
> > > [ 3e70489721b6c870252c9082c496703677240f53 ]
> > > 
> > > Otherwise a dangling reference to a rule object that is gone remains
> > > in the set binding list.
> > > 
> > > Fixes: 26b5a5712eb8 ("netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nf_tables_api.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > 
> > But what about kernels newer than 5.15?  Surely this is also needed
> > there as this only is going to first show up in 6.5-rc1, which hasn't
> > been released yet.
> 
> Yes, do you need a backport? The commit cherry-picks cleanly to
> 6.1.y, 6.2.y and 6.3.y.

Yes, if possible please cherry-pick:

  3e70489721b6 ("netfilter: nf_tables: unbind non-anonymous set if rule construction fails")

to:
        6.1.y
        6.2.y
        6.3.y

Thanks.
