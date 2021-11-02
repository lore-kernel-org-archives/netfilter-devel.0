Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFBEC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49F760F90
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhKBUdy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhKBUdx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:33:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE180C061714
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2021 13:31:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mi0R9-0001bp-GC; Tue, 02 Nov 2021 21:31:15 +0100
Date:   Tue, 2 Nov 2021 21:31:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: run-tests.sh: ensure non-zero exit when
 $failed != 0
Message-ID: <20211102203115.GP1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org
References: <20211020124409.489875-1-snemec@redhat.com>
 <20211020150641.GK1668@orbyte.nwl.cc>
 <YXkXQ2hrbZJ7YLcw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXkXQ2hrbZJ7YLcw@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 27, 2021 at 11:09:23AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 20, 2021 at 05:06:41PM +0200, Phil Sutter wrote:
> > On Wed, Oct 20, 2021 at 02:44:09PM +0200, Štěpán Němec wrote:
> > > POSIX [1] does not specify the behavior of `exit' with arguments
> > > outside the 0-255 range, but what generally (bash, dash, zsh, OpenBSD
> > > ksh, busybox) seems to happen is the shell exiting with status & 255
> > > [2], which results in zero exit for certain non-zero arguments.
> > 
> > Standards aside, failed=256 is an actual bug:
> > 
> > | % bash -c "exit 255"; echo $?
> > | 255
> > | % bash -c "exit 256"; echo $?
> > | 0
> > | % bash -c "exit 257"; echo $?
> > | 1
> 
> This is extra information you provided here for the commit message for
> completion?

No need to extend the commit message IMO. I was just curious and played
a bit with exit values in bash. So although unlikely, the unpatched code
indeed confuses a result of 256 errors for a pass. :)

Cheers, Phil
