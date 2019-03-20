Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BE2C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 13:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F33F21850
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 13:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfCTNq6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:46:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:37366 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfCTNq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 09:46:57 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h6bYU-0001HJ-Tq; Wed, 20 Mar 2019 14:46:54 +0100
Date:   Wed, 20 Mar 2019 14:46:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190320134654.GD4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
 <20190319110624.dy7wqatdtrxy3452@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319110624.dy7wqatdtrxy3452@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 19, 2019 at 12:06:24PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Mon, Mar 18, 2019 at 06:42:43PM +0100, Phil Sutter wrote:
> > On Fri, Mar 15, 2019 at 06:13:28PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > > * Kernel would need to inconditionally build the OS:version string.
> > 
> > Yes, exactly. nft_osf.c would return "OS:version:subtype:opt" and
> > nft_cmp.c will do the right thing if nft_cmp_expr->len is set to RHS
> > length.
> 
> Problem are sets. They need a fixed size for the string, or we would
> need to adjust the size to the largest string in the set. In case of
> dynamic sets, this boils down to the maximum string length since we
> don't know what the length of future element would be.

I knew there's a rub! :)

> > > * We may need to ask users to break existing osf ruleset so they
> > >   explicitly add the wildcard at the end, ie.
> > > 
> > >         osf name "Windows\*"
> > >         osf name "Linux:4.\*"
> > 
> > Not if cmp expr len is set correctly.
> 
> cmp expr len is set correctly using the wildcard.
> 
> I think we should aim to make this work fine with sets and maps. The
> wildcard cannot be used from there, where exact matches are needed. We
> should encourage users to use osf with sets and maps.
> 
> > > then, in the future (if ever needed) add subtypes:
> > > 
> > >         osf subtype "Linux:2.4:cluster"
> > 
> > IMHO this is still redundant: RHS contains <something>:<something>, user
> > wants to match on OS and version. RHS contains <sth>:<sth>:<sth>, user
> > wants to match on OS, version and subtype.
> 
> This is not possible with dynamic sets, there the set may be empty so
> we do not know how many colons will be used :-)

Speaking of sets, it would be awesome if we could support something
like:

| osf genre { "Linux:2.4", "Windows" }

i.e., having elements with varying "granularity". Do you think that's
feasible? If so, how could we support that? Maybe using a concatenation
like:

| osf name . osf version { "Linux" . "2.4", "Windows" . "*" }

Cheers, Phil
