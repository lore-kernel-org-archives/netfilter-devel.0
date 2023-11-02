Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86577C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 16:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbjKBQF7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 12:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjKBQF6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 12:05:58 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DC8186
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 09:05:51 -0700 (PDT)
Received: from [78.30.35.151] (port=56926 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyaCW-009ng0-QU; Thu, 02 Nov 2023 17:05:49 +0100
Date:   Thu, 2 Nov 2023 17:05:44 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Subject: Re: [PATCH nft v2 4/7] build: no recursive make for
 "files/**/Makefile.am"
Message-ID: <ZUPI2ItCERJy8a+3@calendula>
References: <20231019130057.2719096-1-thaller@redhat.com>
 <20231019130057.2719096-5-thaller@redhat.com>
 <ZUOEpOU96ai+dmT7@calendula>
 <ZUOIWNT3sjmqd8EM@calendula>
 <db1347b7716868923326a870d87ccaf9d2572633.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db1347b7716868923326a870d87ccaf9d2572633.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 03:03:42PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-02 at 12:30 +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 02, 2023 at 12:14:49PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 19, 2023 at 03:00:03PM +0200, Thomas Haller wrote:
> > > > diff --git a/Makefile.am b/Makefile.am
> > > > index 8b8de7bd141a..83f25dd8574b 100644
> > > > --- a/Makefile.am
> > > > +++ b/Makefile.am
> > > > @@ -2,6 +2,8 @@ ACLOCAL_AMFLAGS = -I m4
> > > >  
> > > >  EXTRA_DIST =
> > > >  
> > > > +################################################################
> > > > ###############
> > > 
> > > This marker shows that this Makefile.am is really getting too big.
> > > 
> > > Can we find a middle point?
> > > 
> > > I understand that a single Makefile for something as little as
> > > examples/Makefile.am is probably too much.
> > > 
> > > No revert please, something incremental, otherwise this looks like
> > > iptables' Makefile.
> > 
> > Correction: Actually iptables' Makefiles show a better balance in how
> > things are split accross Makefiles, with some possibilities to
> > consolidate things but it looks much better these days.
> > 
> 
> Basically, what I said in the commit message of [1]. Do you disagree
> with anything specifically (or all of it?).
> 
> [1] https://git.netfilter.org/nftables/commit/?id=686d987706bf643f2fa75c1993a5720ad55e6df1
> 
> It's a matter of opinion entirely, but I disagree that the iptables'
> Makefiles are a positive example.
> 
> ---
> 
> 
> The ### line is only a visual aid.

Yes, because it is too large and you needed this visual aid.

> `wc -l` seems the better indication for when the file gets too big.
> A too big file, can be an indication that it's hard to maintain.
> After all, it's about maintainability, being understandable and
> correctness. But is it now really harder to understand, and would
> splitting it into multiple files make it better?
> 
> - see how you would add a new .c/.h file. Can you find it easily with
> the large Makefile?
> 
> - see how libnftables.la is build. Can you find it?
> 
> - see who uses libnftables.la. Can you find it?
> 
> - which dependencies has libnftables.la? Which CFLAGS?

We __rarely__ need to look at all these things at once.

I do not even remember when it was last time I needed to look into
these Makefiles, well now after this churning^H^H^H^H^H^H^H update :-)

> Don't try to understand the file at once. Look what you want to do or
> look at a single aspect you'd like to understand, and how hard that is
> now (I claim, it became simpler!).
> 
> I mean, previously you could read "examples/Makefile.am" at once. But
> when you type `make -C examples` then the dependencies were wrong and
> parallel build doesn't work (across directories). Look how it's now.
> Can you find how examples are build in the large Makefile.am?
> 
> It's all in one file, open in your editor and easy to jump around.

Yes, it is as long as this email :-)

> --
> 
> Another example: "src/expression.c" is 5k+. See how most include/*.h
> include each other, meaning that most source files end up with all
> headers included. Overall, the cohesion/coupling of the code doesn't
> seem great. Maybe it needs to be that way and couldn't be better. The
> point is: 5k+ LOC may be a problem, but it's not as simple as "just
> split it" or "just move functions ~arbitrarily~ into more files". I say
> "arbitrarily" unless you find independent pieces that can be
> meaningfully split.

No, some .c files are really asking for split, and I have patches to
start doing so.

> Likewise, Makefile.am contains the build configuration of the project.
> It's strongly coupled and to some degree, you need to see it as a
> whole. At least, `make` needs to see it as a whole, which SUBDIRS= does
> not. This will be more relevant, when actually adding unit tests and
> integrating tests into `make check`.

Yes, it is great, really.

But this is completely inconsistent with what we have in other existing
Netfilter trees.

> The lack of not integrating tests in `make` (and not having unit tests)
> is IMO bad and should be addressed. I claim, with one make file, that
> will fit beautifully together (maintainable). The unit tests will be in
> another directories, which requires correct dependencies between
> tests/unit/ and src/. With recursive make (SUBDIRS=) it's only
> "everything under src/ must build first", which hampers parallel make
> and does not express dependencies correctly.

No please, do not follow that path.

I have to run `make distcheck` to create tarballs, and I do not have
to wait to run all tests to do so.

Please do not couple tests with make process.
