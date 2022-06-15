Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D641C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jun 2022 11:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbiFOLfO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 07:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiFOLfN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 07:35:13 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4403E4BFFE
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 04:35:13 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id l3so6588558qtp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2022 04:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BEeEWFAyhieKcjJCXLlbGe81tIQgad+1VRtF3wb3N9c=;
        b=NGV7bK46HiD6HtN8xkUW+gI//VW1CZ52H2d+EhYd+kFiCIpvpHn4dnngVPLU3r3Tgt
         32QwhrWjsVo3grtGs8RoNdHirDw7IqvGdrIeIewl75aKXORq/aGK9KVtVxmEfP/rlzRA
         BgG8hiOMB//alEIoPdmdbPaK/jG2yFRj+BpJMbK6kOWDbyMtBvY4kGGjKlQ4TpQS8JK8
         Cq0fEdITANEkXEmJT68DojKC8NHKwH6A1ulHdcUFNLYKA5NMKD0PzLNlP+BXCYyhuiLV
         5e/YwSnU+oFDYpLh3lm7wTJK8TXR6UjHsdChAqgGDbRbd7lgfsAtJ5YQynXAHpVUi1x2
         ORhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BEeEWFAyhieKcjJCXLlbGe81tIQgad+1VRtF3wb3N9c=;
        b=a+Z4G9gPohoSgoSVQLRW9ckJwwSvS2+Yrw21/5isCnsqSmDYf2Y4ANjGzFrwDLww4m
         ACR4tE7D/fRW7WVj4dCl6AhpG5gyc9Ulg6Fgvo3d7haqnwEOwxT8tJVAgfBo80W6GZyO
         UpJkDRcTavYfppL7RMJQOqNPWOGy+U8HlbKNIzVTTevSkJKZFmvbEuCr5VJmb0+09DvK
         F2CU16dkpUz8QZqzjcuWGtkXM6TrK42KLCaSCH2u5bTI7xs/3fyHEtrP/ev+RK2ghEhU
         ZcsZwIGQGSikJvPnul2UrsYMwfetViwRFMswASRtv0yfd1flU1FI8xNXFq65bukoc9nE
         x4Xg==
X-Gm-Message-State: AOAM532Io0eMYJKHWjP+tIyctid+bS6+/jkJIiYS+JYlVrB6cwsLxKDH
        rdc6iGhLMkXNPFnfE6Jgbca76+1dbas=
X-Google-Smtp-Source: ABdhPJyCGRO8+8VFM8i7/xNO56ysFw2nFnfEMxPTkBdXNRLH7zg53plDDyRCACsGYl136AUHVZByxg==
X-Received: by 2002:ac8:5cd0:0:b0:305:2dd7:cd81 with SMTP id s16-20020ac85cd0000000b003052dd7cd81mr8235120qta.421.1655292912354;
        Wed, 15 Jun 2022 04:35:12 -0700 (PDT)
Received: from ?IPV6:2602:ae:1883:e000:1885:966b:4645:8648? ([2602:ae:1883:e000:1885:966b:4645:8648])
        by smtp.gmail.com with ESMTPSA id t67-20020a379146000000b006a71c420460sm11179464qkd.22.2022.06.15.04.35.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:35:11 -0700 (PDT)
Message-ID: <e9fd763b-7057-c563-5908-2b4e9ca7af60@gmail.com>
Date:   Wed, 15 Jun 2022 07:35:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] build: fix clang+glibc snprintf substitution error
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <ffa929491752b73330d883aec65c1ab3898fc284.1655246514.git.nvinson234@gmail.com>
 <YqmH3LgnZGUSahNa@salvia>
From:   Nicholas Vinson <nvinson234@gmail.com>
In-Reply-To: <YqmH3LgnZGUSahNa@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> On Tue, Jun 14, 2022 at 06:59:41PM -0400, Nicholas Vinson wrote:
>> When building with clang and glibc and -D_FORTIFY_SOURCE=2 is passed to
>> clang, the snprintf member of the expr_ops and obj_ops structures will
>> be incorrectly replaced with __builtin_snprintf_chk() which results in
>> "error: no member named '__builtin___snprintf_chk'" errors at build
>> time.
> 
> Please, report this to upstream compiler devel list too.

It's been reported upstream a few times already. Relevant links below.

https://github.com/llvm/llvm-project/issues/7591
https://github.com/llvm/llvm-project/issues/12053
https://github.com/llvm/llvm-project/issues/17831

> 
>> This patch changes the member name from 'snprintf' to 'nftnl_snprintf'
>> to prevent the replacement.
>>
>> This bug can be emulated using GCC by undefining the __va_arg_pack macro
>> before stdio.h is included.
>>
>> This patch is based on the notes provided in
>> https://bugs.gentoo.org/807766.
> 
> Please, rename it to .output instead, I'd suggest.

Renamed from nftnl_snprintf to .output.

Thanks,
Nicholas Vinson
