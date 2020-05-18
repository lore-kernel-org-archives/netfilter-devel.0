Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A12C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 11:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB59F20709
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 11:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgERLA3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgERLA3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 07:00:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA806C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 04:00:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jadVR-0007Jo-99; Mon, 18 May 2020 13:00:25 +0200
Date:   Mon, 18 May 2020 13:00:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, mattst88@gmail.com,
        devel@zevenet.com
Subject: Re: [PATCH nft] build: fix tentative generation of nft.8 after
 disabled doc
Message-ID: <20200518110025.GI31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Laura =?utf-8?Q?Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, mattst88@gmail.com,
        devel@zevenet.com
References: <20200515163151.GA19398@nevthink>
 <20200516201738.GD31506@orbyte.nwl.cc>
 <CAF90-Wjn6vJJbjbSSiTqhcTqWGod9YyZTo3Ks2Q1JZx8Pj4dLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF90-Wjn6vJJbjbSSiTqhcTqWGod9YyZTo3Ks2Q1JZx8Pj4dLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Laura,

On Sat, May 16, 2020 at 11:12:58PM +0200, Laura García Liébana wrote:
> On Sat, May 16, 2020 at 10:17 PM Phil Sutter <phil@nwl.cc> wrote:
> > On Fri, May 15, 2020 at 06:31:51PM +0200, Laura Garcia Liebana wrote:
> > > Despite doc generation is disabled, the makefile is trying to build it.
> > >
> > > $ ./configure --disable-man-doc
> > > $ make
> > > Making all in doc
> > > make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
> > > make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  Stop.
> > > make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
> > > make[1]: *** [Makefile:479: all-recursive] Error 1
> > > make[1]: Leaving directory '/workdir/build-pkg/workdir'
> > > make: *** [Makefile:388: all] Error 2
> > >
> > > Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist tarball")
> > >
> > > Reported-by: Adan Marin Jacquot <adan.marin@zevenet.com>
> > > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > > ---
> > >  doc/Makefile.am | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/doc/Makefile.am b/doc/Makefile.am
> > > index 6bd90aa6..21482320 100644
> > > --- a/doc/Makefile.am
> > > +++ b/doc/Makefile.am
> > > @@ -1,3 +1,4 @@
> > > +if BUILD_MAN
> > >  man_MANS = nft.8 libnftables-json.5 libnftables.3
> >
> > Did you make sure that dist tarball still contains the generated man
> > pages after your change? Because that's what commit 4f2813a313ae0
> > ("build: Include generated man pages in dist tarball") tried to fix and
> > apparently broke what you're fixing for.
> >
> 
> Hi Phil, I tested these cases:
> - if the nft.8 already exists it won't be generated
> - if it doesn't exist it will be generated
> - if disable-man-doc then it won't be generated
> 
> I'm missing something?

No, I think your patch is fine. I wasn't sure what happens if man_MANS,
EXTRA_DIST, etc. get enclosed by the conditional. Matt's patch
explicitly removed the conditionals around man_MANS.

I tried 'make dist' after configure with --enable-man-doc and the
generated tarball's build system seems to behave fine (man pages are
included, not built again and also installed from 'make install').

So for your patch:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
