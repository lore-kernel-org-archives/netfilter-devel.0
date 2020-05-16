Return-Path: <SRS0=1dHg=66=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D56C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 May 2020 21:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B796206D8
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 May 2020 21:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="krkMbzw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgEPVNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 May 2020 17:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726663AbgEPVNL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 May 2020 17:13:11 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FB1C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2020 14:13:10 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id c17so2093800uaq.13
        for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2020 14:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ma8E0iN70mJwKIH+ccZUt9OUPAfHbcOVN0AFD/8ytdQ=;
        b=krkMbzw82rj0YCHtN3PnBrbN+ff/UYzT4Zl1MBcGpXOXga4acdlwB+8etT3aNZtn5P
         Wzz36MydLcfyxMXfLh3r3LkvlKNMdxxI/+kDrchXrkhq5PtvkOOzLm9xJ2a7miEZrMNn
         fuAic0Z3Ygo21ZAHs3bycxFTRHNX/lWnErP7ofN5PzQUj8rTULlgWhNtw9OqCOS1D+Om
         2M0agRrdw8gv2Oy0A8GOe8O8h8CHEgOJj3v5Fu0xH2ntSDDBw0ZtqaIlZ00veAZ4QIKL
         T7CFGSqCbrN2WpChsiKq1zLQCR1G78YBeHAlh9Ue2YEQZmLuiUKhxiaK/7TAXaUldqbu
         KQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ma8E0iN70mJwKIH+ccZUt9OUPAfHbcOVN0AFD/8ytdQ=;
        b=HZuwQOyRKlw7uOQGXQCrVm8oCknvMO0nkJmSo7TttqiGYFAOJGq4a1PSfwYk6X7wa6
         IMvnE1gXy3gNEQU4dQKMxtqtg1OYUcL9m/apqyLUfAMhDMTWSWu08SORFoEybTkIq68R
         4WS2VIyN2wHASSq23TrrNz9mC5Qp5YJ93j1pmYlqhwPxZ3LNPEQfTA+BplGoZJGrFM8g
         voeGSGeis7cR9PpQTXL0dtenCTS6jD264Ps504spR0w1V1vGskAgsqtyPhZSbnC53/+/
         Xw6pAuEQLEkXd/fW8Ff1IxOq3I8p9hq8M2vH085mWhcXlUI65mpfTw/I92WWrpVWTkFp
         K8mg==
X-Gm-Message-State: AOAM530XQfJl46kjn4QcHDDn2Xhe9IdlVKRI6TViQ1TIySmWber6mN3M
        LGx3BEIWwRsXVgUKCWnqHuZeSCrgEvRvBE8hBsI=
X-Google-Smtp-Source: ABdhPJy5qYHWjUB6KMmOKvq7G3kXb6dffdqFle7hRbs52hHGW96tcgmaH5jIQW5Zmx5g2pY4eSXGTmytMrR9nNm1Qv0=
X-Received: by 2002:a9f:372e:: with SMTP id z43mr6954968uad.54.1589663589236;
 Sat, 16 May 2020 14:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200515163151.GA19398@nevthink> <20200516201738.GD31506@orbyte.nwl.cc>
In-Reply-To: <20200516201738.GD31506@orbyte.nwl.cc>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Sat, 16 May 2020 23:12:58 +0200
Message-ID: <CAF90-Wjn6vJJbjbSSiTqhcTqWGod9YyZTo3Ks2Q1JZx8Pj4dLg@mail.gmail.com>
Subject: Re: [PATCH nft] build: fix tentative generation of nft.8 after
 disabled doc
To:     Phil Sutter <phil@nwl.cc>, Laura Garcia Liebana <nevola@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, mattst88@gmail.com,
        devel@zevenet.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 16, 2020 at 10:17 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi Laura,
>
> On Fri, May 15, 2020 at 06:31:51PM +0200, Laura Garcia Liebana wrote:
> > Despite doc generation is disabled, the makefile is trying to build it.
> >
> > $ ./configure --disable-man-doc
> > $ make
> > Making all in doc
> > make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
> > make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  Stop.
> > make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
> > make[1]: *** [Makefile:479: all-recursive] Error 1
> > make[1]: Leaving directory '/workdir/build-pkg/workdir'
> > make: *** [Makefile:388: all] Error 2
> >
> > Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist tarball")
> >
> > Reported-by: Adan Marin Jacquot <adan.marin@zevenet.com>
> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> >  doc/Makefile.am | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/doc/Makefile.am b/doc/Makefile.am
> > index 6bd90aa6..21482320 100644
> > --- a/doc/Makefile.am
> > +++ b/doc/Makefile.am
> > @@ -1,3 +1,4 @@
> > +if BUILD_MAN
> >  man_MANS = nft.8 libnftables-json.5 libnftables.3
>
> Did you make sure that dist tarball still contains the generated man
> pages after your change? Because that's what commit 4f2813a313ae0
> ("build: Include generated man pages in dist tarball") tried to fix and
> apparently broke what you're fixing for.
>

Hi Phil, I tested these cases:
- if the nft.8 already exists it won't be generated
- if it doesn't exist it will be generated
- if disable-man-doc then it won't be generated

I'm missing something?

Thanks!
