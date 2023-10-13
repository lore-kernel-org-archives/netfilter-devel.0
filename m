Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EE9CDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 10:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjJMKIW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 06:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjJMKIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 06:08:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70D4A9
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 03:08:18 -0700 (PDT)
Received: from [78.30.34.192] (port=37020 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qrF5Z-0096ne-LR; Fri, 13 Oct 2023 12:08:15 +0200
Date:   Fri, 13 Oct 2023 12:08:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: string: Clarify description of --to
Message-ID: <ZSkXDERTsSdT9x9u@calendula>
References: <20231012160842.18584-1-phil@nwl.cc>
 <ZShNU7wRaTuNWUjv@calendula>
 <ZShTp0ppM71bUYu0@calendula>
 <ZSkN1c1hIMokOV76@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSkN1c1hIMokOV76@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 13, 2023 at 11:28:53AM +0200, Phil Sutter wrote:
> On Thu, Oct 12, 2023 at 10:14:31PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 12, 2023 at 09:47:38PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 12, 2023 at 06:08:42PM +0200, Phil Sutter wrote:
> > > > String match indeed returns a match as long as the given pattern starts
> > > > in the range of --from and --to, update the text accordingly.
> > > > Also add a note regarding fragment boundaries.
> > > >
> > > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1707
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  extensions/libxt_string.man | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
> > > > index 2a470ece19c9d..efdda492ae78d 100644
> > > > --- a/extensions/libxt_string.man
> > > > +++ b/extensions/libxt_string.man
> > > > @@ -7,9 +7,13 @@ Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morri
> > > >  Set the offset from which it starts looking for any matching. If not passed, default is 0.
> > > >  .TP
> > > >  \fB\-\-to\fP \fIoffset\fP
> > > > -Set the offset up to which should be scanned. That is, byte \fIoffset\fP-1
> > > > -(counting from 0) is the last one that is scanned.
> > > > +Set the offset up to which should be scanned. If the pattern does not start
> > > > +within this offset, it is not considered a match.
> > > >  If not passed, default is the packet size.
> > > > +A second function of this parameter is instructing the kernel how much data
> > > > +from the packet should be provided. With non-linear skbuffs (e.g. due to
> > > > +fragmentation), a pattern extending past this offset may not be found. Also see
> > > > +the related note below about Boyer-Moore algorithm in these cases.
> > > 
> > > Then, matching on:
> > > 
> > > - linear skbuff: if the pattern falls within from-to, all good.
> > > - non-linear skbuff: if pattern falls within from-to, but remaining
> > >   patter
> > > 
> > > This is clearly broken, the fix is just to document this?
> > > 
> > > No attempt to fix it this from the kernel?
> > 
> > I would align linear skbuff behaviour to how non-linear skbuff works,
> > that is, pattern matching stops at to. This requires a small patch for
> > xt_string.
> 
> Sounds reasonable. My efforts at documenting the current behaviour
> probably show how unintuitive this currently is.

I'd suggest you fix it from skb_find_text() to discard a match if it
goes over the "--to" boundary.

I think the "slidding" matching after the to boundary (that only works
with linear skbuff) is something the user does not want, when they
specify a [ from, to ] range, they really mean to narrow it down to
such range.

And if the user ever wants this, a flag could be exposed to provide
such behaviour.

Thanks.
