Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5786C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 13:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379089AbiAaNsU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 08:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378603AbiAaNsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 08:48:19 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510EEC061714
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 05:48:19 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id e6so12906042pfc.7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 05:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IHjxZfCH8E1+tXBOtKjW3hcu0ZC8yXvMqf5lWXyuKfo=;
        b=KvR0Dhg+X/Vb7ELr8DcrpHwUqH4Q1187Q9MpmGQMK6N3k/Cknq335fXKPhMO4AnOZR
         G8BTfKH2b3D0w/o4axfZ9d9LK2bSuH9skKaq3v0ZDmKDU34EUO0X3UwiINwGy80B2L8t
         NRPtaPzsUt3cqjrBnWpsaRdP5dwwVVnYI9MLwOgPqBnxTxtz5oJpiyjyNe53TAO29OwQ
         TwxaXW6BLgL/Fl/D+gviOOMr2nwfCd9mvljJp1O6smHuan3UiQtAFCzeJcyRkyCByF92
         NoLv01jijfl5Kk0qbAgBx2SA/u4abh5y9dyl/qmkNJ3RxkTCgQ8Tv1daql/+BhaogdTo
         R1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IHjxZfCH8E1+tXBOtKjW3hcu0ZC8yXvMqf5lWXyuKfo=;
        b=p2IllvUsQA7cx7vKfNwLFMICRPp4lzGJ5ZtZJZmKZ/6tfHzuRVq3RQm82JHlXvUgR3
         DhalpPwgJsIT/qZOfsN3dSsSUtFOQ5H3gkWIy++HsuerGocOa+W9szZHOqlaFK4r98dq
         BMIgMVtsRomWagiLalflAyqSxl3hltAwmRGS2Kqndk0WDkNQJaUUuExERqqjANfudoh9
         IhfF+8v/iubwzgvQc7kSs1SZQmG8UTGfiUWMP7WVy1O9K/rqdmo6BViqgBpgatoRmBb2
         xaK/MReZYl+hZpD0tTNsWIqrwga17yxBckjSjK2DG6Q0CXSaSp6vDmxy07m9Xoqx/m8E
         Ia2w==
X-Gm-Message-State: AOAM533zHXqbBpgGL1Poz6ASRsrKW2p+ECgA5X28huHlD0xfZrvRUEs2
        k7RV8w4J5oguPLn5GcU8F+VCiwu+B4M=
X-Google-Smtp-Source: ABdhPJwnc8+OTfOsL3mqlp/cJ2qFXgmPbjRPyIqSAEphp/w8DeVR1ctMZgDurxaAh8ie1x/NvFTXmQ==
X-Received: by 2002:a05:6a00:1513:: with SMTP id q19mr20181501pfu.12.1643636898747;
        Mon, 31 Jan 2022 05:48:18 -0800 (PST)
Received: from ?IPV6:2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b? ([2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b])
        by smtp.gmail.com with ESMTPSA id m1sm18931642pfk.202.2022.01.31.05.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 05:48:18 -0800 (PST)
Message-ID: <43a50970-a08f-3956-7ff1-a2ad0ac51694@gmail.com>
Date:   Mon, 31 Jan 2022 20:47:57 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PROBLEM: Injected conntrack lost helper
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
From:   Pham Thanh Tuyen <phamtyn@gmail.com>
In-Reply-To: <20220131112050.GQ25922@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

1. Make sure to disable automatic helper assignment using the command 
'sudo sysctl net.netfilter.nf_conntrack_helper=0'
2. Use NAT
3. Set up a fault tolerant firewall system and then make the active 
firewall machine to fail. The backup firewall machine will recover the 
connection but lose the helper. (Simpler way is to use conntrack -I to 
inject the conntrack).


On 1/31/22 18:20, Florian Westphal wrote:
> Pham Thanh Tuyen <phamtyn@gmail.com> wrote:
>
> [ moving to netfilter-devel ]
>
>>>> My name is Pham Thanh Tuyen. I found a bug related to the ctnetlink
>>>> and conntrack subsystems. Details are as follows:
>>>>
>>>> 1. Summary: Injected conntrack lost helper
>>>>
>>>> 2. Description: When a conntrack whose helper is injected from
>>>> userspace, the ctnetlink creates helper for it but NAT then loses
>>>> the helper in case the user defined helper explicitly with CT
>>>> target.
> Hmm.  If you insert a conntrack entry from userspace, it will already
> be confirmed, so nat rules will have no effect, and template CT rules
> are irrelevant wrt. to the helper, as extension can only be created if
> the conntrack is not in the hash yet.
>
> Can you describe the steps to reproduce this bug?
