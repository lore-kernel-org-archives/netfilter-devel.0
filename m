Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4172CCA473
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 22:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbiFIWth (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345786AbiFIWtg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 18:49:36 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDB541FBC
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:49:35 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t25so40151623lfg.7
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OAj7kkMIiekJ9rTKt4JAtAfIGa2quITOg+UqYlGq1Vc=;
        b=h+XSjN/WVesJqDJFOPBbUOjCsElze90l5AUaZpaMfQE4BCHJP6262qTzyHWJva9Bl7
         Ylea2b1VMRtuu3W6K04USb5N4DyE9/FJG1TJX23DJAAyMpmTkNe0IhcujfXyw2tL6Yzm
         5AoAwHI63jQHxPEb7KgmYY7AsIWc/AhRsgnJ71aDa/ZsS0NcL3wur4vFJaN8UMyAklRE
         aEGCgipKXq1q5OQuT+b1/Z3ZAjDVwg+cOz821DhKZdc3CbTWkxewf2eBhHZ6cA8kCpl2
         vQoxv4lOBXpPPrGtb7sLkscBoEWxzlYML194UCnlDBfFSziOT58BYv12MhyX6zYq7k9Z
         Vkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAj7kkMIiekJ9rTKt4JAtAfIGa2quITOg+UqYlGq1Vc=;
        b=7hnW1JYY/IfYYgG5r6sSlA6Pm6AwRZkNHAEaCbsbm/CfHDDUShX8qFLSrCZUCGewBp
         QMnh0ho4LoNy/apMtcE4yW1jYrRBo76w7dBRgW3CfJHEYG80QiQJmHHQC5kF+tVtHgJd
         dE9+6RKUySJXWTOe3L1dKrxaoN9mScddF8S2MjOgOSkh3o/eYnMiIMdTi2GBR/myecNr
         JqZ+XvZbqIDn/Bo78cTD6PbDWVg9oeX72di7xSJidmeuUBpBk07EGPd4mwRjWG8/olMT
         45AUrRTAgqv94XuD8Z+PwSU/gqhmP/BgaP8GOkZW+C9R/Bgp8cOiLjE1S8uF3VgXAB+J
         PZjw==
X-Gm-Message-State: AOAM531APJYEqsZ9hTmsAro801lUPEaPUAV96h66+C12vMyrh22lXGuL
        q7UKtLxhodzCRekbUaqCBjnUiBP9+OGElq7nzHRF
X-Google-Smtp-Source: ABdhPJxZXTnzcCwuX2K8dXo0GsWxPjCKHZ8xLR+ukHeOsc32GB8PW2KE6FFGhS4Nls3KDQ2FUv5nfKYIhCIQyfCKYvU=
X-Received: by 2002:a05:6512:114e:b0:479:1e02:9318 with SMTP id
 m14-20020a056512114e00b004791e029318mr20896704lfg.156.1654814973186; Thu, 09
 Jun 2022 15:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
In-Reply-To: <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 9 Jun 2022 15:49:21 -0700
Message-ID: <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
To:     Andrew Morton <akpm@linux-foundation.org>
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

On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
>
> > This patch set fixes some clang warnings when -Wformat is enabled.
> >
>
> tldr:
>
> -       printk(msg);
> +       printk("%s", msg);
>
> the only reason to make this change is where `msg' could contain a `%'.
> Generally, it came from userspace.

It helps kernel developers not accidentally to insert an unescaped '%'
in their messages, potentially exposing their code to an attack
vector.

> Otherwise these changes are a
> useless consumer of runtime resources.

Calling a "printf" style function is already insanely expensive. :-) I
understand that it's not okay blithely to increase runtime resources
simply because it's already slow, but in this case it's worthwhile.

> I think it would be better to quieten clang in some fashion.

The "printk" and similar functions all have the "__printf" attribute.
I don't know of a modification to that attribute which can turn off
this type of check.

-bw
