Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D728BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 18:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbiD0SK1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiD0SKZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 14:10:25 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309C842A25
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 11:07:12 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bq30so4564412lfb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 11:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UDAQdaBGEP/l0pi13DdxlhQBFBIXN5BLxsaE3JAVn8Q=;
        b=hD/Cg5Fq7xg+e+eXtGJz8N/OBw/9eg+eCnGz98hGZ5jBRTGK6SSC3cFeUlwB20CMUX
         RG+SmZh6AqNgziOzktotjbeHieWZdsmIvm6aWg857MnOpxHBvMzEARIbDP/jP/Z50ujQ
         f14K5HWf+Y6P2FUH/aYtjEJ096kySkakS7u8ZZ9arbROGrqEAWf3l7KXS0hdj7XJClzI
         A6lr3nwU18BGNl6mr7Z5l47mdE7I+cm2H4pCIzGVthg6R0SNZETv4dSgv3gIxGrVfBCH
         UcPMuHS1UIwUjBFGfXe1ZnS4Be2gx7CFgTZQgmRJYzM8u8wJYX5lWIyn1Af/hcw7P/o+
         AP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UDAQdaBGEP/l0pi13DdxlhQBFBIXN5BLxsaE3JAVn8Q=;
        b=muWVgRi1qeJzXahpnxI7d7dAnsV3p5Cav8GU/+dUS7NKaoOnFBfmKIurV4Osom5uP+
         5nXACPxRCFwfuqInLvmU1EbwkIwCvIQHf3nJ7mfAHvbqxdMzalUvjDJpp/JHpayxAqmQ
         Gm0y/GPi9Fgun/GFNC8KMhSZm6T/7QZfnLFvAflGBpfH2I+8GUMa7ytDf/aPCxQc5SBa
         wdiS6H1OfJOc9kyVPsHPL1E6syIR3XnOVMdGdIiC1mA5msh5myeZquki+UVtf+5tylgf
         sT59JxtJRYw2WfWK13gGgvXPGmDObPH7Zdqkg/2xTpEe7n1Ei7eWBj+tADj1Z563Gpyn
         RxvA==
X-Gm-Message-State: AOAM532CGZd4bLZRw4bwAddCSNRu3o5esbAC8me9T1UuzNtjxUMuMR7c
        AG+IsjGUerQRQcJMAf4qE0aDQ0ibcJMh5A==
X-Google-Smtp-Source: ABdhPJzmNwYkcpwotiJgTS2GeEHR6IZS0yPGGy6V5EFXq5cfZQa9NW/2J5DrL1uYcbeuw7h6GPp90A==
X-Received: by 2002:a05:6512:1107:b0:472:25d9:d25f with SMTP id l7-20020a056512110700b0047225d9d25fmr4120112lfg.329.1651082830242;
        Wed, 27 Apr 2022 11:07:10 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id m17-20020a197111000000b0046d0f737777sm2126599lfc.178.2022.04.27.11.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 11:07:09 -0700 (PDT)
Message-ID: <755d90d5-6f52-456d-8e1a-2e42c0896e97@gmail.com>
Date:   Wed, 27 Apr 2022 21:07:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
 <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com> <Ymheglo+kQ/Hr7oT@salvia>
 <YmhfE/3VzM3vNRbs@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YmhfE/3VzM3vNRbs@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 27.4.2022 0.07, Pablo Neira Ayuso wrote:
> On Tue, Apr 26, 2022 at 11:05:09PM +0200, Pablo Neira Ayuso wrote:
>> On Thu, Apr 21, 2022 at 07:35:06PM +0300, Topi Miettinen wrote:
>>> On 21.4.2022 0.15, Jan Engelhardt wrote:
>>>>
>>>> On Wednesday 2022-04-20 20:54, Topi Miettinen wrote:
>>>>
>>>>> Add socket expressions for checking GID or UID of the originating
>>>>> socket. These work also on input side, unlike meta skuid/skgid.
>>>>
>>>> Why exactly is it that meta skuid does not work?
>>>> Because of the skb_to_full_sk() call in nft_meta_get_eval_skugid()?
>>>
>>> I don't know the details, but early demux isn't reliable and filters aren't
>>> run after final demux. In my case, something like "ct state new meta skuid <
>>> 1000 drop" as part of input filter doesn't do anything. Making "meta skuid"
>>> 100% reliable would be of course preferable to adding a new expression.
>>
>> Could you give a try to this kernel patch?
>>
>> This patch adds a new socket hook for inet layer 4 protocols, it is
>> coming after the NF_LOCAL_IN hook, where the socket information is
>> available for all cases.
>>
>> You also need a small patch for userspace nft.
> 
> Quickly tested it with:
> 
>   table inet x {
>          chain y {
>                  type filter hook socket priority 0; policy accept;
>                  counter
>          }
>   }

Thanks. Assuming that this makes the 'meta skuid' and 'meta cgroupv2' 
always usable, I'd prefer this approach to new 'socket uid'.

I changed the hook of my input and output filters to 'socket' but then 
there are lots of errors:

/etc/nftables.conf:411:3-67: Error: Could not process rule: Operation 
not supported
                 ct state new socket cgroupv2 level 1 vmap 
@dict_cgroup_level_1_in
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:412:3-79: Error: Could not process rule: Operation 
not supported
                 ct state new meta skuid < 1000 meta l4proto vmap { tcp 
: jump tcp_input_sys }
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:413:3-108: Error: Could not process rule: Operation 
not supported
                 ct state new meta skuid >= 1000 meta l4proto vmap { tcp 
: jump tcp_input_user, udp : jump udp_input_user }
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:417:3-36: Error: Could not process rule: Operation 
not supported
                 icmpv6 type 144-147 counter accept
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:418:3-56: Error: Could not process rule: Operation 
not supported
                 meta l4proto { icmp, icmpv6 } counter jump icmp_common
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:423:3-51: Error: Could not process rule: Operation 
not supported
                 counter log prefix "[inet-input] " flags all drop
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:429:3-53: Error: Could not process rule: Operation 
not supported
                 counter log prefix "[inet-forward] " flags all drop
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:435:3-100: Error: Could not process rule: Operation 
not supported
                 rt type 0 counter log prefix "[inet-output-rt] " flags 
all reject with icmpx type admin-prohibited
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:436:3-122: Error: Could not process rule: Operation 
not supported
                 meta protocol != { ip, ip6 } counter log prefix 
"[inet-output-proto] " flags all reject with icmpx type admin-prohibited
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:437:3-78: Error: Could not process rule: Operation 
not supported
                 meta l4proto != { icmp, icmpv6, tcp, udp } counter jump 
log_bad_proto_output
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:438:3-50: Error: Could not process rule: Operation 
not supported
                 ct state { established, related } counter accept
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:441:3-68: Error: Could not process rule: Operation 
not supported
                 ct state new socket cgroupv2 level 1 vmap 
@dict_cgroup_level_1_out
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:443:3-56: Error: Could not process rule: Operation 
not supported
                 meta l4proto { icmp, icmpv6 } counter jump icmp_common
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
/etc/nftables.conf:448:3-87: Error: Could not process rule: Operation 
not supported
                 counter log prefix "[inet-output] " flags all reject 
with icmpx type admin-prohibited
 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-Topi
