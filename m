Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF1DC4361B
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Dec 2020 19:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7B9239ED
	for <netfilter-devel@archiver.kernel.org>; Sun, 13 Dec 2020 19:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388988AbgLMTXH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Dec 2020 14:23:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394837AbgLMTW7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Dec 2020 14:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607887290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbL8Odta7ic6S0aPEogCx7D7h/B71ZIzRWsPMeenY94=;
        b=def49vyBeih9m64CO5vFMB2zNdIqDLpog/L3oqa+BWsK4KBQOk8fcfENpbw8h+q07BTeBv
        uGliGdYnfWMWHfD1Q+amBWNCrbHQBjvmQKq77w8ghDJc9PeyT7olbBtL7RrEm3i0oZJstk
        d1aR9+DPtK5R57ei3kHG++TllFmoUpc=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-RCtWlIhsOtOcv1ymMgiDKg-1; Sun, 13 Dec 2020 14:21:27 -0500
X-MC-Unique: RCtWlIhsOtOcv1ymMgiDKg-1
Received: by mail-oi1-f197.google.com with SMTP id j128so7750827oif.22
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Dec 2020 11:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UbL8Odta7ic6S0aPEogCx7D7h/B71ZIzRWsPMeenY94=;
        b=MRyghiSRZUfMAdMELpZHHB5GQlB8leREtpRH7aazDf+LXyYcC7JUPmSjYPvyUX/BNP
         UK4Rtdd6BAmA1QihPTCaLH7cvYxLAAkD6O7eeWM2k+b/GHi6kMA49n6Z52TM70QpjkgU
         0ErtQOxRIvD9CidSLEScberoXHA0fqt/Xk6UUEvcJQlGFtyivQwCs4wEpLizQOw6H9uP
         GScFQwdS0Ln1k3ZL3ALtYyzavOLESRgyIJRnrjYuLnTJA7KycZiZCLy2gy16XYFJoJkG
         4pFFuf8tN8JQp98MEI5QB9f4syXyM8+zlIJAGwmxh24KVkDAPDVntx7Uyf1fPM95OYM9
         tWjQ==
X-Gm-Message-State: AOAM532NS7korcp8tjWO5UA2umg6D8vbX8lw+9vVoVHk69+3oCdP/gsB
        OdvAMhR1OFLtf2dnijKtsCBJ3puaKgxraMP6K39Rr4a4UPU0rpFzf+ToInro45oqRNPWSXFfluV
        +YeH8u9X4336t4jzC6pph+zf4H5m8
X-Received: by 2002:a9d:269:: with SMTP id 96mr16744066otb.174.1607887286714;
        Sun, 13 Dec 2020 11:21:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQkCv+SsykJEiclAhkJJmaIpJ8GofmaJCmKC2P9NkPzPSY2w5X75hXxW7iT/wQfqs4MJlolQ==
X-Received: by 2002:a9d:269:: with SMTP id 96mr16744053otb.174.1607887286519;
        Sun, 13 Dec 2020 11:21:26 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id c5sm1967722otl.53.2020.12.13.11.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 11:21:25 -0800 (PST)
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
 <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
 <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
Date:   Sun, 13 Dec 2020 11:21:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>>
>>> Yeah, we could go through and remove %h and %hh to solve this, too, right?
>> Yup.
>>
>> I think one of the checkpatch improvement mentees is adding
>> some suggestion and I hope an automated fix mechanism for that.
>>
>> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> + Tom, who's been looking at leveraging clang-tidy to automate such
> treewide mechanical changes.
> ex. https://reviews.llvm.org/D91789
>
> See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> related context.

I have posted the fixer here

https://reviews.llvm.org/D93182

It catches about 200 problems in 100 files, I'll be posting these soon.

clang-tidy-fix's big difference over checkpatch is using the __printf(x,y) attribute to find the log functions.

I will be doing a follow-on to add the missing __printf or __scanf's and rerunning the fixer.

Tom

