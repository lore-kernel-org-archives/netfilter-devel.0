Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66112C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 469E124685
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 16:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBJQEO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 11:04:14 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59478 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbgBJQEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 11:04:13 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j1BXe-0006p3-CP; Mon, 10 Feb 2020 17:04:10 +0100
Date:   Mon, 10 Feb 2020 17:04:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-15?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 4/4] tests: Introduce test for set with
 concatenated ranges
Message-ID: <20200210160410.GH2991@breakpoint.cc>
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

Stefano Brivio <sbrivio@redhat.com> wrote:
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
> 
> > If this can be shortened, better. Probably you can add a parameter to
> > enable the extra torture test mode not that is away from the
> > ./run-test.sh path.
> 
> I can't think of an easy way to remove that sleep(1), I could decrease
> the timeouts passed to nft but then there's no portable way to wait for
> less than one second.

Even busybox' sleep can do 'sleep 0.01', do we really need to be *that*
portable?
