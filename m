Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E00E810DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 12:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjI0MzE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjI0MzE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 08:55:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E730612A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 05:55:00 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlU4A-00019r-Gq; Wed, 27 Sep 2023 14:54:58 +0200
Date:   Wed, 27 Sep 2023 14:54:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRQmIsrRCH9jYO7+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <ZQ7+MF4aweUYmU7j@orbyte.nwl.cc>
 <20230923161813.GB19098@breakpoint.cc>
 <ZRFTx6pFYt2tZuSy@calendula>
 <20230925195317.GC22532@breakpoint.cc>
 <ZRKlszo1ra1EakD+@orbyte.nwl.cc>
 <ZRKt31Vs382Z31IO@calendula>
 <ZRLLDbVlYK5c9HX+@orbyte.nwl.cc>
 <ZRLd8MxWZMt3O/Yh@calendula>
 <ZRLjs5Rv91mJWbC0@orbyte.nwl.cc>
 <20230927114133.GA17767@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927114133.GA17767@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 01:41:33PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > However, this is stalling writers and I don't think we need this
> > > according to the problem description.
> > 
> > ACK. Maybe Florian has a case in mind which requires to serialize reset
> > and commit?
> 
> No, spinlock is fine too, concurrent resets will just burn more cycles.
> I did not think we'd have frequent resets which is why I suggegested
> reuse of the existing lock, thats all.
> 
> No objections to new mutex or spinlock.

OK, so we may just reuse commit_mutex until we find a practical use-case
for which this is a bottleneck? Or should one prefer a dedicated lock in
order to reduce complexity when it comes to lock debugging?

Cheers, Phil
