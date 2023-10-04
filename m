Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78941E7C4C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 14:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbjJDOcg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 10:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjJDOcg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 10:32:36 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB01C1
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 07:32:31 -0700 (PDT)
Received: from [78.30.34.192] (port=57658 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qo2vL-00Bk5r-LK; Wed, 04 Oct 2023 16:32:29 +0200
Date:   Wed, 4 Oct 2023 16:32:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZR13ejv1iBzrzEor@calendula>
References: <ZRxNnYWrsw0VXBNn@calendula>
 <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
 <20231004084623.GA9350@breakpoint.cc>
 <ZR0v54xJwllozQhR@calendula>
 <20231004124845.GA3974@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231004124845.GA3974@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 04, 2023 at 02:48:45PM +0200, Florian Westphal wrote:
> I also think we need to find a different strategy for the
> dump-and-reset part when the reset could be interrupted
> by a transaction.

I think it should be possible to deal with this from userspace.

The idea would be to keep the old cache. Then, from the new cache, if
EINTR happened before, iterate over the list of objects in the new
cache and then lookup for the old objects, then pour the stats from
the old to the new objects, then release old cache. Then only one old
cache is kept around in worst case. This needs a lookup function for
each stateful object type on the old cache based on the handle.
