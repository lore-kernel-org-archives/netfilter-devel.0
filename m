Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADD3C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 11:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01AFE2070A
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 11:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWulIqJj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgERLE4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 07:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgERLE4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 07:04:56 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF2C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 04:04:55 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id a11so3275202uah.12
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 04:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WH3pJdcj8/DpAVnMdmBdtQq7u0DNIRX6sq0pbUTwWgY=;
        b=TWulIqJjJvxDV2C7lIDhp78WRxiiJJ12YJ5b8D0AT5rcZr2vEzjjGU3mRdFBOhJwfD
         M8DOQcmYl/NJtIEG67+51wCPkS91bDCfA2Jqc3uY+UfEvj9gW66x7/LSwvPkX1GTSIMt
         LKAlKbVqu/zMRKM4DZNYHsQyBmqMrP7Jv2ZgeHZ0bHYa01qfurv0DkUPbwgwcvdpEzAy
         v6HUI3K5UOvEJL2P6C+v2CL8YDdYnoi6vGnNFpsQu9xqPfSJa97mhPfuaDQihOehFvEd
         myhCGpPYzywH8vCe3FuLjEfe6/t2BYA7ZlkluLQ5rQZJYBkQhO6zku6a1xybIbe6pUPb
         QSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=WH3pJdcj8/DpAVnMdmBdtQq7u0DNIRX6sq0pbUTwWgY=;
        b=sk0M79Yt+Oovuatip9yCRBwUUddCDwFM0hWtE7wpi3R8G9RWjGfyMXeSvnbUBCi1e8
         mBUcDeIspahKgCVlutgVZVMyUMkBNEQxMFAwV/jT0QIbJrHWth852D2DjnX39WtJAb+n
         6JZGr7XthiEr3EqCCYckk0kHzXyE49rRlCBNLryThfEqtRbo0u4AQyVi2jDJsn0AXuD+
         VzgI/t04JWNTmPC4n85Lgpp+hziyweEL+Y4OLGY1535Ihs1fmKYOwUkhN0lfqbH5QW7Z
         /1+jKiyYuSA+8BBNB2QwczY75ykSDG/ZEK7kj72Wcp5fYjqRIS8Dbze77yUFQpKP8JlB
         NQ4Q==
X-Gm-Message-State: AOAM532YHNvMLyuOm76nWo5yAsTQit4xXNtZmdoRfRiojE9Q3Yv10mgm
        vEY/A43BjXHdN1LfW9L6TCP4vsifAkSZTxGOo8z1xz2E
X-Google-Smtp-Source: ABdhPJzgPqmGP2NpGQS4U0zv7Ig+XdG0Omo1iBr8LypYF7P8jeSxPF+xkhTa4ANH30EsKWEfZAZyVwVfYp/H1MuMllE=
X-Received: by 2002:ab0:b8d:: with SMTP id c13mr10342250uak.1.1589799895016;
 Mon, 18 May 2020 04:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200515163151.GA19398@nevthink> <20200516201738.GD31506@orbyte.nwl.cc>
 <CAF90-Wjn6vJJbjbSSiTqhcTqWGod9YyZTo3Ks2Q1JZx8Pj4dLg@mail.gmail.com> <20200518110025.GI31506@orbyte.nwl.cc>
In-Reply-To: <20200518110025.GI31506@orbyte.nwl.cc>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Mon, 18 May 2020 13:04:43 +0200
Message-ID: <CAF90-Wg_j+vLaZgM1oswWLc0Kaaw4FF1re0NQJSJuQfXLK6tLA@mail.gmail.com>
Subject: Re: [PATCH nft] build: fix tentative generation of nft.8 after
 disabled doc
To:     Phil Sutter <phil@nwl.cc>,
        =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, mattst88@gmail.com,
        devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 18, 2020 at 1:00 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Laura,
>
> On Sat, May 16, 2020 at 11:12:58PM +0200, Laura Garc=C3=ADa Li=C3=A9bana =
wrote:
> > On Sat, May 16, 2020 at 10:17 PM Phil Sutter <phil@nwl.cc> wrote:
> > > On Fri, May 15, 2020 at 06:31:51PM +0200, Laura Garcia Liebana wrote:
> > > > Despite doc generation is disabled, the makefile is trying to build=
 it.
> > > >
> > > > $ ./configure --disable-man-doc
> > > > $ make
> > > > Making all in doc
> > > > make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
> > > > make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  S=
top.
> > > > make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
> > > > make[1]: *** [Makefile:479: all-recursive] Error 1
> > > > make[1]: Leaving directory '/workdir/build-pkg/workdir'
> > > > make: *** [Makefile:388: all] Error 2
> > > >
> > > > Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist t=
arball")
> > > >
> > > > Reported-by: Adan Marin Jacquot <adan.marin@zevenet.com>
> > > > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > > > ---
> > > >  doc/Makefile.am | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/doc/Makefile.am b/doc/Makefile.am
> > > > index 6bd90aa6..21482320 100644
> > > > --- a/doc/Makefile.am
> > > > +++ b/doc/Makefile.am
> > > > @@ -1,3 +1,4 @@
> > > > +if BUILD_MAN
> > > >  man_MANS =3D nft.8 libnftables-json.5 libnftables.3
> > >
> > > Did you make sure that dist tarball still contains the generated man
> > > pages after your change? Because that's what commit 4f2813a313ae0
> > > ("build: Include generated man pages in dist tarball") tried to fix a=
nd
> > > apparently broke what you're fixing for.
> > >
> >
> > Hi Phil, I tested these cases:
> > - if the nft.8 already exists it won't be generated
> > - if it doesn't exist it will be generated
> > - if disable-man-doc then it won't be generated
> >
> > I'm missing something?
>
> No, I think your patch is fine. I wasn't sure what happens if man_MANS,
> EXTRA_DIST, etc. get enclosed by the conditional. Matt's patch
> explicitly removed the conditionals around man_MANS.
>
> I tried 'make dist' after configure with --enable-man-doc and the
> generated tarball's build system seems to behave fine (man pages are
> included, not built again and also installed from 'make install').
>
> So for your patch:
>
> Acked-by: Phil Sutter <phil@nwl.cc>
>

Ok, great.

Thank you for your checking.
