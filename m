Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDA2C04AA9
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 16:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjITQEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbjITQEv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 12:04:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E83CD6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 09:04:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qizgw-0004kH-40; Wed, 20 Sep 2023 18:04:42 +0200
Date:   Wed, 20 Sep 2023 18:04:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] gmputil: add nft_gmp_free() to free strings from
 mpz_get_str()
Message-ID: <ZQsYGpnBigZ8ETX2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230920131554.204899-1-thaller@redhat.com>
 <20230920131554.204899-3-thaller@redhat.com>
 <ZQr8KsFAXIT0mca9@orbyte.nwl.cc>
 <9d90f25dd24e76567e784c93b2a1a5493c14e379.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d90f25dd24e76567e784c93b2a1a5493c14e379.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 04:46:12PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-20 at 16:05 +0200, Phil Sutter wrote:
> > On Wed, Sep 20, 2023 at 03:13:39PM +0200, Thomas Haller wrote:
> > > 
> > > +       mp_get_memory_functions(NULL, NULL, &free_fcn);
> > 
> > Do we have to expect the returned pointer to change at run-time?
> > Because
> > if not, couldn't one make free_fcn static and call
> > mp_get_memory_functions() only if it's NULL?
> 
> Hi Phil,
> 
> 
> no, it's not expected to EVER change. Users must not change
> mp_set_memory_functions() after any GMP objects were allocated,
> otherwise there would be a mixup of allocators and crashes ahead.
> 
> However, I didn't cache the value, because I don't want to use global
> data without atomic compare-exchange (or thread-local). Doing it
> without regard of thread-safety so would be a code smell (even if
> probably not an issue in practice). And getting it with atomic/thread-
> local would be cumbersome. It's hard to ensure a code base has no
> threading issues, when having lots of places that "most likely are
> 99.99% fine (but not 100%)". Hence, I want to avoid the global.

OK, thanks.

> I think the call to mp_get_memory_functions() should be cheap.

Yes, the function is indeed very simple.

Cheers, Phil
