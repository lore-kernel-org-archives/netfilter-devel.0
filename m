Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293ECE776C7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 21:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjJBVub (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjJBVua (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 17:50:30 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C98AB
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 14:50:27 -0700 (PDT)
Received: from [78.30.34.192] (port=36648 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnQo3-00GXA4-Jr; Mon, 02 Oct 2023 23:50:25 +0200
Date:   Mon, 2 Oct 2023 23:50:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZRs7H7C/Xr7dbRc7@calendula>
References: <20231002090516.3200649-1-pablo@netfilter.org>
 <ZRsGslT23xzSsbgd@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZRsGslT23xzSsbgd@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 02, 2023 at 08:06:42PM +0200, Phil Sutter wrote:
> On Mon, Oct 02, 2023 at 11:05:16AM +0200, Pablo Neira Ayuso wrote:
> > The dump and reset command should not refresh the timeout, this command
> > is intended to allow users to list existing stateful objects and reset
> > them, element expiration should be refresh via transaction instead with
> > a specific command to achieve this, otherwise this is entering combo
> > semantics that will be hard to be undone later (eg. a user asking to
> > retrieve counters but _not_ requiring to refresh expiration).
> 
> From a users' perspective, what is special about the element expires
> value disqualifying it from being reset along with any counter/quota
> values?
>
> Do you have a PoC for set element reset via transaction yet? Can we
> integrate non-timeout resets with it, too? Because IIUC, that's an
> alternative to the pending reset locking.

Problem is listing is not supported from transaction path, this is
using existing netlink dump infrastructure which runs lockless via
rcu. So we could support reset, but we could not use netlink dump
semantics to fetch the values, and user likely wants this to
fetch-and-reset as in ctnetlink.

> What we have now is a broad 'reset element', not specifying what to
> reset. If the above is a feature being asked for, I'd rather implement
> 'reset element counter', 'reset element timeout', 'reset element quota',
> etc. commands.

We are currently discussing how to implement refresh timeout into the
transaction model.

I would suggest we keep this chunk away by now for the _RESET command,
until we agree on next steps.
