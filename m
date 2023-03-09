Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0ABC64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 15:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCIPc4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjCIPcn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2023 10:32:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F101F93F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Mar 2023 07:32:41 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1paIFz-000734-Kb; Thu, 09 Mar 2023 16:32:39 +0100
Date:   Thu, 9 Mar 2023 16:32:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Document lower priority limit for nat
 type chains
Message-ID: <ZAn8F+e8qwLApaNM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230309135246.18143-1-phil@nwl.cc>
 <ZAn57dCJmPkoBns/@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAn57dCJmPkoBns/@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 09, 2023 at 04:23:25PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 09, 2023 at 02:52:46PM +0100, Phil Sutter wrote:
> > Users can't know the magic limit.
> >
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  doc/nft.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/doc/nft.txt b/doc/nft.txt
> > index 7de4935b4b375..0d60c7520d31e 100644
> > --- a/doc/nft.txt
> > +++ b/doc/nft.txt
> > @@ -439,6 +439,9 @@ name which specifies the order in which chains with the same *hook* value are
> >  traversed. The ordering is ascending, i.e. lower priority values have precedence
> >  over higher ones.
> >  
> > +With *nat* type chains, there's a lower excluding limit of -200 for *priority*
> > +values, because conntrack hooks at this priority and NAT requires it.
> 
> prerouting, output 		-200 	NF_IP_PRI_CONNTRACK
> 
> this should only apply in these two hooks, it should be possible to
> relax this in input and postrouting in the kernel.

So far nobody has complained, right? Motivation for my patch came from a
question in IRC, I don't think there was a real need for more priority
"space" in nat type chains. So while we may relax the restriction, I
don't see the motivation to do so. :)

Cheers, Phil
