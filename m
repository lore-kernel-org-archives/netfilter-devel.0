Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C71C04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 21:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiI1Vjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 17:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiI1Vjt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 17:39:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885B55209A
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 14:39:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1odemM-0004jO-Go; Wed, 28 Sep 2022 23:39:42 +0200
Date:   Wed, 28 Sep 2022 23:39:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix meta statement parsing
Message-ID: <YzS/Htm4KqlXJGQ5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
References: <20220928162300.1055-1-phil@nwl.cc>
 <20220928175723.GN12777@breakpoint.cc>
 <YzSM/KSLYpHFzTIN@orbyte.nwl.cc>
 <20220928212709.GO12777@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928212709.GO12777@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 28, 2022 at 11:27:09PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Wed, Sep 28, 2022 at 07:57:23PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > The function nft_meta_set_to_target() would always bail since nothing
> > > > sets 'sreg->meta_sreg.set' to true. This is obvious, as the immediate
> > > > expression "filling" the source register does not indicate its purpose.
> > > 
> > > Hmm, is there a missing test case?  I did not see any failures.
> > 
> > extensions/libxt_TRACE.t was failing if I called iptables-test.py with
> > '-n' option.
> 
> Argh, I only tested classic :-(

Same here! Making nft changes and forgetting to run the testsuite in nft
mode is a classic. :)

I guess we need a button to run them all at once.

Cheers, Phil
