Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A015EC001DE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 16:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjHDQWd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 12:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjHDQWc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 12:22:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D603C3D
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Aug 2023 09:22:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qRxZL-0006YP-Vh; Fri, 04 Aug 2023 18:22:27 +0200
Date:   Fri, 4 Aug 2023 18:22:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, robert.smith51@protonmail.com
Subject: Re: [PATCH iptables] nft-ruleparse: parse meta mark set as MARK
 target
Message-ID: <20230804162227.GN30550@breakpoint.cc>
References: <20230803193917.26779-1-fw@strlen.de>
 <ZM0lptBHzgTMV24n@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZM0lptBHzgTMV24n@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Aug 03, 2023 at 09:39:13PM +0200, Florian Westphal wrote:
> > Mixing nftables and iptables-nft in the same table doesn't work,
> > but some people do this.
> > 
> > v1.8.8 ignored rules it could not represent in iptables syntax,
> > v1.8.9 bails in this case.
> > 
> > Add parsing of meta mark expressions so iptables-nft can render them
> > as -j MARK rules.
> > 
> > This is flawed, nft has features that have no corresponding
> > syntax in iptables, but we can't undo this.
> > 
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1659
> 
> Intentionally not "Closes:"?

Yes, its unfixable.
