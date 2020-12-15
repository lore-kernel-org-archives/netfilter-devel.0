Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C024AC4361B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 776A6207CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgLOKNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgLOKNq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 05:13:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED5EC06179C
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2020 02:13:05 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kp7KK-0001tu-6Y; Tue, 15 Dec 2020 11:13:04 +0100
Date:   Tue, 15 Dec 2020 11:13:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 1/2] set_elem: Use nftnl_data_reg_snprintf()
Message-ID: <20201215101304.GG28824@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201214180251.11408-1-phil@nwl.cc>
 <20201214183023.GA9271@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214183023.GA9271@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Dec 14, 2020 at 07:30:23PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 14, 2020 at 07:02:50PM +0100, Phil Sutter wrote:
> > Introduce a flag to allow toggling the '0x' prefix when printing data
> > values, then use the existing routines to print data registers from
> > set_elem code.
> 
> Patches LGTM.

Thanks, I'll push it along with the change in nftables' tests/py.

> You will have to update tests/py too, right?

To my surprise, it's merely a single test case that needed adjustment.
Either I missed something (testing stops before payload comparison if
e.g. input and output differ) or we really have quite low concat-range
coverage.

Cheers, Phil
