Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5A3C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jun 2022 20:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbiFMUGG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbiFMUFu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 16:05:50 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C7BA554
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 11:40:21 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l18so7127734lje.13
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 11:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SW1J4TxrbvE0J+NvABWMWUwXUDHi8O6WM5U0kmdXuvs=;
        b=YcOMN9J8NO13M1lsQJ09hM7cCxE8MS8M7Gv1MrIUfDqyrowxYIz0M4kq/4DzZS1VvJ
         X+WwlBoGf6CzRGJ8G1EjU7INISE4kKU0Z/BuQnIyh3+0qLr9mDdeVrnpP8AHGXywflLI
         gn4vt4eUHsaKF6mpPhECp6pZ2U/kiDWVsOWPKlO9R4E2oApQGpBRq/kLZZK9nbrMH8Vs
         rXrYvlBgBc2y9ISFPMRSym0HBSe8rRlM0D6NK0Ddpva36u6S2KIqGMmwmrN+Mz2tgqDy
         Zm5vDhOTpucmZ8RQFhCIrZBcGzE3vnnOhB0faQ7Lbps3yLPlEQLVSwLrlcC8TPCjgrM+
         10Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SW1J4TxrbvE0J+NvABWMWUwXUDHi8O6WM5U0kmdXuvs=;
        b=bcob/QIVW7pvjZ4mkL9NWgEQ3us7uqITAAsOBLLGxv/X2/lFkWapOAQOAsOjINCx+E
         3GWxzdmPh1XdAV2k7jC0QMXkTX8+b/6kJJuPEv2hdZLSPh9ceZRycjxBiIzYK5izVHAv
         h0QzhNFx7jGHCulCpH4udrojewfeQ0F0vjiI9cenlUpNvbnbguwydWpO6g3L16x7nktb
         D4g1BHPur2+aF9YcgXE0Ud+f+OzQRPJ5xRYLD9aDUR4yEYAIqCfpnZhydPp+fyNa8O0X
         Gbp1UPUt9SdQJUdC4OlgGXcP3QuA6BEjyUg9dD4Qz5ErVYgjJVZ2JeW/y1QPu9+hO6/h
         OoBg==
X-Gm-Message-State: AJIora+QczuCFDA9DVyVG4bAG0fWYAABL1LnJOpq+n0qPq/9zSJLXWDx
        KabGLOZ2cfR4DMWyluyV+OOkURB1iohHkyLF0HqH
X-Google-Smtp-Source: AGRyM1sc5PXhrpO/NALvqllDtgfvAmsGr0nMSO+nh757PXQ+6BPBVtmdCaZdkhadYmRsZLgDd/bC0jYF0EiuvoWxC2E=
X-Received: by 2002:a05:651c:1581:b0:255:48d1:fdae with SMTP id
 h1-20020a05651c158100b0025548d1fdaemr459115ljq.286.1655145619959; Mon, 13 Jun
 2022 11:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609221702.347522-8-morbo@google.com>
 <YqLUORmZQgG1D6lc@kroah.com>
In-Reply-To: <YqLUORmZQgG1D6lc@kroah.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 13 Jun 2022 11:40:08 -0700
Message-ID: <CAGG=3QV1DqiufpBRmUcYMEuH55OizMGLCcCiLhxaZ8FEwbn7gA@mail.gmail.com>
Subject: Re: [PATCH 07/12] driver/char: use correct format characters
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 9, 2022 at 10:18 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 09, 2022 at 10:16:26PM +0000, Bill Wendling wrote:
> > From: Bill Wendling <isanbard@gmail.com>
>
> Why isn't that matching your From: line in the email?
>
There must be something wrong with my .gitconfig file. I"ll check into it.

> >
> > When compiling with -Wformat, clang emits the following warnings:
>
> Is that ever a default build option for the kernel?
>
We want to enable -Wformat for clang. I believe that these specific
warnings have been disabled, but I'm confused as to why, because
they're valid warnings. When I compiled with the warning enabled,
there were only a few (12) places that needed changes, so thought that
patches would be a nice cleanup, even though the warning itself is
disabled.

> > drivers/char/mem.c:775:16: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
> >                               NULL, devlist[minor].name);
> >                                     ^~~~~~~~~~~~~~~~~~~
> >
> > Use a string literal for the format string.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/378
> > Signed-off-by: Bill Wendling <isanbard@gmail.com>
> > ---
> >  drivers/char/mem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 84ca98ed1dad..32d821ba9e4d 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -772,7 +772,7 @@ static int __init chr_dev_init(void)
> >                       continue;
> >
> >               device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
> > -                           NULL, devlist[minor].name);
> > +                           NULL, "%s", devlist[minor].name);
>
> Please explain how this static string can ever be user controlled.
>
All someone would need to do is accidentally insert an errant '%' in
one of the strings for this function call to perform unexpected
actions---at the very least reading memory that's not allocated and
may contain garbage, thereby decreasing performance and possibly
overrunning some buffer. Perhaps in this specific scenario it's
unlikely, but "device_create()" is used in a lot more places than
here. This patch is a general code cleanup.

-bw
