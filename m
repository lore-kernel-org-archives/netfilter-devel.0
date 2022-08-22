Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E31C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 15:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiHVP0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 11:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbiHVP0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 11:26:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB61928B;
        Mon, 22 Aug 2022 08:23:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z187so10634387pfb.12;
        Mon, 22 Aug 2022 08:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=c1VQcKO19zDd4dLcQGMK2dWX2+6edh8we7um74ba2OI=;
        b=Tk2ouaHH1BcyvoMkRErkOiqa4uqGZueCNz6rPkcxZhqbkj8VNe34MUQnbqH9kDZlox
         40aBe3EJLiyZ9ggdhoov3hRJv36gUICpkLzk3NaalrD4QpyMrZrhxd0fplt8SOo+HaFP
         1Gex4Ts9ZhRayaHd9/Bt6EKhYUI1kNDs8Oo+NtpTdEix8C2cTuVqJxGgujsdxlE+RuaQ
         6E6J4jfUSVICss2yJV76D1JrdfXSAZIocmAMHUaCp7fs1SEZKd8q66SD6sif+FCw1522
         Jw2FZYR2BWA6SNC/eTnKkPzbaUegWZBSoruo55CLL0ceHwdnen61veKyk1ad3i4XHEuA
         6t0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=c1VQcKO19zDd4dLcQGMK2dWX2+6edh8we7um74ba2OI=;
        b=QXzl/1UdY0DDwDXXo5O7VXvxxs3hbrvOwRTT3YSlsXDTbZoBNrc10i4ZbGK4cMebW5
         qe5uRIw3u9TtUMWRyUUG/MyjJaKbqf7Lb0tVsC3H/lKoTW0KxwQ7s4tXkrVa8Z8v+S12
         PQFLj3GhVK5sbGUxDqYh70pS2uUBBU5QUHvGan/gcct90b0dLiHJU5tgf9SupIcDYFX4
         +SBYdrQRtio6OUqyA9ochKLi8oyWAS0dIthHJ8H64RAZ6EMtZIyhlhhLDEx29JxFBVLo
         9uP9UedMC7vJmjcZ/KhYEaD/NlugwkCgBvo4vb9y0P0/UFXD27tNA53Kp53rbbxunRIP
         heOQ==
X-Gm-Message-State: ACgBeo1A0g2RGZaqHciNtMxFecF7ulPzy2ARYxkNFZgWYSsawGO9vtTc
        0DbiBzIGjb9yHmasC3dtCceInt0wTjk=
X-Google-Smtp-Source: AA6agR6NQ/+YcdoHjUreR2kMthayaHa9SXLgIKoIuNz342/A7fRXT/iwaERzlbnMaTG4cQZeDwcniw==
X-Received: by 2002:a05:6a00:189d:b0:52d:d4ae:d9f2 with SMTP id x29-20020a056a00189d00b0052dd4aed9f2mr21302639pfh.2.1661181823250;
        Mon, 22 Aug 2022 08:23:43 -0700 (PDT)
Received: from ?IPV6:2405:201:6:4005::2? ([2405:201:6:4005::2])
        by smtp.gmail.com with ESMTPSA id x3-20020a626303000000b0052dd7d0ad02sm8748424pfb.162.2022.08.22.08.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 08:23:42 -0700 (PDT)
Message-ID: <71eda095-f021-3d00-7ad8-568b934ac194@gmail.com>
Date:   Mon, 22 Aug 2022 20:53:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Optimization works only on specific syntax? (was [ANNOUNCE]
 nftables 1.0.5 release)
Content-Language: en-US
From:   Amish <anon.amish@gmail.com>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <YvK7fkPf6P52MV+w@salvia>
 <fff1fe66-9bad-a732-12ad-133bd9c40218@gmail.com>
In-Reply-To: <fff1fe66-9bad-a732-12ad-133bd9c40218@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Anyone has update regarding this?

Sorry for repeat noise.

Thank you

Amish.

On 15/08/22 06:30, Amish wrote:
> On 10/08/22 01:24, Pablo Neira Ayuso wrote:
>> - Fixes for the -o/--optimize, run this --optimize option to 
>> automagically
>>    compact your ruleset using sets, maps and concatenations, eg.
>>
>>       # cat ruleset.nft
>>       table ip x {
>>              chain y {
>>                      type nat hook postrouting priority srcnat; 
>> policy drop;
>>                      ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
>>                      ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
>>              }
>>       }
>>
>>       # nft -o -c -f ruleset.nft
>>       Merging:
>>       ruleset.nft:4:3-52:                ip saddr 1.1.1.1 tcp dport 
>> 8000 snat to 4.4.4.4:80
>>       ruleset.nft:5:3-52:                ip saddr 2.2.2.2 tcp dport 
>> 8001 snat to 5.5.5.5:90
>>       into:
>>              snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 : 
>> 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }
>
> This optimization seems to be working only on specific syntax.
>
> If I mention same thing with alternative syntax, there is no 
> suggestion to optimize.
>
> # cat ruleset.nft
> add table ip x
> add chain ip x y { type nat hook postrouting priority srcnat; policy 
> drop; }
> add rule ip x y ip saddr 1.1.1.1 tcp dport 8000 snat to 4.4.4.4:80
> add rule ip x y ip saddr 2.2.2.2 tcp dport 8001 snat to 5.5.5.5:90
>
> # nft -o -c -f ruleset.nft
> <no output with exit code 0>
>
> Which means that no optimization is suggested but check passed 
> successfully.
>
> I was expecting that it will reply with:
>
> Merging:
>  ...
> into:
>     add rule ip x y snat to ip saddr . tcp dport map { 1.1.1.1 . 8000 
> : 4.4.4.4 . 80, 2.2.2.2 . 8001 : 5.5.5.5 . 90 }
>
> OR if it can not translate to exact syntax then atleast it should 
> mention that there is possibility to optimize the rules.
>
> Is there any reason? Am I doing something wrong?
>
> Please suggest.
>
> Thank you and best regards,
>
> Amish
>
