Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C80AC25B06
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Aug 2022 01:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiHOBA2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Aug 2022 21:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiHOBA1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Aug 2022 21:00:27 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC9F2DDD;
        Sun, 14 Aug 2022 18:00:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so1248024pjb.0;
        Sun, 14 Aug 2022 18:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WenmcpC3sVVnxR1zLL1wLdsp83TtT0xVcnU5htrVtb4=;
        b=MsDNHNB+fYsCnWpl4EgaH/LZA/cqRXtl2SGZzPEmTgfaFXz5NHIsGB/gizQAQNDttz
         NrkQcs9ffLQgB4rzsdQrw8LW5tOynvKetwx8LY1dDufMc/F8Z7nA48v6mHpiPevlRCi5
         KkbP4d66lE5e21luK3Dd6dcBO9jzpKsqkd26XKjQ3PKJ/eiIDVtCeN5YvMXjdQn0pW/0
         4KojwjGmkElaiGPVPZ32w/KSKufrQ+yeYCqYX7Hdivu3GC0c6fzAhEA61wxg070M7Chu
         CnaVZm+0H6weF+ZRK4YOHjf7AlqhCxjHeSnU8nFsrLOP2kYGL0g3DUxpbo63qqmuQVtk
         uRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WenmcpC3sVVnxR1zLL1wLdsp83TtT0xVcnU5htrVtb4=;
        b=gCnwGGsfV4U9sTysYTHorxvFqSHiLzfL+Y5bNdWeo60pU3HwvMHp8P7wkqkP5ApjxL
         LLbv8CjdZ5wOA7E6pyj7ubSecbJkeM6W7XwjTfJaICf7yoIUKq0MMD2LQrBGK0KaG7Z3
         IPBxDiK+0FCz/pDXi8qpyXnkK3LsWSdNXJp9uTJsYNk3QQ0QaW7aGytROiTOs5PyF+DB
         gG+PuByjQu86NSZF7+Vgk9bmz09VeWHkAybQQ3Y0VAT/E0Svdn4Z0rVkRtGaAytO1UXf
         gRfITy8PWeemmrcKdR7YjG1iCRsYkr9HaXxrP9CsN9Tr30iuqNubNlBgCOuyG2lfuGjl
         NRQA==
X-Gm-Message-State: ACgBeo2mSOdXapHE2B0BhAMcTR8Pfx9M+GmuGiSSCG7g0mcB29wLLYLf
        /wlX8lr+MKm0ivvOSk+gcqQ5WsNJ1fk=
X-Google-Smtp-Source: AA6agR6I3q/754siflagODqAUhm6icF39n/GH0aeEJ03SkPWxc1Fd8J8cWZxG+RUsU/s7cd/UdCcQw==
X-Received: by 2002:a17:90b:4b86:b0:1f7:6fbf:116 with SMTP id lr6-20020a17090b4b8600b001f76fbf0116mr15462554pjb.56.1660525225583;
        Sun, 14 Aug 2022 18:00:25 -0700 (PDT)
Received: from ?IPV6:2405:201:6:403d::2? ([2405:201:6:403d::2])
        by smtp.gmail.com with ESMTPSA id nd10-20020a17090b4cca00b001f260b1954bsm3773646pjb.13.2022.08.14.18.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 18:00:25 -0700 (PDT)
Message-ID: <fff1fe66-9bad-a732-12ad-133bd9c40218@gmail.com>
Date:   Mon, 15 Aug 2022 06:30:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Optimization works only on specific syntax? (was [ANNOUNCE] nftables
 1.0.5 release)
Content-Language: en-US
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <YvK7fkPf6P52MV+w@salvia>
From:   Amish <anon.amish@gmail.com>
In-Reply-To: <YvK7fkPf6P52MV+w@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 10/08/22 01:24, Pablo Neira Ayuso wrote:
> - Fixes for the -o/--optimize, run this --optimize option to automagically
>    compact your ruleset using sets, maps and concatenations, eg.
>
>       # cat ruleset.nft
>       table ip x {
>              chain y {
>                      type nat hook postrouting priority srcnat; policy drop;
>                      ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
>                      ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
>              }
>       }
>
>       # nft -o -c -f ruleset.nft
>       Merging:
>       ruleset.nft:4:3-52:                ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
>       ruleset.nft:5:3-52:                ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
>       into:
>              snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 : 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }

This optimization seems to be working only on specific syntax.

If I mention same thing with alternative syntax, there is no suggestion 
to optimize.

# cat ruleset.nft
add table ip x
add chain ip x y { type nat hook postrouting priority srcnat; policy drop; }
add rule ip x y ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
add rule ip x y ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90

# nft -o -c -f ruleset.nft
<no output with exit code 0>

Which means that no optimization is suggested but check passed successfully.

I was expecting that it will reply with:

Merging:
  ...
into:
     add rule ip x y snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 : 
4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }

OR if it can not translate to exact syntax then atleast it should 
mention that there is possibility to optimize the rules.

Is there any reason? Am I doing something wrong?

Please suggest.

Thank you and best regards,

Amish

