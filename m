Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043ABC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 13:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbiBANcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 08:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiBANcb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 08:32:31 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D455C061714
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2022 05:32:31 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f8so15306298pgf.8
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Feb 2022 05:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HsqAVq0fdC5CtF7r3KOT54bbqHDuw8k3pdFjT+T5OC8=;
        b=hKj1HdscMlo1erWEpeNWsoBdb7PHWGFrV/r7qn4GE012SR85GMoxnexx3buBtlvwA9
         itTSvuGeXyA+QiJ6L47Hk51SXTFPq7EDNHAzOVb+cX6VzryaInY/noIGgRlzIeDIJw28
         JkYLD2V9ATC4gzQvp04JaVlFWAgGZtmXB3XRRdFCeiVLPqm7/GQ/VwZrUxw/Cmu3C5sq
         3pvl88zlXo5kC1WKR6FCuILvuvNwZh6lccSx0tfU1i/tmHIDe/kxwZEkDvA101E/eIST
         NKB9fnId6IBS74LJvTnhTR1ioynu6cdl1MhRkloZCPiPmAeVrBe3HyQ44rxtHAy+0m2Q
         wlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HsqAVq0fdC5CtF7r3KOT54bbqHDuw8k3pdFjT+T5OC8=;
        b=FWV5kgwv2z90FOyyLdVIgRKMXPxp6F6NAvCbV8js0P4k4s0FMjz3ETNRGZkpTJuiu/
         SZz3UQUKxoZtADG5k34qvUNE99AlEGXXnP+dxjtdtAu04y4NtmVNNlhbUxnEVX+tP8Ib
         VWXvyMh7hOvDfPfvnNt5NxWRm3M+3SI0VSnzwOMmsXlAngOX0AsfXK/LPd0FiMlwEMvg
         jgzzJl5pX0+Ff3dzNhhRAzozt/LShlvQkDHHdElB5L7VplnejG1eH3l4hlIszDXq6ktX
         qlBmaYBcfjmy3fOm8wuSFWrZYywh13634IngmmOmZ4/JDvjlXV1fER5m9YZGpb4e0bHQ
         F4jQ==
X-Gm-Message-State: AOAM533u/cJI0fVUJbHlU/tkw1F9mE5wr4Z+CZLN0fal3Zyip4S4ujZT
        P1d2HV3S3dvjn8oIvJOgS80Kdljozig=
X-Google-Smtp-Source: ABdhPJze13TXceh7RyX5XwcZK5iasVZjflAwJtTgclZ3bQJELglMAsZoOjEi0JZKrHIYuNnAb8i+yg==
X-Received: by 2002:a63:c106:: with SMTP id w6mr20722510pgf.313.1643722351064;
        Tue, 01 Feb 2022 05:32:31 -0800 (PST)
Received: from ?IPV6:2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b? ([2001:ee0:48be:3c40:a6c3:f0ff:fecf:f70b])
        by smtp.gmail.com with ESMTPSA id mq3sm3288750pjb.4.2022.02.01.05.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 05:32:30 -0800 (PST)
Message-ID: <bca957db-0774-e337-fc3a-ada0c4325fe9@gmail.com>
Date:   Tue, 1 Feb 2022 20:32:07 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PROBLEM: Injected conntrack lost helper
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <f9fb5616-0b37-d76b-74e5-53751d473432@gmail.com>
 <3f416429-b1be-b51a-c4ef-6274def33258@iogearbox.net>
 <0f4edf58-7b4e-05e8-3f13-d34819b8d5db@gmail.com>
 <20220131112050.GQ25922@breakpoint.cc>
 <2ea7f9da-22be-17db-88d7-10738b95faf3@gmail.com> <YfkLnyQopoKnRU17@salvia>
 <20220201120454.GB18351@breakpoint.cc>
From:   Pham Thanh Tuyen <phamtyn@gmail.com>
In-Reply-To: <20220201120454.GB18351@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously I also thought ct->status |= IPS_HELPER; is ok, but after 
internal pointer assigning with RCU_INIT_POINTER() need external pointer 
assigning with rcu_assign_pointer() in __nf_ct_try_assign_helper() function.

On 2/1/22 19:04, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Tue, Feb 01, 2022 at 10:08:55AM +0700, Pham Thanh Tuyen wrote:
>>> When the conntrack is created, the extension is created before the conntrack
>>> is assigned confirmed and inserted into the hash table. But the function
>>> ctnetlink_setup_nat() causes loss of helper in the mentioned situation. I
>>> mention the template because it's seamless in the
>>> __nf_ct_try_assign_helper() function. Please double check.
>> Conntrack entries that are created via ctnetlink as IPS_CONFIRMED always
>> set on.
>>
>> The helper code is only exercised from the packet path for conntrack
>> entries that are newly created.
> I suspect this is the most simple fix, might make sense to also
> update the comment of IPS_HELPER to say that it means 'explicitly
> attached via ctnetlink or ruleset'.
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2313,6 +2313,9 @@ ctnetlink_create_conntrack(struct net *net,
>   
>   			/* not in hash table yet so not strictly necessary */
>   			RCU_INIT_POINTER(help->helper, helper);
> +
> +			/* explicitly attached from userspace */
> +			ct->status |= IPS_HELPER;
>   		}
>   	} else {
>   		/* try an implicit helper assignation */
