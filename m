Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37969C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 18:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EEA421916
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 18:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfCUSOl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 14:14:41 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40360 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfCUSOl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 14:14:41 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h72D8-0006Jl-TM; Thu, 21 Mar 2019 19:14:38 +0100
Date:   Thu, 21 Mar 2019 19:14:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190321181438.GM4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <20190318174243.GT4851@orbyte.nwl.cc>
 <20190319110624.dy7wqatdtrxy3452@salvia>
 <20190320134654.GD4851@orbyte.nwl.cc>
 <20190321083245.lndl3sjq47pajaza@salvia>
 <20190321111515.GJ4851@orbyte.nwl.cc>
 <20190321111818.uqmioy5jk4kbamru@salvia>
 <20190321140656.GL4851@orbyte.nwl.cc>
 <20190321165711.is2jcq3b4yzty6fy@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321165711.is2jcq3b4yzty6fy@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 21, 2019 at 05:57:11PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Thu, Mar 21, 2019 at 03:06:56PM +0100, Phil Sutter wrote:
> [...]
> > I was talking about the "osf name . osf version" part. If not optimized,
> > each osf expression would perform a database lookup and return different
> > parts of the fingerprint.
> > 
> > Or did I miss your point?
> 
> Oops, sorry. I misunderstood.

OK, no worries!

> I don't think we should split this in two separated selectors.
> Matching on 'osf version' alone itself does not make sense to me.

I like how one may use concatenations with it, but I agree it's not
really useful by itself.

> I think it's useful to match on:
> 
> * genre
> * genre:version
> * genre:version:subtype
> 
> anything else for this, I don't have a use case.

Fine with me!

> We can achieve something similar to what you suggest in your 'osf name
> . osf version' example via:
> 
>         osf version {  "Linux:2.4", "Windows\*" }

Supporting strings in sets would be nice for ifname matches, too. :)

Cheers, Phil
