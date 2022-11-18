Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63941C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 14:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiKROw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 09:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiKROwY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 09:52:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288F38FB02
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 06:52:23 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ow2j7-00051X-1Y; Fri, 18 Nov 2022 15:52:21 +0100
Date:   Fri, 18 Nov 2022 15:52:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <Y3ecJC6b2KBEsuR9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221117211347.GB15714@breakpoint.cc>
 <Y3dUxJZ6J4mg/KNh@orbyte.nwl.cc>
 <Y3daXmuU0Nsyeij6@salvia>
 <Y3dhhVpfoA73W3kA@orbyte.nwl.cc>
 <20221118114643.GD15714@breakpoint.cc>
 <Y3d2qqm2r8Z8Tbih@orbyte.nwl.cc>
 <Y3d4JEmztrNTbK99@salvia>
 <Y3d5eqTGTwEAa2Dq@orbyte.nwl.cc>
 <20221118133431.GE15714@breakpoint.cc>
 <Y3eSbhQ+ihCNeSpE@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3eSbhQ+ihCNeSpE@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 18, 2022 at 03:10:54PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 18, 2022 at 02:34:31PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > This one:
> > > 
> > > Subject: [nft PATCH] Warn for tables with compat expressions in rules
> > > Date: Wed, 12 Oct 2022 17:31:07 +0200
> > > Message-Id: <20221012153107.24574-1-phil@nwl.cc>
> > 
> > This is:
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221012153107.24574-1-phil@nwl.cc/
> > 
> > LGTM, no objections from me.
> 
> LGTM.

Applied, thanks!
