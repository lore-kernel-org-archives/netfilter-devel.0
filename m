Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FC4C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E391613B3
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbhDFLxP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243320AbhDFLxP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 07:53:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE82C061756
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 04:53:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i18so10450983wrm.5
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=npw7JXHgOB07FgvCHurMMa2h8eIayswEBsVyhztxNG8=;
        b=HKLQ0O//HfUKdAj7vEanf3d3av2O2fYn230ul2YD347WfT/UjrB6X2CvNB5KJOyzOL
         WdoSy1IXtoSIPQkWv8vxr1X486ynZrYqIuiELcKY3vW8b8U+qVER7bfMCUjtwD7JJ0O8
         yjCc4uQVRiXm2SdT09fHVXgH8JkhsfXC8Tiz2euYe9a7NR5qd2vdTxr3FYSssjAJI/Wk
         VP6SyN65Tm1wN5a9/tIfPjsPYjMh9zXdwTJsvDC8ltgYafkvQz2S3ydzDm8/GKBeM8bE
         n4kskQGFKdx0qJpyQ8macVfENTeinWrS438FxWRA/uH4NkowgTsOL88TlyzwPmxn9twI
         VOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=npw7JXHgOB07FgvCHurMMa2h8eIayswEBsVyhztxNG8=;
        b=aYCBOH6bMEMkUClKrSMNzE7bHlwJKnCa7fQmw0+1mpSaTVxY66vL7P4Oz50FMB1NRT
         7m6fpUMTt49aMxcKSBpQJA02OYEfqDShsvfTFKRKiKYk3c+b3bicU/Ih/VzNrMijl4w5
         q+sHNt5giNvmJZXHP0WNCPnJfABR5mfpVwWnYlnHc9AJWpMxNnK5VEzGeHcIJYXBk6yC
         XUpvKURLKep2+sPRRjNs9onrrfuy5QnYBTlJI9kGpUaUD/OL2XGNswFixfF7BzO1sdHh
         xhLlKSqqqYDXatn93Xlx8FF34Fh2jP4ie+KI7/jb6v+OKjUzeNAODooQ1J4vC8H5YIMU
         8fEA==
X-Gm-Message-State: AOAM530dZMnH8zKjkB5BI5kf0SDpEEmUoiWuRRXIlZGmPMrJotIlJ9gw
        Y5/S/uYJEU43yoJexJVcGDo=
X-Google-Smtp-Source: ABdhPJy1Lg473zQDYbgwB3W0DVlJ1fWD1gruuZYSgLfA1AwnI7JuXKnEKg6W2F1LRx6N2RRhyD/ANA==
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr34938227wrg.237.1617709986146;
        Tue, 06 Apr 2021 04:53:06 -0700 (PDT)
Received: from [10.8.0.194] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id y10sm2332006wrp.31.2021.04.06.04.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 04:53:05 -0700 (PDT)
Subject: Re: Unused macro
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <f209f7b0-af4c-e41c-b53e-27028b925978@gmail.com>
 <20210404200517.GN13699@breakpoint.cc>
 <57ad16e0-a116-5fe7-4f95-3790fffccb20@gmail.com>
 <20210405214414.GA10493@salvia>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <e137e030-77ae-36c9-cc7f-e5f098c2f71b@gmail.com>
Date:   Tue, 6 Apr 2021 13:53:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210405214414.GA10493@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 4/5/21 11:44 PM, Pablo Neira Ayuso wrote:
>>
>> Then we still have the issue that ARRAY_SIZE is not defined in that
>> header (see a simple test below).  You should probably include some
>> header that provides it.
> 
> SCTP_CHUNKMAP_IS_* macros are used from iptables/extensions/xt_sctp.h
> (iptables userspace codebase). These macros are also used internally
> from net/netfilter/xt_sctp.c. It's using a rather unorthodox trick to
> share code between the kernel and userspace, otherwise iptables would
> need to keep a copy of this code.
> 
> BTW, why do you need xt_sctp.h for the manpages? This header is rather
> specific to the match on sctp from the xtables infrastructure, so it's
> not so useful from a programmer perspective (manpages) I think.

I don't need it.  Actually, I was fixing the includes in the SYNOPSIS, 
and when I was grepping for some variable (I don't even remember which 
one), the search brought me at some point to this header, where the use 
of ARRAY_SIZE() caught my attention :-)

> 
>> But again, if no one noticed this in more than a decade, either no one
>> used this macro, or they included other headers in the same file where
>> they used the macro.  So I'd still rethink if maybe that macro (and
>> possibly others) is really needed.
>>
>> Test 1:
>>
>> [[
>> $ cat test.c
>> #include <linux/netfilter/xt_sctp.h>
>>
>> int foo(int x)
>> {
>> 	int a[x];
>>
>> 	return ARRAY_SIZE(a);
>> }
>> $ cc -Wall -Wextra -Werror test.c -S -o test.s
>> test.c: In function ‘foo’:
>> test.c:7:9: error: implicit declaration of function ‘ARRAY_SIZE’
>> [-Werror=implicit-function-declaration]
>>      7 |  return ARRAY_SIZE(a);
>>        |         ^~~~~~~~~~
>> cc1: all warnings being treated as errors
>> $
>> ]]
> 
> I see, this is breaking self-compilation of the headers.
> 
> If there a need to remove xt_sctp.h from the ignore-list of the header
> self-compilation infrastructure, it should be possible to fix
> userspace to keep its own copy and probably add a #warn on the UAPI
> header to let other possible consumers of this macro that this macro
> will go away at some point.
> 

Well, I ignore what is this header for; I was just reporting something 
that I casually found and might be a bug.  I'll leave the fix to you ;)

Cheers,

Alex

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
