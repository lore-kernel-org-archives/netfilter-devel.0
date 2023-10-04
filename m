Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EB6E8FDD1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 08:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241624AbjJDIX5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 04:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjJDIX4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 04:23:56 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC91A6
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 01:23:52 -0700 (PDT)
Received: from [78.30.34.192] (port=50006 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnxAa-009paH-Sm; Wed, 04 Oct 2023 10:23:51 +0200
Date:   Wed, 4 Oct 2023 10:23:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZR0hFIIqdTixdPi4@calendula>
References: <ZRtBkeP9TYJ10Nrm@calendula>
 <ZRtKbZmqr4uZRT9Y@orbyte.nwl.cc>
 <ZRvG5vesKHRyUvzx@calendula>
 <ZRw6B+28jT/uJxJP@orbyte.nwl.cc>
 <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231004080702.GD15013@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 04, 2023 at 10:07:02AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > We will soon need NFT_MSG_GETRULE_RESET_NO_TIMEOUT to undo this combo
> > command semantics, from userspace this will require some sort of 'nft
> > reset table x notimeout' syntax.
> 
> NFT_MSG_GETRULE_RESET_NO_TIMEOUT sounds super ugly :/
> 
> Do you think we can add a flags attr that describes which parts
> to reset?

Sure. This will require one attribute for each object type, also
reject it where it does not make sense.

> No flags attr would reset everything.

Refreshing timers is a bad default behaviour.

And how does this mix with the set element timeout model from
transaction? Now timers becomes a "moving target" again with this
refresh? Oh, this will drag commit_mutex to netlink dump path to avoid
that.

> Do you consider reset of timers to be something that must
> be handled via transaction infra or do you think it can
> (re)use the dump-and-reset approach?

The question why user wants to reset the timers in this path.

For counters, this is to collect stats while leaving remaining things
as is. Refreshing timers make no sense to me.

For quota, this is to fetch the consumed quota and restart it, it
might make sense to refresh the timer, but transaction sounds like a
better path for this usecase?

For limit, they do not expose internal stateful information, so this
just a reset. Timer refresh makes no sense to me here.

If this is for a dynamic set, user is refreshing/extending the
timeout, but usually it is packet path that refreshes this timeouts
via update.

This reset feature is just there to collect stateful properties and
leave things as is.
