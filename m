Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEECC04FD1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 18:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjITSXB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjITSXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 14:23:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C495ECF
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 11:22:52 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qj1qc-0006Ju-JZ; Wed, 20 Sep 2023 20:22:50 +0200
Date:   Wed, 20 Sep 2023 20:22:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
Message-ID: <ZQs4eu74k86+7FK0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230920131554.204899-1-thaller@redhat.com>
 <20230920131554.204899-4-thaller@redhat.com>
 <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc>
 <ZQsYf3moTtXQytXX@calendula>
 <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
 <754c07f7fc0a44d3619e51993c7a891a064ccdae.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <754c07f7fc0a44d3619e51993c7a891a064ccdae.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 08:03:17PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-20 at 18:49 +0200, Phil Sutter wrote:
> > On Wed, Sep 20, 2023 at 06:06:23PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Sep 20, 2023 at 04:13:43PM +0200, Phil Sutter wrote:
> > > > On Wed, Sep 20, 2023 at 03:13:40PM +0200, Thomas Haller wrote:
> > > > [...]
> > > > > There are many places that rightly cast away const during free.
> > > > > But not
> > > > > all of them. Add a free_const() macro, which is like free(),
> > > > > but accepts
> > > > > const pointers. We should always make an intentional choice
> > > > > whether to
> > > > > use free() or free_const(). Having a free_const() macro makes
> > > > > this very
> > > > > common choice clearer, instead of adding a (void*) cast at many
> > > > > places.
> > > > 
> > > > I wonder whether pointers to allocated data should be const in
> > > > the first
> > > > place. Maybe I miss the point here? Looking at flow offload
> > > > statement
> > > > for instance, should 'table_name' not be 'char *' instead of
> > > > using this
> > > > free_const() to free it?
> > > 
> > > The const here tells us that this string is set once and it gets
> > > never
> > > updated again, which provides useful information when reading the
> > > code IMO.
> > 
> > That seems like reasonable rationale. I like to declare function
> > arguments as const too in order to mark them as not being altered by
> > the
> > function.
> > 
> > With strings, I find it odd to do:
> > 
> > const char *buf = strdup("foo");
> > free((void *)buf);
> > 
> > > I interpret from Phil's words that it would be better to
> > > consolidate
> > > this to have one single free call, in that direction, I agree.
> > 
> > No, I was just wondering why we have this need for free_const() in
> > the
> > first place (i.e., why we declare pointers as const if we
> > allocate/free
> > them).
> 
> 
> I think that we use free_const() is correct.
> 
> 
> Look at "struct datatype", which are either immutable global instances,
> or heap allocated (and ref-counted). For the most part, we want to
> treat these instances (both constant and allocated) as immutable, and
> the "const" specifier expresses that well.

So why doesn't datatype_get() return a const pointer then? I don't find
struct datatype a particularly good example here: datatype_free() does
not require free_const() at all.

BTW: I found two lines in src/netlink.c reading:

| datatype_free(datatype_get(dtype));

Aren't those just fancy nops?

Cheers, Phil
