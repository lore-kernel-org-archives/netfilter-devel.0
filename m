Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F38C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30C6E2076B
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgJ2LS2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgJ2LS1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE69C0613D2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kY5wm-0005ff-QV; Thu, 29 Oct 2020 12:18:24 +0100
Date:   Thu, 29 Oct 2020 12:18:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/shell: Restore
 testcases/sets/0036add_set_element_expiration_0
Message-ID: <20201029111824.GV13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201028170338.32033-1-phil@nwl.cc>
 <20201028190538.GA4169@salvia>
 <20201028190847.GA4360@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028190847.GA4360@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Oct 28, 2020 at 08:08:47PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 28, 2020 at 08:05:38PM +0100, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Wed, Oct 28, 2020 at 06:03:38PM +0100, Phil Sutter wrote:
> > > This reverts both commits 46b54fdcf266d3d631ffb6102067825d7672db46 and
> > > 0e258556f7f3da35deeb6d5cfdec51eafc7db80d.
> > > 
> > > With both applied, the test succeeded *only* if 'nft monitor' was
> > > running in background, which is equivalent to the original problem
> > > (where the test succeeded only if *no* 'nft monitor' was running).
> > > 
> > > The test merely exposed a kernel bug, so in fact it is correct.
> > 
> > Please, do not revert this.
> > 
> > This kernel patch needs this fix:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20201022204032.28904-1-pablo@netfilter.org/
> 
> With the kernel patch above, this test does not break anymore.
> 
> ie. --echo is not printing the generation ID because kernel bug.

Oh, I mis-read the kernel patch, sorry for the mess. I would suggest to
change your test case fix into this though:

| -test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | head -n -1)
| +test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | grep -v '# new generation')

This makes it clear what is to be omitted and also makes the test work
with unpatched kernels as well. Fine with you?

Thanks, Phil
