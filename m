Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9DFC433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE71C206E7
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgIBQji (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 12:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIBQjh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 12:39:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8464BC061244
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2020 09:39:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kDVnK-0008VZ-1z; Wed, 02 Sep 2020 18:39:34 +0200
Date:   Wed, 2 Sep 2020 18:39:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nf,v3] netfilter: nf_tables: coalesce multiple
 notifications into one skbuff
Message-ID: <20200902163934.GF23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, eric@garver.life
References: <20200902163743.18697-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902163743.18697-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 02, 2020 at 06:37:43PM +0200, Pablo Neira Ayuso wrote:
> On x86_64, each notification results in one skbuff allocation which
> consumes at least 768 bytes due to the skbuff overhead.
> 
> This patch coalesces several notifications into one single skbuff, so
> each notification consumes at least ~211 bytes, that ~3.5 times less
> memory consumption. As a result, this is reducing the chances to exhaust
> the netlink socket receive buffer.
> 
> Rule of thumb is that each notification batch only contains netlink
> messages whose report flag is the same, nfnetlink_send() requires this
> to do appropriately delivery to userspace, either via unicast (echo
> mode) or multicast (monitor mode).
> 
> The skbuff control buffer is used to annotate the report flag for later
> handling at the new coalescing routine.
> 
> The batch skbuff notification size is NLMSG_GOODSIZE, using a larger
> skbuff would allow for more socket receiver buffer savings (to amortize
> the cost of the skbuff even more), however, going over that size might
> break userspace applications, so let's be conservative and stick to
> NLMSG_GOODSIZE.
> 
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
