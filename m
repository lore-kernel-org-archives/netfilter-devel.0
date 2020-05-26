Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EBEC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C4F2068D
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgEZNjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 09:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgEZNjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 09:39:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944BC03E96D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 06:39:54 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jdZo8-0004ia-Br; Tue, 26 May 2020 15:39:52 +0200
Date:   Tue, 26 May 2020 15:39:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: Introduce test for concatenated
 ranges in anonymous sets
Message-ID: <20200526133952.GX17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <cover.1590324033.git.sbrivio@redhat.com>
 <5735155a0e98738cdc5507385d6225e05c225465.1590324033.git.sbrivio@redhat.com>
 <20200525154834.GU17795@orbyte.nwl.cc>
 <20200526011247.71f5c6e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526011247.71f5c6e1@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, May 26, 2020 at 01:12:47AM +0200, Stefano Brivio wrote:
> On Mon, 25 May 2020 17:48:34 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> 
> > On Sun, May 24, 2020 at 03:00:27PM +0200, Stefano Brivio wrote:
> > > Add a simple anonymous set including a concatenated range and check
> > > it's inserted correctly. This is roughly based on the existing
> > > 0025_anonymous_set_0 test case.  
> > 
> > I think this is pretty much redundant to what tests/py/inet/sets.t tests
> > if you simply enable the anonymous set rule I added in commit
> > 64b9aa3803dd1 ("tests/py: Add tests involving concatenated ranges").
> 
> Nice, I wasn't aware of that one. Anyway, this isn't really redundant
> as it also checks that sets are reported back correctly (which I
> expected to break, even if it didn't) by comparing with the dump file,
> instead of just checking netlink messages.
> 
> So I'd actually suggest that we keep this and I'd send another patch
> (should I repost this series? A separate patch?) to enable the rule you
> added for py tests.

But nft-test.py does check ruleset listing, that's what the optional
third part of a rule line is for. The syntax is roughly:

| <rule>;(fail|ok[;<rule_out>])

It allows us to cover for asymmetric rule listings. A simple example
from any/ct.t is:

| ct mark or 0x23 == 0x11;ok;ct mark | 0x00000023 == 0x00000011

So nft reports mark values with leading zeroes (don't ask me why ;).

Am I missing some extra your test does?

Cheers, Phil
