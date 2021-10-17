Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23FBC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 01:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE8060F8F
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 01:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244850AbhJQB62 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 21:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244869AbhJQB6Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 21:58:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127E4C06176D
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 18:56:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q19so11812664pfl.4
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 18:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=512qeNBOCY5KRepEppzWlR+8yj69cWOECi3euasR7J0=;
        b=prvbSNu3hWwMnJ5oH+WppOZWb18cPaVOyVLLxAuJUfDnF9v33DfQC0/D8r7rfGQR1W
         oLmZfCGOXOGezSd2jY2/p3j7QhNDEGr6vSrbitnHmOsdW7ohAZzdRHUoRnSMxpYyuJby
         tXZvf1mk6i3+PqKCP+7OxRzjDuWBjtAdz0bsr6aVHioXvqPrePT7mlodIej9Glrlzmi7
         X+CYKaObJnMmJOeZv3IaP7Fiog72bVM631qn8xo5qxD0DuibVsYwnjPbzpX5hvtnLX9u
         QSH3/7TXwq1Cp1B9vsu4DxwJThMiJYbq/XDj1jFkySzK9EeE2cXQTMRIog9FOJv/MJMb
         pd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=512qeNBOCY5KRepEppzWlR+8yj69cWOECi3euasR7J0=;
        b=MtXHb5P/5g1JINPZIo4fFO7QMZs4H54csZP3Epk7B0xXclZkrg4aOYT3V46zIzOwY2
         kMZx16CE1gfogLjdu22yvzb3OzMwBpcLX0STonWKgscmzeu4Y0eXcqZkXHeP0sFFvzY6
         /4RmU3FihyVAODiuTa98dpPUDU/a5dAVLJx+lIVLdWd309HY9ZLRRHLJKUnEHLEX5zCK
         gkbhayZgS34uxCRFIyEWOoQ6EBx/8RkX8oBySR6pzYhVFJkBwRM+1+fgJnsmC6h5Ajlk
         xap/QfyHCTGvdwa3yPiZAheKIMJngBXMYje4RgeOiAu+KwjzJXBnTUoEX7QwR+9LJv3g
         uLEg==
X-Gm-Message-State: AOAM532C+ez7+5LtO4ctNLMMrFEnQ3B/C2w0sgKPU8YPZKhtoiE6N/eL
        y7iMjhP2QjofMDGgwQ+b3eRDMiWRFc4=
X-Google-Smtp-Source: ABdhPJy0XuQKkuNMMZ8K6ySTdeMlRRNtHkJVKwZfITuJHXXdzXQdTKMH0Wzi335wLNXZpMej2X8/sQ==
X-Received: by 2002:a62:d11e:0:b0:446:d705:7175 with SMTP id z30-20020a62d11e000000b00446d7057175mr20897367pfg.74.1634435772905;
        Sat, 16 Oct 2021 18:56:12 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id x7sm15056177pjg.5.2021.10.16.18.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 18:56:12 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 17 Oct 2021 12:56:07 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: You dropped the wrong patvh from patchwork
Message-ID: <YWuCt8cFd3k5YcXz@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20211016043948.2422-1-duncan_roe@optusnet.com.au>
 <YWp+/MO6jhvgUdGM@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWp+/MO6jhvgUdGM@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Oct 16, 2021 at 06:27:56PM +1100, Duncan Roe wrote:
> On Sat, Oct 16, 2021 at 03:39:48PM +1100, Duncan Roe wrote:
> > - configure --help lists non-default documentation options.
> >   Looking around the web, this seemed to me to be what most projects do.
> >   Listed options are --enable-html-doc & --disable-man-pages.
> > - --with-doxygen is removed: --disable-man-pages also disables doxygen unless
> >   --enable-html-doc is asserted.
> > If html is requested, `make install` installs it in htmldir.
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> > v2: broken out from 0001-build-doc-Fix-man-pages.patch
> > v3: no change (still part of a series)
> > v4: remove --without-doxygen since -disable-man-pages does that
> > v5: - update .gitignore for clean `git status` after in-tree build
> >     - in configure.ac:
> >       - ensure all variables are always set (avoid leakage from environment)
> >       - provide helpful warning if HTML enabled but dot not found
> [...]
> Sorry Pablo, this is for libnetfilter_queue.
> I don't see it in patchwork - did you get rid of it already?
> Will re-send with correct Sj.
>
Sorry again for the confusion but you dropped the good libnetfilter_log patch
that was Tested-by: Jeremy Sowden and left the bad libnetfilter_log patch that
actually applies to libnetfilter_queue.
To save you the time to reinstate the dropped patch, I have re-sent it.
It's in Patchwork - title is

libnetfilter_log,v5,1/1] build: doc: `make` generates requested documentation

Can you please post a comment why you have not applied this patch or the
libnetfilter_queue corrresponding patch?

Can I change anything to get you to apply them?

Cheers ... Duncan.
