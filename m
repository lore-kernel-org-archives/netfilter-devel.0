Return-Path: <SRS0=bANH=AA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E15BC433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 18:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0901220DD4
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592591897;
	bh=ZhJKyQamkAob25KyheSdbYpntbCoqJg8sUQ/+nKR09A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=oYFmLsfYND42PChAzo4fe+qX3ExPjO8Zb8Jnb/JzrAnAPGeCp9gkpfoUz2rvnkTZw
	 h8agUW53q+Q92QmW9G1UTbuhsxd54Zp8OAwpanDzyPa3eAOd4KaFqVLU2LA0E0RhGZ
	 91crqBMUfqxi/kCflDP/+D4fTWT+GAs8HBkLyi1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388608AbgFSSiK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jun 2020 14:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgFSSiG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 14:38:06 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A10C06174E
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 11:38:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z9so12586509ljh.13
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H3fbVijkwGqEXjgf746UVzNHZFijt5PEP/I+cIGFrOI=;
        b=Pbi6ZcZ/j5UzKi4TuELv3vWZVoPaSRX4qHDHfjemlgk/7t9FABxdeWgh51bILfCKJ5
         wi8F+rrtMy4gj2dpmCJd8yxSDI3bKAoHjCDk9Pmgk4ebmFXb7pgJH6u8Pl1d3HL2Cn+Y
         CfZiRrUn8yF0xtr+Dhn2AXvWp8IgyXRWpqhQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H3fbVijkwGqEXjgf746UVzNHZFijt5PEP/I+cIGFrOI=;
        b=rYE36r+WJiCxFB04o0LquGc2tpJk8GvU1gf+htASJ2cykHiwqlM6bHClOj2c+AulPO
         XFPKN9XMGbT09seONEPxAx+RhndWDs2mPm/P9r8G5PDnyztfwnpqOlIwz2kTWNck+QGT
         tGoOUBHK0Uebf+AK6jD9kDQ5W1bwSdli4hLhnxSP/3EaZgrHY0nu52dfXJA6Nmx6Gsqz
         hq6LwUawrPxZnJ2uEyVcGwmN72t+eAfx65jQg850EsLKTl32ohVG6jgK33gT6Kxe/yHC
         Y5duc6sSNq3NMIaEQXapK/JSRvDF837JDMPEnW2gPwILdx23d6nFEcZ4CSlhDmQtW3jV
         AIVA==
X-Gm-Message-State: AOAM531MB3+CMWiLTgQdEJREPhtX/gAEeK9AQOHOpJAC7QCIP5ty46Ot
        jqDvouta4UyuskRp2lg5ql07asv6eww=
X-Google-Smtp-Source: ABdhPJxZeN7bhg0XAAgT00u3JmZ1LshWTyUabbDz/Gs0VvjMYYJ/+32h02uHr1b24a69yGlp5fYqyA==
X-Received: by 2002:a2e:8994:: with SMTP id c20mr2546240lji.378.1592591884514;
        Fri, 19 Jun 2020 11:38:04 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id j12sm1289600ljg.15.2020.06.19.11.38.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 11:38:03 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id c11so6114065lfh.8
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 11:38:03 -0700 (PDT)
X-Received: by 2002:a19:ae0f:: with SMTP id f15mr2684358lfc.142.1592591883165;
 Fri, 19 Jun 2020 11:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200618210645.GB2212102@localhost.localdomain>
In-Reply-To: <20200618210645.GB2212102@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 19 Jun 2020 11:37:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
Message-ID: <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 18, 2020 at 2:06 PM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Rename
>         struct notifier_block *this
> to
>         struct notifier_block *nb
>
> "nb" is arguably a better name for notifier block.

Maybe it's a better name. But it doesn't seem worth it.

Because C++ reserved words are entirely irrelevant.

We did this same dance almost three decades ago, and the fact is, C++
has other reserved words that make it all pointless.

There is no way I will accept the renaming of various "new" variables.
We did it, it was bad, we undid it, and we now have a _lot_ more uses
of 'new' and 'old', and no, we're not changing it for a braindead
language that isn't relevant to the kernel.

The fact is, C++ chose bad identifiers to make reserved words.

If you want to build the kernel with C++, you'd be a lot better off just doing

   /* C++ braindamage */
   #define this __this
   #define new __new

and deal with that instead.

Because no, the 'new' renaming will never happen, and while 'this'
isn't nearly as common or relevant a name, once you have the same
issue with 'new', what's the point of trying to deal with 'this'?

             Linus
