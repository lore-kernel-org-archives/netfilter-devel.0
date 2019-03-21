Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58144C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EBD621841
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfCULSW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:18:22 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42736 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCULSW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:18:22 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h6viE-0006H8-TQ; Thu, 21 Mar 2019 12:18:20 +0100
Date:   Thu, 21 Mar 2019 12:18:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190321111818.uqmioy5jk4kbamru@salvia>
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
 <20190319110624.dy7wqatdtrxy3452@salvia>
 <20190320134654.GD4851@orbyte.nwl.cc>
 <20190321083245.lndl3sjq47pajaza@salvia>
 <20190321111515.GJ4851@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321111515.GJ4851@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 21, 2019 at 12:15:15PM +0100, Phil Sutter wrote:
> On Thu, Mar 21, 2019 at 09:32:45AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 20, 2019 at 02:46:54PM +0100, Phil Sutter wrote:
> > [...]
> > > Speaking of sets, it would be awesome if we could support something
> > > like:
> > > 
> > > | osf genre { "Linux:2.4", "Windows" }
> > 
> > We can support something like this:
> > 
> >         osf version { "Linux:2.4", "Windows\*" }
> > 
> > where the wildcard specifies any Windows version.
> > 
> > We need a new set type though, to deal with strings.
> 
> Given that RHS for osf expression is a string in any option we discussed
> so far this is inevitable, right?
> 
> > > i.e., having elements with varying "granularity". Do you think that's
> > > feasible? If so, how could we support that? Maybe using a concatenation
> > > like:
> > > 
> > > | osf name . osf version { "Linux" . "2.4", "Windows" . "*" }
> > 
> > Not sure we want this level of granularity. Matching the version
> > without no OS genre does not look useful when I look at how the osf
> > engine works. I'd prefer we go for the first approach you have
> > mentioned here above.
> 
> I agree. It looks nice on paper, but without further optimization in
> background it leads to multiple fingerprint lookups for the same
> package.

Not if we have a set that implements Aho-Corasick.
