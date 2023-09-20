Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1663DC04AA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 16:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbjITQGe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbjITQGd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 12:06:33 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92FCB9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 09:06:27 -0700 (PDT)
Received: from [78.30.34.192] (port=36028 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qizia-004aDM-6Y; Wed, 20 Sep 2023 18:06:26 +0200
Date:   Wed, 20 Sep 2023 18:06:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
Message-ID: <ZQsYf3moTtXQytXX@calendula>
References: <20230920131554.204899-1-thaller@redhat.com>
 <20230920131554.204899-4-thaller@redhat.com>
 <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 04:13:43PM +0200, Phil Sutter wrote:
> On Wed, Sep 20, 2023 at 03:13:40PM +0200, Thomas Haller wrote:
> [...]
> > There are many places that rightly cast away const during free. But not
> > all of them. Add a free_const() macro, which is like free(), but accepts
> > const pointers. We should always make an intentional choice whether to
> > use free() or free_const(). Having a free_const() macro makes this very
> > common choice clearer, instead of adding a (void*) cast at many places.
> 
> I wonder whether pointers to allocated data should be const in the first
> place. Maybe I miss the point here? Looking at flow offload statement
> for instance, should 'table_name' not be 'char *' instead of using this
> free_const() to free it?

The const here tells us that this string is set once and it gets never
updated again, which provides useful information when reading the
code IMO.

I interpret from Phil's words that it would be better to consolidate
this to have one single free call, in that direction, I agree.

/* Just free(), but casts to a (void*). This is for places where
 * we have a const pointer that we know we want to free. We could just
 * do the (void*) cast, but free_const() makes it clear that this is
 * something we frequently need to do and it's intentional. */
#define free_const(ptr) free((void *)(ptr))

I like this macro.

Maybe turn it into:

        nft_free(ptr)

and we use it everywhere?

BTW, nitpick, netdev comment style is preferred:

/* Just free(), but casts to a (void*). This is for places where
 * we have a const pointer that we know we want to free. We could just
 * do the (void*) cast, but free_const() makes it clear that this is
 * something we frequently need to do and it's intentional.
 */

Thanks!
