Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC23C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927D620714
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBJPvv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:51:51 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59310 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbgBJPvv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:51:51 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j1BLf-0006Qd-Fb; Mon, 10 Feb 2020 16:51:47 +0100
Date:   Mon, 10 Feb 2020 16:51:47 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft v4 4/4] tests: Introduce test for set with
 concatenated ranges
Message-ID: <20200210155147.GA10078@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <6f1dbaf2ab5a98b2616b14d93ee589a7e741e5f9.1580342294.git.sbrivio@redhat.com>
 <20200207103442.3fnk6rrxzny7hvoa@salvia>
 <20200210160840.695a031c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210160840.695a031c@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 04:08:40PM +0100, Stefano Brivio wrote:
> On Fri, 7 Feb 2020 11:34:42 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Thu, Jan 30, 2020 at 01:16:58AM +0100, Stefano Brivio wrote:
> > > This test checks that set elements can be added, deleted, that
> > > addition and deletion are refused when appropriate, that entries
> > > time out properly, and that they can be fetched by matching values
> > > in the given ranges.  
> > 
> > I'll keep this back so Phil doesn't have to do some knitting work
> > meanwhile the tests finishes for those 3 minutes.
> 
> But I wanted to see his production :(

I'm not good at knitting, always liked crocheting more. That said, I
like fast testsuites more than any of those. ;)

> > If this can be shortened, better. Probably you can add a parameter to
> > enable the extra torture test mode not that is away from the
> > ./run-test.sh path.
> 
> I can't think of an easy way to remove that sleep(1), I could decrease
> the timeouts passed to nft but then there's no portable way to wait for
> less than one second.
> 
> Probably a good way to make it faster and still retain coverage would
> be to decrease the amount of combinations. Right now, most of the 6 ^ 3
> combinations (six "types", three values each to have: single, prefix,
> range -- where allowed) are tested. I could stop after the first 3 x 3
> matrix instead, if we come from run-tests.sh.
> 
> Let me know if you have other ideas, otherwise I'd send a patch doing
> this.

You could test the timeout feature just once and for all? I doubt there
will ever be a bug in that feature which only a certain data type
exposes, but you may e.g. create all the sets with elements at the same
time so waiting for the timeout once is enough.

Cheers, Phil
