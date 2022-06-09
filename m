Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BDCCCA473
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 23:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345995AbiFIXQb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 19:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245602AbiFIXQb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 19:16:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002F3C2220
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 16:16:29 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i29so23514916lfp.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 16:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qQsabkwxRvA8bdaAfDmJWrhJnuevA/KFdg/I1GgKtI=;
        b=Ild0j7K/fhaVoC0PM7iI7pWdMAhRoR7/W2DRfNt0y6B95s4E9BAdtVXpgi3bEW9uNf
         AG1lgqOnQ2uv5vAvry2j8xPExVeLJ3BYnAE/tN+xXqHuPln6DSb5D7skU1STvZI/NDhW
         jtR8Pxq27ZSax7URoP+iTQwlBmGjk0LFf4D0uom1Imt1fNNlM84d4KYNh2dTlJaTBsbT
         JVm5nxYhNIVv0OxKdscaj9QMvA2PvsOaMEbHHEGSiRoofkVzd7gclfaU8PJEykQKLQma
         53nit31M3stTWvFisr1YokQQjCrMXni13o6jwb6NDhQT5srtIccNwD3iLK4QBnuEEitd
         6fKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qQsabkwxRvA8bdaAfDmJWrhJnuevA/KFdg/I1GgKtI=;
        b=MkwqZRxPN7/KNGwWgQu/qKE65fX4GSJN3+Ek55+jjIe+GmujGDw/WuH4vhSAA5E3Yr
         kLo11Er9t2GPa4cwoSSJ2vHYbB+zxB/d9F2RLxkAie5M4bDjJjXCVuJoFMeE1fA/lH8Y
         SbF0bIRfLg6gg5sl17XCRoD9fxeFOo3GPa786YVo7g0dEeuMm2QPqKq3z9LX841ej3Yp
         p0KEOlo76um2KT/OhLwXy2kNSqavE85y5q9Up6F026+wiuXdA8nXDkUHPPP7YuXNVw/Y
         ByjhqnvP8THP8he/AsBFPfSsKbwYGkOA0Epy/LGRxihDY+Ep1mfEpmwSLr2BVdqGnPrJ
         Dsvg==
X-Gm-Message-State: AOAM531iX6EmvMoUuB1oEE7UDvXIjYkhGIsPYzMnt8u+3AfKb3BWCQuT
        Q5n5lyefI/oZtiukCQyDE4hupk2BUvi31PvPWJRM
X-Google-Smtp-Source: ABdhPJxylpDJBi9Oyjp7yXKp6FA+T0ynmXHzLKYVD27usilZLqbUqbJzR3v4r67aMe0WXL7WusF4sc80jjd/QAokEMo=
X-Received: by 2002:a05:6512:280a:b0:47a:e70d:63e9 with SMTP id
 cf10-20020a056512280a00b0047ae70d63e9mr5068916lfb.288.1654816587358; Thu, 09
 Jun 2022 16:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
 <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com> <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
In-Reply-To: <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 9 Jun 2022 16:16:16 -0700
Message-ID: <CAGG=3QU0XJhQKJXLMayOkQSiF2yjBi2p2TEZ9KNTzU5mmye-gg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
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
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
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

On Thu, Jun 9, 2022 at 4:03 PM Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2022-06-10 00:49, Bill Wendling wrote:
> >On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
> >>
> >> > This patch set fixes some clang warnings when -Wformat is enabled.
> >>
> >> tldr:
> >>
> >> -       printk(msg);
> >> +       printk("%s", msg);
> >>
> >> Otherwise these changes are a
> >> useless consumer of runtime resources.
> >
> >Calling a "printf" style function is already insanely expensive.
> >[...]
> >The "printk" and similar functions all have the "__printf" attribute.
> >I don't know of a modification to that attribute which can turn off
> >this type of check.
>
> Perhaps you can split vprintk_store in the middle (after the call to
> vsnprintf), and offer the second half as a function of its own (e.g.
> "puts"). Then the tldr could be
>
> - printk(msg);
> + puts(msg);

That might be a nice compromise. Andrew, what do you think?

-bw
