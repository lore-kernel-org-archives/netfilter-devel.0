Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975F7C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 03:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiBADJT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 22:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiBADJT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 22:09:19 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A303C061714
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 19:09:19 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f8so14065441pgf.8
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 19:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Pd8q4Zewm64hPq3DolMXCu5Si5qox9yYtwVrtDLLCQg=;
        b=jW32UxcogELknqyXxwna94M9nRUJS5YExWSLU5IR3SLyvmY49Pnp5pPBMNSKq63t7m
         dOMtW5W2CUtLUlmroDlsChw/QI6DnhcaIZTgWg3HxseD2xAi9OMZRnC7hxYh7KAcmEjq
         CCYvIr5nAD7oFrqeykZ/6sQumZqr/bJaGHXLKdbcyTqDU19WAkTpiB7bAcKKvhJPAVwV
         H8Xlg0J+OtM3MrFvVoOa4FFSqApLJ9etoMUJVr0brWFCgyFoqk5v2zhf6WRsbguezwZB
         1XBJ2UwQ3r/bitltBfVWhwMH/UnW8DvVZu8FMcBUCv5g36c83GCB7H9ThX7OMUOMunB0
         KW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pd8q4Zewm64hPq3DolMXCu5Si5qox9yYtwVrtDLLCQg=;
        b=AgGCDJblIVHR10im6uKdYNeucdGcpNlHF5/sc7CZf+8orBsaspWmnxmMLsqXcpKsNP
         e62XoXmzh7TpxniOTvBnfv4xp3NZq4GxJlGzGHUoRQRrIuvNRgaivfaiCcuAzHYjuiPu
         1QJfA5d2m6N4xxp20lJdhVSZcoGpIxuCd79+qEZa03SLQlRo/ypQLqlfbQcwTLk1/6SN
         jMsVJgeff/bcupoYHFUukjQkpDVttU4OwXzFr/5e8SRgMvNyoD03RhWSiaxUqCWiYRIb
         yg1srcwV22Avh2mX2oMBA2TCoYGE4fQWPcZcPEZvy4DdCOFdWeFVXTBfFG8OKK8tBM7x
         Wntw==
X-Gm-Message-State: AOAM530ZyQ80EyjDCSs6JsKIKw96HhEbCp7nCd2PNENkIRtC8QLnn6cs
        9swTptxpTNOYnA0xA9OLKjftmDb71QE=
X-Google-Smtp-Source: ABdhPJx/1vMsSTmSqti5x7J//f6jc++4OhJKoFmm0eS2JMXbFRIF1s//mMYaoUZSk5DZsZS7Fuh5bQ==
X-Received: by 2002:a62:1ec7:: with SMTP id e190mr22901309pfe.66.1643684958570;
        Mon, 31 Jan 2022 19:09:18 -0800 (PST)
Received: from ?IPV6:2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b? ([2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b])
        by smtp.gmail.com with ESMTPSA id m13sm6241470pfh.197.2022.01.31.19.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 19:09:17 -0800 (PST)
Message-ID: <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com>
Date:   Tue, 1 Feb 2022 10:08:55 +0700
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

When the conntrack is created, the extension is created before the 
conntrack is assigned confirmed and inserted into the hash table. But 
the function ctnetlink_setup_nat() causes loss of helper in the 
mentioned situation. I mention the template because it's seamless in the 
__nf_ct_try_assign_helper() function. Please double check.

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
