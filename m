Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8033C7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCDF2070D
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 14:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="DHLEfAhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbfG2OIr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 10:08:47 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:51348 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbfG2OIp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 10:08:45 -0400
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x6TE8XuF013627;
        Mon, 29 Jul 2019 23:08:33 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x6TE8XuF013627
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564409314;
        bh=uSPQx/lOeIWy3VSnjzeRdBwGgXuOHDLD+EQgSpgUB+Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DHLEfAhPo6fyvFS/z/p2S642b0+jDXKEd//M2loX+Hjh9ZIkssKftTmqCQzzpEb1v
         V+0gKA9uAW+2Fo3GQ7vJaV3hMNwKki9SFpvZRrsOwvguJt+7M7slgVFQR1E+t3aqrJ
         3fJgS33rRwcnA/amwMcbbDS6hcibUcBDTqViHt1BraEKmC00yHqKSYiG0nmikqjP8o
         O9GrmyIvuRUmlmofCjbHkBsugKBiDsf8H32gpbvbuZTsbiXWV+rfszZR7HdpOonbhE
         BkdlYNxH2TY9Crr5xZvwuJnSpV9F9kYG9Ssy5P3RH0Fes+6vd7Z7pCklCbtiS7Mve6
         ayU0f4Zv7H/Nw==
X-Nifty-SrcIP: [209.85.221.177]
Received: by mail-vk1-f177.google.com with SMTP id b64so11976993vke.13;
        Mon, 29 Jul 2019 07:08:33 -0700 (PDT)
X-Gm-Message-State: APjAAAWcqPWChJKILf5dv4D7fbh115EHMIPWeKdbo+xRxlfy7n/R9AeI
        b/JEZpkL5E5DykZaKrMonvz/MCLXr7tq2nlCHR8=
X-Google-Smtp-Source: APXvYqwczpnrvR30MjqU1/slK/sm/xbhh0ihUQ9ff7momkusfqIbyZmm2cVmkjBbhhbW9HmVE//A01oYj0B+5GpQ9q4=
X-Received: by 2002:a1f:b0b:: with SMTP id 11mr40548573vkl.64.1564409312295;
 Mon, 29 Jul 2019 07:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190728155138.29803-1-yamada.masahiro@socionext.com> <20190729131528.4vl6zpyyoyqd7np6@salvia>
In-Reply-To: <20190729131528.4vl6zpyyoyqd7np6@salvia>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 29 Jul 2019 23:07:56 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS4zC0=Ptf2_ux6d=kXhWELeaV_tp6+ZBaD-oDKdCEfrA@mail.gmail.com>
Message-ID: <CAK7LNAS4zC0=Ptf2_ux6d=kXhWELeaV_tp6+ZBaD-oDKdCEfrA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: add include guard to xt_connlabel.h
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 10:15 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Mon, Jul 29, 2019 at 12:51:38AM +0900, Masahiro Yamada wrote:
> > Add a header include guard just in case.
>
> Applied to nf.git, thanks.
>
> BTW, is the _UAPI_ prefix really needed? I can see netfilter headers
> under include/uapi/ sometimes are prefixed by UAPI and sometimes not.


The _UAPI prefix will be useful when you happen to
add the corresponding kernel-space header
since it is often the case to have the same name headers
for kernel-space and uapi.



For example, compare the include guards of the following.

include/linux/kernel.h
include/uapi/linux/kernel.h


Or, if you want to see an example for netfilter,

include/linux/netfilter/xt_hashlimit.h
include/uapi/linux/netfilter/xt_hashlimit.h



I recommend to add _UAPI prefix to headers
under include/uapi/
to avoid include guard conflict.

The _UAPI prefix is ripped off by
scripts/headers_install.sh
when exported to user-space.



-- 
Best Regards
Masahiro Yamada
