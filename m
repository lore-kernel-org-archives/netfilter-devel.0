From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nft] hash: generate a random seed if seed option is empty
Date: Fri, 14 Apr 2017 07:13:20 +0800
Message-ID: <CAML_gOdPm1X3gudfEdMwCo95y3998KP-dvGWiPLi=EeapEdNJg@mail.gmail.com>
References: <1491208197-5493-1-git-send-email-zlpnobody@163.com> <20170413205709.GA2039@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?=
        <laura.garcia@zevenet.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34503 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdDMXNW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:13:22 -0400
Received: by mail-vk0-f51.google.com with SMTP id z204so34393114vkd.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 16:13:22 -0700 (PDT)
In-Reply-To: <20170413205709.GA2039@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-14 4:57 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> -     nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
>> +     if (expr->hash.seed)
>> +             nftnl_expr_set_u32(nle, NFTNL_EXPR_HASH_SEED, expr->hash.seed);
>
> I prefer we have a hash.seed_set, instead of relying on 0 meaning
> "unset".

OK, I will send V2 based on your suggestions.

> I'm thinking of people willing to implement some sort of poor man
> symmetric hashing with two rules, one per each direction. The seed
> needs to be the same so the jhash is consistent.
