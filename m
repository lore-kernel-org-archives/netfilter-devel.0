Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D84DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 10:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbiAQKk7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 05:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238691AbiAQKk6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 05:40:58 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69315C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:40:58 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1n9PRT-0007wI-0y; Mon, 17 Jan 2022 11:40:51 +0100
Date:   Mon, 17 Jan 2022 11:40:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <YeVHs4oOQki9FIgj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20211001174142.1267726-1-jeremy@azazel.net>
 <YeQ0JeUznhEopHxI@azazel.net>
 <20220116190815.GB28638@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116190815.GB28638@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 16, 2022 at 08:08:15PM +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2021-10-01, at 18:41:34 +0100, Jeremy Sowden wrote:
> > > nftables supports 128-character prefixes for nflog whereas legacy
> > > iptables only supports 64 characters.  This patch series converts
> > > iptables-nft to use the nft back-end in order to take advantage of the
> > > longer prefixes.
> > >
> > >   * Patches 1-5 implement the conversion and update some related Python
> > >     unit-tests.
> > >   * Patch 6 fixes an minor bug in the output of nflog prefixes.
> > >   * Patch 7 contains a couple of libtool updates.
> > >   * Patch 8 fixes some typo's.
> > 
> > I note that Florian merged the first patch in this series recently.
> 
> Yes, because it was a cleanup not directly related to the rest.
> I've now applied the last patch as well for the same reason.
> 
> > Feedback on the rest of it would be much appreciated.
> 
> THe patches look ok to me BUT there is the political issue
> that we will now divert, afaict this means that you can now create
> iptables-nft rulesets that won't ever work in iptables-legacy.
> 
> IMO its ok and preferrable to extending xt_(NF)LOG with a new revision,
> but it does set some precedence, so I'm leaning towards just applying
> the rest too.
> 
> Pablo, Phil, others -- what is your take?

I think the change is OK if existing rulesets will continue to
work just as before and remain compatible with legacy. IMHO, new
rulesets created using iptables-nft may become incompatible if users
explicitly ask for it (e.g. by specifying an exceedingly long log
prefix.

What about --nflog-range? This series seems to drop support for it, at
least in the sense that ruleset dumps won't contain the option. In
theory, users could depend on identifying a specific rule via nflog
range value.

Cheers, Phil
