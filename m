Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9566AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 17:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbiA0RbV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 12:31:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:39972 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbiA0RbU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 12:31:20 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E8B3360702;
        Thu, 27 Jan 2022 18:28:15 +0100 (CET)
Date:   Thu, 27 Jan 2022 18:31:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Fix response to unprivileged users
Message-ID: <YfLW5BA1EaBXoadZ@salvia>
References: <20220120101653.28280-1-phil@nwl.cc>
 <YfLINxzIDlCwej1X@salvia>
 <YfLRjynofXWBGFCo@orbyte.nwl.cc>
 <YfLUhuZ8Eg9lB42I@salvia>
 <YfLWdhzy8C9vI03S@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfLWdhzy8C9vI03S@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 27, 2022 at 06:29:26PM +0100, Phil Sutter wrote:
> On Thu, Jan 27, 2022 at 06:21:10PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Jan 27, 2022 at 06:08:31PM +0100, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Thu, Jan 27, 2022 at 05:28:39PM +0100, Pablo Neira Ayuso wrote:
> > > > On Thu, Jan 20, 2022 at 11:16:53AM +0100, Phil Sutter wrote:
> > > > > Expected behaviour in both variants is:
> > > > > 
> > > > > * Print help without error, append extension help if -m and/or -j
> > > > >   options are present
> > > > > * Indicate lack of permissions in an error message for anything else
> > > > > 
> > > > > With iptables-nft, this was broken basically from day 1. Shared use of
> > > > > do_parse() then somewhat broke legacy: it started complaining about
> > > > > inability to create a lock file.
> > > > > 
> > > > > Fix this by making iptables-nft assume extension revision 0 is present
> > > > > if permissions don't allow to verify. This is consistent with legacy.
> > > > > 
> > > > > Second part is to exit directly after printing help - this avoids having
> > > > > to make the following code "nop-aware" to prevent privileged actions.
> > > > 
> > > > On top of this patch, it should be possible to allow for some
> > > > nfnetlink command to be used from unpriviledged process.
> > > > 
> > > > I'm attaching a sketch patch, it skips module autoload which is should
> > > > not be triggered by an unpriviledged process.
> > > > 
> > > > This should allow for better help with -m/-j if the module is present.
> > > 
> > > That's interesting. What's the use-case? With my patch, extension help
> > > text printing works fine as unprivileged user. Does it allow to drop the
> > > "revision == 0 && EPERM" hack?
> > 
> > Your patch is needed because we have to deal with older kernels.
> > 
> > You assume revision 0 in case of EPERM. My patch provides better help
> > if the module is present since there is no need to assume revision 0.
> 
> Ah, that's a good point. Users always see rev0 help texts, which are
> naturally the most limited ones.
> 
> > Anyway, I think your approach is fine for the unpriviledged scenario
> > you describe. I just wanted to write here that there is room to extend
> > nfnetlink to support for unpriviledged requests.
> 
> I see, thanks. Yet your approach works only if the module is loaded
> already, right?

Yes, I don't think we should allow to autoload modules for non-CAP_NET_ADMIN.

> Unless it's useful elsewhere as well, I don't think it's worth the
> effort for iptables alone - requesting extension help as non-root is
> quite a corner-case IMHO.

Agreed.
