Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79693C43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293EA20825
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfIEQOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:14:00 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:32967 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfIEQN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 12:13:59 -0400
X-Originating-IP: 24.35.62.146
Received: from roberto (c-24-35-62-146.customer.broadstripe.net [24.35.62.146])
        (Authenticated sender: eric@garver.life)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 469E920008;
        Thu,  5 Sep 2019 16:13:56 +0000 (UTC)
Date:   Thu, 5 Sep 2019 12:13:54 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: check that rule add with index works
 with echo
Message-ID: <20190905161354.3lqlvvhajzhdoaiy@roberto>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190903232713.14394-1-eric@garver.life>
 <20190905155418.z2lpiet466ceixjy@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905155418.z2lpiet466ceixjy@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 05, 2019 at 05:54:18PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 03, 2019 at 07:27:13PM -0400, Eric Garver wrote:
> > If --echo is used the rule cache will not be populated. This causes
> > rules added using the "index" keyword to be simply appended to the
> > chain. The bug was introduced in commit 3ab02db5f836 ("cache: add
> > NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED flags").
> > 
> > Signed-off-by: Eric Garver <eric@garver.life>
> > ---
> > I think the issue is in cache_evaluate(). It sets the flags to
> > NFT_CACHE_FULL and then bails early, but I'm not sure of the best way to
> > fix it. So I'll start by submitting a test case. :)
> > ---
> >  tests/shell/testcases/cache/0007_echo_cache_init_0 | 14 ++++++++++++++
> >  .../cache/dumps/0007_echo_cache_init_0.nft         |  7 +++++++
> >  2 files changed, 21 insertions(+)
> >  create mode 100755 tests/shell/testcases/cache/0007_echo_cache_init_0
> >  create mode 100644 tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft
> > 
> > diff --git a/tests/shell/testcases/cache/0007_echo_cache_init_0 b/tests/shell/testcases/cache/0007_echo_cache_init_0
> > new file mode 100755
> > index 000000000000..280a0d06bdc3
> > --- /dev/null
> > +++ b/tests/shell/testcases/cache/0007_echo_cache_init_0
> > @@ -0,0 +1,14 @@
> > +#!/bin/bash
> > +
> > +set -e
> > +
> > +$NFT -i >/dev/null <<EOF
> > +add table inet t
> > +add chain inet t c
> > +add rule inet t c accept comment "first"
> > +add rule inet t c accept comment "third"
> > +EOF
> > +
> > +# make sure the rule cache gets initialized when using echo option
> > +#
> > +$NFT --echo add rule inet t c index 0 accept comment '"second"' >/dev/null
> 
> Looks like the problem is index == 0?

No. The index gets incremented by 1 by the JSON parser (CLI does the
same thing). It's never zero if the "index" keyword is used.

It's just as easily reproduced if you use any other index.

> 
>                 if (cmd->handle.index.id ||
>                     cmd->handle.position.id)
>                         flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;

We never reach this code since cache_evaluate() breaks if --echo is
used. i.e. evaluate_cache_add() is never called.

> We might need to set up a flag, eg. cmd->handle.flags &
> NFT_HANDLE_INDEX, similarly with position, given that index.id can be
> zero. Alternatively, initialize index id to -1, assuming we'll never
> get to ~0U index.
