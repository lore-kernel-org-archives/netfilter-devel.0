Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ECCC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 22:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiCCWVp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 17:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiCCWVp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 17:21:45 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C6E65DE
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 14:20:59 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id r7so7553702iot.3
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Mar 2022 14:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VBkt6m9LITkn++JGkO1ATzV9oKt4/whQ3jS4HjOvbjY=;
        b=E/qaOd662MgY3tCHS/0oI3+UZv6QenjXIpbFU8+3oufy/C1cLxAww/MMsdrx4fpnRe
         h/52IgeNVh12CA4WCd1qqls6kE0A24yNGsZ9MkJgSP7o9Vk4Pql39Upxla6HfUhb+H3o
         GvG4KNzVhxzsD2om+P82ly6OfbKl53BcMDygI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VBkt6m9LITkn++JGkO1ATzV9oKt4/whQ3jS4HjOvbjY=;
        b=jfSkqwyUSNV6B0ViDJs5X3cy3OBC7kK8R5J6D0JkoWHjHnc0LQOxevCJFRdR/iMoi7
         VGWmcsKMzV4Q02HhuJxQFITjpdaWyoLvr8vVJ5cG6mazIEcDyqDswPKzBaxTydR1mjmc
         ab4eveWEBR67b7vA//cJDdqMCqfPIn+zehpqMhBtZdNqGQndI4siYG37HywQD290LC/h
         evp610cArnSBQ305B5Az4EuI8JqKjYcfObAAYG3uCAoblWr6M4KYIjsci9hWXdTYCs+F
         k9JTF9CnAmTzrRUP0A33ZN1pIXsD7yrSfqdS0oQv6o7iM8jafaAtf71pmXl8SNeJF7gC
         ubtQ==
X-Gm-Message-State: AOAM530zu/AFSDl56WB+3EP+BBnsfmNRZivoVhCZi0DSW4kU/llnrjj6
        5c7Tpn3yEYt6LPx23g6a+nSMNQ==
X-Google-Smtp-Source: ABdhPJx3VuKiHfWWx8r9qbf1hxEuZ/ORapgZH72gzhQLghnV3ArpSlo+D8U8zVmhdFVTr5D9boDiFA==
X-Received: by 2002:a5d:984f:0:b0:63d:a956:cdbc with SMTP id p15-20020a5d984f000000b0063da956cdbcmr28299695ios.37.1646346058516;
        Thu, 03 Mar 2022 14:20:58 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id m1-20020a056e021c2100b002c2ec1c8012sm3799828ilh.53.2022.03.03.14.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 14:20:58 -0800 (PST)
Subject: Re: [PATCH v2] selftests: netfilter: fix a build error on openSUSE
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Geliang Tang <geliang.tang@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Kai Liu <kai.liu@suse.com>, netfilter-devel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <5ee95e93a11a239df8e09d059da25a4eaa5725ba.1646198836.git.geliang.tang@suse.com>
 <8cbf1231-0da5-c8a0-d66b-1488633d9895@linuxfoundation.org>
 <Yh+wulh/nIkFeFmz@salvia>
 <c2318ebe-beaa-64b8-6c6c-ee552cb35e0f@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3618874c-b3bb-8423-0c16-38c52712a36d@linuxfoundation.org>
Date:   Thu, 3 Mar 2022 15:20:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c2318ebe-beaa-64b8-6c6c-ee552cb35e0f@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 3/3/22 12:10 PM, Shuah Khan wrote:
> On 3/2/22 11:00 AM, Pablo Neira Ayuso wrote:
>> On Wed, Mar 02, 2022 at 10:11:11AM -0700, Shuah Khan wrote:
>>> On 3/1/22 10:29 PM, Geliang Tang wrote:
>>>> This patch fixed the following build error on openSUSE Leap 15.3:
>>>>
>>>> =======================================================================
>>>>    gcc     nf-queue.c -lmnl -o tools/testing/selftests/netfilter/nf-queue
>>>>    nf-queue.c:13:10: fatal error: libmnl/libmnl.h: No such file or directory
>>>>     #include <libmnl/libmnl.h>
>>>>              ^~~~~~~~~~~~~~~~~
>>>>    compilation terminated.
>>>> =======================================================================
>>>>
>>>> It is because libmnl.h is put in the directory of
>>>> "/usr/include/libmnl/libmnl/" on openSUSE, not "/usr/include/libmnl/":
>>>>
>>>>    > rpm -ql libmnl-devel
>>>>    /usr/include/libmnl
>>>>    /usr/include/libmnl/libmnl
>>>>    /usr/include/libmnl/libmnl/libmnl.h
>>>>    /usr/lib64/libmnl.so
>>>>    /usr/lib64/pkgconfig/libmnl.pc
>>>>
>>>> Suggested-by: Kai Liu <kai.liu@suse.com>
>>>> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
>>>> ---
>>>> v2:
>>>>    - use pkg-config
>>>> ---
>>>>    tools/testing/selftests/netfilter/Makefile | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
>>>> index e4f845dd942b..8136c1fab7ab 100644
>>>> --- a/tools/testing/selftests/netfilter/Makefile
>>>> +++ b/tools/testing/selftests/netfilter/Makefile
>>>> @@ -8,6 +8,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
>>>>        ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
>>>>        conntrack_vrf.sh nft_synproxy.sh
>>>> +CFLAGS += $(shell pkg-config --cflags libmnl 2>/dev/null || echo "-I/usr/include/libmnl")
>>>>    LDLIBS = -lmnl
>>>>    TEST_GEN_FILES =  nf-queue
>>>>
>>>
>>> Adding Pablo to the thread.
>>>
>>> Pablo,
>>>
>>> This looks good to me. I can take this through linux-kselftest tree.
>>> Let me know either way.
>>>
>>> Or if it is going through netfilter tree:
>>> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> If this does not cause any issue when running tests in any other
>> distros, then it is fine with me.
>>
> 
> I tested this on Ubuntu 21.10 and worked for me. I will apply this for
> Linux 5.18-rc1 then.
> 

Applied to linux-kselftest next for Linux 5.18-rc1.

thanks,
-- Shuah
