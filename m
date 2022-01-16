Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E926C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Jan 2022 19:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiAPTIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Jan 2022 14:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiAPTIS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Jan 2022 14:08:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03890C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Jan 2022 11:08:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n9Asx-0002Vs-VS; Sun, 16 Jan 2022 20:08:16 +0100
Date:   Sun, 16 Jan 2022 20:08:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <20220116190815.GB28638@breakpoint.cc>
References: <20211001174142.1267726-1-jeremy@azazel.net>
 <YeQ0JeUznhEopHxI@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeQ0JeUznhEopHxI@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2021-10-01, at 18:41:34 +0100, Jeremy Sowden wrote:
> > nftables supports 128-character prefixes for nflog whereas legacy
> > iptables only supports 64 characters.  This patch series converts
> > iptables-nft to use the nft back-end in order to take advantage of the
> > longer prefixes.
> >
> >   * Patches 1-5 implement the conversion and update some related Python
> >     unit-tests.
> >   * Patch 6 fixes an minor bug in the output of nflog prefixes.
> >   * Patch 7 contains a couple of libtool updates.
> >   * Patch 8 fixes some typo's.
> 
> I note that Florian merged the first patch in this series recently.

Yes, because it was a cleanup not directly related to the rest.
I've now applied the last patch as well for the same reason.

> Feedback on the rest of it would be much appreciated.

THe patches look ok to me BUT there is the political issue
that we will now divert, afaict this means that you can now create
iptables-nft rulesets that won't ever work in iptables-legacy.

IMO its ok and preferrable to extending xt_(NF)LOG with a new revision,
but it does set some precedence, so I'm leaning towards just applying
the rest too.

Pablo, Phil, others -- what is your take?
