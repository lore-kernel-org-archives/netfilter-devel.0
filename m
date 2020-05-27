Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCFDC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 15:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CEC2078C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 15:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389607AbgE0PR0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 11:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389520AbgE0PR0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 11:17:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DBAC05BD1E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2020 08:17:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jdxo1-0006UB-Gi; Wed, 27 May 2020 17:17:21 +0200
Date:   Wed, 27 May 2020 17:17:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] doc: libxt_MARK: OUTPUT chain is fine, too
Message-ID: <20200527151721.GC17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200519230822.15290-1-phil@nwl.cc>
 <20200526170050.GA16695@salvia>
 <20200526170531.GA17094@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526170531.GA17094@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 26, 2020 at 07:05:31PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 26, 2020 at 07:00:50PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 20, 2020 at 01:08:22AM +0200, Phil Sutter wrote:
> > > In order to route packets originating from the host itself based on
> > > fwmark, mangle table's OUTPUT chain must be used. Mention this chain as
> > > alternative to PREROUTING.
> > > 
> > > Fixes: c9be7f153f7bf ("doc: libxt_MARK: no longer restricted to mangle table")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  extensions/libxt_MARK.man | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/extensions/libxt_MARK.man b/extensions/libxt_MARK.man
> > > index 712fb76f7340c..b2408597e98f1 100644
> > > --- a/extensions/libxt_MARK.man
> > > +++ b/extensions/libxt_MARK.man
> > > @@ -1,7 +1,7 @@
> > >  This target is used to set the Netfilter mark value associated with the packet.
> > >  It can, for example, be used in conjunction with routing based on fwmark (needs
> > > -iproute2). If you plan on doing so, note that the mark needs to be set in the
> > > -PREROUTING chain of the mangle table to affect routing.
> > > +iproute2). If you plan on doing so, note that the mark needs to be set in
> > > +either the PREROUTING or the OUTPUT chain of the mangle table to affect routing.
> > 
> > You have two choices:
> > 
> > * Set the mark in filter OUTPUT chain => it does not affect routing.
> > * Set the mark in the mangle OUTPUT chain => it _does_ affect routing.
> > 
> > Are we on the same page?
> 
> Ah, I right I just re-read and it looks fine.

OK. :)

Thanks, Phil
