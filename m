Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD30C04AAF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 16:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbjITQuG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjITQuG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 12:50:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4949F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 09:50:00 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qj0Ok-0005Cs-5f; Wed, 20 Sep 2023 18:49:58 +0200
Date:   Wed, 20 Sep 2023 18:49:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
Message-ID: <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230920131554.204899-1-thaller@redhat.com>
 <20230920131554.204899-4-thaller@redhat.com>
 <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc>
 <ZQsYf3moTtXQytXX@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQsYf3moTtXQytXX@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 06:06:23PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 04:13:43PM +0200, Phil Sutter wrote:
> > On Wed, Sep 20, 2023 at 03:13:40PM +0200, Thomas Haller wrote:
> > [...]
> > > There are many places that rightly cast away const during free. But not
> > > all of them. Add a free_const() macro, which is like free(), but accepts
> > > const pointers. We should always make an intentional choice whether to
> > > use free() or free_const(). Having a free_const() macro makes this very
> > > common choice clearer, instead of adding a (void*) cast at many places.
> > 
> > I wonder whether pointers to allocated data should be const in the first
> > place. Maybe I miss the point here? Looking at flow offload statement
> > for instance, should 'table_name' not be 'char *' instead of using this
> > free_const() to free it?
> 
> The const here tells us that this string is set once and it gets never
> updated again, which provides useful information when reading the
> code IMO.

That seems like reasonable rationale. I like to declare function
arguments as const too in order to mark them as not being altered by the
function.

With strings, I find it odd to do:

const char *buf = strdup("foo");
free((void *)buf);

> I interpret from Phil's words that it would be better to consolidate
> this to have one single free call, in that direction, I agree.

No, I was just wondering why we have this need for free_const() in the
first place (i.e., why we declare pointers as const if we allocate/free
them).

> /* Just free(), but casts to a (void*). This is for places where
>  * we have a const pointer that we know we want to free. We could just
>  * do the (void*) cast, but free_const() makes it clear that this is
>  * something we frequently need to do and it's intentional. */
> #define free_const(ptr) free((void *)(ptr))
> 
> I like this macro.
> 
> Maybe turn it into:
> 
>         nft_free(ptr)
> 
> and we use it everywhere?

I believe this is exactly what Thomas is trying to move away from. IIUC,
he wants to have a "special" free() to mark the spots where a const
pointer is freed (and make it a more deliberate action).

Cheers, Phil
