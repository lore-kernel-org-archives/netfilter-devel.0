Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4DBC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 14:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E17520716
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 14:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgA1Olf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:41:35 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54462 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbgA1OOS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:18 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iwRdA-00038S-HY; Tue, 28 Jan 2020 15:14:16 +0100
Date:   Tue, 28 Jan 2020 15:14:16 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 4/4] segtree: Refactor ei_insert()
Message-ID: <20200128141416.GI28318@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20200123143049.13888-1-phil@nwl.cc>
 <20200123143049.13888-5-phil@nwl.cc>
 <20200128122312.2mhlwu45p6jalfsn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128122312.2mhlwu45p6jalfsn@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jan 28, 2020 at 01:23:12PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Jan 23, 2020 at 03:30:49PM +0100, Phil Sutter wrote:
[...]
> > +	if (!merge) {
> > +		errno = EEXIST;
> > +		return expr_binary_error(msgs, lei->expr, new->expr,
> > +					 "conflicting intervals specified");
> >  	}
> 
> Not your fault, but I think this check is actually useless given that
> the overlap check happens before (unless you consider to consolidate
> the insertion and the overlap checks in ei_insert).

That's interesting, indeed. What's more interesting is how
interval_cmp() works: I assumed it would just sort by start element when
in fact interval size is the prominent aspect. In practice, this means
my changes work only as long as all intervals are of equal or decreasing
size. Does it make sense to uphold this ordering scheme?

> > -	__ei_insert(tree, new);
> > +	/* caller sorted intervals, so rei is either equal to lei or NULL */
> > +	rei = ei_lookup(tree, new->right);
> > +	if (rei != lei) {
> 
> Isn't this always true? I mean rei != lei always stands true?

Not if the second interval is entirely contained within the first one,
something like { 10-20, 12-14 }.

Cheers, Phil
