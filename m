Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F0C433ED
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Apr 2021 20:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A43F61382
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Apr 2021 20:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhDDUoY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Apr 2021 16:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhDDUoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Apr 2021 16:44:20 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EEFC061756
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Apr 2021 13:44:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f6so3195627wrv.12
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Apr 2021 13:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PrYBgVpCuXsQZ19z1Kx5Xf/3drP0pjcl4VEVZYujLIg=;
        b=iwSnfMuJn7o2hHhKFpKY/I5TKL3jmAoJsY93hs7WZmbTiMJtCHQuLfT2BFiI44f8nM
         rhAKRkvcb+CvDRVIq2P6SFlvHBqen2YT9TX+P1LkStXZrjxs0g1mGtuZO7+p9IVbDFh3
         eI33nMLqLJ0p0UjkbZE8B/oCv2OINZRcrnku8fb+fhHxXWKyH2oIyDYY090VA1wCscyt
         zXU86oXS9RgbjU7TUjREOUm2KliMj3ocGHNWsqFNRga5YpnpeZrYHqgqlM8QgsLRigSU
         fW8V/+2YDhFHbCbhxyFqzSXDrcaIgTykaNLP7/GPRd8ru0PmONGmq4NhyOtTOKsXUQoJ
         dEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PrYBgVpCuXsQZ19z1Kx5Xf/3drP0pjcl4VEVZYujLIg=;
        b=sKjPabs7wMzLPo5JlTlZaXJy6ow8RkkJ4Y3l6Cy25GN9kKEFGIoCajTJV3WOJE+wpz
         +vz5YeYQa9x2xlH6YqiWQMG4wp2XknNdcazU6k0EP/LdoZ6H0aJLFYf4ii7t9We5WlJv
         NjZ8M/5fVRhSlF645ZF67tIbrxd0B5Iwo6gX+sLRGxKhfGbT0+kloTEMqcfqMMAvuiH0
         wOgAzTAWaSE1K/+C5l8HeivQ72Xb2k4cC3nBX8NvrbkqwSlyiPoUkSzy/LgNN5JUImLM
         UOIE2lmTjeRyxEGd9FweMGOhYus1+rl/In8U+xDSJJJhVdVhlQOpFkf4kzd9a2EWD1xB
         PJtA==
X-Gm-Message-State: AOAM532cFNwUOsqNHgLL6Nm4Fy/ik1I4+27xuwoMQKascF3iEyVu8aM/
        heU50O+x8zpe/eif8t5FaHA=
X-Google-Smtp-Source: ABdhPJxqEO7vSV54UVc94l5vETJiM2iGARl99PK5BRk6fdLM2oP1Dnc9RtApbDkn33q48P9Z1/89WQ==
X-Received: by 2002:adf:deca:: with SMTP id i10mr7988948wrn.319.1617569054046;
        Sun, 04 Apr 2021 13:44:14 -0700 (PDT)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id m5sm9691381wrx.83.2021.04.04.13.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 13:44:13 -0700 (PDT)
Subject: Re: Unused macro
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <f209f7b0-af4c-e41c-b53e-27028b925978@gmail.com>
 <20210404200517.GN13699@breakpoint.cc>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <57ad16e0-a116-5fe7-4f95-3790fffccb20@gmail.com>
Date:   Sun, 4 Apr 2021 22:44:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210404200517.GN13699@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Florian,

On 4/4/21 10:05 PM, Florian Westphal wrote:
> Alejandro Colomar (man-pages) <alx.manpages@gmail.com> wrote:
>> I was updating the includes on some manual pages, when I found that a
>> macro used ARRAY_SIZE() without including a header that defines it.
>> That surprised me, because it would more than likely result in a compile
>> error, but of course, the macro wasn't being used:
>>
>> .../linux$ grep -rn SCTP_CHUNKMAP_IS_ALL_SET
>> include/uapi/linux/netfilter/xt_sctp.h:80:#define
>> SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
>> .../linux$
> 
> This is an UAPI header, this macro is used by userspace software, e.g.
> iptables.
> 

Ahh, I see.  Thanks.

Then we still have the issue that ARRAY_SIZE is not defined in that
header (see a simple test below).  You should probably include some
header that provides it.

But again, if no one noticed this in more than a decade, either no one
used this macro, or they included other headers in the same file where
they used the macro.  So I'd still rethink if maybe that macro (and
possibly others) is really needed.

Test 1:

[[
$ cat test.c
#include <linux/netfilter/xt_sctp.h>

int foo(int x)
{
	int a[x];

	return ARRAY_SIZE(a);
}
$ cc -Wall -Wextra -Werror test.c -S -o test.s
test.c: In function ‘foo’:
test.c:7:9: error: implicit declaration of function ‘ARRAY_SIZE’
[-Werror=implicit-function-declaration]
    7 |  return ARRAY_SIZE(a);
      |         ^~~~~~~~~~
cc1: all warnings being treated as errors
$
]]

As you can see, no ARRAY_SIZE().

Test2:

[[
$ cat test.c
#include <linux/netfilter/xt_sctp.h>

int foo(int x)
{
	unsigned a[x];

	return SCTP_CHUNKMAP_IS_ALL_SET(a);
}
$ cc -Wall -Wextra -Werror test.c -S -o test.s
$ <test.s grep ARRAY_SIZE
	call	ARRAY_SIZE@PLT
$
]]

In this second test, tere's no error, because it's a system header, but
you can see that ARRAY_SIZE is treated as an implicitly declared
function, and it appears in the assembly file.

Cheers,

Alex



-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
