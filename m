Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3920EC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 14:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084AF218B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfCUOG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:06:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39932 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfCUOG7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 10:06:59 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h6yLQ-0002ge-6e; Thu, 21 Mar 2019 15:06:56 +0100
Date:   Thu, 21 Mar 2019 15:06:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190321140656.GL4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
 <20190319110624.dy7wqatdtrxy3452@salvia>
 <20190320134654.GD4851@orbyte.nwl.cc>
 <20190321083245.lndl3sjq47pajaza@salvia>
 <20190321111515.GJ4851@orbyte.nwl.cc>
 <20190321111818.uqmioy5jk4kbamru@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321111818.uqmioy5jk4kbamru@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 21, 2019 at 12:18:18PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 21, 2019 at 12:15:15PM +0100, Phil Sutter wrote:
> > On Thu, Mar 21, 2019 at 09:32:45AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 20, 2019 at 02:46:54PM +0100, Phil Sutter wrote:
> > > [...]
> > > > Speaking of sets, it would be awesome if we could support something
> > > > like:
> > > > 
> > > > | osf genre { "Linux:2.4", "Windows" }
> > > 
> > > We can support something like this:
> > > 
> > >         osf version { "Linux:2.4", "Windows\*" }
> > > 
> > > where the wildcard specifies any Windows version.
> > > 
> > > We need a new set type though, to deal with strings.
> > 
> > Given that RHS for osf expression is a string in any option we discussed
> > so far this is inevitable, right?
> > 
> > > > i.e., having elements with varying "granularity". Do you think that's
> > > > feasible? If so, how could we support that? Maybe using a concatenation
> > > > like:
> > > > 
> > > > | osf name . osf version { "Linux" . "2.4", "Windows" . "*" }
> > > 
> > > Not sure we want this level of granularity. Matching the version
> > > without no OS genre does not look useful when I look at how the osf
> > > engine works. I'd prefer we go for the first approach you have
> > > mentioned here above.
> > 
> > I agree. It looks nice on paper, but without further optimization in
> > background it leads to multiple fingerprint lookups for the same
> > package.
> 
> Not if we have a set that implements Aho-Corasick.

I was talking about the "osf name . osf version" part. If not optimized,
each osf expression would perform a database lookup and return different
parts of the fingerprint.

Or did I miss your point?

Cheers, Phil
